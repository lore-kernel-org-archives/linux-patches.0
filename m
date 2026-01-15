Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6F029C338;
	Thu, 15 Jan 2026 17:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496515; cv=none; b=ixMwNUL5rf6/qqZNCj9nsM1ECL6GFuPWYopTImX7WQQnQhbt9HLXMiXwwA9xwgji7KZUgksiTr6fsBz1YNizFKWkzg7RScP7a/fGKzD7IE4VJnw2PLx8PMl8LvgMO5gBGYcHvVO/sT66JT5vKVBYHh8jYWeF5R6GItqJ9RQY68o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496515; c=relaxed/simple;
	bh=Uyq0JePWOByD7GeTpCzMdcnUe9yVs0RLv6/Ye5zb8Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/oOMBToT/0BIie9YL2r7ppQQ9qOIFUt5HK4YcYiuHcjQO0tvUfu5sqCpo35uby+RSWpWGkqHtreVOcbXNpVJkJOvgCsAB9YHrTrTWQfNS9+pOqNdLLxfSQu/Ry8Y9HperiO4Rb/KKtlQdhQDxB/usFl5VHYGfI6+WxvD/QHf6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6P3sQmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6P3sQmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99C0C116D0;
	Thu, 15 Jan 2026 17:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496515;
	bh=Uyq0JePWOByD7GeTpCzMdcnUe9yVs0RLv6/Ye5zb8Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6P3sQmqyhM+faKFyud2RlC+TPAZCdAdrCsx2GCgjx3wPb29IdXAQpUBsimgkOepY
	 4Jr9Cfmku7Di0vvTxV6cwEMsDmYnOWZM2+shlqaTYsKA3rWxuzd+yu5EfIkvGB0Tox
	 f09C7a5nM1QQBs5DqrL0Qv7hZjrMyWqyeJU8gVjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/119] smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value
Date: Thu, 15 Jan 2026 17:47:35 +0100
Message-ID: <20260115164153.406686476@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

[ Upstream commit b2b50fca34da5ec231008edba798ddf92986bd7f ]

This was reported by the KUnit tests in the later patches.

See MS-ERREF 2.3.1 STATUS_DEVICE_DOOR_OPEN. Keep it consistent with the
value in the documentation.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/nterr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 7ce063a1dc3f6..d46d42559eea2 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -44,7 +44,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_NO_DATA_DETECTED 0x8000001c
 #define NT_STATUS_STOPPED_ON_SYMLINK 0x8000002d
 #define NT_STATUS_DEVICE_REQUIRES_CLEANING 0x80000288
-#define NT_STATUS_DEVICE_DOOR_OPEN 0x80000288
+#define NT_STATUS_DEVICE_DOOR_OPEN 0x80000289
 #define NT_STATUS_UNSUCCESSFUL 0xC0000000 | 0x0001
 #define NT_STATUS_NOT_IMPLEMENTED 0xC0000000 | 0x0002
 #define NT_STATUS_INVALID_INFO_CLASS 0xC0000000 | 0x0003
-- 
2.51.0



