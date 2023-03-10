Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CC28494
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC28FC4339C;
	Fri, 10 Mar 2023 14:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458989;
	bh=cCH7VQG9oHwEHtMIfZAQ+VE25nBoMuZ8zCtrHLV57SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrmBHJRoEGDWiZyNi+L1jcZ3424842O9s+WqOkf7m8aZuMxHRxlNWk0wwby8gpBB7
	 lxwwA2j1/nuhluhDxcwPnndz8TZQ3H13aIlqyA22ugTp/uYy1MpdDeA5W82M2bhBZR
	 C98QM38moq97TMrGge5WcuNtAfVl7AXU1TeDO3QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun ASAKA <JunASAKA@zzy040330.moe>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.4 211/357] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
Date: Fri, 10 Mar 2023 14:38:20 +0100
Message-Id: <20230310133744.023961556@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jun ASAKA <JunASAKA@zzy040330.moe>

commit c6015bf3ff1ffb3caa27eb913797438a0fc634a0 upstream.

Fixing transmission failure which results in
"authentication with ... timed out". This can be
fixed by disable the REG_TXPAUSE.

Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221217030659.12577-1-JunASAKA@zzy040330.moe
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1671,6 +1671,11 @@ static void rtl8192e_enable_rf(struct rt
 	val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
 	val8 &= ~BIT(0);
 	rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
+
+	/*
+	 * Fix transmission failure of rtl8192e.
+	 */
+	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
 }
 
 struct rtl8xxxu_fileops rtl8192eu_fops = {


