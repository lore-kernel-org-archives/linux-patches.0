Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042995;
	b=gEZk+QB4EDDh3LFGP2bXiCv9xNYc2z4L4e6lAs/4UNsOIlZc+RlqMAY8MfMjE+H6hKS3
	 V0j7izrWaGbmFxWc4MS8J806pO2i6e9CBR8w/6QOAOmhq0YGsHO9eBcVfBNlBSP2nlVF+
	 dajIL33yhsmviZ1kypDgJLFCReNGDdtpI0q1cURu6hEWG7/XcSGiQ2Ov+MGkQAYMvo/vd
	 3dPSC505RWzpuuaeS53q5lOZ7RQK7W8bLyjTwydh4wa5CbilAbibEPnylzhuHCPGcKLHA
	 mqZgzqrFjyl2QVs0IlixnIvEohIpb6Riq6yTLsbu0yMVf5viWKJ7W4Es5niVDHBe6eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=poA8i0YK0Vn3YkBr+X91cZS9nnIxyuNMngOnuDQ3MEI=;
	b=zlcqd8By0OrccAhMTCOppJw9dE4gjFGFqxB6OyOBNGgiZNzn/IRZfTbU++gZwNM+hymn
	 Nfs54dfeiK3gP6h9lXmRHLk9XlXCddpuwJXn8wQawcuQmyDp3RNa1pNx/aVRDN+A66Tmj
	 9841zhw5wYUQLVn9+GRT9EYrFzulJzec2cukIsAZib/gEQNxvWMdE+Fzggofdh4hJP5M4
	 otSdPbR30TRrdM2rQzsEs3XUEwGgWDn1TmCgiacY9bdQMXjMEZHnkKW9PvT51a0U9nf9a
	 KAlyMRBQgzlFSydCiAhMbWigSqfM3Jv30qshN4qFZuia6PMlR1e1g9z/Or+dc32CjEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGjsgQRU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7AA606A31C;
	Wed, 18 Nov 2026 23:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGjsgQRU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA941F000C4;
	Wed, 18 Nov 2026 23:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042995;
	bh=poA8i0YK0Vn3YkBr+X91cZS9nnIxyuNMngOnuDQ3MEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGjsgQRUkxhGngAgL8tG8+8BSMoOINOwC/3KgRuv9wUg/EXeo2lVyRNCtVHKdYKMP
	 rXckc0zeJyeGYt4j/Qw2GIhtR9zIILQekzhR0rHRmqJ99n3khQiV36aTQ91rO/9EQc
	 LJlqoIXADTksmRwg/pvL7v06KTvWQqmxeuSWFyAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Hansen-Baird <william.hansen.baird@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0052/2857] wifi: rtlwifi: rtl8723be: Remove unnecessary irq save/restore in hw_init()
Date: Wed, 18 Nov 2026 15:18:06 +0100
Message-ID: <20261118150203.187348996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0ba3bbed6ed36..69d2370792e26 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -1339,11 +1339,6 @@ int rtl8723be_hw_init(struct ieee80211_hw *hw)
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
@@ -1449,7 +1444,6 @@ int rtl8723be_hw_init(struct ieee80211_hw *hw)
 
 	rtl8723be_dm_init(hw);
 exit:
-	local_irq_restore(flags);
 	rtlpriv->rtlhal.being_init_adapter = false;
 	return err;
 }
-- 
2.53.0



