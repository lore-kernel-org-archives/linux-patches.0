Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CF247DFB9;
	Sat, 12 Sep 2026 13:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219194; cv=none; b=dr4JDLWsHwXLCyVO763uCGayhcrmBGbWUzkVCgZCknK2GYj+yGpNzM07fWYmUlE1bqP+ccoVY171qbQlewl6bcud0ULNHrP1edJ3UhY47rnUXFFzrtfMfV4uswzI0YGu8Ex2mUD9KprjryDXgKEIP+4t9MUPQ4jk3X5WIQnJDaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219194; c=relaxed/simple;
	bh=WkaUUo6tttp3S2N+SIO3L09Tf1RsIFOnArZmlMA5nfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsC73xUpJi0oXczy4lQegKLQACqnxUrTUXupVB9n4Jd4VRwcwAd4/HUoh9CnuPZ3myEEooKkNwzLoG7bjEMyepf8ikbLAEpajm7t6aSMGE48cUZZyjaFerENI3nvjlm2O5opykfhxr6DyTPM2VYVGi/tFHi04ROct1LV4qP9hJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7PhO0kL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7PhO0kL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466471F00893;
	Sat, 12 Sep 2026 13:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219192;
	bh=E90Pqk9rgKEbHMxJ0Mz/yE/LX/qP1X4KMvwx8+Bak/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7PhO0kLPzES6f5Ti6wJVNPsfu5qmH+GjsqB3Ap3/AVtxu7Nn/Cvm/RScCklZCu6s
	 YsXJvxw9MMjKZj0mskHz3DzkfMxxjzOQP0CcUH9JzNkEseKvZLb42bv3F5LtgBvNpK
	 IeWn72giOKrkZlqj++P5w7mHeHHZLwaug8SyMPZw=
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
Subject: [PATCH 6.12 1294/1376] maple_tree: fix argument name in header
Date: Sat, 12 Sep 2026 09:02:00 +0200
Message-ID: <20260912065636.376101814@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c2c11004085e5..ecbcc2b3e59a6 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -528,7 +528,7 @@ void mas_destroy(struct ma_state *mas);
 int mas_expected_entries(struct ma_state *mas, unsigned long nr_entries);
 
 void *mas_prev(struct ma_state *mas, unsigned long min);
-void *mas_prev_range(struct ma_state *mas, unsigned long max);
+void *mas_prev_range(struct ma_state *mas, unsigned long min);
 void *mas_next(struct ma_state *mas, unsigned long max);
 void *mas_next_range(struct ma_state *mas, unsigned long max);
 
-- 
2.53.0



