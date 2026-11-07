Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065091;
	b=YQ2muopnk7uahOGFySKswtQXsSGI4pq/0ALRmHoULPhH+kGCArUprsZjf9RC8RYq5m62
	 mdbSyN15kBe5NTgpUhSrA8MFx4CBR4Ls9gFBPCb6p6uOR0klDr/Mx/IVHo/mboqqPnD//
	 SVCtB6DSMoioMwkBafXQmqxNxWtT86mbHZz51BH8dpXEtJCTKIi0tP/4aHkf9Qch7skj4
	 5ti2UG7rtUY5THBLvJd4z6DOFC0pOSEgButZXYYQuA96S/1vrUMPKxN77UXzNsbGiaBxh
	 HB7PPGTzaSg+c/v8Fbb8zbmPJ3gcpZwcQRI0llaqGhm5VpcSE+g1HtVN1udDxqtqLaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XHSm+iw85o4u0GAHPcO4LV7ACqeav2gZKK5vtUPcdTE=;
	b=b8Hz5sTdmLMXUxghGDN00SFnKEWVINDfpL/m1S96KYs0BCI+CnQk8fIdydMSVeebruWF
	 8ZFtC3b/q9OtV00+ETrCHQtNeDNkKIZKN8BEjJRSpwHsTl6xxoOcLhbfRTgLtQZZiBlnv
	 sJMHPKc8q3UJoe1KBc7d6f5zCtTbQxZBjw5zQcY8oMs43dtY8ObaBkFx/JRTJc3QeGMDn
	 iCbBe7ONfQPYuDmhyOx2zaRgy8ifCXGQgOJD4bHkEDe9I7FfIe7jD8GMtjDOjWT+LmvjF
	 kv8UbG3uzDAcEBp8RJhjTclKFUjtqwivUdEIwRfoQXuq6MyAx/ZN4EPdk10DpHohDYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmhV86WG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED40606A326;
	Sat,  7 Nov 2026 15:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmhV86WG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEE01F008A1;
	Sat,  7 Nov 2026 15:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065090;
	bh=XHSm+iw85o4u0GAHPcO4LV7ACqeav2gZKK5vtUPcdTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qmhV86WGAhXX8MtX1eNGfbB2YqGZn3ezV1O7ZKXVKVtaS3tVHVvUMxXqhZbhrLqO9
	 kwrVDG/bWdUa8cmKsZJKUgDkZUxMBFSwAqnthx0IzNacgld+kw0Wq6Jptt9Mlpp0LY
	 F+ydNPeUoOL1YgItOY2OyuoEv4FJkSZ3a7zZYNmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0875/1257] lib/buildid: reject file offsets that do not fit in pgoff_t
Date: Sat,  7 Nov 2026 08:52:51 -0500
Message-ID: <20261107135003.493812566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index c4b7376406215..995a327f46ae7 100644
--- a/lib/buildid.c
+++ b/lib/buildid.c
@@ -47,6 +47,10 @@ static int freader_get_folio(struct freader *r, loff_t file_off)
 
 	freader_put_folio(r);
 
+	/* the page index must fit in pgoff_t */
+	if (file_off < 0 || file_off > MAX_LFS_FILESIZE)
+		return -EFAULT;
+
 	/* only use page cache lookup - fail if not already cached */
 	r->folio = filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT);
 
-- 
2.53.0



