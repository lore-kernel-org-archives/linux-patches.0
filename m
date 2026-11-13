Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585581;
	b=vwhTMNz3dEpy7Y7txS/CuImURkyDsdYrj8mEkbVamBT6Wk4WRzZIsWHPrLwCuCp2A68Q
	 0wEJep2+zKHrKSg0q22AEBaDdTSwRwhTKlsxnSCDgb/KA3g9lMs25vU83LpYKqsyPIwSz
	 T4QjdzYc4H0E4BlEcbJmoaUK4SsAohPMMJfjbLGutLzj/bkZDg5kqPsSqFFWo4GqUguWv
	 S6aUxt4bovjVvOZaCp9niVNKzEpGG7t1GlNZ3fRIz7eFiqoRZe/toBXqQ82jckRt+2lB0
	 esfnh7fAD+X9RUupzcHu2YM5xEd0qt3bdTI4e9TtfEsNfTQpTb4LUM4VIkbE9cq4tQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9eBrws0+ZT3S41wwHdM4NcOwXnTvMR1E6WVHnZv2Oeg=;
	b=WUATOE2AJasSKKxKDsp1sl5sGAwZjFn+GsJIf+nP0UQeSUXwYt67pwPHQ3KifkxjZudX
	 9cFfEpK6gns+pAUDUnyJq+BT3HdfW7AcLW/jYNME71uPCWJ+LWwFSUC+AbBV3clkMtMjm
	 WvWT/7foxB7uBwVu06bpLKe/NgUqPh+ERs6IB/ySSJoTLaKdGSZM0FK21aMgkQSDvJdP7
	 V6SyfZDx6kQuAK1AjZNlRqYQ9IXDB/Nlg68XZ8P4OES3ybblXdQsf+TxRhjtKW35laZ7z
	 DRxFq8ReBANJCpouskmb4d7Xhii+M3AFljojlH+AaTOVm9cDiM2fm5EHXbej2au7rnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUWB6ak6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D8F607021A;
	Fri, 13 Nov 2026 15:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUWB6ak6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7341F1F000C4;
	Fri, 13 Nov 2026 15:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585581;
	bh=9eBrws0+ZT3S41wwHdM4NcOwXnTvMR1E6WVHnZv2Oeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUWB6ak60AkhkfQJxM6PCuWTTPXVmFo+LIMH4XVgKuLnntt1+zfyg5d/wqmjbkdzT
	 e8iuTzkE/mzjFirBQbL0D9x/ZJJyxkY7g9pPxufgesRHQTQz5SvVzHaKK2DiIBUl73
	 +Bo1STQqFrC1B9ZGL1yu3zHcPEvyS/LdTYIS2dbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Yingjie Wang <1075151112@qq.com>,
	Alex Henrie <alexhenrie24@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 213/507] ipv6: reject wrapped temporary address preferred lifetimes
Date: Fri, 13 Nov 2026 10:48:37 -0500
Message-ID: <20261113153801.705595127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Yingjie Wang <1075151112@qq.com>

[ Upstream commit c3e67bd82b9b9b1a5118f09a429ccefe2aab0741 ]

ipv6_create_tempaddr() raises a temporary address's preferred lifetime to
regen_advance + age + 1 when the configured lifetime is too short. The
result is stored in a u32, while regen_advance and age are unsigned long.
If the sum wraps or is truncated, the stored lifetime can still be less
than or equal to regen_advance + age.

addrconf_verify_rtnl() then sees the new address as due for regeneration
and creates another one. Temporary addresses are not limited by
max_addresses since commit 4b08a8f1bd8c ("ipv6: remove max_addresses
check from ipv6_create_tempaddr"), so this can cause unbounded address
growth. With dad_transmits set to -1, a baseline kernel reached 2859
loopback addresses in two seconds.

After storing the adjusted lifetime, verify that it is still greater than
regen_advance + age. Reject the new address if the check fails.

On an x86-64 KASAN kernel, the normal configuration created three IPv6
addresses. The negative dad_transmits, positive multiplication overflow,
and large retransmission-time cases each left only the loopback and public
addresses. An i386 defconfig and an x86-64 allmodconfig both built
addrconf.o with W=1.

Fixes: f4bcbf360ac8 ("net: ipv6/addrconf: clamp preferred_lft to the minimum required")
Cc: stable@vger.kernel.org
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/netdev/20261029175827.GA1411453@shredder/
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Alex Henrie <alexhenrie24@gmail.com>
Link: https://patch.msgid.link/tencent_7A270291DDE5CD89DAFFE8A745D094D5BD06@qq.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index a2d3fb187f768..3350330c3f1c2 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1484,7 +1484,8 @@ static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, bool block)
 	age = (now - tmp_tstamp + ADDRCONF_TIMER_FUZZ_MINUS) / HZ;
 	if (cfg.preferred_lft <= regen_advance + age) {
 		cfg.preferred_lft = regen_advance + age + 1;
-		if (cfg.preferred_lft > cfg.valid_lft ||
+		if (cfg.preferred_lft <= regen_advance + age ||
+		    cfg.preferred_lft > cfg.valid_lft ||
 		    cfg.preferred_lft > if_public_preferred_lft) {
 			in6_ifa_put(ifp);
 			in6_dev_put(idev);
-- 
2.53.0



