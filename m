Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585994;
	b=y4iBVGHk8+jeZNhxss6ODIWpEincvE5q11A/f1FYv9X1W59wn1QSgJrcqlxsD19NU3oG
	 2ASZkQFVG1QHR7y5xqqpMJYch5cusa7xQRHmtX8H9FpLRWxJl6Q11U7WV2KWmwSu16FmD
	 ZvyMWqEwAzVXGqseFkPCm2M6fFwPMiglR2HbrQ2UumknQSqA4PLlqhlatEIf5fWG3sMKi
	 FtJ9/fPfrOwNqxEraFdn1U8JbCG+Vd/y6nuJ0FBRaRlxzIJpC14rnEBP+aYYgxva4WgLe
	 rn6UPYgbgLa7354AzBltavEJaWFkDBiavow4kCKkNIMUZx6CUCiA2mpZIBz5ngcyX3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3DmcOtxntMt3VwrynuKSD/uTcxfN1ry2qepI3bSbGrc=;
	b=paz2fadomrQGzY4eRnj+NgFhudDdaLj3JUv+RM3y/vkNDG63cJeRk9fFRhPANa66spRL
	 yRU4xAqWAzw1C0ZFV4SXQ9g+yoL0Rgs4I+/4J1H3y+m9PZeyXj1CWEsG+mtrvuT4+K6lm
	 A4JRQ7SyFVCRy7J91NkGMqHIr58rvqyRytfvtZ5hSV8Itayun8ddm79WC61yIJf7wj4+c
	 m4sYAY5ovdmFc5b4lRfh36bpBhEQLA6LSyv5guEdkMAhSFf7ERI+IIKaV5UIHqbh0Tqo4
	 PYAt9qzWS3R7PQHmEbbrBdUVbQnDWIZrb/BLiRr/KM5ZtZypxet0Sge8RG//jGqNUtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyJ7FGz6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23376076E30;
	Fri, 13 Nov 2026 16:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uyJ7FGz6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5641F000C9;
	Fri, 13 Nov 2026 16:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585994;
	bh=3DmcOtxntMt3VwrynuKSD/uTcxfN1ry2qepI3bSbGrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyJ7FGz6/1MCZKj8VXDG4MEi2/weIFHZRNLx7RL9bC0qSAxSV/M8WzNdCtgL0NG38
	 XJn+tMvKvM+UoyrsTPsJaKQ4uLRpO8qfaChMJfTi5+hJctHsh7w/lEtrObNdIhraX5
	 xUjelOA1kjddSYdE3BrHCXU+bmYos9v2SWQ6K1vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/686] exportfs: Complete kernel-doc for struct export_operations
Date: Fri, 13 Nov 2026 10:42:50 -0500
Message-ID: <20261113153822.232787705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Almeida <andrealmeid@igalia.com>

[ Upstream commit 7a6f811e2c06d656996776771f0498df129a0cc2 ]

Write down the missing members definitions for struct export_operations,
using as a reference the commit messages that created the members.

Signed-off-by: André Almeida <andrealmeid@igalia.com>
Link: https://patch.msgid.link/20260112-tonyk-fs_uuid-v1-3-acc1889de772@igalia.com
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 5d28b2c920d9 ("nfsd: don't offer flexfiles layouts when NFSv3 isn't being served")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/exportfs.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index f0cf2714ec52d..0dc1bae9e1654 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -201,7 +201,7 @@ struct handle_to_path_ctx {
  * @commit_metadata: commit metadata changes to stable storage
  *
  * See Documentation/filesystems/nfs/exporting.rst for details on how to use
- * this interface correctly.
+ * this interface correctly and the definition of the flags.
  *
  * encode_fh:
  *    @encode_fh should store in the file handle fragment @fh (using at most
@@ -252,6 +252,19 @@ struct handle_to_path_ctx {
  * commit_metadata:
  *    @commit_metadata should commit metadata changes to stable storage.
  *
+ * @get_uuid:
+ *    Get a filesystem unique signature exposed to clients.
+ *
+ * @map_blocks:
+ *    Map and, if necessary, allocate blocks for a layout.
+ *
+ * @commit_blocks:
+ *    Commit blocks in a layout once the client is done with them.
+ *
+ * @flags:
+ *    Allows the filesystem to communicate to nfsd that it may want to do things
+ *    differently when dealing with it.
+ *
  * Locking rules:
  *    get_parent is called with child->d_inode->i_rwsem down
  *    get_name is not (which is possibly inconsistent)
-- 
2.53.0



