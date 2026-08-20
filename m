Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7641B188CC9;
	Thu, 20 Aug 2026 17:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247056; cv=none; b=C6sLPV41CeOD+39QCYzDrMG6alNCemwXcB0nN9kBLB+L8ajOYWWFSAr3rn9noZEUToz55Evkm6dO3wg3fwvVdwX+he/7QmO6UQ287Oh27tMMyFCaIx3abXQN6+m8db/uGwAIMYjj/UqhmAAyhrHsc6YQmbDzXzZG25IChMbKd0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247056; c=relaxed/simple;
	bh=7YFqEERKbBY+6a/k+Wazx46hHwWEMQE5qcn2GHHgTQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpaOrURWqD3VtrXafPlg96NTYGaSObicbwcd9v7ySGLvtuyVJpwRVpDe/GiZf8SSHfBhPoZJfRMkHNoH7Ci+NYULEOBKB8ANd1QTP81iCDROP+bMt/8Q+CPa29JPv5P5bHETX6niHsUTxSOxb0Yni5zcPJoTNKs1Z2GORh2aNzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twLKMH5Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twLKMH5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8794E1F000E9;
	Thu, 20 Aug 2026 17:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247055;
	bh=5mZmCOrQphWRWOmUsq1nvYz878aQWKBLbfI6Oz2JuYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=twLKMH5ZZKDT3kUQ/omYADD1SIUZ86hB2p1RMaSEARVQVgAfgWtKC+uuy8mu6xLR2
	 o1v9um4Dx2XiQaqAqfLEFo3+xnSnvrJVUgtMgQU4/inp+vd3Ykamml0KPH4bMtqNZV
	 hgl5xXWcKmByhYKblp23Nj7jqAKHEqMvhocpWx6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/220] smb/server: rename include guard in smb_common.h
Date: Thu, 20 Aug 2026 16:55:22 +0200
Message-ID: <20260820145227.435270468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 01ab0d1640e379f0a0d6602250b33ff2b45e9560 ]

Make the include guard more descriptive to avoid conflicts with include
guards that may be used in the future.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: cfc0b8e5080a ("ksmbd: validate minimum PDU size for transform requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb_common.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -3,8 +3,8 @@
  *   Copyright (C) 2018 Samsung Electronics Co., Ltd.
  */
 
-#ifndef __SMB_COMMON_H__
-#define __SMB_COMMON_H__
+#ifndef __SMB_SERVER_COMMON_H__
+#define __SMB_SERVER_COMMON_H__
 
 #include <linux/kernel.h>
 
@@ -421,4 +421,4 @@ unsigned int ksmbd_server_side_copy_max_
 unsigned int ksmbd_server_side_copy_max_total_size(void);
 bool is_asterisk(char *p);
 __le32 smb_map_generic_desired_access(__le32 daccess);
-#endif /* __SMB_COMMON_H__ */
+#endif /* __SMB_SERVER_COMMON_H__ */


