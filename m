Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBCF3AE6EE;
	Mon, 23 Mar 2026 14:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275191; cv=none; b=Oh0BFf/6Qeq93rnc97gg4aGPnQUUh0CS4Zsc7CrCLjaOa8L2SLAZVk5U5rYl0P5dGm7zFzXInurTBdCScjxEEI0EqHv9YRFthBypari1Yi31xEyEXvuZJRHVPjJwlzoys3twIwqtA585yFVLPlOb7IWSav9xrPAisAcCQSDqlGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275191; c=relaxed/simple;
	bh=xFvPqxqm+9gta4rKtBJTKmybR9o4YkHYVe2f7RxiBJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ao1XFpdHxn/N1fDPtJUYYVbRTuek2UwRbO9WR5RVez72dQrP+q3yTWw/hHY4xv7GF6alpO6qB3ZKwdluOsgHSfpBUKRdPlwkBY3+qu3/4Fwo4Biv8TC7weSu6piuIQUF8TiFOS6XyqhkE50I77NGs0v/h1QXZnZh1ps3nooKm+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+C6y+Yx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+C6y+Yx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4EEC4CEF7;
	Mon, 23 Mar 2026 14:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275191;
	bh=xFvPqxqm+9gta4rKtBJTKmybR9o4YkHYVe2f7RxiBJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+C6y+YxWEtjLK8rhiGYP9mSDUTJ/EL2N6fm1kH4K8kCCj2IdfigXeALNI0TI8sWi
	 MSZL4peef5yQnJAeBYNp9tUyB5mAwpFe4GLRJ5hznFNylJSGucD+JxdKM9CH1pCMS6
	 96Im+lS/K38ZgGTem8W46wgg2mZ7vM4yfAfKjB7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/567] rseq: Clarify rseq registration rseq_size bound check comment
Date: Mon, 23 Mar 2026 14:38:48 +0100
Message-ID: <20260323134533.958431024@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

[ Upstream commit 26d43a90be81fc90e26688a51d3ec83188602731 ]

The rseq registration validates that the rseq_size argument is greater
or equal to 32 (the original rseq size), but the comment associated with
this check does not clearly state this.

Clarify the comment to that effect.

Fixes: ee3e3ac05c26 ("rseq: Introduce extensible rseq ABI")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260220200642.1317826-2-mathieu.desnoyers@efficios.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rseq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/rseq.c b/kernel/rseq.c
index 810005f927d7c..e6ee81dd1e457 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -432,8 +432,9 @@ SYSCALL_DEFINE4(rseq, struct rseq __user *, rseq, u32, rseq_len,
 	 * auxiliary vector AT_RSEQ_ALIGN. If rseq_len is the original rseq
 	 * size, the required alignment is the original struct rseq alignment.
 	 *
-	 * In order to be valid, rseq_len is either the original rseq size, or
-	 * large enough to contain all supported fields, as communicated to
+	 * The rseq_len is required to be greater or equal to the original rseq
+	 * size. In order to be valid, rseq_len is either the original rseq size,
+	 * or large enough to contain all supported fields, as communicated to
 	 * user-space through the ELF auxiliary vector AT_RSEQ_FEATURE_SIZE.
 	 */
 	if (rseq_len < ORIG_RSEQ_SIZE ||
-- 
2.51.0



