Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F7547F797;
	Thu, 20 Aug 2026 17:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248441; cv=none; b=B6g5oy5HFLfvj6dlFz7TZFZxfTeCOuyKtN0uBjG42j60qVM7gMtUgwY5sTmkr/enN7Kt8+Gbvt2JSLJwiZ6WafFNiaCGInLdDKrOFebBXRIyFJY23cZvrap7FT/WnbCW6x5y9999eBjPcHc/OAp6g8l/ELmZh95B0GjilPRKqS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248441; c=relaxed/simple;
	bh=4zuAeSHZ/UmhNZ7/sl7lfRw+Kl3GnxscZSrfDKWgBO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rg63MdCHEeIPiXMld3+ua8emw0vUboutLN3769ypUoqcPyd0PAeSaQLAH63s/+GUMENhmQyu3DajFw3gSb1yDJKmCOV3DNDZfTKn1rbICBm73wGBcl90RtT5T7+NzQC4TxGs2v1DnolSuae9uuxyGPmAWlH8nWmLS9nPxoN+hGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=taSKv0VA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="taSKv0VA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5231F000E9;
	Thu, 20 Aug 2026 17:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248439;
	bh=2/4L4eHYbEqz0cvuqcZ8U5V2RgqSkXB7+Xf2bDFQwAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=taSKv0VA3wLLSxGqqLp1nmidGkwqw7iLKcdFQ41KKSV/DjfQOP623sT/cSnGX5cdn
	 LQSxZxripSRjRH4ofelTTbWdU70kngz6THxPzWjYHKBaawBxJtiJlOxB5DzzRHURl7
	 NUZ38RB3R7a/fiut1/lr85O3/hxjm66JtXqIyZOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 226/303] smb/server: rename include guard in smb_common.h
Date: Thu, 20 Aug 2026 16:56:02 +0200
Message-ID: <20260820145300.203968053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -426,4 +426,4 @@ static inline unsigned int get_rfc1002_l
 {
 	return be32_to_cpu(*((__be32 *)buf)) & 0xffffff;
 }
-#endif /* __SMB_COMMON_H__ */
+#endif /* __SMB_SERVER_COMMON_H__ */


