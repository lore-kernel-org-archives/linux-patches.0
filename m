Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957ED320A
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B5FC433EF;
	Mon,  8 May 2023 11:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544808;
	bh=StmVsysVd4p1rnWmO2N1aV30ZfZtt5Np3+56CZNJ9fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spfsZwEf1hWbrPTucR7S6SF+N3df46e5PRBYzgyB8St2n7ZYn/p0/IHahyn8QtzjU
	 K1V4A0CQVSCRvG2D+tz2i4e2ZGyEbxbq3b57FHMPa2C+loCT9Ze92msUaord53k9pd
	 n7JmYBsNrvr1whgg1kV4yuMaekOotR42XdwQL2b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 529/694] HID: amd_sfh: Increase sensor command timeout for SFH1.1
Date: Mon,  8 May 2023 11:46:04 +0200
Message-Id: <20230508094451.496804347@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

[ Upstream commit 571dc8f59dd477037bb5a029e8d1b5a4a4d9dd63 ]

The initialization of SFH1.1 sensors may take some time. Hence, increase
sensor command timeouts in order to obtain status responses within a
maximum timeout.

Fixes: 93ce5e0231d7 ("HID: amd_sfh: Implement SFH1.1 functionality")
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c
index 6f6047f7f12e9..4f81ef2d4f56e 100644
--- a/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c
+++ b/drivers/hid/amd-sfh-hid/sfh1_1/amd_sfh_interface.c
@@ -16,11 +16,11 @@ static int amd_sfh_wait_response(struct amd_mp2_dev *mp2, u8 sid, u32 cmd_id)
 {
 	struct sfh_cmd_response cmd_resp;
 
-	/* Get response with status within a max of 1600 ms timeout */
+	/* Get response with status within a max of 10000 ms timeout */
 	if (!readl_poll_timeout(mp2->mmio + AMD_P2C_MSG(0), cmd_resp.resp,
 				(cmd_resp.response.response == 0 &&
 				cmd_resp.response.cmd_id == cmd_id && (sid == 0xff ||
-				cmd_resp.response.sensor_id == sid)), 500, 1600000))
+				cmd_resp.response.sensor_id == sid)), 500, 10000000))
 		return cmd_resp.response.response;
 
 	return -1;
-- 
2.39.2



