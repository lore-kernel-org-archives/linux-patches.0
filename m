Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831586;
	b=Up3d4c6teKRPlvQ7gU8iYqglkv8BEUk/fCc0Tc8ZJgeYNTxFIibdkiQcUe0CgZ3meW6r
	 O4KjZeByPxNVvVD3EEFh64JTft4ZYgZbUKkiNPNfw9ec59YTP+aGCN0o4Im7Vif2NYK+j
	 mjO+XReea7W3ZeCugFAG/VFTFxlcrm2N33+Ds6CIDNRE7hsFwvLUlbqNJvbwq6fDaGbLX
	 UORzW8Ew3PsDYLxeQvF0xzWdWWnlxgIGw11tR5sYx6N19xGr8qlZYYGgfu0QleRQDKr9A
	 90U5wG0auvrXmcysati2pCwn5y5WmrnwL+l9rFEQ9oAdfe/4L8mABELKXhyh6TLGTRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=33hQaI+kWGnr4Ib2BFNwTuLNMi4T+Pc5iIJq4KyWYzc=;
	b=wo7ajarhy93fzKebxZDIKURHIRyeeNIkipfapb2hU1iVnygOidZDtIALIDcu0dd/s70p
	 3p07SUNkUZAFk3OlO3rXwj/gF+V1JPc765+v11vQGyn3xQRuH8l2tMC3EB9ansLtwJV/4
	 njees5uanWFK+WCNRyky/0eFjuGGTp6DzTtHMXvWPlu94VGcHIDxI1JGF7TPqyp9+/RjL
	 trmo+X+yxZshRNlx3AjjpWw9olA+WuyvIfwhk1iduvrXdVCKGrCCTOkki9MonsRVDf0q3
	 syG6ESNah1uYC+OY98daerk9U7ZlZ3JG0WrOFSqkw4EMQqRpZXZ6bl4DeS/aUyxLSAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cln6Biqj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB577606A844;
	Wed,  4 Nov 2026 22:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cln6Biqj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA0D1F00919;
	Wed,  4 Nov 2026 22:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831585;
	bh=33hQaI+kWGnr4Ib2BFNwTuLNMi4T+Pc5iIJq4KyWYzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cln6BiqjzckjVWYq6GWGWKUJdAtZXkLJyF5uUwOOxCS5fq811A1hrkGEYA6zYSbj5
	 wtVzZZmqzoo1HZ2ktRpIudszwDF5pq3Bk9Ok31Cio9M16Qh2h4YTbBmP/yU8IbrgTV
	 ImGymMTWzrkpA0zExuj7qc5hs8Vkd2dxnVRmR7v8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0791/1005] xfs: dont fix the directory tree if live update fails
Date: Wed,  4 Nov 2026 16:08:44 -0500
Message-ID: <20261104211105.497839226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit c8226f3d1a7eafe472addc232689e9c9a0c36a1c upstream.

LOLLM complains that we don't double-check dl->aborted one last time to
before committing repairs to the filesystem.  This is important because
the live update handler could have set ->aborted if it encountered a
runtime error.

Cc: stable@vger.kernel.org # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree_repair.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -427,6 +427,11 @@ again:
 		error = -ESTALE;
 		goto out_trans_cancel;
 	}
+	if (dl->aborted) {
+		mutex_unlock(&dl->lock);
+		error = -EIO;
+		goto out_trans_cancel;
+	}
 	xrep_dirpath_set_outcome(dl, path, XREP_DIRPATH_DELETING);
 	mutex_unlock(&dl->lock);
 


