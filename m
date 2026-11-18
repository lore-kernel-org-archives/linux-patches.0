Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042507;
	b=Gl7wiOVLQmsdKNMZBnB1tBjrEFOKXdNOaP+Wqs4eb9SVw/EDpxMfIPZHc7+S90digK30
	 0kEB09Rk12WCzMGBK2jvkH3YIo0PVJXlQdQv2h/vwRAB13n6tWGtvpWbBiljLgy7c/i3e
	 WDuS/MHMf/4TGapx7PTILUHH7nHMwynTPB3aVppWJ2AFkODXG7tsPgAz2ZcWFncYlLVDe
	 hbozBH9a9XLigNkm2OdVrQHJP09VDtbcqo0tRLIpgmWp6vSrHZXqLg3Zx9MvaNwIGZ+Rg
	 SPRiuHNPbXCyIqson4P4pqEaXb3hvKmXwWjN7DRRP5Q+Ed2TaK9OB8BlpR/kTyXMqCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AHQD07R18r+n/gTjRdU4tx0b5KgIKUyl/DcYtEFewp4=;
	b=3DCs5NP87kqbUQWbeqLsxUz7v+KaiMFOVnJfs4zJgek7WI5kYC9g6e7mIskd9x23TZwt
	 hbSRTkI7ZR05zt6ZffJIGe66X5DmgRyetSC5xSTNnW8RChy/O2PZVE5G4LJNUsGYbZSS3
	 7stsP+bgG4/kHnOxQFhJhQ9HvBghf4Y7VXsoLYpLlZQmavYU0J4YwpSoNDaFd10bS19NT
	 O4W3IBrSaNRcZqmZ25uECZx3tpgAggHcBsp3a1U/17lMF2YPJ/3f1pT5dQriWAjioDYjV
	 n8drdmrA4hvo2uc7/fH3kCkw7T4yPEQyPJMhDyZryopRwkEuzW7SfU60VSp5wSTSTbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VSHgSe+k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1726F606A31C;
	Wed, 18 Nov 2026 22:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VSHgSe+k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C63B1F000C4;
	Wed, 18 Nov 2026 22:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042506;
	bh=AHQD07R18r+n/gTjRdU4tx0b5KgIKUyl/DcYtEFewp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSHgSe+kcJPTVCHiFevxGFak419eqLE0shFSaT8O3Sk9rO9uo0FKA1K7uiwHCp8tL
	 aqNGH7QXZOHrl0a0ThtWBFpHSQKsBOgMQ2/NRWdNXODuB0akoGq2mLcjAryOfSlUds
	 D7PeeSHbOCQQPm1FbP+eE10q0FEJ3DeN9tNIqtz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3194/3318] net: xps: bound the cleanup loop by the old maps num_tc
Date: Wed, 18 Nov 2026 16:03:36 +0100
Message-ID: <20261118150455.596613486@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit 6d5a2cb0b7d6caf170d37ae7ac74738d592d2a05 ]

__netif_set_xps_queue() walks the OLD dev_maps to free its entries.  The
per-row trip count uses the NEW num_tc while the row stride uses the OLD
dev_maps->num_tc, so when dev->num_tc was raised without rebuilding the
XPS map the last row indexes attr_map[] past the allocation:

  BUG: KASAN: slab-out-of-bounds in __netif_set_xps_queue+0x1458/0x1ee8
  Read of size 8 at addr ffff000014f69458 by task insmod/112

The loop frees entries in dev_maps, so both the trip count and the stride
must come from dev_maps->num_tc.  The map is sized
XPS_CPU_DEV_MAPS_SIZE(old num_tc)/XPS_RXQ_DEV_MAPS_SIZE(old num_tc, ...),
so iterating the new (larger) num_tc reads past the end.

Fixes: 255c04a87f43 ("net: embed num_tc in the xps maps")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://patch.msgid.link/20261021155538.67867-1-phx0fer@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 61dfbfd283634..a270657f672fb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2755,7 +2755,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		goto out_no_old_maps;
 
 	for (j = 0; j < dev_maps->nr_ids; j++) {
-		for (i = num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
+		for (i = dev_maps->num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
 			map = xmap_dereference(dev_maps->attr_map[tci]);
 			if (!map)
 				continue;
-- 
2.53.0



