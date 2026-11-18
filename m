Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045832;
	b=TqexIz1wVJ+ZKo6mjUGq5aCCfE4bwBb+MAei0/iQWQgpJTTJVxzjzrG5qpXn3K+udMMn
	 GbrR0ExtBnohlNxorMaqr/3C6IWyuYPZIR4zcuulFcxPJME8VLRMTWJvLduK0fm2QCtEx
	 YrTPUW8kchZPF1ItbucAn3Jf7aIDPb6RzADQNqNOhvFUTSAfTiEgt4tmX1XhTTlFWEv4V
	 apIqp9lEdAkuVeXUlIBaCtXB0QQGDOXF8w8sdoNBpr03AGwZpbIxyrq/2tHxLlzHqZBqG
	 T27urSXOCv1zYaTIIYUlSNHF7v3mil/7x/Fj0AjWd1mwVz6KIZs6BQQbQm5RYV5UuYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045832;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LpaIxtfCMfKDsjevmTbEA9ops8bWohtRNlllkfYBIj8=;
	b=c9skGdwNRUlDGNt4k5UGMzTdE9IbuOjcRkeY60qI33XTahLm2d2OGKdCPjCHFRt7naZz
	 QrJ2HeqXwiP+HcmsKiHlzWsaxblnEnyjjLkFimOwrkgLLiBw6Fye08h1AoeBu0m3lH86f
	 rutVW0mn2tyx8jDd6W/kbdbV28LlE+LoOJHpaQJ/cvROBp7L0hJ+G/qIPLRqV44P1rj2z
	 wvEMlqu4EJ+DyTZTz/RRksZMNFzjDLowBRI1KyYR4GLFPMu42hAssFHDG7gP6SK+NDUTr
	 0kUMVPnW15YaJi0HxPOtG1ZqPQ3iY2ImGgB5Qlb5UQU8VG7hKabvBhkqadhjJfu8tNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hSr5VC3x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9A6606A32F;
	Wed, 18 Nov 2026 23:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hSr5VC3x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAA01F000C6;
	Wed, 18 Nov 2026 23:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045832;
	bh=LpaIxtfCMfKDsjevmTbEA9ops8bWohtRNlllkfYBIj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hSr5VC3xEq6NeO4jec/yqAP4fCRlYABrNPEWW0ewt5DeAdJQD2D0R+DJp3VBYILmR
	 28iEHKHXuYX6nf5ANvj5Q5BshEr6sHWt3U4D3Ew22wrbMZfZIdPNiHM2jSio/pR2Hk
	 fV5GmnBkYwC58wDV5f9O7OCinM0m9L8/Sm7BJDkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1063/2857] bonding: fix out-of-bounds read of arp_ip_target
Date: Wed, 18 Nov 2026 15:34:57 +0100
Message-ID: <20261118150239.870095877@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit a81513bf5bdf29cf00c0a11f56be515c1ec260f4 ]

arp_ip_target is a module parameter array with BOND_MAX_ARP_TARGETS
entries. In the loop parsing it in bond_check_params(), arp_ip_count is
the number of accepted targets, while i is the index into
arp_ip_target. Invalid and duplicate entries are skipped without
bumping arp_ip_count, so bounding the loop with arp_ip_count lets i run
past the end of arp_ip_target, e.g. 16 targets with one duplicate:

  BUG: KASAN: global-out-of-bounds in bond_check_params.constprop.0+0x1148/0x1440
  Read of size 8 at addr ffffffff96e9ee00 by task swapper/0/1
  Call Trace:
   <TASK>
   dump_stack_lvl+0x91/0xf0
   print_report+0xd1/0x630
   kasan_report+0xf3/0x130
   __asan_report_load8_noabort+0x14/0x30
   bond_check_params.constprop.0+0x1148/0x1440
   bonding_init+0x13/0xe0
   do_one_initcall+0xe7/0x5b0
   kernel_init_freeable+0xa91/0x1120
   kernel_init+0x24/0x220
   ret_from_fork+0x5b3/0x820
   ret_from_fork_asm+0x1a/0x30
   </TASK>

  The buggy address belongs to the variable:
   arp_ip_target+0x80/0xa0

Bound the loop with i instead. arp_ip_count never exceeds i, so it
stays within BOND_MAX_ARP_TARGETS too.

Fixes: 5a5c5fd48e3b ("bonding: arp_ip_count and arp_targets can be wrong")
Cc: stable@vger.kernel.org
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20261023104528.232427-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index cd148bd014fae..1bf3ba0ebdb12 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -6272,7 +6272,7 @@ static int bond_check_params(struct bond_params *params)
 	}
 
 	for (arp_ip_count = 0, i = 0;
-	     (arp_ip_count < BOND_MAX_ARP_TARGETS) && arp_ip_target[i]; i++) {
+	     (i < BOND_MAX_ARP_TARGETS) && arp_ip_target[i]; i++) {
 		__be32 ip;
 
 		/* not a complete check, but good enough to catch mistakes */
-- 
2.53.0



