Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590317;
	b=cRrU38MsKdJ0eTzUnx2R3dyIL6zph9QSxnsaVPWlDdMCxl17Ulaki3F7tvwCg5L9HQnN
	 hPEzRzcDoLx1ABQL3bCr4kHjK+39io8fbMibP0jYoOjLjpLNbz0ZOb/PzOdJ98vWq/odu
	 2qhHQowfJynHg06YTxmwXINCZEjeHn+lec2XOS17MvyNhGU3AD+PxBwilCEPjccOQ0OzZ
	 e3eEjP9KQnoUEsrX5ZRy5BJ9h0Ya8Vkk0ScPQ61WigS+wBubAa430khqcbG7/lESURt5i
	 TnwC5P8DWpn32HSpYnMoYA7kZuxin8l45I/WBoaAHmeGCf+qhQOhA7KHgbfYoYKtSCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Iw/43NndVYAgymiIlGt+CTMpczIS3zIKRDVF+F2TbJM=;
	b=NWpVnIylArT2yjaQ+z8zH//17zwFzRM5x85Ma68XIseUangZCrYH7BXJC3GZaFbhTa+5
	 xGTIke5ifmpa/Iixk/4kHTLJ6pQegGlileaL9l3deeBPzXmFBpGxSgJFl/wTJuYSchheL
	 ZA3A2Gx7R6H9LTH4zdVg6HatI9MNs5miW7NWMBP8LV1CJw1nns5yqoS9R8VId0h0R1kyu
	 Wim6XGKi9DUMXm4oqJDDsHnaRLqEBaRmZct/UuUOOfpRsuvTWeuOMoyzcDzBdKckkKXNO
	 Bf7jJdiwLcCui0w0CQ1ZVpAKIOec1tm5ZkcDSPutrXUHlq/+At+RKvV7tFZ/LWXu/sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2QmxQpTj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77603607E041;
	Fri, 13 Nov 2026 17:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2QmxQpTj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04101F000C7;
	Fri, 13 Nov 2026 17:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590317;
	bh=Iw/43NndVYAgymiIlGt+CTMpczIS3zIKRDVF+F2TbJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2QmxQpTjG9M6dwNyjhdJAvsSUe6CZmEn7CzB2Qyy6EEu5/tRIuzl9wyt8UWDwJuwI
	 BVC8ZUhoq+eBdedn8M/btHVOjCTR//SknOwtzkNoYHF49Z6ao5bdXN50ELOESWQUWb
	 zrKWd27tjRwp4zPInGOhz0Mu+5KIKPl/W2loIvRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Yingjie Wang <1075151112@qq.com>,
	Alex Henrie <alexhenrie24@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 300/686] ipv6: reject wrapped temporary address preferred lifetimes
Date: Fri, 13 Nov 2026 10:47:13 -0500
Message-ID: <20261113153831.120881493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 527ae9fc1c41c..8f651cafcb2a5 100644
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



