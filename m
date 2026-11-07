Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063503;
	b=D1gfoDoPs9AE8s0u5d6eSJys7mjmo03HhDBgXnb+wXtTyqc+yG5IMJCQeAzUYXHbfiyM
	 FB6IcCKS4bBvVR0w/q373dhVV5YpsKCOes5rzKpAKv5DftERJ1BQ6tmH6Pzn3+c/Y+tvN
	 o3Vat65+cJPp/Ue8JxLNQ+GhvcQs9XwiaTIBE8uMZUd2U2Yu1IJ6FadtBZskE4PVZkZ5B
	 ZbTVqtrTy7SlO42y6Dd14QGxE1ozhpw7exMcKN8UmwF3pyVh+UafSfZ8vGka384xdXerf
	 Byt9Xw850XL9Mk4Lbe2ukHGUgbr5di3mL2gRvV0fHpMx2hm7K9B3NKzmdi+kKJWUK+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GFKWwiSZHP72k86nakMT6XfsSi5OJO2+/KxDn72LBEg=;
	b=hPZXTJU7yLr9ld0odclcP6ptgpDml5f2rAHUZPFgDVho8VdO2DQUnwNwxzLWXYnvVrwu
	 of+XbvixW1itigKMkLM8QP2lyJEzGJJFRmm/OVctzs5IW9KGZttdNgn37BVRn7SAmxX6d
	 nbIVuGYPurzNM1wlngcJvJh1KbCCmxz6FxOu+cxOX5vQmbYiLIP8ocAuuuYVWuhSzRe0o
	 mzX7r5MDu4nTJUDWITFBw6VfnbcuY5qSw8JwyzddnsmfI6Z6/Wa2AFFXq4Vm3yU+zJjYy
	 1cN2nE4BsRgBgv799P32t+kge0Q+HNtfBHWFmZzbdPf+POWo6coM0CmfUfmsEAgqvgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f4GBx9gK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20528606A338;
	Sat,  7 Nov 2026 14:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f4GBx9gK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF56B1F008A2;
	Sat,  7 Nov 2026 14:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063503;
	bh=GFKWwiSZHP72k86nakMT6XfsSi5OJO2+/KxDn72LBEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4GBx9gKo71VonT8HzRRnKMk4ot81z1yojZw2XfKTDhVVNkH+hgctJbyA6zJ3BTwv
	 Akoe1p8JWRIN+Vs2ITL2qqda3MeoMA2PNXMfa8xLZTxWxliwwQfRPV0X9e5fVwhE07
	 CoYWtNwkAWgjMOtxk0kdo4Cjqc+j80bQ61/GiAD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 640/869] lib/buildid: reject file offsets that do not fit in pgoff_t
Date: Sat,  7 Nov 2026 08:55:22 -0500
Message-ID: <20261107134914.618286150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit 0007654a7bf13ef2a19afd398bbc6507087f19fd ]

On a 32-bit kernel, parsing the build ID of a crafted ELF file can copy
far more than the intended bytes into a 64-byte on-stack buffer in
__build_id_parse(), corrupting the stack of whatever context fetches the
build ID.  This might be reachable without privilege: perf records a build ID
for PERF_RECORD_MMAP2 on the no-fault path when a process mmaps its own file
(build_id_parse_nofault() from perf_event_mmap()), and BPF build-id stack
maps do the same.

freader_get_folio() turns a 64-bit file offset into a page cache index
with file_off >> PAGE_SHIFT and passes it to filemap_get_folio().
pgoff_t is unsigned long, 32-bit on a 32-bit kernel, so an ELF64 e_phoff
of 2^44 + k * PAGE_SIZE truncates to index k.  filemap_get_folio()
returns the cached folio at index k, whose folio_pos() is far below the
requested file_off.  In freader_fetch() the folio does not contain
file_off, so the "crossing folio boundaries" path computes
part_sz = folio_off + folio_sz - file_off as a large u64 (file_off is
much larger), and the following memcpy() truncates it to size_t and
copies a page into the 64-byte buffer.  On a 64-bit kernel the index is
not truncated, the folio is not cached and the fetch returns -EFAULT, so
only 32-bit kernels are affected.

Reject a file offset that cannot be represented as a page cache index
before the lookup, so such a file fails the build ID parse cleanly as it
already does on 64-bit.

Reproduced on i386 under QEMU with CONFIG_STACKPROTECTOR_STRONG: mmapping
a crafted ELF (ELFCLASS64, e_phoff = 2^44) while a perf event with
attr.build_id is open panics with "stack-protector: Kernel stack is
corrupted in: __build_id_parse"; with this patch the parse returns
-EFAULT and the mmap completes cleanly.  Built for i386 with W=1, no new
warnings.

Fixes: de3ec364c3c3 ("lib/buildid: add single folio-based file reader abstraction")
Assisted-by: LLM
Cc: stable@vger.kernel.org
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/buildid.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/buildid.c b/lib/buildid.c
index ef112a7084ef1..015a1f9d2b48b 100644
--- a/lib/buildid.c
+++ b/lib/buildid.c
@@ -66,6 +66,10 @@ static int freader_get_folio(struct freader *r, loff_t file_off)
 
 	freader_put_folio(r);
 
+	/* the page index must fit in pgoff_t */
+	if (file_off < 0 || file_off > MAX_LFS_FILESIZE)
+		return -EFAULT;
+
 	/* only use page cache lookup - fail if not already cached */
 	r->folio = filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT);
 
-- 
2.53.0



