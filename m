Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0885938A739;
	Tue, 10 Mar 2026 11:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142179; cv=none; b=kukP/a86Z1bdnhhnVfCbYEGadD+aLt0LwT8ePVIsp3Xr5YTSAnHFogTcrBaaok13lj5GL58C6NaENfmjGvHVdQJRBSsVD/0tbZSMtPXJkWb+fJ0NyehDtSp/jvRz+xg/s//huTPOjK7gS8Gqk3pIQiEbqXjRzi1tjoEpzla1ato=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142179; c=relaxed/simple;
	bh=qNNbkfUdOXt+R5qMaoTb9QP9kNSNnWnQ3yVz4f9dJMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCHH7/MVEm8MHJfT5ADWxqiIaEZVFmuT0iPkzeZ2D1UhLdl5xVfAash7CzUQwgcDHntQlinJhEh43kf6vipt8ne9IcWAKs3p4HdJfX1JfWCkDMhaC5iZc5zfpnR2uNT+1GBWdZpk+HJLni6QscwzB8rrgQeiNdgkd8HzXT3nOVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Za9vlREv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Za9vlREv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D58FC19423;
	Tue, 10 Mar 2026 11:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142178;
	bh=qNNbkfUdOXt+R5qMaoTb9QP9kNSNnWnQ3yVz4f9dJMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Za9vlREv97gqgrj64YLbLnSb33sChhWIEMkp/fiKpn/9lmArd34N96PLbW/cf9ZpF
	 l9htnX3GlKgZnpf6oE/eKjPbV+Tgyk9/GM5++gWmDTostY50c1XMDSZT+FQ24MJcqw
	 yxW9VikTbnQHBhk1ZLtX9yDvVhl86JhPftUnkfzq6D5J9wKbbGHfR5j0GzO8Pnvfhs
	 5LATK47jOwOKjVBXaglLkvdLQYw2kmXwXuiB4p9ucddqx+c9NECvtt1FOOBet02RhO
	 mWOf2DEsN20YYhG0oodjv7fnT8OudYD9iFEoADMoHMTpnOBYPhQoSgARakWFx9RxYI
	 RPSMdkE199wBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 267/314] smb/client: fix buffer size for smb311_posix_qinfo in SMB311_posix_query_info()
Date: Tue, 10 Mar 2026 07:18:46 -0400
Message-ID: <0ddf090d65c0852432baa163d21f0a55c63839e7.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit 9621b996e4db1dbc2b3dc5d5910b7d6179397320 ]

SMB311_posix_query_info() is currently unused, but it may still be used in
some stable versions, so these changes are submitted as a separate patch.

Use `sizeof(struct smb311_posix_qinfo)` instead of sizeof its pointer,
so the allocated buffer matches the actual struct size.

Fixes: b1bc1874b885 ("smb311: Add support for SMB311 query info (non-compounded)")
Reported-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 58238e65c7edf..309e2fcabc087 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3915,7 +3915,7 @@ int
 SMB311_posix_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 		u64 persistent_fid, u64 volatile_fid, struct smb311_posix_qinfo *data, u32 *plen)
 {
-	size_t output_len = sizeof(struct smb311_posix_qinfo *) +
+	size_t output_len = sizeof(struct smb311_posix_qinfo) +
 			(sizeof(struct smb_sid) * 2) + (PATH_MAX * 2);
 	*plen = 0;
 
-- 
2.51.0

