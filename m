Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785A536A37A;
	Thu, 20 Aug 2026 15:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239058; cv=none; b=gR/W5PvFGDkxdFu3+t5ky/38gFZMjeYIeXxOp8B92NSfx7EUeOOb/0p46VcY+cIfk6Dm47Yw7dJLdErVjZrNtXa97Lu74CJ9glUKTbgRbjoZ2unW7jWOwyCe+q+MpbXRTTmYBQKBSCscMv3io9EcJRrilw3s/vlRIEVH11oAeQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239058; c=relaxed/simple;
	bh=VdWrC/en81ffHdTDlVbjwU2KPRZ4oVaLHL5wfABtN/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=li64+9OJ3xiJVLfFZU89jB+cQwbiATEjpe9R1LQypt4n5oZxy1f2x7MpLS7fvLoD6wXOMAF8tE1LTLei0UzLUcPAsSfzt/B24Q9DDFPSiniuIKuaF++4ywqbXS0ht9XgCQSQ3YyPasb9S6nlzZl/bw6AWqAa+y3wR7mG66aGRjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qI6Vp0vm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qI6Vp0vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32AA1F000E9;
	Thu, 20 Aug 2026 15:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239057;
	bh=glLNVqvUwzxYQ3tDdsUSVYW8uZEENiVdJ8Li+awr1DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qI6Vp0vmWXhmd3sqRfDGiOQXKUgjPUrlzRR86yLUVY3zrlwrLvOgH/Zn6SmZR2hlB
	 AVbxJIpQAsBdzGc7ia6hg0WnS8WRNqdK8sJYVvKLWeT6eIFpUKcHsCT06o56M9wnx5
	 CpijbJiw76eXGgU5I5FAnYwPlQ5z9aH+tQNhIpzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 136/217] smb/server: rename include guard in smb_common.h
Date: Thu, 20 Aug 2026 16:55:04 +0200
Message-ID: <20260820145241.847103663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 
@@ -423,4 +423,4 @@ unsigned int ksmbd_server_side_copy_max_
 unsigned int ksmbd_server_side_copy_max_total_size(void);
 bool is_asterisk(char *p);
 __le32 smb_map_generic_desired_access(__le32 daccess);
-#endif /* __SMB_COMMON_H__ */
+#endif /* __SMB_SERVER_COMMON_H__ */


