Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064797;
	b=pdSpgKijUWA+ssF0/5l4iGNTT+5u1fGyWgXYTVBfgQBJV69fcxyA3c4jgclsf+LagPY1
	 pAl1ePVmFJJ7gEcrE0lJyTKGwRx4qzwmQmuQ2MnEhsNQdrLAahyC/wZYt94Y6URPys55u
	 W63k9SiYNxcwdixBZYgSy0FGaHWh+029ydpPfsQNXon10pFqbeD3AiZQYDMiNG1Tpb6u/
	 MGlZ+H5n+7iaBb+ntA8LiHpSg5TpwEJIt9nQSUavwki0kUdx15i4X8fMRWbxPbC94KNhp
	 fTIDRNAChS4puYTbaolOKu1Pxgm904kdeoA6N0DaROSobGm3pzKUA2Qba6lKmk0X9Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PQbdSOqTFiAFxCo9VDKPTSfvvrfrGo9Y5UtjZpbCGio=;
	b=JfJdNIpFX8hPDFLOq9snuRis/9Rq7CU3RQ4HMB0t/RmDqxfPjM4+jpHFK4Nd1Vj20PYO
	 PiKDnj66pRwLzu5JzyU1UIND62aT8AQJe729KEvxXK2c0JycVBWX1KVaiIK8OFI83xAbw
	 5g5rz/QCKqpj8GCq7f7IE10+xwE8ZfWtw3NqkxS06qPfn6y9go7HwFVUassJqDJ+558XR
	 0McU3w/n1m77Bv8owk1hk/2T5A7nbEvjOnrgErbfn07Xbj0Llm7g9uM7iwz6AgBWTVk0E
	 FaprbjmrnmaIZOg518EKgBTjgxUP6sA4g8XZ6jTWLBCJeS/IfBXYOy9X0ZcBlk2kYcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j2JR7Wmh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4BE606C01A;
	Sat,  7 Nov 2026 15:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j2JR7Wmh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D9C1F0089F;
	Sat,  7 Nov 2026 15:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064797;
	bh=PQbdSOqTFiAFxCo9VDKPTSfvvrfrGo9Y5UtjZpbCGio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j2JR7Wmh09Zvr20/rPN88pr0fjUDTjv2+BvQ2rCWzYY7tyJLyQ451IUvKbu6LZAWI
	 beo/sUpxFNvujXVf87IKUyuzjnXbmSQYpLXOF830/qcM0Q3w3sKcOJ+rARrRNlOJ8s
	 eALtwzmAbzKTWQl1exzfwhoUOjqQDbpeRRHEc2GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Gabriel Krisman Bertazi <gabriel@krisman.be>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0740/1257] tmpfs: fix unicode_map leaks in casefold option handling
Date: Sat,  7 Nov 2026 08:50:36 -0500
Message-ID: <20261107134959.725539502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Kazuki Hanai <hnkz.64@gmail.com>

[ Upstream commit f439d79e8cd19f89e04cbb3b532347edacd72c79 ]

shmem_parse_opt_casefold() stores the unicode_map returned by utf8_load()
in ctx->encoding.  A filesystem context can receive the casefold parameter
more than once, and a second successful parse overwrites the stored map
without releasing it.

The map is also leaked when an unmounted filesystem context is freed.
This includes the temporary context used for remount, because
shmem_reconfigure() does not take ownership of ctx->encoding.

Reject a second casefold setting, clear ctx->encoding after transferring
ownership to the superblock, and release any remaining map from
shmem_free_fc().

An unprivileged user can repeatedly create tmpfs filesystem contexts, set
the casefold parameter, and close them from a user namespace.  This causes
unbounded kernel memory consumption and can result in a local denial of
service.

Link: https://lore.kernel.org/20261002081306.637148-1-hnkz.64@gmail.com
Fixes: 58e55efd6c72 ("tmpfs: Add casefold lookup support")
Signed-off-by: Kazuki Hanai <hnkz.64@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Gabriel Krisman Bertazi <gabriel@krisman.be>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: André Almeida <andrealmeid@igalia.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 93714b47f414b..de2362209cc38 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4511,6 +4511,9 @@ static int shmem_parse_opt_casefold(struct fs_context *fc, struct fs_parameter *
 	struct unicode_map *encoding;
 	char *version_str = param->string + 5;
 
+	if (ctx->encoding)
+		return invalfc(fc, "casefold parameter cannot be specified twice\n");
+
 	if (!latest_version) {
 		if (strncmp(param->string, "utf8-", 5))
 			return invalfc(fc, "Only UTF-8 encodings are supported "
@@ -5000,6 +5003,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	if (ctx->encoding) {
 		sb->s_encoding = ctx->encoding;
+		ctx->encoding = NULL;
 		set_default_d_op(sb, &shmem_ci_dentry_ops);
 		if (ctx->strict_encoding)
 			sb->s_encoding_flags = SB_ENC_STRICT_MODE_FL;
@@ -5097,6 +5101,9 @@ static void shmem_free_fc(struct fs_context *fc)
 	struct shmem_options *ctx = fc->fs_private;
 
 	if (ctx) {
+#if IS_ENABLED(CONFIG_UNICODE)
+		utf8_unload(ctx->encoding);
+#endif
 		mpol_put(ctx->mpol);
 		kfree(ctx);
 	}
-- 
2.53.0



