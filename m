Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774893;
	b=btn+EP2sx0mRaLL0loeFSoLmxgE/sBbxot+xH4AIwNKwh1SSyDX/sHXLXmkZkc2Rsvim
	 OpHWF0tgNS0Kq7JrA1pJcGIj7O059C50Gdf5zb6c+hOHvjIWikSvWEl2AVdyWMNS0NHHn
	 ba4FsVODHHxyR5aOWoFg0XIZQYuSTw8wfTPD7nlFB1HVyIgUlYP9avBLCP9tdO+J6Xtny
	 9xrwIVmTdCb+PS26zR5rT0pS2EB9iSnJMPsF7+zKzI49jOvsFZnMGqkTT7gElBQqmch5M
	 2EdkO0hpeA6z2chMQdcFCeZacBtXkGyBIOwy69SVnrTi9ktaA+3j7vv5BEzYA06rKAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+/d+WjmhGRzdrd6bYf3GzBfM8MnszXW5wOgAb/Blgq0=;
	b=nTgUKZkmDxwT0VMRrWd3l43kOwZT4HTvObXpBGi4G4KrFYjNpy6mXOyIvINJ0W+HAs0C
	 GEoJo8ugyFvVe3wCjagHhE4UYsDkYSpeSQnEZripyZkgWkz+tU4z2863D3iIRXMgo6/RS
	 M0s7+G4d49PBoYjueed7YQfnk/ijhUfhGIeY15ny8updyw3zgZP1E4aXm/Q1GatKRSmY5
	 EDEuPi8mJUZGTXbZxRHdIXHad6T1TWtJZE2FvTOfJy8pROGQOAoPkklwK8sXNoi3AXLMW
	 xTvHqGQCP16geWu9Diaweyr+Va5ukKWZb+0S/vq/qNBH/tSQucacupEpy1hP8WVsR9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yzTa/heD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE109606A31B;
	Fri, 23 Oct 2026 17:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yzTa/heD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7611F01825;
	Fri, 23 Oct 2026 17:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774892;
	bh=+/d+WjmhGRzdrd6bYf3GzBfM8MnszXW5wOgAb/Blgq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yzTa/heD8QyRRegNGKJi119CSGWWEXqIAmYCWvwdhdJKPUdI2fErwuauG8fTfYxt8
	 ZxdvGuZM3iNJariAUjCqlW+3b9PcxwQeIbqnS8dgmZdgjjj7Y9cKnGd4SLIVuMyTcj
	 QqCU23KMhPHspOo1E9bLBCZa0gGwt2gvXdfBr2NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 193/242] netlink: specs: fix the conntrack filter type
Date: Fri, 23 Oct 2026 18:40:35 +0200
Message-ID: <20261023163718.357645602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

commit 2a004bfb62bdb847f25a8001e104bf33922a2cf4 upstream.

The CTA_FILTER doesn't contain nested tuple attributes, instead it
contains bit masks that specify which tuple attributes to filter on.
The values for filtering are taken from the top-level CTA_TUPLE_ORIG
and CTA_TUPLE_REPLY, which are also missing in the attribute list
for the dump request.

The bits themselves somehow are not in the public headers, so not
defining them in the spec either for now.  Once they are public in
uAPI, they can be added here with enum-as-flags.

Fixes: 23fc9311a526 ("netlink: specs: add conntrack dump and stats dump support")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Link: https://patch.msgid.link/20260826220444.4054714-2-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/netlink/specs/conntrack.yaml |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/Documentation/netlink/specs/conntrack.yaml
+++ b/Documentation/netlink/specs/conntrack.yaml
@@ -361,6 +361,17 @@ attribute-sets:
         type: u32
         byte-order: big-endian
   -
+    name: filter-attrs
+    attributes:
+      -
+        name: orig-flags
+        type: u32
+        doc: bitmask of tuple fields to filter on, original direction
+      -
+        name: reply-flags
+        type: u32
+        doc: bitmask of tuple fields to filter on, reply direction
+  -
     name: conntrack-attrs
     attributes:
       -
@@ -466,7 +477,7 @@ attribute-sets:
       -
         name: filter
         type: nest
-        nested-attributes: tuple-attrs
+        nested-attributes: filter-attrs
       -
         name: status-mask
         type: u32
@@ -591,6 +602,8 @@ operations:
         request:
           value: 0x101
           attributes:
+            - tuple-orig
+            - tuple-reply
             - mark
             - filter
             - status


