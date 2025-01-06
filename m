Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643551547D8;
	Mon,  6 Jan 2025 15:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178220; cv=none; b=Mjr9JP8yRdsLs2Uxy8NML4cmAS0Pco+CdfoKnHF+K2bZKDSznr1lNK1DEQGzMECalAzYpks3+jTdn11zcHp2gpl40wVzPKnjWlpqU2dcQjLATczYnngeUfU8Jue2lb9Nmv8qvt1KBFFNp5tnupXhpdmZqvWLOdxKlhr+Gbweb8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178220; c=relaxed/simple;
	bh=g0MVkStH1uv2UsBvc2NrgX0S+Al5Dtim0r4PJS+2u8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIXDHYBP2MTvjvyxhd6aI2WYghVaeWPXw7xHr9U+/orDB3wSZIspWJ+t742agxB/f2QvTesYNzYDK+ewlrK7tvuFgkdgiZczEUqM8QB9W4jt2sxENGv2QmPsu9eTbQrCRvHdBgHqYvmKsxYnYbjnd3Dxq/VvmhJv7tyLYwDZW8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LI/Syy5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LI/Syy5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FA7C4CED2;
	Mon,  6 Jan 2025 15:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178220;
	bh=g0MVkStH1uv2UsBvc2NrgX0S+Al5Dtim0r4PJS+2u8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LI/Syy5TgpP9r6Idx+TGQhS6hFwCDrq5VV27E2cw6fk/51bqiU6al7UMFeEJTa3kj
	 IUCoLjT8mZxseUN78tRj/CrF0kyy2ujR6X6j3BVFSKrlykWCO+n6SnpLJYoMYsJUvp
	 aOEVycj0hTa+LlgfOt23q1q4sjLLS0SWEnCoixNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/138] mm/vmstat: fix a W=1 clang compiler warning
Date: Mon,  6 Jan 2025 16:16:09 +0100
Message-ID: <20250106151134.943999768@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 30c2de0a267c04046d89e678cc0067a9cfb455df ]

Fix the following clang compiler warning that is reported if the kernel is
built with W=1:

./include/linux/vmstat.h:518:36: error: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Werror,-Wenum-enum-conversion]
  518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
      |                               ~~~~~~~~~~~ ^ ~~~

Link: https://lkml.kernel.org/r/20241212213126.1269116-1-bvanassche@acm.org
Fixes: 9d7ea9a297e6 ("mm/vmstat: add helpers to get vmstat item names for each enum type")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/vmstat.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 322dcbfcc933..1ca120344b00 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -428,7 +428,7 @@ static inline const char *node_stat_name(enum node_stat_item item)
 
 static inline const char *lru_list_name(enum lru_list lru)
 {
-	return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
+	return node_stat_name(NR_LRU_BASE + (enum node_stat_item)lru) + 3; // skip "nr_"
 }
 
 static inline const char *writeback_stat_name(enum writeback_stat_item item)
-- 
2.39.5



