Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617671;
	b=ZYqXg+XO85Ah3479g3PqyKXQG3mVIaFyZhP+mTghJpceIGfAcfqTLzZ7vb7QjtZdRPcb
	 aVizeR6vKddXQ0anID1s+8Aw5loKw4b+mlaZUmN8RTablOHm1E/Oshhh6oPFXbGhWw6gM
	 OFO/rrRZVi5cmv7qV52YnW/OYTQ0+TdBvd5OWTqKGvB6GvOZy75gAzW2V9biTwTv1s+Nk
	 kBhGgNq7H6Mq6S/y0rklwjluaFDjzb0wHhhfom3I14RSkMIFypIqBcdcJR0jU4EAvzFWh
	 pOE59CYNdGkm1nxI/i39/xeCHTJ3bmXGepiIWsTTR7XemJQMw9wwmZBictcs7EuhYeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PFrPhR/XLF+tCU3lIIcRCEMas9pQzBDL6UtHxdlCE5w=;
	b=324TXT4kE86phvSnBnh9bc2tOfqsZV1ez/c9kisjgzgjis3rU/8aCDHeRNwz4rU/iPos
	 Lu17JmHFdv5U+JNPyKTvHcvuHkx2WD+3cp2dcxB+6YOiUSpVw5HSlQ8Sl9fn47mhuw9+D
	 TPl4tCMc1DApbDa5QPcwGoB9KXZtPmR+IG59XDKl3eRvuWu/OA6aJd3w3tarvspCDTytJ
	 WVnxajmpqMEc/QY0E3jfW70f1RJGrNFuDq2JeLP3u5LiQbgBTEa78GkO4ynwppKN6aBcY
	 LxBO7oeH+1NEpmRJKaUF7FKGDAmR0OqQAyYyz3sso4UaLjDVLw2OOOXz9Pc1dfd3LzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXlkhl6k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF199606A327;
	Wed, 25 Nov 2026 14:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXlkhl6k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5471F000D4;
	Wed, 25 Nov 2026 14:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617671;
	bh=PFrPhR/XLF+tCU3lIIcRCEMas9pQzBDL6UtHxdlCE5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXlkhl6kw47+oRc71UR2DL+3LnBPR5zJJJ+HfYyYr1Ek2lnqvV80itxbTaFcGQ79m
	 +0FZNlXNyfppazoX4suqGaDHaYOQUWRs9w7T93yr2JN+9K3kndbY2P8SfWOe3G/5hP
	 L8MZRj4reIk4JKD6QXDUUWrxVYZ/LYIP+FK3WZjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antony Antony <antony.antony@secunet.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0039/1005] docs: xfrm: include mark in XFRM_MSG_MIGRATE_STATE EEXIST tuple
Date: Wed, 25 Nov 2026 15:22:57 +0100
Message-ID: <20261125143822.655909578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit dcf413245c8c2351f7f80502f89c344256f61a66 ]

Document mark as part of the EEXIST tuple and update the SA lookup
description to match.

Fixes: c13c0cc6f52e ("xfrm: add documentation for XFRM_MSG_MIGRATE_STATE")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../networking/xfrm/xfrm_migrate_state.rst    | 25 +++++++++++++------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/xfrm/xfrm_migrate_state.rst b/Documentation/networking/xfrm/xfrm_migrate_state.rst
index 9d53cb22b0075..ca2c9e5aaf33a 100644
--- a/Documentation/networking/xfrm/xfrm_migrate_state.rst
+++ b/Documentation/networking/xfrm/xfrm_migrate_state.rst
@@ -27,15 +27,20 @@ SA Identification
 =================
 
 The struct is defined in ``include/uapi/linux/xfrm.h``. The SA is looked
-up using ``xfrm_state_lookup()`` with ``id.spi``,
-``id.daddr``, ``id.proto``, ``id.family``, and
-``old_mark.v & old_mark.m`` as the mark key::
+up using ``xfrm_state_lookup_exact()`` with ``id.spi``, ``id.daddr``,
+``id.proto``, ``id.family``, and an exact match against ``old_mark.v``
+and ``old_mark.m``. Unlike the data path, which uses a masked
+comparison, this requires the SA's mark and mask to equal ``old_mark``
+exactly, so a broad-mask SA is never matched when a more specific one
+was intended. If no such SA exists, ``-ESRCH`` is returned.
+
+The layout is::
 
     struct xfrm_user_migrate_state {
         struct xfrm_usersa_id  id;       /* spi, daddr, proto, family */
         xfrm_address_t         new_daddr;
         xfrm_address_t         new_saddr;
-        struct xfrm_mark       old_mark; /* SA lookup: key = v & m */
+        struct xfrm_mark       old_mark; /* SA lookup key (exact v/m match) */
         struct xfrm_selector   new_sel;  /* new selector (see Flags) */
         __u32                  new_reqid;
         __u32                  flags;    /* XFRM_MIGRATE_STATE_* */
@@ -72,8 +77,8 @@ inherits the value from the existing SA (omit-to-inherit).
      - Description
    * - ``XFRMA_MARK``
      - Mark on the migrated SA (``struct xfrm_mark``). Absent inherits
-       ``old_mark``. To use no mark on the new SA, send ``XFRMA_MARK``
-       with ``{0, 0}``.
+       the mark of the existing SA. To use no mark on the new SA, send
+       ``XFRMA_MARK`` with ``{0, 0}``.
    * - ``XFRMA_ENCAP``
      - UDP encapsulation template; only ``UDP_ENCAP_ESPINUDP`` is supported.
        Set ``encap_type=0`` to remove encap.
@@ -259,8 +264,12 @@ Attributes in the notification
 Error Handling
 ==============
 
-If the target SA tuple (new daddr, SPI, proto, new family) is already
-occupied, the operation returns ``-EEXIST`` before the migration begins.
+If the target SA tuple (new daddr, SPI, proto, new family, mark) is
+already occupied, the operation returns ``-EEXIST`` before the migration
+begins. "Occupied" includes wildcard shadowing: an existing SA with a
+broader mask (e.g. mark 0/0) claims every mark value, so it blocks
+migrating to any more specific mark at the same tuple, not just an
+exact mark/mask duplicate.
 The old SA remains intact and the operation is safe to retry after
 resolving the conflict.
 
-- 
2.53.0



