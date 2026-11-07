Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065270;
	b=p/wPOXOZROn1oZaSqymbBSgVup/pdv57isj6krrtvhoC0lHoloHDodpNJqTCdhpZRfIs
	 kQv4MnqJVvjoes/hUXupjqdMIhEDnoJyEuXv3TrcASvj9vuro2oFyazD359U4vaWdFWqi
	 oMKqMFX2ro34cKoMXzGuzuCa8rrquBDXDU0bPsQPOzbl0wGcUGpywhs9D0Bil63pi0T+d
	 MGp01JGgqsyX2Jn2um0pCyYOXYArCY3qMqZG2scvp+r/O90/nULYbAsCDK8PFXmvzaneX
	 AltFGE9ELuCEBMmopvK6uhPQAnF8GMfUACq8gPBvZ4UCZZmSoqTc/E4WUTPtlpF6L0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zkck/OH2c27/J2qLN0nb36GLECCKjMyF12Z8Mfa17go=;
	b=Z5HPCVpGDnHVgkNCThYf2POv+T7qXxUcCYR4t9W7G+AAw01RxptIlss8lPTOLJZUAArg
	 djTl2ERoQnroZ9/vEtHVfl4U0Wh+oC3s7avq1uq2GqNwgfnThmGhjeBg02V9o9alR89v6
	 plTUhvrGXDnS/iT/lLGLnTn3lAYvAC//TjFAf5B059yW+ID8iseqmtRYX4QMZd4YYdCMd
	 UVEqs1sBUi3EttV8dFHAG15QD+Wh9hUBgzcmUybY8/JDWxGvUtY6Pn7pPk0zkPy7e2p9X
	 3t41UDhAgb5eg8a9On5oPSmvjDIrVqwSACvoAujG+jZKhv3aRoztyzkmegoPDEMVnhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dkbdk4YT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFC4606A32C;
	Sat,  7 Nov 2026 15:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dkbdk4YT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098A31F0089F;
	Sat,  7 Nov 2026 15:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065270;
	bh=zkck/OH2c27/J2qLN0nb36GLECCKjMyF12Z8Mfa17go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dkbdk4YTwz3k+23I7zflI6b4NDGlC/vvAQwBmhNlPFdYFvdpvr23eD/fe4U5dBnzq
	 dFMxAbU1OIDxTSCMuraHLqDoI7Ck253Pq7Vyr+b0MOL6eeRm7SmTuHz9oC3328Ia/6
	 6lgnldM89nlOWVMejIIGEpnACLt0rE4XB02tBVs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0974/1257] ipv6: do not restart DAD for a dead ifaddr
Date: Sat,  7 Nov 2026 08:54:30 -0500
Message-ID: <20261107135006.259576065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit ffb668669ce4144347973d8b2fad449e9be0563d ]

addrconf_dad_failure() can create a stable-privacy replacement without
RTNL. After ipv6_add_addr() publishes it, addrconf_ifdown() can mark the
new ifaddr DEAD, clear its route, and unlink it before the recovery path
takes ifp2->lock.

The recovery path then unconditionally changes the state back to PREDAD
and queues delayed DAD work. The MTU teardown path can leave IF_READY
set. For an optimistic address, addrconf_dad_begin() can consequently
pass the cleared NULL route to ip6_ins_rt().

This follow-on was found by source review and was not separately
triggered at runtime.

The new ifaddr is already initialized in PREDAD. Under ifp2->lock, record
the retry and queue DAD only if teardown has not changed the state to
DEAD. If teardown wins after this check, the work observes DEAD and exits
without reviving the address.

This complements the existing lock_errdad check that preserves the original
ifaddr's DEAD state after the same function reacquires its lock.

Fixes: 5f40ef77adb2 ("ipv6: do retries on stable privacy addresses")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <netdev-bot+sashiko@kernel.org>
Closes: https://lore.kernel.org/r/179161099408.434549.14449036924552933828@kernel.org
Link: https://lore.kernel.org/r/20260513025509.3776405-1-lilinmao@kylinos.cn
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261015050651.1841557-5-4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index df56668122619..a2d3fb187f768 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2198,6 +2198,7 @@ void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp)
 			     ifp->idev->dev->name, &ifp->addr, eth_hdr(skb)->h_source);
 
 	if (ifp->flags & IFA_F_STABLE_PRIVACY) {
+		bool start_dad = false;
 		struct in6_addr new_addr;
 		struct inet6_ifaddr *ifp2;
 		int retries = ifp->stable_privacy_retry + 1;
@@ -2236,11 +2237,14 @@ void addrconf_dad_failure(struct sk_buff *skb, struct inet6_ifaddr *ifp)
 			goto lock_errdad;
 
 		spin_lock_bh(&ifp2->lock);
-		ifp2->stable_privacy_retry = retries;
-		ifp2->state = INET6_IFADDR_STATE_PREDAD;
+		if (ifp2->state != INET6_IFADDR_STATE_DEAD) {
+			ifp2->stable_privacy_retry = retries;
+			start_dad = true;
+		}
 		spin_unlock_bh(&ifp2->lock);
 
-		addrconf_mod_dad_work(ifp2, net->ipv6.sysctl.idgen_delay);
+		if (start_dad)
+			addrconf_mod_dad_work(ifp2, net->ipv6.sysctl.idgen_delay);
 		in6_ifa_put(ifp2);
 lock_errdad:
 		spin_lock_bh(&ifp->lock);
-- 
2.53.0



