Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619636;
	b=ogOn0Ik02Bbs2A553VVYDca0Nbtlq2M+B+ZXeTPpY8J156c6vsc7RPRFv4R3uQn4MAS6
	 +I5pAz+4Rpp09Ra7D6afzxpMHMHlbR/kjjbqz26WB4lc97LHhtTmUobxZ8I2wWDic2Ktm
	 +dmRFrvOPO+DnMnxWCgEDE3zv5145YsBBMQfRb7eTwbqkNtowasbzYfZVWTBDlQcv8uYw
	 U0Gfcoi8iDdtQOR87bgCp1uXXqi0Vv43s8Nnb+77mhOi9OZlnZjKs2zvVxkCWxUHSCqSy
	 wnEeFYhLlZS1E6eiYF0GgZTLQGEtnzUGeFTHYnnwWEH3zQIvDpGRYq0yZVtM0NUg+zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=A23Wd0b7UGj0HZ6YwhmoZgQ7LXP92CSVhIk8f1rPY1Y=;
	b=X5l109kKQqL+2aHw/LRX2hYjJCyxMbd7HUFEJXd8uk7uuNpqeHCu/xF6F/9F8zOr8d1k
	 a+33wGHBgyMI9vdKKdgMfPldvAjULWL6v8FJ8SbRmvDvoTXgDe8gm8Ba4vH9wsh+hAmQJ
	 FyTBHAcVxkKB0Mjd6l0J5InosEibQjRRMKQ5tEouNVSzXAaJ1bp/24FbtwKrzNrl5GpkU
	 RibGCrvgEq/0nTE3paSCyyktKYiw0Xgqw/T+B+V4Z8+qOboyRPVVFBGk5cCFWpVcs2yt5
	 a5SpAnIq7Q2+yh70X+mE2xSVVQjRTKzGOh1CLM5AaIXZ0HDr0HXebs83eElm2oenLYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LjbdEaML;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7876606A321;
	Wed, 25 Nov 2026 15:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LjbdEaML
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124BC1F000CF;
	Wed, 25 Nov 2026 15:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619636;
	bh=A23Wd0b7UGj0HZ6YwhmoZgQ7LXP92CSVhIk8f1rPY1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LjbdEaMLu9MK8/90bsOI4NbAXl4A5DAT/U3WtEIppzV4PnmDtutUxHjFAUT7ncqiJ
	 nyEPiH7Z+SYuq3BNV8QMOI4j6A1PmFIowFxCoYVOJcqYWbm0Vx5cGB567pCQ2+Oci/
	 +J5nUavtQwT7JR5gdYmWaV3ZYY69fAe0hpJz4LrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 0662/1005] netfs: preserve prepare_write errno on reissue
Date: Wed, 25 Nov 2026 15:33:20 +0100
Message-ID: <20261125143837.256606541@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

commit 62869ecb3aeca670b86058387e7533a33524b95b upstream.

prepare_write() may call netfs_prepare_write_failed() (FAILED + errno)
before write_retry calls netfs_reissue_write().  Clearing subreq->error
to 0 for a clean I/O reissue (82e8885bd763) then makes
netfs_do_issue_write() terminate with 0.  The collector copies
front->error into stream->error and mapping_set_error(), which ignores
0, so writeback failure is silent.

Skip clearing error when NETFS_SREQ_FAILED is already set;
do_issue_write() already terminates FAILED subrequests.

Fixes: 82e8885bd763 ("netfs: when subreq is marked for retry, do not check if it faced an error")
Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/netfs/write_issue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -252,7 +252,9 @@ void netfs_reissue_write(struct netfs_io
 	iov_iter_truncate(&subreq->io_iter, size);
 
 	subreq->retry_count++;
-	subreq->error = 0;
+	/* Keep prepare_write() errno; do_issue_write() terminates FAILED. */
+	if (!test_bit(NETFS_SREQ_FAILED, &subreq->flags))
+		subreq->error = 0;
 	__clear_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
 	__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
 	netfs_stat(&netfs_n_wh_retry_write_subreq);


