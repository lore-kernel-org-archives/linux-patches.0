Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619769;
	b=mTlHLd6HpDYviIJ1MrISoJc0eWczg+g0CBEX/TSqDcCaPXTmL8drdxVkGAV4AI3VAlXP
	 rHxx9F4OaSryXoR1jvOHqcmx1rF1PvTfC9VUiRHEIlHrJaaX3zQtekyHhFB2WleExCIkJ
	 j+X0Ejb7yQEilSNJBQOVpSDZL+jD7hdBji9Eka1JShtcyVyl1hVDjwPTvmBQhpCBbdfuh
	 O0eSvak3opZEcVn3aR8hpgNRMeGDu8Qihy7LU4M1WsTFuhVEzxdUnGLIu+xRHfvMLSkKi
	 M+jj3C7cbgGRHDfQLuODcaFvfWztI5etGKWuWSrMvFaUtc7C5E7uqn+RxZVI/7W1TsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xd0yptUQGnf+AzSnRJ1Th94bMe/XS5iyqk4eIN/ZC+o=;
	b=pLOyh2HFn5jAjOCASix01EJDoBXo+edCnERmEi/1CpbHo+ZbKIC/KbsI/clG7KNErXza
	 cqEStHhE0b4Tmzqwml+hz03UtVKUWEqr/qJh+SldspQlI9vIJnCQmX+bx9c0zUAoCwYh6
	 TNmngCW9239RwV2Lp32/1rf9i9OwNe3iFp+IocoXaJBlQ5KFd1r/QZYhQMhagsvdJc/Kb
	 ZG8eAoCkxqpVYl1fseZLm5t/tiK94F/0LH3bgG+a8JPvKOYdqrYwZAWXeIyGVqwVyknRK
	 53bSJz99rEQd5VfqaKsj3S4WyQBEMlgRt6JQ1XtJCaBKlDlP+CUf/y0S496aih40vQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=edho1Gl3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453ED606A323;
	Wed, 25 Nov 2026 15:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=edho1Gl3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6511F000D1;
	Wed, 25 Nov 2026 15:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619768;
	bh=xd0yptUQGnf+AzSnRJ1Th94bMe/XS5iyqk4eIN/ZC+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=edho1Gl3mgY5lte6fcjthEpiiVaJr6dLtSeBI8ACFN6ldX/IKAmT09nnJbfY145Ih
	 JdCLV0zKaHGbS6ZYuJi60DhQrKA1IausUVmT2xixsKAy/uBpCGT+3N+WWm3wUCuRtz
	 Rero+uRdf5eWQM5CHtZ2f/urh5rnI9VKgEZZund4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0703/1005] fs/splice: clamp an over-reported write_iter result
Date: Wed, 25 Nov 2026 15:34:01 +0100
Message-ID: <20261125143838.227071904@linuxfoundation.org>
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

From: Cheng Yongkang <teel4res@gmail.com>

commit 2d956723e82cddae8ff8e9da99a666217b02065f upstream.

iter_file_splice_write() builds a bvec iterator of at most
sd.total_len - left bytes and passes it to ->write_iter().  It then
subtracts the returned length from sd.total_len and walks the pipe
buffers by that length.  A ->write_iter() implementation that reports
more bytes than the iterator held makes sd.total_len underflow and the
dismissal loop advance pipe->tail past pipe->head, releasing a zeroed
pipe buffer:

  Splice Exceeded! ret=7 tot=1 left=0
  Oops: general protection fault
  RIP: 0010:iter_file_splice_write+0xb6f/0x1170

Commit a3de58b12ce0 ("netfs: Fix unbuffered write error handling")
added the warning for this condition but only reports it.  Clamp the
return value to the size of the iterator that was actually handed to
->write_iter(), so the pipe accounting stays consistent even when a
producer violates the iterator contract.

Fixes: 8d0207652cbe ("->splice_write() via ->write_iter()")
Cc: stable@vger.kernel.org
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Link: https://patch.msgid.link/179328314072.648427.13388575162083843840@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/splice.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -737,9 +737,12 @@ iter_file_splice_write(struct pipe_inode
 		sd.pos = kiocb.ki_pos;
 		if (ret <= 0)
 			break;
-		WARN_ONCE(ret > sd.total_len - left,
-			  "Splice Exceeded! ret=%zd tot=%zu left=%zu\n",
-			  ret, sd.total_len, left);
+		if (unlikely(ret > sd.total_len - left)) {
+			WARN_ONCE(1,
+				  "Splice Exceeded! ret=%zd tot=%zu left=%zu\n",
+				  ret, sd.total_len, left);
+			ret = sd.total_len - left;
+		}
 
 		sd.num_spliced += ret;
 		sd.total_len -= ret;


