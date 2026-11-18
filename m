Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052896;
	b=QoCPQoLaVsHghhlMPq2h98KSiRybIE3qa9IHxdyTefIJAj91jRlPhMypI/TmZo26hohN
	 mKtUqAySSXQZOicw/U8+yREgsxcpdkmRnl+51Ujv3hM9ac3t33lARyI2XoncSuLQwuUTy
	 mwWOiZJitNSTtUwD5+k4SPArD5TWPLpw4IXIDOuQ4ZjSDse9XjYmHs7Z2npCllNDebluV
	 eeLhoIFVhyKYwhofcdLHr2bAdZ+xpZwbk47JOqEuAvyjBKHisKRvTMH/qgr5fug6XV+bp
	 13Q0GI/grZXeWhRC0/MiJ4XBgmci74M2WkekrvlfT4NWTtzqbQQFI3JkcgtNsu+Tvxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OqvOQQxlY/BWiZXRU59NQfX5iPE+cBFUYhvL5gMTUU8=;
	b=46DOSxMtAmXVb6B3T6KVTiK/S84WobSXBQc1kHh38MGgqa+Z/meXyULKKxG/IdOcv9Qg
	 OSLC6wYDpB6quyPbbFGvmcWWowcZurjAwfdwUPRwEqRUkOowpnumtlBT5ScXSO4tIlRd4
	 H904NC6f4cYBbYwiSPG8DwQClPxcoqguEnXghhslq8DUbO6d6c7f7yRzsAJyNE0Uk+dHq
	 goSLs2+yFyp9jPPOg6c5QKAS82kQzWTgGDW67e45DZNgkqvMn8Po/dQVgwGUu7Y5YLmCc
	 xFt14b4THc0M+FQzdyyR1UTedKzJU7q5H+g7iTb1zzB726DXquxHmpj3PROsqYW4nMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IVCvaW+M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24277606A320;
	Thu, 19 Nov 2026 01:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IVCvaW+M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809381F000CA;
	Thu, 19 Nov 2026 01:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052896;
	bh=OqvOQQxlY/BWiZXRU59NQfX5iPE+cBFUYhvL5gMTUU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IVCvaW+MvZK+7gTNadQ292cIuJWu83J/RWoqrMIXSSsDhr8du3EC2jAJJnIFMrpj5
	 nkSFR8dMXOWV/oN+JaeAirhNGG6W4++eXFVshoMJDie0rJnxMGGzJdn5DwhHiBpYT9
	 UEvErNioWBli6wMEjSK1z4Lm87I+FvPYDhLEFiFA=
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
Subject: [PATCH 5.15 0724/2214] bonding: fix out-of-bounds read of arp_ip_target
Date: Wed, 18 Nov 2026 15:40:00 +0100
Message-ID: <20261118150040.739270934@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 12dc1d3c6e2b6..558bff14740bd 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5757,7 +5757,7 @@ static int bond_check_params(struct bond_params *params)
 	}
 
 	for (arp_ip_count = 0, i = 0;
-	     (arp_ip_count < BOND_MAX_ARP_TARGETS) && arp_ip_target[i]; i++) {
+	     (i < BOND_MAX_ARP_TARGETS) && arp_ip_target[i]; i++) {
 		__be32 ip;
 
 		/* not a complete check, but good enough to catch mistakes */
-- 
2.53.0



