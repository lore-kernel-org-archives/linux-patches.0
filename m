Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B604929A1;
	Tue, 17 Feb 2026 20:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361653; cv=none; b=Vpm06MA1A33mAKkbcMu8Muuyym4ESc4cYez/I9m9SHykaKhYCIFnHc/fizW/Qei9ECJ4iEoWmywD+hgiz9dXJRHyynwNxRfHKrfO+wGu5GMSMI2/ko3ENoFTfK+lzCwAdkIpI9JgO8XhX2/ujq6FtsXGj4XTZJhin5tx5xERTwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361653; c=relaxed/simple;
	bh=87JhsQMAIOaYLbqsBu6vxwz0Jp011JJKWrlh7mo/q3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E434+vYsqMdicl0n0jiqX4onbB8F8hYDd6GGJiUbfF+9CsRNe0MF8mERINbgMqQpYTE3Wlb8C7S6n7gP+zudw1Quj5xSjEEAqyhEusY1E3v5cBb4+AuhtcHHEY8CMZmi4D8fFcmK7VFk4WHuhuh10ZPJ28WBBGp1155uTo0X7uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GblBJlTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GblBJlTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A5FC4CEF7;
	Tue, 17 Feb 2026 20:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361653;
	bh=87JhsQMAIOaYLbqsBu6vxwz0Jp011JJKWrlh7mo/q3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GblBJlTxY5oILUbNcLOur2RG5/fYg6knRqClwnAKjAixhuAEF4ndW8WRvveFQMrLO
	 mOhQOD+X21hgjc5d6rGxNmU6isxHqQZGDuqhpFgWWjC/SwPRGKsSTE3Uo7oVnTQ64L
	 E4AR3rheyfPxDpl+At67JE5CCPtnhxPy51IU3Ah8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 35/42] f2fs: fix to add gc count stat in f2fs_gc_range
Date: Tue, 17 Feb 2026 21:32:26 +0100
Message-ID: <20260217200007.343204159@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
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

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

commit 761dac9073cd67d4705a94cd1af674945a117f4c upstream.

It missed the stat count in f2fs_gc_range.

Cc: stable@kernel.org
Fixes: 9bf1dcbdfdc8 ("f2fs: fix to account gc stats correctly")
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -2072,6 +2072,7 @@ int f2fs_gc_range(struct f2fs_sb_info *s
 	if (unlikely(f2fs_cp_error(sbi)))
 		return -EIO;
 
+	stat_inc_gc_call_count(sbi, FOREGROUND);
 	for (segno = start_seg; segno <= end_seg; segno += SEGS_PER_SEC(sbi)) {
 		struct gc_inode_list gc_list = {
 			.ilist = LIST_HEAD_INIT(gc_list.ilist),


