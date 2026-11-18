Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022721;
	b=j3X6g4zd25Gs4lwZL6kBfvPtpsLDOO7qEdWRrNII1cdmzC0i9n0RH1cULm/XGS0QsYu+
	 9wBwuSwhuJGqr/P8p/pMKMTYs5hb/zOtkdQyOAR6uKSEW/4lqZeWgLrwSyWfdCe+lgkVT
	 kgHW+AD5dAuQNeL1xGNAFOl90S7lBrl+KcguGSZV1Rd49zOnkNSQQBcjQ72zm4ccFt8GK
	 sDUrY2wFWZqg8UMoiu9Jrc3ygbH8PNt08aqCLQCwku6z90TRIgqu1wymNLgskplpnpf0W
	 6Rm2XQ/A7+jW4ulONLY+7Rd9J9cL/RkZb0jl8/MmMX638BAHxBZwTeX07Fb18q3kJog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LYa2WtB485HaqmHanMZF5LoB1A04wJtEw6i/UHJvmes=;
	b=J4lzS0lmfEwv1bFcQJb2sG1njYMrXXB2spkkrv/ihwLDdhlF+AeUPSxwLGn1e5SXWOsi
	 3/rFUJQuQCZW4m0cGAqRK0XL7Rpqnqwg4aZiAGJD1t3C6S2RDNtBt3S5xyI277TSl4NfJ
	 vsIfE/sFmTsizOHLaCVkX2yE+Pr8CSq7X6GN8723y8/hiXN0Kr+Bqsiq3CFJEeWCsTaiQ
	 oKEAyiDacEaA63fxeXBNzBtNhUBXEILth7a5UAD0xGt1Dg+OK8R81mNVxxJp8PgZbyApN
	 UDosyzODIm2rsi4KogkuaDxaupCHyUYaKyCjsvFHDey6Q09ZqRBPO2TT4z+tXFaQUzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KVXA8o+2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFBC606A325;
	Wed, 18 Nov 2026 17:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KVXA8o+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC731F000C4;
	Wed, 18 Nov 2026 17:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022721;
	bh=LYa2WtB485HaqmHanMZF5LoB1A04wJtEw6i/UHJvmes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KVXA8o+2eBeidMmm+dpnSqkhBPgFhnMzU8mYZSF5pT8L5La52TlIUYVOI5P6mvuJ5
	 qJwAsqO3wmShz0ivZyW/Kv+MaG4u18LAPAjnWurlcSN9jU0/hsQdDxNy4kQS3D9w+y
	 ARSKwOSTPQ6l4W9bdAkrhhFL9h+/nrViJU46R6eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0114/2151] rose: clear the other half of a through route a new call takes over
Date: Wed, 18 Nov 2026 15:30:49 +0100
Message-ID: <20261118150125.948332790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

When a Call Request comes in on the LCI of an existing through route,
for a call other than the one the route was built for, the neighbour
has evidently lost that call: it gives the LCI out again.
rose_route_frame() then removes the route and goes on with the new
call, but says nothing to the neighbour on the other half. That end
keeps its virtual circuit up with nothing behind it, and its LCI on
our side is freed while it may still send on it.

Do as rose_clear_routes_by_neigh() does when a neighbour goes away:
detach the half that the new call takes over and send a Clear Request
on the other half. The route stays for that half until its Clear
Confirmation, which removes it, and its LCI is not given to another
call meanwhile. The cause is the one given to a socket in the same
case, network congestion. A route that has no other half left is
removed as before.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 9b1a1d3395bdcf1eca96d3db517eae195d02a632)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_route.c | 40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 30dfbe1f14311..d23f8d30067ba 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -1145,8 +1145,24 @@ int rose_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 								    120);
 					goto out;
 				}
-				/* Remove an existing unused route */
-				rose_remove_route(rose_route);
+				/*
+				 *	Another call on the LCI of a through
+				 *	route: the neighbour no longer has the
+				 *	call it was built for.  Clear the other
+				 *	half, which keeps the route until its
+				 *	Clear Confirmation, and leave the LCI
+				 *	to the new call.
+				 */
+				if (rose_route->neigh2 != NULL) {
+					rose_neigh_put(rose_route->neigh1);
+					rose_route->neigh1 = NULL;
+					rose_transmit_clear_request(rose_route->neigh2,
+								    rose_route->lci2,
+								    ROSE_NETWORK_CONGESTION,
+								    0);
+				} else {
+					rose_remove_route(rose_route);
+				}
 				break;
 			} else if (rose_route->neigh2 != NULL) {
 				skb->data[0] &= 0xF0;
@@ -1180,8 +1196,24 @@ int rose_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 								    120);
 					goto out;
 				}
-				/* Remove an existing unused route */
-				rose_remove_route(rose_route);
+				/*
+				 *	Another call on the LCI of a through
+				 *	route: the neighbour no longer has the
+				 *	call it was built for.  Clear the other
+				 *	half, which keeps the route until its
+				 *	Clear Confirmation, and leave the LCI
+				 *	to the new call.
+				 */
+				if (rose_route->neigh1 != NULL) {
+					rose_neigh_put(rose_route->neigh2);
+					rose_route->neigh2 = NULL;
+					rose_transmit_clear_request(rose_route->neigh1,
+								    rose_route->lci1,
+								    ROSE_NETWORK_CONGESTION,
+								    0);
+				} else {
+					rose_remove_route(rose_route);
+				}
 				break;
 			} else if (rose_route->neigh1 != NULL) {
 				skb->data[0] &= 0xF0;
-- 
2.53.0



