Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B43E15C8A
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D350EC433D6;
	Mon,  5 Dec 2022 19:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269267;
	bh=9e1bDwrzC8xjHeM+GlfAFgxwD1ki7khbQsbjjYy1rAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWIQQj/KiFd/GqnHJ7Yul4w2+Kqq37L3B6LA+7r9S3GiDhRRYnaUcgoYab6gCVCt7
	 O6bFquJefrlpjDEThz6fjBnoCLdem2EceepWCYXQSLbPS4xKvr5QOakD3m8fCl07l1
	 KnW3rFODS5hsOepncWFG6WPxntIPzTkorPshPcE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 065/153] platform/x86: hp-wmi: Ignore Smart Experience App event
Date: Mon,  5 Dec 2022 20:09:49 +0100
Message-Id: <20221205190810.588364070@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 8b9b6a044b408283b086702b1d9e3cf4ba45b426 ]

Sometimes hp-wmi driver complains on system resume:
[ 483.116451] hp_wmi: Unknown event_id - 33 - 0x0

According to HP it's a feature called "HP Smart Experience App" and it's
safe to be ignored.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20221114073842.205392-1-kai.heng.feng@canonical.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp-wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index a67773eca3ac..d3a329b201b1 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -63,6 +63,7 @@ enum hp_wmi_event_ids {
 	HPWMI_PEAKSHIFT_PERIOD		= 0x0F,
 	HPWMI_BATTERY_CHARGE_PERIOD	= 0x10,
 	HPWMI_SANITIZATION_MODE		= 0x17,
+	HPWMI_SMART_EXPERIENCE_APP	= 0x21,
 };
 
 struct bios_args {
@@ -632,6 +633,8 @@ static void hp_wmi_notify(u32 value, void *context)
 		break;
 	case HPWMI_SANITIZATION_MODE:
 		break;
+	case HPWMI_SMART_EXPERIENCE_APP:
+		break;
 	default:
 		pr_info("Unknown event_id - %d - 0x%x\n", event_id, event_data);
 		break;
-- 
2.35.1



