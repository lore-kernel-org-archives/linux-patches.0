Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782F0347BC6;
	Tue, 21 Jul 2026 22:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674712; cv=none; b=f0ZfODMhXi4ge4c0UjVUonOWBsdEyTq83y/IHD7jslW64T4x7nK5xD6pKkPPqqCJ8OSNUe06zhcBYxsDWMxqDxvwybf3owM7UBZMvqXcCfK/KczXDxN1hY3kDXq+S30TE/a5SxgHXOHtRxGd2JaOYITxp5x24wR0SDXU/g3pDvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674712; c=relaxed/simple;
	bh=KGE21wh7UFUrU9TtmQPsNdbOJwOwFfOtSUgPaecX0yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPzGrK57otCnlZ8bo2G/JZR11aIWi+bQOPUtYudYNoskS6+7easiybLgC46jdwvzzaglS+Oc+6BKWmyizqad/sgDac9qzbFSUmugbElvimKvsf0KiDj5A46PqhrarSxcbd9aX7Zo2h0wO3Tdv0wrGGz1AYW/5hDFfLiSWGAcOYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGHRb9VS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGHRb9VS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBFF1F000E9;
	Tue, 21 Jul 2026 22:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674711;
	bh=PFrz2Lx6fVj17kUR5jv+HsKv9KQyxHhr4A6GY8cjceU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGHRb9VSWXlEZMd7RHxIzf0O/WfpYGWd85jH1um7k/WxJmHM2Ro+u4re4Ia/+Mt5G
	 hry4v91DpWxkXiW2atECiKtKdP5qrKjTHtl5OwLhFRWgsgLs89R/pWa7iztXQ73gZl
	 V47EQ+IPW1KwzGLwTU/lKu0PQxzRWvdx9MUiwVl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zihan Xi <xizh2024@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 645/699] smb: client: harden POSIX SID length parsing
Date: Tue, 21 Jul 2026 17:26:44 +0200
Message-ID: <20260721152410.301186327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <xizh2024@lzu.edu.cn>

[ Upstream commit 7ad2bcf2441430bb2e918fb3ef9a90d775a6e422 ]

posix_info_sid_size() reads sid[1] to obtain the subauthority count,
but its existing boundary check still accepts buffers with only one
remaining byte. Require two bytes before reading sid[1] so all client
paths that reuse the helper reject truncated POSIX SIDs safely.

Fixes: 349e13ad30b4 ("cifs: add smb2 POSIX info level")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4518,7 +4518,7 @@ int posix_info_sid_size(const void *beg,
 	size_t subauth;
 	int total;
 
-	if (beg + 1 > end)
+	if (beg + 2 > end)
 		return -1;
 
 	subauth = *(u8 *)(beg+1);


