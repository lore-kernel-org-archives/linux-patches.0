Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617827;
	b=Cg8Ja+7KB6/iGxxt57MMNsn9k6nNd57+fWA3ys1SnhVyOStFOX7ETPNG2me546oeKVr1
	 RkHjV7IAC3df8z8+9s3cPb+ft2WCOUTXYJZRGY0luAA/gOyMzcwGZ/5heUtdpJcbKTks6
	 O3YMv7bb/37dkdVjsGiWnHvcqZeg+ABtAlq0HIqPMPwkF6uORv6rYdHJfdTqCFublI1Wb
	 tDSLljeryvE+c3CjpfBsjh5yKxp0dqDpxR98x7sFWOpuoBw3ARvz9KUeekTgB8T2hIJb2
	 ZQTrgAuhKiemhzYsQtfWqJPkcUz5Wk/k6fwGhw/UmHYNuR9EVtD9MJ2HzezAIIR2hJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SJWiyNp0b1TC6hQE4lEKxRs8qB1ggt+Qo6py6ifJBNE=;
	b=CbRK8CKCEgpIXf96j0Ik06Qn8mwvm9Q/4s+0RkrbgbBnyvrf1vTp7ASCAoMOt2tEE5l8
	 XGB4xCxzutIY/FuxONfHdBOtIol5LuvNb6JLN8g1Sok6B76PJOmH1qPyC7ZpxPgvZryCf
	 VLhb1mJ52Er5cg6B10a4eyiABNGrTDkNwJTIzMy0zs0KbAQw1l38e4kMWNcwiM+a6zSbu
	 xJFhvGGwvRmCQZR/ESDYme8UiUIgSZcNsiSdDx1A+1/vmW/PiCtCPpriS0U/RfGax6Fic
	 J2+odcItWCxMkyo7VfUvklLbjpyU65WzgPG7OnqLSRJ9lgyheoO7zZyw3VBNgzAevfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A+tHjaxg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF201606A31E;
	Wed, 25 Nov 2026 14:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A+tHjaxg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E240A1F000C4;
	Wed, 25 Nov 2026 14:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617827;
	bh=SJWiyNp0b1TC6hQE4lEKxRs8qB1ggt+Qo6py6ifJBNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+tHjaxgPJzRp05uJqxOU5hGM/GYGeTRjRaWeI+ls0qglJdkDGsAKgaja654chzzj
	 +b2o6DBh62EJkM6827o2U3rJopjpRt78ZbM0rZd+AjbxKn7b+AW7iQ1A5+nz+sLPq9
	 gsWXYDMTYsAjg33igugj6Wx/U3HqLkSliACyY09s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guolingxing <guolingxing@tju.edu.cn>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0070/1005] btrfs: verity: propagate orphan insertion errors when enabling verity
Date: Wed, 25 Nov 2026 15:23:28 +0100
Message-ID: <20261125143823.382919835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: guolingxing <guolingxing@tju.edu.cn>

[ Upstream commit 45a686dff6b91c3667cd8188d3a02c69f62f4d00 ]

btrfs_begin_enable_verity() ignores the return value of
btrfs_orphan_add() and unconditionally returns 0. If orphan insertion
fails, btrfs_orphan_add() aborts the transaction, but the generic
fs-verity code still proceeds with Merkle tree construction because
the begin_enable_verity callback reported success.

Return the error so that fs-verity stops immediately instead of
continuing after the initialization failure.

The transaction is already aborted by btrfs_orphan_add() and the
handle is released by btrfs_end_transaction(), so no additional
cleanup is needed.

Fixes: 705242538ff3 ("btrfs: verity metadata orphan items")
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/verity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index c29d92c3bbc3e..87722e5d41868 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -610,7 +610,7 @@ static int btrfs_begin_enable_verity(struct file *filp)
 		set_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags);
 	btrfs_end_transaction(trans);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
2.53.0



