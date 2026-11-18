Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058722;
	b=Vg2NZ/I73N45POv0G3gVdjEDpmct09qoKsdOu5tFrBkBYn7Mr4y82va4EJZ+F0IvxOFs
	 1Z8smpY5MehkduC5WsBxDe1ZFixgVpknDDJ7/pS/5+rmDimf1b0/naTbvc7v0Ax4wZysi
	 dYhjv5vMWqQZ1XGx0cqaAjTNKW0QYiHuTM1v4la9bQDXXlaO0YoZbymBCDwPx6zkwAHer
	 JfvJmcZsf5TDXp67qIUmfzxR42Nvg4KtRF/R4p3Lwx7Kv6LeKsvaPNXzajqKVwnDYeS/S
	 TERD7XrNYcUvsctgh8lsVHzlxFc77C5gmDOH4mJz9PoKXGmQDHzJrzmEBrS/1vR27Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lnt/Om/GxtKM3VgCi5gSditX4J7mp8lCJXSNJvaw5RE=;
	b=Q1r15j3NSzW745u4DBUCtb3mMU54oM+0A8JXe7TC7+XstOiIfNr0KNducSMzc8Kfp3ij
	 MErJ4kjrED3w+Yfd9amyOrqt98xaAj6I3p+aSi1WJ3if52r3YywKIpWJnhGheUejCls90
	 SAgMrtD7kElHyIVARfbsMLm1H+XudqHQgGK8/AvC9jURdF0n5tYr30gFV6LuOX2Uv2A2m
	 WDYcdjR8HCcKR26RB21185IV8OWlk7EyZkmxcm5cMSZuzE+AdEqOOiGr/wDGDLY/I5pUL
	 K8Zws8Z1xeWPdlh90vwzzlrRlQq++ALDvu8pEiC0VG8R3J/1ba/iLxEh3RUjH8ZG9CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ykFI3iyD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F05E606A320;
	Thu, 19 Nov 2026 03:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ykFI3iyD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069BD1F000C4;
	Thu, 19 Nov 2026 03:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058722;
	bh=Lnt/Om/GxtKM3VgCi5gSditX4J7mp8lCJXSNJvaw5RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ykFI3iyD5ju/4zCx/oBGzw1Nl/6P5190FLVnT0/e/BTQsL+4ZPy7eeDhhTxhhsQDH
	 y2SoJ3qlklI87QRk8efGJ4Dc9nWU3ePzJvliPFdezqjAksR5Ucy15I+W/CuSFcFwoH
	 V+C48oXB6Ojeqcx/GdS1/lM6zh7QnIQO19271/iY=
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
Subject: [PATCH 5.10 0588/1848] bonding: fix out-of-bounds read of arp_ip_target
Date: Wed, 18 Nov 2026 15:43:46 +0100
Message-ID: <20261118145940.056388462@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ec712fdeaa4c5..0d56ff2a8bd1a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5178,7 +5178,7 @@ static int bond_check_params(struct bond_params *params)
 	}
 
 	for (arp_ip_count = 0, i = 0;
-	     (arp_ip_count < BOND_MAX_ARP_TARGETS) && arp_ip_target[i]; i++) {
+	     (i < BOND_MAX_ARP_TARGETS) && arp_ip_target[i]; i++) {
 		__be32 ip;
 
 		/* not a complete check, but good enough to catch mistakes */
-- 
2.53.0



