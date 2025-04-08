Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D520219301;
	Tue,  8 Apr 2025 11:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112118; cv=none; b=jQIg1wgthxWlLwJPZuJMFT6YdykXojqZcNF0KIwylswguxrzjTR87x5yMk7EzeSaiuA4faTHyMjGkHzDJeG9p384DVQJTCG4NsLVJ3qdQmfvVtQ57ogd/vMYvriBTOQcUmVmWxVZuE6jdciybAPYeMS9ddtXlSdEXIGaQylD+3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112118; c=relaxed/simple;
	bh=Y4tMvST6cjI8usn0KpLZf4gT7DEnKdHJZr3oksGUPeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knzEb7tWApCd3ZtzJ+W7w0tcfbICPOQvTBZML9HZdS3oX2xh1a+mYUjmm4KU4YRH+CFPBttIb+INh7v7Gs9AIZo5tXyVVl4Y0nSkvWkiaU+nVq4uIrYsGBvx2uYcpPhFxdqemUWIDDvmUmdxBBxTz0EgP4kKmS7EFq0AFm5u960=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6D2rQp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6D2rQp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E006C4CEE7;
	Tue,  8 Apr 2025 11:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112117;
	bh=Y4tMvST6cjI8usn0KpLZf4gT7DEnKdHJZr3oksGUPeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6D2rQp3JrZIYaPOglSURU4AK4UI4CpVpTqhvcehtBeEO0D9cct5B6cSBGmyvYfk7
	 BiIxqea544DybgAwrQQt5wEnPXedIGgisxyumRbHQAWDZENL6hrP4RxA6AmlRjvPct
	 DR1zWYugn+H6/HdhmG8Ig2PQo4R3s5Gk8A4Hr8f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 643/731] netlink: specs: rt_route: pull the ifa- prefix out of the names
Date: Tue,  8 Apr 2025 12:49:00 +0200
Message-ID: <20250408104929.223309636@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1a1eba0e9899c286914032c78708c614b016704b ]

YAML specs don't normally include the C prefix name in the name
of the YAML attr. Remove the ifa- prefix from all attributes
in route-attrs and metrics and specify name-prefix instead.

This is a bit risky, hopefully there aren't many users out there.

Fixes: 023289b4f582 ("doc/netlink: Add spec for rt route messages")
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://patch.msgid.link/20250403013706.2828322-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/rt_route.yaml | 180 +++++++++++-----------
 1 file changed, 91 insertions(+), 89 deletions(-)

diff --git a/Documentation/netlink/specs/rt_route.yaml b/Documentation/netlink/specs/rt_route.yaml
index a674103e5bc4e..292469c7d4b9f 100644
--- a/Documentation/netlink/specs/rt_route.yaml
+++ b/Documentation/netlink/specs/rt_route.yaml
@@ -80,165 +80,167 @@ definitions:
 attribute-sets:
   -
     name: route-attrs
+    name-prefix: rta-
     attributes:
       -
-        name: rta-dst
+        name: dst
         type: binary
         display-hint: ipv4
       -
-        name: rta-src
+        name: src
         type: binary
         display-hint: ipv4
       -
-        name: rta-iif
+        name: iif
         type: u32
       -
-        name: rta-oif
+        name: oif
         type: u32
       -
-        name: rta-gateway
+        name: gateway
         type: binary
         display-hint: ipv4
       -
-        name: rta-priority
+        name: priority
         type: u32
       -
-        name: rta-prefsrc
+        name: prefsrc
         type: binary
         display-hint: ipv4
       -
-        name: rta-metrics
+        name: metrics
         type: nest
-        nested-attributes: rta-metrics
+        nested-attributes: metrics
       -
-        name: rta-multipath
+        name: multipath
         type: binary
       -
-        name: rta-protoinfo # not used
+        name: protoinfo # not used
         type: binary
       -
-        name: rta-flow
+        name: flow
         type: u32
       -
-        name: rta-cacheinfo
+        name: cacheinfo
         type: binary
         struct: rta-cacheinfo
       -
-        name: rta-session # not used
+        name: session # not used
         type: binary
       -
-        name: rta-mp-algo # not used
+        name: mp-algo # not used
         type: binary
       -
-        name: rta-table
+        name: table
         type: u32
       -
-        name: rta-mark
+        name: mark
         type: u32
       -
-        name: rta-mfc-stats
+        name: mfc-stats
         type: binary
       -
-        name: rta-via
+        name: via
         type: binary
       -
-        name: rta-newdst
+        name: newdst
         type: binary
       -
-        name: rta-pref
+        name: pref
         type: u8
       -
-        name: rta-encap-type
+        name: encap-type
         type: u16
       -
-        name: rta-encap
+        name: encap
         type: binary # tunnel specific nest
       -
-        name: rta-expires
+        name: expires
         type: u32
       -
-        name: rta-pad
+        name: pad
         type: binary
       -
-        name: rta-uid
+        name: uid
         type: u32
       -
-        name: rta-ttl-propagate
+        name: ttl-propagate
         type: u8
       -
-        name: rta-ip-proto
+        name: ip-proto
         type: u8
       -
-        name: rta-sport
+        name: sport
         type: u16
       -
-        name: rta-dport
+        name: dport
         type: u16
       -
-        name: rta-nh-id
+        name: nh-id
         type: u32
       -
-        name: rta-flowlabel
+        name: flowlabel
         type: u32
         byte-order: big-endian
         display-hint: hex
   -
-    name: rta-metrics
+    name: metrics
+    name-prefix: rtax-
     attributes:
       -
-        name: rtax-unspec
+        name: unspec
         type: unused
         value: 0
       -
-        name: rtax-lock
+        name: lock
         type: u32
       -
-        name: rtax-mtu
+        name: mtu
         type: u32
       -
-        name: rtax-window
+        name: window
         type: u32
       -
-        name: rtax-rtt
+        name: rtt
         type: u32
       -
-        name: rtax-rttvar
+        name: rttvar
         type: u32
       -
-        name: rtax-ssthresh
+        name: ssthresh
         type: u32
       -
-        name: rtax-cwnd
+        name: cwnd
         type: u32
       -
-        name: rtax-advmss
+        name: advmss
         type: u32
       -
-        name: rtax-reordering
+        name: reordering
         type: u32
       -
-        name: rtax-hoplimit
+        name: hoplimit
         type: u32
       -
-        name: rtax-initcwnd
+        name: initcwnd
         type: u32
       -
-        name: rtax-features
+        name: features
         type: u32
       -
-        name: rtax-rto-min
+        name: rto-min
         type: u32
       -
-        name: rtax-initrwnd
+        name: initrwnd
         type: u32
       -
-        name: rtax-quickack
+        name: quickack
         type: u32
       -
-        name: rtax-cc-algo
+        name: cc-algo
         type: string
       -
-        name: rtax-fastopen-no-cookie
+        name: fastopen-no-cookie
         type: u32
 
 operations:
@@ -254,18 +256,18 @@ operations:
           value: 26
           attributes:
             - rtm-family
-            - rta-src
+            - src
             - rtm-src-len
-            - rta-dst
+            - dst
             - rtm-dst-len
-            - rta-iif
-            - rta-oif
-            - rta-ip-proto
-            - rta-sport
-            - rta-dport
-            - rta-mark
-            - rta-uid
-            - rta-flowlabel
+            - iif
+            - oif
+            - ip-proto
+            - sport
+            - dport
+            - mark
+            - uid
+            - flowlabel
         reply:
           value: 24
           attributes: &all-route-attrs
@@ -278,34 +280,34 @@ operations:
             - rtm-scope
             - rtm-type
             - rtm-flags
-            - rta-dst
-            - rta-src
-            - rta-iif
-            - rta-oif
-            - rta-gateway
-            - rta-priority
-            - rta-prefsrc
-            - rta-metrics
-            - rta-multipath
-            - rta-flow
-            - rta-cacheinfo
-            - rta-table
-            - rta-mark
-            - rta-mfc-stats
-            - rta-via
-            - rta-newdst
-            - rta-pref
-            - rta-encap-type
-            - rta-encap
-            - rta-expires
-            - rta-pad
-            - rta-uid
-            - rta-ttl-propagate
-            - rta-ip-proto
-            - rta-sport
-            - rta-dport
-            - rta-nh-id
-            - rta-flowlabel
+            - dst
+            - src
+            - iif
+            - oif
+            - gateway
+            - priority
+            - prefsrc
+            - metrics
+            - multipath
+            - flow
+            - cacheinfo
+            - table
+            - mark
+            - mfc-stats
+            - via
+            - newdst
+            - pref
+            - encap-type
+            - encap
+            - expires
+            - pad
+            - uid
+            - ttl-propagate
+            - ip-proto
+            - sport
+            - dport
+            - nh-id
+            - flowlabel
       dump:
         request:
           value: 26
-- 
2.39.5



