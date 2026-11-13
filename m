Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585555;
	b=boCyQEd/oa80xhTiarV2YorCxExtd2RnI/AzDcu4pXkq/8lTjqQ0CS/QAU0chzihm2as
	 elvbhmqfpM9tDTEwiw/awP4YSD4g3hABlUEZCI8TLkOr+e/52dS3ES1BRqwIYsaUMy+py
	 Txv0iiw5w/HCnuYi4wsKOjc3B2oIkdoPMzdDLxqKpZKPmFjnuEA61ijkw+9ihRVY8GM4x
	 qtYYRMy6QY7h1UuPjclexGW5OL9X1lhQSVdIZj/GHEHfIrg+6YS0P6dbzGPnCV9qnJ3uk
	 6QprKwumATE/YaCi9z0uYGeVARi+C05D/1u/8NjVBwVDT3DKZX2rCZJRKZlzQWMVoVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JQSgYDk72tpQVvIZF+vyzBnbaXdIw+VK4sUmdst2kn4=;
	b=plKOpjFCAEYtFs9glLD1QfBSg6Q3lEf+0PsaGRLEzUyfaqjpARXV3yCP/O27jS5eI14N
	 hLpFaheG0dHgyWNDPCa/0o82ev2YACxIUV5jZEXcDAsEjifCtzT/Vw804TPe5tZoDQ0Mw
	 dJofpSZe3iNJi4tpqDFkbmrrMcZnBi0DzlSvrcRBeo56qTzmCdLj+R/jokfQBcjO2Ol8U
	 HRTcNpRCAG8vDQuUKlaI82anBJKPajbCSQRnhvCEslxW24QneLIlHp3Yn1g0L0JtEPY7l
	 1M6F2jLxQeT2A0nH9yr9y6VhIjHNllfD8IO2oeJWUkJeGO7iXk1Klx2xxsHIC2HvhiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HWGXJBvC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B49860A2628;
	Fri, 13 Nov 2026 15:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HWGXJBvC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBEF1F000C4;
	Fri, 13 Nov 2026 15:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585555;
	bh=JQSgYDk72tpQVvIZF+vyzBnbaXdIw+VK4sUmdst2kn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HWGXJBvC9zuyQM/WyXHx3/Fl1s6D3htbqnrtudMz/A5QRwlCUOjcec/69GZqoGI5E
	 HUZOmNc6CCFd5jqolailIYrI9qYEYa7tyMp5CBL6QTnLf0fR3xsLN2rK9JwF/qB5hk
	 dvp7fbH4CqkKLFcTisJ2Kx/NP7ERinCXz5OPDhxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 141/507] mm/shmem: preserve allocation errors when swapping in large entries
Date: Fri, 13 Nov 2026 10:47:25 -0500
Message-ID: <20261113153759.225941178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit f4ce23b1feef16d435aa1188b6c2a637a5373ed5 ]

shmem_swapin_folio() adjusts swap to the requested slot within a large
swap entry before allocating a folio. If allocation or charging fails,
the error path compares this adjusted value with the original entry
still stored in the XArray in shmem_confirm_swap().

Unless the index is at the start of the entry, this turns -ENOMEM into
-EEXIST even though nothing changed.

The caller retries -EEXIST, so persistent allocation failures can leave
the task spinning instead of returning the error.

Restore swap to index_entry on allocation failure so the existing error
path checks the original entry. This preserves the allocation error if
the entry is unchanged and still retries if it changed concurrently.

Fixes: 91ab656ece13 ("mm/shmem, swap: tidy up swap entry splitting")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-12-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index fab3f1d24550a..2b2f347bb8a71 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2327,6 +2327,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			else
 				error = -ENOMEM;
 			folio = NULL;
+			/* Make sure to validate the original value. */
+			swap = index_entry;
 			goto failed;
 		}
 		if (fault_type) {
-- 
2.53.0



