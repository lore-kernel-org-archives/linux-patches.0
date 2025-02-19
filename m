Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7881A314B;
	Wed, 19 Feb 2025 09:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957149; cv=none; b=EEv4feJ7leA9LD+o/rVM9QUJ8QOcRM+GvGBX4rbuHZj+zuuw69u5fVrO0SDeHaGDitXX0qi+8C+6cyDim9XeL79OOh5EDw+YnxjhjUFl6eC8gTMoKXHCc0HyBgbimkonmnvveUFagEVCi2tEysr+SaRx0XaIncayX21RqR4P1FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957149; c=relaxed/simple;
	bh=hUaSZ2UjFgCryo+iOwKW4vCytxnQ4rQ8nwhjPcw6dCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQCc8c8JI5jCyOCmEXxhgbKz9zOGdZI1BoBToE2LIFbVKY8ckzkwI2okmlwdZTZgQiB4djKmaKTxDry2vPO1FqFNsgthvKs2fD65Rk6kH+Vao9nSxOexF25VlzetWlKdQRmXaLO7Od9pcfejTutewC/n8nArhhmPoLT93wPZYn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLRmBze7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLRmBze7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0322AC4CED1;
	Wed, 19 Feb 2025 09:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957149;
	bh=hUaSZ2UjFgCryo+iOwKW4vCytxnQ4rQ8nwhjPcw6dCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLRmBze7rsSaxxV7r+SW9w7W8YcIjPL3HAPAVp4n55nOFxtnP84l33adeSrJv07bN
	 z/iZh4j/4rrsjIWGgbx6XA9f3TxVeumlcBghGnhVhRqgQKCb/7SoOgBc9qOAcp/vqR
	 oG+st7Hs9JuLC9ceGIuhFW6qBwvB790eUS7Yxaz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heming Zhao <heming.zhao@suse.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 426/578] ocfs2: fix incorrect CPU endianness conversion causing mount failure
Date: Wed, 19 Feb 2025 09:27:10 +0100
Message-ID: <20250219082709.772648783@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heming Zhao <heming.zhao@suse.com>

commit f921da2c34692dfec5f72b5ae347b1bea22bb369 upstream.

Commit 23aab037106d ("ocfs2: fix UBSAN warning in ocfs2_verify_volume()")
introduced a regression bug.  The blksz_bits value is already converted to
CPU endian in the previous code; therefore, the code shouldn't use
le32_to_cpu() anymore.

Link: https://lkml.kernel.org/r/20250121112204.12834-1-heming.zhao@suse.com
Fixes: 23aab037106d ("ocfs2: fix UBSAN warning in ocfs2_verify_volume()")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2342,7 +2342,7 @@ static int ocfs2_verify_volume(struct oc
 			mlog(ML_ERROR, "found superblock with incorrect block "
 			     "size bits: found %u, should be 9, 10, 11, or 12\n",
 			     blksz_bits);
-		} else if ((1 << le32_to_cpu(blksz_bits)) != blksz) {
+		} else if ((1 << blksz_bits) != blksz) {
 			mlog(ML_ERROR, "found superblock with incorrect block "
 			     "size: found %u, should be %u\n", 1 << blksz_bits, blksz);
 		} else if (le16_to_cpu(di->id2.i_super.s_major_rev_level) !=


