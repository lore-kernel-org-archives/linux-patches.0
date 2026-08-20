Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0DE37E5CD;
	Thu, 20 Aug 2026 17:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247560; cv=none; b=inBqbMyj0Ai1slrjkfz7Z8ESHZNZqqK9qt1x0sCOAHwgYiU4Z9fwFHes83FhVlI6UL6wi8F++rsGo67YIOV9jq+aXIk9wcPxTn9GTWQ6kiAzQ66tuQxuLyb/4bAoob6r5xkoV/m8vn1ovS6AyPlbBpILeKjoE1ePSgh+48BQIuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247560; c=relaxed/simple;
	bh=puOn1K8kQV5MziWimufF4YC0T++85qhtFHaYb/yWS+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzcT5ThV4XKTvtDTFgFOjeRsk/AwG4e3RELziYxcv2mp1J3+y49zy/GBH+DiIQTqSM8Mx7vZbRipatcgVxy0FCaORyKvZ0upecewIf4Q+snjK4nGU9drLlRgWLQ5RYVaWtcjLDXk+pOPanVUO0vgcQdDbSfciNa5c8JDPNcASnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gR7/vd4J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gR7/vd4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4CF1F000E9;
	Thu, 20 Aug 2026 17:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247559;
	bh=axE6KhX4VuQTQXKHsPVKFop9+byazfGHHKCwUiJGkRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gR7/vd4JGTEQIkn1F7lGZ58hVzN8hpIKnWnBM4H6jp7Qql8O6rjxbWvhGE0XBcPFK
	 txjzniUD/uUWemxiGrZGHGP9IJ1oIiqdQSpOQ1Q2RgvD0IiMVQN6indyY96wtOCEAL
	 v6Qn3qid/szucLeNrNOJPKQ/sB93YbqBszWVv414=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/166] smb/server: rename include guard in smb_common.h
Date: Thu, 20 Aug 2026 16:55:48 +0200
Message-ID: <20260820145213.828788727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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


