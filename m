Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028875;
	b=caGwdXNM1fQCgdSFJF+CjaKe/PD5Tu/UlWBXE+iBb8pA/yD/HzGEf16SBZrDJ/1uN8CK
	 4A3YnBqM2O3Vy6EIsjuDJLm5ZXKI2wb+nsPbVl+j15HgSjfpdlTA7o4Bpima+woJHLI5k
	 gtxbyBz4YR4BzEUGdfO5BMvSiXOrJteGmB5UjvUTaEIdalAIg17bno4dmb/PTpakGzdh7
	 gdzmZawTI7nyY74QQGFbb2DvI0m+Ve9p8IZT0bNC5jeWgQctdFgmV3DnIOKpt8DkGUskx
	 Xr9JGDkCE6wN2vaFFnQBZTjLypkX0J7Kqof6dnbEXWuoiGYKJe4fHqYk4HcEfUqu/Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U4hHMfABW8weGRl9IxMWU66fA/5bYQfAGpq0125/DTo=;
	b=KhbyvzD61FQRIC0T5m0CXo/HSOws3jqqfpd8E5jlGXC379GpHndMGcMF49DDwlUof9RA
	 JN5N69x+D77Z7zSMxYciD9ZR8hyCLxbj+3KcwGEx7WwaonluAXohK6hVpozeTVAeWYaw1
	 uh0VJFZzmiEnm2bx3kDmv2S9jJFTMXHlGWatpHNMB7hzZelI59h+4pXkAF+IXVTfniZFZ
	 Ruho44O148a5JY1JBnJIQhDKet+5OD+NXD2Tp6eoY8fZOSdxYtGtvYO9tzfcr7+iTwyHt
	 E5ZHuFLgNcfwSopnuQaKzFhBL7BFCBkBXKkv6Q5Sld4u1VwMNbMpO974s4RpCwsySwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cGl6zcS4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5830A60A260E;
	Wed, 18 Nov 2026 19:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cGl6zcS4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709E31F000C4;
	Wed, 18 Nov 2026 19:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028875;
	bh=U4hHMfABW8weGRl9IxMWU66fA/5bYQfAGpq0125/DTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cGl6zcS42moFm6aOQTgRRMsXslSZUOG9yNUQRRU4warMQ4yl4+/utQz8vtzm+GeX/
	 5FfyVUGZk+pVB0usbaDTfvMaU09B7KtwL7CxQ0kxyRxsGmgQeMqyrDYv3bqz8WFgkG
	 g2EneN1E55EaX4scCHEy6ets1IVSi75WMHIhDn6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0113/1756] rose: clear the other half of a through route a new call takes over
Date: Wed, 18 Nov 2026 15:37:20 +0100
Message-ID: <20261118150012.699816520@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



