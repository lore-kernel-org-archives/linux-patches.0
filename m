Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464C6156864;
	Mon, 16 Sep 2024 11:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726487983; cv=none; b=erMNTmSs0GhiMpI4zfeh3lamndyAN8MN2bHi3pFk37qYK3EJwe782uhA0pvkoeNu4Q2EHw0K2yt0vzCvnV33bPgWp6FJFme5YR3dyVLRO965TQy3N1GSJ2/x7c0oXlvHGM1HjeITaSSibuBLU7Z0v7M9G7xKy9G5fCUGhMvDlLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726487983; c=relaxed/simple;
	bh=7yPmjvbLv6f71I84eL5ZmyaKu1pWzxDKEMqm0Q1kHB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATR7tc8vN6MGywIP0XHaCKXSl/K5GHbSJ4oVrX3BodRXFsy1GVz2yNKq3HoKH8nOOu8zZroWHNMCcClPY3k0jb5n57dwnjJML8nwa8S7bUfqvWyDGruM3K18JIzwVueNi2wNmldnM3wRdMJS/yQTi7JvskgagTb1eHTFrGzRaIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1Hy4SHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1Hy4SHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C66C4CEC4;
	Mon, 16 Sep 2024 11:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726487983;
	bh=7yPmjvbLv6f71I84eL5ZmyaKu1pWzxDKEMqm0Q1kHB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1Hy4SHbXZF1DkCUfjdwxJoVJD44rLBZ3QLFvjCZo9s8gbtl1v02CWFv2Ch5plo7/
	 ASd2aHWhqCJra4IVFvNQL5+X9JNVrR4gzcsUzwr+HbmU4TlX9gHN5ytov1U4ASyzLC
	 oPENlQCP3DxhBqfWPGPqhZuwadZR0ei2nVyCn41Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 18/63] smb/server: fix return value of smb2_open()
Date: Mon, 16 Sep 2024 13:43:57 +0200
Message-ID: <20240916114221.704997961@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 2186a116538a715b20e15f84fdd3545e5fe0a39b ]

In most error cases, error code is not returned in smb2_open(),
__process_request() will not print error message.

Fix this by returning the correct value at the end of smb2_open().

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 808c62d7ff3e..dc8f1e7ce2fa 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3482,7 +3482,7 @@ int smb2_open(struct ksmbd_work *work)
 	kfree(name);
 	kfree(lc);
 
-	return 0;
+	return rc;
 }
 
 static int readdir_info_level_struct_sz(int info_level)
-- 
2.43.0



