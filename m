Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829379;
	b=k9BinP1RM4jU3DWMBF2kUllg3/yOy/RXeeju2cRB1ZqqyTU/XTpTsrVmd/k6st6wuR51
	 TqapB1d3PjE272s7E8mzoLTLIJb1/oQUabU0W25ovBF+RuOVtUdQSmcoaVcN6vQa+mPaX
	 Tk1GtU/oW4CAl/HDHaAgCg6IoPrybEHOYodxXpzhKm/P08x5a9Kw+yFre7Y2BzS2uf77b
	 KDn4xrJL/pZyZ01bOobPWG0Qhe5wZQcVJy9j38blbUXKgTwcQVisbl8KtSvywljPrcbV7
	 H3o9S8uWnykDyRiRjrSu1yPUo609Ri+YMPtGm9jXBQPSvFOhmXfQ03jWGnyZGw13mQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s7ruZ09gOsNmm5DvNAh9UH+SI19zM72lNbG34EJmj30=;
	b=zEN2Ed3OgEeJZFJ5G8WHY58lC821+9mZYWeubrFLcfqIJfLY7ysOminQbWGvsx5tNb+X
	 ASA1b2XPO0x2X8EmRoeRTR7l0dNCUVdow5rntAKNCJKc3oIXJ0KaAJBBWsCAiCwAtf8g8
	 NNESpA00iLbtvZktnzX8BPQRjp693dDNji3xyUszwG9fpSIQJDDjszOnG4CZHSQiMWxl4
	 GLK5n2BQamgvTWCYb/V7U+RVLZG5GfCN+VA/0zUHKppnV7jAd3oY2Nn76SGfXbyfIJNgx
	 5A1isK9j4o7r+fO5JUrWT1zxN5UZnvwvkVj0zOJvaE6xlwR4OFBArPgFa/RMBcJNUjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y7Lp8YuH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358AF607490E;
	Wed,  4 Nov 2026 21:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y7Lp8YuH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EB61F00A17;
	Wed,  4 Nov 2026 21:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829378;
	bh=s7ruZ09gOsNmm5DvNAh9UH+SI19zM72lNbG34EJmj30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y7Lp8YuHNHSJr/5Gmh5xXz7G/1FZfwjyGtkbch9fmiO78h9gqHyFNdo2u7Ag6Av0p
	 aHKVFOWhlxQ0ndTW9CEhT2envc5G2wxP3yYICdoZ2BOBpm0Zdu9E8YW1jKl1seNlkM
	 VPFeG83ioio6LgWzO8YJviey035yYte9AgAMY25g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Hansen-Baird <william.hansen.baird@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0088/1005] wifi: rtlwifi: rtl8723be: Remove unnecessary irq save/restore in hw_init()
Date: Wed,  4 Nov 2026 15:57:01 -0500
Message-ID: <20261104211046.092173631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e1f8112188949..bf7b5a32adaaf 100644
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



