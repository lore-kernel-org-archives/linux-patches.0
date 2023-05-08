Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA861549F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC42C4339B;
	Mon,  8 May 2023 10:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540600;
	bh=2HE7cBAkhH1rYywG8/ZuDvlgZIOaAeoVhwQc1IRCbak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWl/ZhRe6no0MOMbT6WDqYs/H2gxxmW+uVXTrUrticv7AyISlPPBqnLpS42t+/olD
	 CoYo1w+rYZv8cUqpyUc5kBxMA8e17OgrXcGZut6vSxX9WMuRXH3i6VfT5m5hTgLRCz
	 wnbjLeKOaia3R1rK02R8zm/z2DwaWMM14E6UMno8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 427/611] HID: amd_sfh: Correct the sensor enable and disable command
Date: Mon,  8 May 2023 11:44:29 +0200
Message-Id: <20230508094436.074550204@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 0b9255bf11baa61cd526e6bd24d6c8e6d1eabf8d ]

In order to start or stop sensors, the firmware command needs to be
changed to add an additional default subcommand value. For this reason,
add a subcommand value to enable or disable sensors accordingly.

Fixes: 93ce5e0231d7 ("HID: amd_sfh: Implement SFH1.1 functionality")
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c
index c6df959ec7252..6e19ccc124508 100644
--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c
@@ -33,6 +33,7 @@ static void amd_start_sensor(struct amd_mp2_dev *privdata, struct amd_mp2_sensor
 	cmd_base.ul = 0;
 	cmd_base.cmd.cmd_id = ENABLE_SENSOR;
 	cmd_base.cmd.intr_disable = 0;
+	cmd_base.cmd.sub_cmd_value = 1;
 	cmd_base.cmd.sensor_id = info.sensor_idx;
 
 	writel(cmd_base.ul, privdata->mmio + AMD_C2P_MSG(0));
@@ -45,6 +46,7 @@ static void amd_stop_sensor(struct amd_mp2_dev *privdata, u16 sensor_idx)
 	cmd_base.ul = 0;
 	cmd_base.cmd.cmd_id = DISABLE_SENSOR;
 	cmd_base.cmd.intr_disable = 0;
+	cmd_base.cmd.sub_cmd_value = 1;
 	cmd_base.cmd.sensor_id = sensor_idx;
 
 	writeq(0x0, privdata->mmio + AMD_C2P_MSG(1));
-- 
2.39.2



