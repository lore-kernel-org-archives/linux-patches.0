Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213657;
	b=ye4vF2nilahfRbXPElZxgbhXVHiZAqp4jDkop6pW/84WcLIZ7EShjPi9ireA8w7V3EJQ
	 t6JBzYssU4hUAF755A2+ZrnwMqmLm5xKYC37Kz/lo+eoc3Xr9xerLWqXpT3LsxG/8WsIo
	 LEKCNwkZtKnmNWXcXX2Oc7VmwQNmP4lCsZcg0Kbwz9MH78abrspPaMcw2HFOmAC/faNW9
	 WXZD4FEiE8eJuaBKljIB2wJsiqwJFyl08q8EUMdAWUEUjkBLM1eyHtk1T1oo3vu6oVxz6
	 CbtIafTEo/dRdXTcSNC59ZDyCNWPcXqxiDQp5dLhtq24q3rtmxgbTIDgWV2RHrb4PsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e3K6f1ue6+QPMDY/lZIO2UodXiBlE3mVXGSPNbIT+wo=;
	b=JmpMnh/DQzp4FwHemkt3ukWxnW2YKJhoXwTgeDymmof3/3ev/XWvc6NlxEUa0hCmlkX/
	 LPwYwQAX0a1EqsYVJl5XM4ncg2iF5X3nYGjZ45C/dx5L/gue4c+sZ+fA952z8las1rY+d
	 X2c/AO8A7rLIQwwUqglsZIiGALFgE7BKtYvHK/2xi/gD7BM4p6LBxLEgFHR51jePtmt7Y
	 NP/ryHgRimswdd7amkZJ6D15Tn85gVm1tm6983L/Ym5oCVc3i6QW/t3QeJITsBtk7WcCX
	 ObYGdmBXCvNeukaiAv5lyZPYX/PCzOB8Jo5n5FM3Y3jnWPgsy2V3+YCLIqf0sVJ0ioQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kaAFIzvG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20090606A32A;
	Wed, 28 Oct 2026 18:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kaAFIzvG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337821F01829;
	Wed, 28 Oct 2026 18:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213656;
	bh=e3K6f1ue6+QPMDY/lZIO2UodXiBlE3mVXGSPNbIT+wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kaAFIzvGLsrLAWOQuuadfZUOBiZYqrRrZwOY694gj6hiLZ/8eEtqC1L3WQXYuVajs
	 vrRY6B0ZV5UpLtakegyIueHyCfh+loymu5rzm2Rp1vGb9NiTUxP2bpdcX1Du4e2RJq
	 ytq7q5rFu2wMYyugWY/MyziPVaTGRsunU4mkakeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0576/1887] nexthop: Do not return invalid nexthop object during multipath selection
Date: Wed, 28 Oct 2026 17:44:32 +0100
Message-ID: <20261028170512.520049366@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit 75f5f04c7bd2163044f80d5f7bea6b79edc288fa ]

With legacy nexthops, when net.ipv4.fib_multipath_use_neigh is set,
fib_select_multipath() will never set res->nhc to a nexthop that is not
good (as per fib_good_nh()). OTOH, with nexthop objects,
nexthop_select_path_hthr() may return a nexthop that failed the
nexthop_is_good_nh() test even if there was one that passed. Refactor
nexthop_select_path_hthr() to follow a selection logic more similar to
fib_select_multipath().

The issue can be demonstrated with the following sequence of commands. The
first block shows that things work as expected with legacy nexthops. The
last sequence of `ip rou get` in the second block shows the problem case -
some routes still use the .2 nexthop.

sysctl net.ipv4.fib_multipath_use_neigh=1
ip link add dummy1 up type dummy
ip rou add 198.51.100.0/24 nexthop via 192.0.2.1 dev dummy1 onlink nexthop via 192.0.2.2 dev dummy1 onlink
for i in {10..19}; do ip -o rou get 198.51.100.$i; done
ip neigh add 192.0.2.1 dev dummy1 nud failed
echo ".1 failed:"  # results should not use .1
for i in {10..19}; do ip -o rou get 198.51.100.$i; done
ip neigh del 192.0.2.1 dev dummy1
ip neigh add 192.0.2.2 dev dummy1 nud failed
echo ".2 failed:"  # results should not use .2
for i in {10..19}; do ip -o rou get 198.51.100.$i; done
ip link del dummy1

ip link add dummy1 up type dummy
ip nexthop add id 1 via 192.0.2.1 dev dummy1 onlink
ip nexthop add id 2 via 192.0.2.2 dev dummy1 onlink
ip nexthop add id 1001 group 1/2
ip rou add 198.51.100.0/24 nhid 1001
for i in {10..19}; do ip -o rou get 198.51.100.$i; done
ip neigh add 192.0.2.1 dev dummy1 nud failed
echo ".1 failed:"  # results should not use .1
for i in {10..19}; do ip -o rou get 198.51.100.$i; done
ip neigh del 192.0.2.1 dev dummy1
ip neigh add 192.0.2.2 dev dummy1 nud failed
echo ".2 failed:"  # results should not use .2
for i in {10..19}; do ip -o rou get 198.51.100.$i; done
ip link del dummy1

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20230719-nh_select-v2-3-04383e89f868@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b72a6a7ab957 ("net: nexthop: Increase weight to u16")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 005465e61ae3d..5dc50bbdd2d07 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1195,20 +1195,22 @@ static struct nexthop *nexthop_select_path_hthr(struct nh_group *nhg, int hash)
 	for (i = 0; i < nhg->num_nh; ++i) {
 		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
 
-		if (hash > atomic_read(&nhge->hthr.upper_bound))
-			continue;
-
 		/* nexthops always check if it is good and does
 		 * not rely on a sysctl for this behavior
 		 */
-		if (nexthop_is_good_nh(nhge->nh))
-			return nhge->nh;
+		if (!nexthop_is_good_nh(nhge->nh))
+			continue;
 
 		if (!rc)
 			rc = nhge->nh;
+
+		if (hash > atomic_read(&nhge->hthr.upper_bound))
+			continue;
+
+		return nhge->nh;
 	}
 
-	return rc;
+	return rc ? : nhg->nh_entries[0].nh;
 }
 
 static struct nexthop *nexthop_select_path_res(struct nh_group *nhg, int hash)
-- 
2.53.0



