Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031803;
	b=cZuLgE05JGA/VWsiDQnSwsDKN9xNbAlGiHdgauNv82qdBmx3hE1l/rcU8YuKgzEeDvHj
	 QWggMZK83zFFUDlOsy2n23LCRHYFKDM4E+MxlioFrvxnO2DXHGxGJo3KdilGRCubRDqfI
	 i19FRcFCM+x81XIfODWY80cvJ79nFQeSMFVrp6cm3iX7plDiU9EPqsa3hbAjHY5RdA8Rs
	 NbnGQ8l1SkY+CzTIdF7vaU4rctWoqOMpxxtmOQ/1f1COqtjH8Ce5jmXJ8ggDBx351ehW8
	 6aM1RtGs3/A5eSdl1K3tJ8SER6odHz0cxSyv5b4uoxiEeu9DFSS5KCwwhp6G8H0SzBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=14c95qI9B4/NP5Q1f9i2tw/RbRPWcliZSYk8KpXCSNw=;
	b=Olg454F8c5yhpKSiEnmFr942X27HWSYDXB+2Jme905W6xKUBGa/PPHuqS0EnFAW3giSW
	 zLz37uckH+2/u4ab/juc1Z4yNQyof6VUXprTQ19Zd8kqeSeufuuHBm7XKIkSRUCXrQamg
	 8LRXMa2PE9Hyf74wgZpFzhAP4XPauCjt/UMlX1Mf0B7CQ0qCs2hkMkuwnBjqZtV1if+ip
	 nxBQ1UJtb9F+dt940cDJEiEUsepZo09ufIFBOYQE9K9gVBHQgBZNDVVAN/+hVbr2gMc9x
	 teorjCfWWc0X8eBYKObMRgHwXVh9+OzccnktJmtTdEWY4jA/Hjj5Jsl3DcgtwKnR+iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dsrimrgp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67890606A31C;
	Wed, 18 Nov 2026 19:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dsrimrgp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6C61F000C4;
	Wed, 18 Nov 2026 19:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031803;
	bh=14c95qI9B4/NP5Q1f9i2tw/RbRPWcliZSYk8KpXCSNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsrimrgpnoePeHnWDqdBl4ymdwF7chl6RP0lmFlS+IY+8h20/2EDH7XPuXlMa59Vl
	 LwmmTBXLDSm5JCI0ncld1DAwOrqNmuDIeV+dztS7o54p0kk2L+DaVZFcq7Gu3Knlt3
	 NJFpKWW5YUolKrOMhsIjTXun76hkquJD0ObsZdU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Hao Li <hao.li@linux.dev>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1185/1756] mm/slab: Mark the kmem_buckets_create() context as a Context: section
Date: Wed, 18 Nov 2026 15:55:12 +0100
Message-ID: <20261118150057.077738765@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 655668f0caf32a42fef10aaf31137e52f46a0260 ]

kmem_buckets_create() had the same sentence about calling context as
kmem_cache_create(), but lacked the "Context:" prefix, so kernel-doc
rendered in the body instead of as a "context" section.

Give it the missing prefix. Additionally fix the "a interrupt" typo
__kmem_cache_create_args() had.

Fixes: b32801d1255be ("mm/slab: Introduce kmem_buckets_create() and family")
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Hao Li <hao.li@linux.dev>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Kees Cook <kees@kernel.org>
Link: https://patch.msgid.link/20261014052344.384723-1-kees@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slab_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 88f1c07fa13ff..12d0f5a2b9ff2 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -302,7 +302,7 @@ __kmem_cache_alias(const char *name, unsigned int size, slab_flags_t flags,
  * &SLAB_TYPESAFE_BY_RCU - Slab page (not individual objects) freeing delayed
  * by a grace period - see the full description before using.
  *
- * Context: Cannot be called within a interrupt, but can be interrupted.
+ * Context: Cannot be called within an interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure.
  */
@@ -406,7 +406,7 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  *		to/from userspace.
  * @ctor: A constructor for the objects, run when new allocations are made.
  *
- * Cannot be called within an interrupt, but can be interrupted.
+ * Context: Cannot be called within an interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure. When
  * CONFIG_SLAB_BUCKETS is not enabled, ZERO_SIZE_PTR is returned, and
-- 
2.53.0



