Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A895825DD07;
	Tue, 11 Mar 2025 15:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705777; cv=none; b=CzYFElvtQXAWEgQxuju236evQVYHFreYWhh34Y1ebWN/Yzw8UKEWlTjiFrMFTpCem10EHAfNVBRnSBHoGQhWzkgfkau9h1rIjP00/g1qPdu1cnasCQGFf6IrUQG1nOJwfWIx/1FmfgSlL9LJTpScugxTGiHttCRAyQSRZXM72DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705777; c=relaxed/simple;
	bh=dpmaZf9m1LWvdG03Y5+uVHnKDe4Cmb+eWqKVSUhq3vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoK9+Vv6LErUkNb84Hj80gWfd5gosohuLWn1BNpUJFj5z0YPpjTUVNlEIgHmrP8UIfN/Zz3GMiZyHBzvPGn6mmUglRXmSh9iq24tiTV+qee91SyvoQNn3ptYZ7QRB8xiPNJNZUuAA6IvPlasrXx3xjQCYfVdu7g2R18yZ7q0E60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nh4Svi6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nh4Svi6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6C6C4CEE9;
	Tue, 11 Mar 2025 15:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705777;
	bh=dpmaZf9m1LWvdG03Y5+uVHnKDe4Cmb+eWqKVSUhq3vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nh4Svi6UW21olDYXEUrE/BcJsruQL6BoUqNLVCN9KNOrF56xlR9B6/yiRKg4qLWm+
	 Wbn2kog3bHM/kohYG/SlzjFuykvcIOmc+EQphqP6M3LUpHn/mDNjFGQ5EGTAmgZFdh
	 FiU6Kpp9x6IHGLw338xAt6aw83Z4iq11IVCrkSQ8=
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
Subject: [PATCH 5.4 152/328] ocfs2: fix incorrect CPU endianness conversion causing mount failure
Date: Tue, 11 Mar 2025 15:58:42 +0100
Message-ID: <20250311145720.948794565@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2350,7 +2350,7 @@ static int ocfs2_verify_volume(struct oc
 			mlog(ML_ERROR, "found superblock with incorrect block "
 			     "size bits: found %u, should be 9, 10, 11, or 12\n",
 			     blksz_bits);
-		} else if ((1 << le32_to_cpu(blksz_bits)) != blksz) {
+		} else if ((1 << blksz_bits) != blksz) {
 			mlog(ML_ERROR, "found superblock with incorrect block "
 			     "size: found %u, should be %u\n", 1 << blksz_bits, blksz);
 		} else if (le16_to_cpu(di->id2.i_super.s_major_rev_level) !=


