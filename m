Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060631;
	b=aTbVK1zmxJzeQHVNzpiiD3haBEtXkzvChVljUdDgbMejhi9Jnh4kzvoQvZ5l1iRtUwUe
	 0S4QLM4H9j39UzuiGeRiJ3vGo7LKEG9tghdRDbKZzHDC74Uh3Rc5J24Oi3W9gVoIZWuRP
	 LOy+vHLsb0z9rEShUSRF/smxL3sirtasTM/OkpmrWy7E11cFFYEoPI0oncgrbwn35+Z6q
	 C/08ctv8ORVgy6rL2UeoXl28EkCL2TD8UBlcpKcrYDBQP9WpgkBh8PJ6X+ChVU3pUdGnH
	 SWsqd0Qn0L9e0sIQ0Ao/XUKnutXI3vHesobVSlu2q8lQptodfvN7NPs+AoeC2Ie+FTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XfjeijZzqQzcB6MrDncxDGpTp9IkROq1x/tdbBcs25s=;
	b=llzWiUSLxPfJPjAGdK4L7s6vHdHPSaJqR07D44QUr9thArW7wSxDYAUmSgMOWYmIuePV
	 sSRelpE0jh8q4ghvv26PrWQmxwKON0F10zTI2HTy/ISYzxKwOGOHNCR2cu+G6iiivFB/1
	 UiTe0GMU8/SvSO2OS+KK1zFCFU/pwTmzJbHFfCwF5Zs1I0BoLvf9KtrsyLFS5rAU8Z4bG
	 TiFUUzvi40ioPeIAZGBRIzM5wRao//xQx2lbubi7WuGZ22jgxSXfVcwSZS32stnuY2lC5
	 DKXykX1V8XgGLf4KZtM5ln9CEsN5javQk52WVDu6xM5X11y9qPpSht3KVTuMaLlt5wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zrCfmEXd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F66606A32C;
	Sat,  7 Nov 2026 14:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zrCfmEXd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D80F1F008A1;
	Sat,  7 Nov 2026 14:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060631;
	bh=XfjeijZzqQzcB6MrDncxDGpTp9IkROq1x/tdbBcs25s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrCfmEXd4VSWvPf1K+qtonrD9YN06CzK6nwYVwDMnB/DlUWks1CVl1SGsbNSRH+mj
	 SOixFNd5ST4iaUQneUPrA0XkQiTyzM+2feT35knGkFvi004VFzu2Q9VDWYcXk7Rmdd
	 IaatdSYvQ5+2BX2g/1+PNWfnLuh6+pKfrK1nHUnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Hansen-Baird <william.hansen.baird@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0075/1536] wifi: rtlwifi: rtl8723be: Remove unnecessary irq save/restore in hw_init()
Date: Sat,  7 Nov 2026 08:34:51 -0500
Message-ID: <20261107134959.783191717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Hansen-Baird <william.hansen.baird@gmail.com>

[ Upstream commit 1b4cd55626b6ffa93d18848412afb912a4add585 ]

rtl8723be hw_init() calls local_save_flags(flags) followed by
local_irq_enable(). Later, local_irq_restore(flags) is called.

This causes warnings from Lockdep on boot and modprobe,
as local_irq_restore(flags) should only be called while irqs are disabled.
The warning was introduced to detect this class of bug in [1].

With testing I found that all paths which call hw_init() have irqs
already enabled for rtl8723be.

Furthermore, the calls were originally added for the rtl8192ce
in commit f78bccd79ba3 ("rtlwifi: rtl8192ce: Fix too long disable of IRQs")
before later being added to most other rtlwifi drivers.

Commit d3feae41a347 ("rtlwifi: Update power-save routines for 062814 driver")
then replaces the call to spin_lock_irqsave() before hw_init(),
and thus the codepath which caused irqs to be disabled in hw_init and
prompted the original commit has been removed.

The same irq save/restore pattern is also present in the hw_init() of
rtl8192ce, rtl8723ae, rtl8188ee, rtl8192se and rtl8192cu,
however I don't have the hardware to test them,
so I did not include them in my changes.

Tested on a Razer Blade 14 2017.

Example of output from Lockdep prior to fix:

raw_local_irq_restore() called with IRQs enabled

...

Call Trace:
<TASK>
rtl8723be_hw_init+0x5992/0x7220 [rtl8723be]
? static_obj+0x61/0xa0
rtl_pci_start+0x222/0x5c0 [rtl_pci]
rtl_op_start+0x128/0x1a0 [rtlwifi]
? __kasan_check_read+0x11/0x20
drv_start+0x16c/0x550 [mac80211]

...

irq event stamp: 887679
hardirqs last  enabled at (887689): [<ffffffff96511170>] __up_console_sem+0x90/0xa0
hardirqs last disabled at (887698): [<ffffffff96511155>] __up_console_sem+0x75/0xa0
softirqs last  enabled at (887670): [<ffffffff962f4675>] __irq_exit_rcu+0x175/0x2f0
softirqs last disabled at (887649): [<ffffffff962f4675>] __irq_exit_rcu+0x175/0x2f0
---[ end trace 0000000000000000 ]---

[1] https://lore.kernel.org/all/20210111153707.10071-1-mark.rutland@arm.com/

Signed-off-by: William Hansen-Baird <william.hansen.baird@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260609095359.2964193-1-william.hansen.baird@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 0e77de1baaf87..c65650c72d7c9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -1333,11 +1333,6 @@ int rtl8723be_hw_init(struct ieee80211_hw *hw)
 	bool rtstatus = true;
 	int err;
 	u8 tmp_u1b;
-	unsigned long flags;
-
-	/* reenable interrupts to not interfere with other devices */
-	local_save_flags(flags);
-	local_irq_enable();
 
 	rtlhal->fw_ready = false;
 	rtlpriv->rtlhal.being_init_adapter = true;
@@ -1443,7 +1438,6 @@ int rtl8723be_hw_init(struct ieee80211_hw *hw)
 
 	rtl8723be_dm_init(hw);
 exit:
-	local_irq_restore(flags);
 	rtlpriv->rtlhal.being_init_adapter = false;
 	return err;
 }
-- 
2.53.0



