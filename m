Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1AA230BDB;
	Sat, 12 Sep 2026 15:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226236; cv=none; b=pvPwLcV9hc6isglm+wzvBDzF9Agm03WfUkJ2xZddZyTXG/ZS2z9Cm1tYsnnx0wRQqymcfho0fMAYaOThSfCkeiQKfunko/ZB6xLUW2R3u94LRiyoIIj9HljlTZlq+/E0IFuq4M1sePBFKOsb+AYvVAVecwUPrVsE135dJt0jTBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226236; c=relaxed/simple;
	bh=H9yhTxPOdW/Yr+Hcp9tFdPZcDY8kKVuTpdf3Vx1+WF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7l+uDBvoxzZE6oPzQNOVlrJvIL0v7CVRcSk39T2g3o5phbE40XtafV20nSth4y+yT8Ls+tPeHLCIxrRbcv1+jmaecI4Cikp9WMghzNFSd/N0eR6KH1foJQFGWKMtHBvw+e2yLf2bJKe//tE29spWXctPIxjfb0nMiwQeb3JtYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQkb07Ww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQkb07Ww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7099F1F000FF;
	Sat, 12 Sep 2026 15:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226233;
	bh=vqn9A1dWqOHACJ2HiDazcu21uZYOfeRCrxUyVL+esTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQkb07WwyNQBm8mQ7wKe9kbV2+sCYcie8aDO6i7utxmaUXF4mwygfUu6mOR2qJyo2
	 PkVgmCKeTXluUL+thIn3h0dSc4c8ySXq2cgVTLyL2SXaYW6X/MOjSBzMWyHEUn3YCX
	 hgfgvSTKEN0ncuee9IQnIWbf+XN4c4DeHzi4pIuw=
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
Subject: [PATCH 6.6 1359/1424] maple_tree: fix argument name in header
Date: Sat, 12 Sep 2026 09:03:11 +0200
Message-ID: <20260912065637.698028344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d01e850b570fd..1ca191a7e53ca 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -478,7 +478,7 @@ void mas_destroy(struct ma_state *mas);
 int mas_expected_entries(struct ma_state *mas, unsigned long nr_entries);
 
 void *mas_prev(struct ma_state *mas, unsigned long min);
-void *mas_prev_range(struct ma_state *mas, unsigned long max);
+void *mas_prev_range(struct ma_state *mas, unsigned long min);
 void *mas_next(struct ma_state *mas, unsigned long max);
 void *mas_next_range(struct ma_state *mas, unsigned long max);
 
-- 
2.53.0



