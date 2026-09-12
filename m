Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F3B47124F;
	Sat, 12 Sep 2026 11:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212328; cv=none; b=eRamyN9NL+DopjNyQDPEEt2zprl/Ua7ycIsJYFPze+5pqaRouSqU7maaO4kJSpHXETfKspvTsdsL1GnagxEJpajTqC97MymcVIZoDiLb5nS/zGAZNdij5jo4oNNJGlgJKM53zPeKSRbSg2Z8xD8M5+39msvxZ3FQiHhQh4gSauE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212328; c=relaxed/simple;
	bh=2CLX9mmJODIAzj2LxmSf3rpNx6sqRajYtFkL6D0moCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7jGyeQyw1LJVmpi8fSv9OyYK6ZbLFWtCVTeGPja6GhzSKg/MtTmfTykymOJm7CADGJWoJMzYwe3TlV+DhFyCNx8i1QMbkYIH+bzT1DPyq0GjLq9awazTzJDbW3o2r0wonrBAtJSEVWT0Qdv/aBZ7XnNF6svskc++DgggyVjVaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OzrYcQJT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OzrYcQJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9641F00893;
	Sat, 12 Sep 2026 11:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212327;
	bh=56JHKElrERS3z1FqhjmZa6PcYBFE3pAs2s9748QGhvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OzrYcQJTaK983zUQUJlCPpc6d/f2cCUPCGXqMB/+HottJwD7ntM7U3kmfpWbIAfyh
	 7kUN5HjvCfA49KHhj1hXTKCZZJNieP/LKy9eqFOxhOs0GEE+EesqhWiJKoW0CRZn4o
	 G6lLFyR66ZScEoIMJvLUilbjPzUTF0yDsG+el50A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Chris Mason <clm@meta.com>,
	Chuck Lever <cel@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joe Perches <joe@perches.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1413/1518] maple_tree: fix argument name in header
Date: Sat, 12 Sep 2026 08:59:42 +0200
Message-ID: <20260912065655.514692991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam R. Howlett (Oracle) <liam@infradead.org>

[ Upstream commit 00f67814a14e614b749ebe54076ef1e3e6454f2b ]

The mas_prev_range() function takes a min and not a max.

Link: https://lore.kernel.org/20260821192627.4085470-18-liam@infradead.org
Fixes: 6b9e93e01020 ("maple_tree: add mas_prev_range() and mas_find_range_rev interface")
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/maple_tree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 66f98a3da8d8b..2ba53c0654678 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -539,7 +539,7 @@ void mas_destroy(struct ma_state *mas);
 int mas_expected_entries(struct ma_state *mas, unsigned long nr_entries);
 
 void *mas_prev(struct ma_state *mas, unsigned long min);
-void *mas_prev_range(struct ma_state *mas, unsigned long max);
+void *mas_prev_range(struct ma_state *mas, unsigned long min);
 void *mas_next(struct ma_state *mas, unsigned long max);
 void *mas_next_range(struct ma_state *mas, unsigned long max);
 
-- 
2.53.0



