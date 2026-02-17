Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A019E29A1;
	Tue, 17 Feb 2026 20:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361396; cv=none; b=lmv6k4k+gu8FqkAwBQUO9SPmRu+/S+LotQ0KCpERG53ppHyqIu0vqSj0Iki2NLAebCe6sh31NLWkGOInafieig/38WjUuizxEQwonC/Ur3o6Wb17QItdLOt3xr//+3IrUO201LpPldJ2Dmvpcq7iBdfUmgHPWrNhMayYE4Qmdnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361396; c=relaxed/simple;
	bh=QXWkYTUT0jfuX6dFXZzPedvWeALMI7vFwXa3Cg0KVe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAInoFBsqa1bcm3z+y0tsAOlsBkvtl1kjjNHgjpw8FfCH/BlDGSNorxA31+xt72M/1FjlA1ElM2dNFhQ6QLH4L/Or15eI/bxXDuBikBMvAgaTzKB6mdoDRdtanGryRqBx3OZpU2nl61dyZ+iAI/lKTrnQVYMVX78Cwl8w7ulIik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOizBOOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOizBOOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99A4C4CEF7;
	Tue, 17 Feb 2026 20:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361396;
	bh=QXWkYTUT0jfuX6dFXZzPedvWeALMI7vFwXa3Cg0KVe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOizBOOGEtuknJcKr2+0CbaDG+51plaTBwkHCjlROwk+mgWmiROQ35ZZnwuvEZmzP
	 gri7Kca5wi1G1h/okfHuXrlL2BIy9yWJfj7FkJ5uFOBhre4qRvJO/admDSnp7IpSO4
	 tMcnTkQAqUSewl4Yg1XXWi0ITdEFqsFp1vDOdGF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.19 06/18] f2fs: fix to add gc count stat in f2fs_gc_range
Date: Tue, 17 Feb 2026 21:32:02 +0100
Message-ID: <20260217200002.936285214@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
References: <20260217200002.683975158@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2096,6 +2096,7 @@ int f2fs_gc_range(struct f2fs_sb_info *s
 	if (unlikely(f2fs_cp_error(sbi)))
 		return -EIO;
 
+	stat_inc_gc_call_count(sbi, FOREGROUND);
 	for (segno = start_seg; segno <= end_seg; segno += SEGS_PER_SEC(sbi)) {
 		struct gc_inode_list gc_list = {
 			.ilist = LIST_HEAD_INIT(gc_list.ilist),


