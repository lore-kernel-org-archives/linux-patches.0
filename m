Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA9979C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B3BC433D6;
	Wed, 30 Nov 2022 18:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833670;
	bh=8olDvIHac9dD1AeNT6hCOJPK43BZg6OH+0NnGYT6G7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7TNIHPO3p5Y3LygH54RpRMe8BzaDpeRusAowdd19D/TydO86/ZmW0pgio9I1xUju
	 UGvN9XcFa4YmWGgxpUV7o8ZGK1FK9KKehP6FX+xyJ+KjABE60yBrOAqxbCZ0cVCY0B
	 6xnxMyM+zWkWawgTuHTzB/2ziABuOlzF0D6WaMa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/206] platform/x86: hp-wmi: Ignore Smart Experience App event
Date: Wed, 30 Nov 2022 19:23:51 +0100
Message-Id: <20221130180537.574939491@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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
index 5a3a3cd89214..1e390dcee561 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -64,6 +64,7 @@ enum hp_wmi_event_ids {
 	HPWMI_PEAKSHIFT_PERIOD		= 0x0F,
 	HPWMI_BATTERY_CHARGE_PERIOD	= 0x10,
 	HPWMI_SANITIZATION_MODE		= 0x17,
+	HPWMI_SMART_EXPERIENCE_APP	= 0x21,
 };
 
 struct bios_args {
@@ -641,6 +642,8 @@ static void hp_wmi_notify(u32 value, void *context)
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



