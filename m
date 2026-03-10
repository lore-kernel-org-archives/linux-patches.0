Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE1E389DE0;
	Tue, 10 Mar 2026 11:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141253; cv=none; b=uzuHDarItzJsxDQOcXReIbjFkB1+OFDvA9dOM3qi9+eYfAmnOiJc1TYy6YgGjO6DywG4QUVdNclyY1fSp+FXejJDN/LejOqfVLWdUDT2yFgBe945TXePeY8sVMc90OyEvWUXDRYK/DNJyy1uS+1daEFT2IpMTyFr2qh8wHmGT8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141253; c=relaxed/simple;
	bh=u6Pu1BL2VHHw9LI2/RKEZMC4x74UGtflQwtD4Uf6MtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkYAyu+GHGOj+0hkC4kevSA1hsG5cNPM432YSap6ldMzuunHLs2f+znF/8xseq+QqCyNlojKA5RdKZCL9GKULA0xjrPK0Hryfty8pktDW/8XXcuRtcgccxCqbsa7ygQn5zhIomXVw/1q1waWvN3x/Z0QD0/S88IrrN/fPmkDN/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B7NfvqSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B7NfvqSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEA3C2BC9E;
	Tue, 10 Mar 2026 11:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141253;
	bh=u6Pu1BL2VHHw9LI2/RKEZMC4x74UGtflQwtD4Uf6MtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7NfvqSG3rGflz+avioWulNVDetTWqIgfIgaDXk+ZZG36Q/8hG8JTSfuCTfltKv/u
	 qE/cguKrxCsZANHQljXmwXj0E2p+tivUXZHiqFrd2ZJv4o8A0neOQMQ/caMGbRfy4F
	 iqWtTM9txrU5kdUwFkrxiRbfoO4TLh1E6TnEpiGKytZwn4wJMWSUvfpJJ906Hq8G2a
	 pTFT/KSHTL+sFfQX1lG/oobwkWi7/GX7zgkTVcwjYrQmL+RSlPFDqfnINfeOM8WHrv
	 xbKFvjGH2BzR/SbUs2Ubu7YeTJfEzALY0vvUmK7eCq+QKf12dg655gtA5Ahf08Uv+9
	 9qMBbqpPwgbyw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 255/311] smb/client: fix buffer size for smb311_posix_qinfo in SMB311_posix_query_info()
Date: Tue, 10 Mar 2026 07:05:02 -0400
Message-ID: <dde8b9f523aba7bf6540a0db0eaffafa4668e3b0.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index b16d7b42a73c4..bf4a13acc8b86 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3981,7 +3981,7 @@ SMB311_posix_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 			u64 persistent_fid, u64 volatile_fid,
 			struct smb311_posix_qinfo *data, u32 *plen)
 {
-	size_t output_len = sizeof(struct smb311_posix_qinfo *) +
+	size_t output_len = sizeof(struct smb311_posix_qinfo) +
 			(sizeof(struct smb_sid) * 2) + (PATH_MAX * 2);
 	*plen = 0;
 
-- 
2.51.0

