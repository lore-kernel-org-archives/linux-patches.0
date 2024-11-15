Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8572A185B5B;
	Fri, 15 Nov 2024 06:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653127; cv=none; b=cbh36+G0LZzttEZxT2ddwAF3SLd3Q4o5xYZTT9uFwobofaSAwk8OplSxw6mcDVYkWSwccPT8iykK1gEjVpr28D58lsme/gsi7aGWgnajCBjiozen6lTGCJZcHMqUWnIkRu+5epQnz4W/xhPLOMj3F6BsNqHmoC2wcvkktrSK49E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653127; c=relaxed/simple;
	bh=O0ChvaqJZJf4ZlRLy0wVRqEyjz17kVAGRg/Wrbfqb84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riiz0ZnDrtvADimMCSYgVOxXMsoqBXaeFEzlK01iWZl/0ELsJR+VVWsMgRHDEqJ7nGGtmjMekMhBDu6KlLNSGhXZWsaFr46CVvlPp61QiLPgG7Vc7w9KOxweuVMxYYwfTmgrTPo4BMGa0IbPl3Sf2FO5j/Ns/wXUysxYFvVAtJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QmdPVlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QmdPVlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD04C4CECF;
	Fri, 15 Nov 2024 06:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653127;
	bh=O0ChvaqJZJf4ZlRLy0wVRqEyjz17kVAGRg/Wrbfqb84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1QmdPVlQ9QJqbNvi7doMzecZae8EGSg7PUuNb6NTLp9LtG873wDSH3TVUIP/PlE2i
	 0yUom2iq/BTxtV75GiHMOiXN/H6UzuRmM60NRnZ37/QX953gEFKRNj05DBglxwK2At
	 dsRK3iIijgfPAwDYpCT0sn9Fd3KkHX4XmjGWLXZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Wenhu <wenhu.wang@vivo.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Subject: [PATCH 5.4 62/66] mm: clarify a confusing comment for remap_pfn_range()
Date: Fri, 15 Nov 2024 07:38:11 +0100
Message-ID: <20241115063725.079065062@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WANG Wenhu <wenhu.wang@vivo.com>

commit 86a76331d94c4cfa72fe1831dbe4b492f66fdb81 upstream.

It really made me scratch my head.  Replace the comment with an accurate
and consistent description.

The parameter pfn actually refers to the page frame number which is
right-shifted by PAGE_SHIFT from the physical address.

Signed-off-by: WANG Wenhu <wenhu.wang@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20200310073955.43415-1-wenhu.wang@vivo.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1921,7 +1921,7 @@ static inline int remap_p4d_range(struct
  * remap_pfn_range - remap kernel memory to userspace
  * @vma: user vma to map to
  * @addr: target user address to start at
- * @pfn: physical address of kernel memory
+ * @pfn: page frame number of kernel physical memory address
  * @size: size of map area
  * @prot: page protection flags for this mapping
  *


