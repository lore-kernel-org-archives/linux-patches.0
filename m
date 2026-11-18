Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028660;
	b=oRDM+eyJ+RkRQobZLfl/WDsQ3I3yd9+wbv2J0XocWMkmvE5l0aJOu1EtOmyyzPEl/Fg0
	 H1/lv7AiQtUcsTHSZu7P+mL7XcRESPjlR5G2snayZyfH67Sv2TLRUmCgsjVIDooKj9bEG
	 qxN7cg2YN2FSovbRX5NFnVviQSPeXkJCBqr7gVjVcCW2ZvJvzK1sJW1wKzEh6ddwB55ts
	 Rc70APVQS+PPhvdq9BLOHcp4Z2fDGc4q3Lv+Ccxep+NH1Ft3aEz/MqW7SLLkpiyr3CBZz
	 rFKPX0QgkuqfilyeSofiumGrVgQS/gKAGyCLKFiltuN0qF6lZp4KhyF2kswFpyLEvDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tUDs9VWbZ2AmvpbDGPkiNZhFZ9J+5N1sodNyfWtIlo4=;
	b=k9CkQyVK2m49932pyuFfcBvgMN3nGQeuJEaytwVyrHvBGKYPyeimoH8c0cAfw1mIEM4z
	 o3IqW6J9xUd5K8l44GJTl/RrvUDb082imIrhjKc7+jcP4wOphhaL9aDUJ03dYL9oKNnfS
	 d2l4G4cEUiTvFOGpV0eoqwTNqRKMNd4Yk8ezn7PeMNhzfaxTj4ew+df8zUMGbj9HKVSVq
	 fMKEUohcHzODBDS5tXH/0bhqmsJUh1wi47eF1bxc21udguFQMkRMD3T9FxGDXc5zRs518
	 2x+N8O6K5n+MJ143PZNpP94t2C0Ta8JWGUDFBCUVgUPJ54FZpHUbKQrJXpwbKPwfVNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6DIM7lh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12135606A320;
	Wed, 18 Nov 2026 19:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j6DIM7lh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1DC1F000C4;
	Wed, 18 Nov 2026 19:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028659;
	bh=tUDs9VWbZ2AmvpbDGPkiNZhFZ9J+5N1sodNyfWtIlo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6DIM7lhJoIsTtLHKou5H9mzNBsrY/vKeUtTkC0w+fBKarSSFInrS18zRmPlsGYX6
	 51C9qN8KWzK6YT1JIUShFJpoVEYXAE7mM82dI5CS3GYlOKT5PsE6rZokhfzE+qH6eI
	 0fmxZQLjI3UdVrz22ES8jwQeHVdS/VrAPiA+v9zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0075/1756] mm: fix outdated incorrect code comments for handle_mm_fault()
Date: Wed, 18 Nov 2026 15:36:42 +0100
Message-ID: <20261118150011.290921424@linuxfoundation.org>
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

From: Jinliang Zheng <alexjlzheng@gmail.com>

[ Upstream commit 8e6173ccf7b87c1f855e1ad3d94fd50c51d1f46b ]

[akpm@linux-foundation.org: s/mmap_Lock/mmap_lock/, per Liam]
Link: https://lkml.kernel.org/r/20241213031820.778342-1-alexjlzheng@tencent.com
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: f681d4580d5c ("mm: fix address wraparound when scanning large folio PTEs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 38019497d8d4f..4e6c893b18b38 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6071,7 +6071,8 @@ static vm_fault_t sanitize_fault_flags(struct vm_area_struct *vma,
 }
 
 /*
- * By the time we get here, we already hold the mm semaphore
+ * By the time we get here, we already hold either the VMA lock or the
+ * mmap_lock (FAULT_FLAG_VMA_LOCK tells you which).
  *
  * The mmap_lock may have been released depending on flags and our
  * return value.  See filemap_fault() and __folio_lock_or_retry().
-- 
2.53.0



