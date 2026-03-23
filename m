Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3A81A23B1;
	Mon, 23 Mar 2026 14:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277973; cv=none; b=E5o1sfxgYJF9RKX+dhw8kK1/ygM0GbuB6o8/abzVnWoO59fkV83F6MlIBbTR4na3rRYwnt41xMHuSsxKAt7q+mjd7LPS4UVuIkUV15IPLWGx/79YnuYHX2oeJbh7hcmok9Yc672KCKz9v0l446L4vWdZkYWcnBPp7G7WF8CGaPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277973; c=relaxed/simple;
	bh=GzNsi4JIhXOdtc/6tcXaxGp9bze/JLgXaOoH4pegl14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eP/Ve/MluFJyFNy5+lRGjdqAhjU9KWpzBc63JDC6jYikTJLMB1/ouVYb9jN9PTK7DFaV/gvZT2YZsELngTpsCqbyYJ/4n+UxaJBwZ2JyQOdTUE2pXSXbr+xtu5SgYUfOGghxABiWgjepEhfi8ZFOvVcPJ1jO1x/IGkns8/YQS7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCJVFwjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCJVFwjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580D4C4CEF7;
	Mon, 23 Mar 2026 14:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277973;
	bh=GzNsi4JIhXOdtc/6tcXaxGp9bze/JLgXaOoH4pegl14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCJVFwjdVGh+lruQUKOd5LbNqO9YK+dIKMjpAdssuVdcISLwRtv1soo6wBLCuD/fq
	 MNPvM0J2/U67yY7K/WqlRmMbJRY2qEyZN6oALonT5G3SvM6by8lVk7N3Iq+OdmoiR+
	 Gp2+zpuCak5urarJ1NScpSGb/D5UbeXwdr3qDy0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/567] smb/client: fix buffer size for smb311_posix_qinfo in SMB311_posix_query_info()
Date: Mon, 23 Mar 2026 14:41:21 +0100
Message-ID: <20260323134537.805639294@linuxfoundation.org>
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
index d1d332f08883a..094f431e428fa 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3927,7 +3927,7 @@ int
 SMB311_posix_query_info(const unsigned int xid, struct cifs_tcon *tcon,
 		u64 persistent_fid, u64 volatile_fid, struct smb311_posix_qinfo *data, u32 *plen)
 {
-	size_t output_len = sizeof(struct smb311_posix_qinfo *) +
+	size_t output_len = sizeof(struct smb311_posix_qinfo) +
 			(sizeof(struct smb_sid) * 2) + (PATH_MAX * 2);
 	*plen = 0;
 
-- 
2.51.0



