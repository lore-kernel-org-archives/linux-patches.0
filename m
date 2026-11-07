Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064665;
	b=Krwqt3E4t5C/Nl5STFIlomiRm6y0knGZCpaqCiXtVVxrHC5n2KrUa+dYdSNvnFZ3/M+4
	 RkqOp2RYVeSKUVkL0W6LEshsqYKemrVVjLRlUAz5sULpynWzsgtOJDu70nLfX4s5WBEC3
	 xksOiVPXcAziWw1hJs6uWjExBnxoGI7K4kxfvznKGa52dkKxkBHwZNuFv3YpEDhVXdhEf
	 PNJtyfxGlsgcA+bCXjJHSuzN8f/0KY47nCjuWAUTDIe4OI9tDXRK1dhDpGHYkk4CRu1eL
	 sSLT0HU/G8p3xI2SbtTKTeUjKF8Oi+RfsVE5rgvyuZCS4mMeh5zC1LDSmqlhprvmv0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iUxHZEZh3Oh/qeRK4Yo1etzpPlN+xNurDBEEPnjQJZs=;
	b=g3S/vy/w+BkI6Q0xqS9M+zEU+2GK921N9uDO2084EjGhnIE0LjH+cGZ6LfqID7LjcRwo
	 ea7BHId8RHDkBJ0fAYtTSejp0ZnSEy0XP/gPUITndr+T7TgSoWj1DJZAv9B8tx5la11cL
	 IdYI2bH6qLBxJWCj50cPBUs0SHF1rNC6ISbkvu1/zoA30Xk9d3ZWjn9R4lIEWfmla4Ua4
	 e2Cy4SfCpKkIph9+2kDgm5CoNiks2H2Dwl1EuGUXF/fTgS7pKKmwJXz59KZqZi8+dBoIv
	 FZIWqkhFOzTAKo85IE142KaRBYYxSwrTjryoJ+0LYOSkiikc1PIMpa+9Wg/CQqDv2sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M0i4P0W9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220CE606CE58;
	Sat,  7 Nov 2026 15:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M0i4P0W9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818C61F008A1;
	Sat,  7 Nov 2026 15:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064664;
	bh=iUxHZEZh3Oh/qeRK4Yo1etzpPlN+xNurDBEEPnjQJZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M0i4P0W9z32Jd6M6Dl4Y+O4xRMQTufEdQWlv2E6O+fs+ctHZvo+CkDsVKJNxXEmFo
	 yHH3Au/rCBY5afHivVDs32vLq1b51CzMmFh8nOnq3DfGnUa9YPbjXwEu4oafayH0fB
	 KqwhBEkT8UEOJze7Rv/Xah04SZBa/riRIctnbFEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Ge <hao.ge@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0663/1257] mm/alloc_tag: account for reserved tag ids in the kernel tag check
Date: Sat,  7 Nov 2026 08:49:19 -0500
Message-ID: <20261107134957.568047152@linuxfoundation.org>
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

From: Hao Ge <hao.ge@linux.dev>

[ Upstream commit c6e5c0b9a493891634d0a413c3485930a28a8903 ]

The tag ids stored in the page flags include two reserved markers.
Id 0 means the page has no tag and id 1 means the tag was cleared,
so real tags start at CODETAG_ID_FIRST. The kernel-side check in
alloc_tag_sec_init() compared kernel_tags.count alone against the
addressable limit, so with the count at or just under the limit
the last tag ids wrapped into those markers. Pages allocated
through them then look the same as untagged pages on free, nothing
is ever subtracted from the real tag and /proc/allocinfo shows
that memory as still allocated.

Add the missing CODETAG_ID_FIRST, same as tags_addressable().

Link: https://lore.kernel.org/20260916075557.121316-1-hao.ge@linux.dev
Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/alloc_tag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index b334103104779..82e2c3448dcf2 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -621,7 +621,7 @@ void __init alloc_tag_sec_init(void)
 	kernel_tags.count = last_codetag - kernel_tags.first_tag;
 
 	/* Check if kernel tags fit into page flags */
-	if (kernel_tags.count > (1UL << NR_UNUSED_PAGEFLAG_BITS)) {
+	if (CODETAG_ID_FIRST + kernel_tags.count > (1UL << NR_UNUSED_PAGEFLAG_BITS)) {
 		shutdown_mem_profiling(false); /* allocinfo file does not exist yet */
 		pr_err("%lu allocation tags cannot be references using %d available page flag bits. Memory allocation profiling is disabled!\n",
 			kernel_tags.count, NR_UNUSED_PAGEFLAG_BITS);
-- 
2.53.0



