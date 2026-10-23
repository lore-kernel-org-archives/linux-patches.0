Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774137;
	b=HYaV5eXvSJOcE4X31WYJ+JORdfDmNLgmN+LHTwMchiW1x3iLM96Z6+MNfMbnJLD3iBJi
	 RJzylRn+nv/c2Lvl6fMcFK17fuKXS+4DqlDamH8Vn86UoqftyaWx/mC4Gh6AjFeEJVWvL
	 aVNSJKEGrTn6REGG9r27LdYTbcH5TqBmH9NJIGRXy15r+ADYkTpxGnYU6PotY/N8z6NBb
	 bG6Bm8zaFF5YCuEE//Cd3uYRP5yVa45otL4hxRUxARBrclTUMDBljeAxmEY3XJ17ATYhw
	 C5dV9MOnTavqBxT1EsyvcCkwvgKFWd1GBr0XYR2DeTjE3ikiy+CLSJpHtjFYPh1GCWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zWfIsdHuk9hJ/Tfnue2T7yQVdADXK0bqJJOGhqfHeiw=;
	b=veN1tyikSAhKp0i3PYUuSWsvNGHLjpwYEhqcCRqmODO9qPe1hGzEOCxSoytguhucYq7P
	 mUAVwf2u/VT0XTQcJZCwOYw384+9zSmP5GP5HaUl1KMaAX1rY958FB68b7IfsKDRLt3eE
	 7ozjZu0tlCMASjDiSlaCVEc2h853w1MJ1wYq0T47r8a9vbiO8BLLPISETe5PKz7QBZm4X
	 3eMQpJW2fFpCZZq/OuXkR5D53wsUFh57K8zHaY3A4tSAQNmwtXR6UxYxKqlJhPYiTc81F
	 H1EJGFCrILOuMk+HJRVC1oWvz0nLql6BAJgm9zzqqPBB3hU5GGXW/1Q4LNav/2pbtmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LG6mnDoZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F22606A32F;
	Fri, 23 Oct 2026 16:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LG6mnDoZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013D61F01829;
	Fri, 23 Oct 2026 16:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774136;
	bh=zWfIsdHuk9hJ/Tfnue2T7yQVdADXK0bqJJOGhqfHeiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LG6mnDoZYBFMbQihP8zOTN5Abd6z4DRmTgAPM7NR7YLeJiG/QaUGkQH3FbobkK0Jz
	 UV/qjsRlhBeLVuFlRc5Cji3SMj81+caWVVpSNLbtqJCKC3d1scrkIL1HG/YiPdG9Sy
	 akGgfkke/KyvzDyG6EQN2rTbXU8mprE3OhdcOVng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 132/193] netlink: specs: fix the conntrack filter type
Date: Fri, 23 Oct 2026 18:36:49 +0200
Message-ID: <20261023163717.331591643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


