Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BB93212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234E2C433EF;
	Tue,  7 Feb 2023 13:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774947;
	bh=Y8+FvqjuBLDQ4TraZa3mKRi3X8JJScyTWNtADBTUAvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fF1UnpwFhcL1YKdBMR/Ua3Jl9JrqdAv2yi8W1FgGYGVtHyx1C1GL6dSEydcnEAkgc
	 Pr87RExNLTd8u4FT2vey0LdjyLfNjFLAh9NyMDMk0KnVb6Y9gVEj67pCFJGuh4Z46h
	 skmS/VEj9A6aosnFnRR3vVL3cPjPZh1LgRbKaSIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/208] platform/x86: thinkpad_acpi: Fix thinklight LED brightness returning 255
Date: Tue,  7 Feb 2023 13:55:13 +0100
Message-Id: <20230207125636.959324715@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit eebf82012dddbdcb09e4e49d3cdfafb93bc66eb2 ]

Reading the thinklight LED brightnes while the LED is on returns
255 (LED_FULL) but we advertise a max_brightness of 1, so this should
be 1 (LED_ON).

Fixes: db5e2a4ca0a7 ("platform/x86: thinkpad_acpi: Fix max_brightness of thinklight")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230127235723.412864-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 7fd735c67a8e..2a48a2d880d8 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5566,7 +5566,7 @@ static int light_sysfs_set(struct led_classdev *led_cdev,
 
 static enum led_brightness light_sysfs_get(struct led_classdev *led_cdev)
 {
-	return (light_get_status() == 1) ? LED_FULL : LED_OFF;
+	return (light_get_status() == 1) ? LED_ON : LED_OFF;
 }
 
 static struct tpacpi_led_classdev tpacpi_led_thinklight = {
-- 
2.39.0



