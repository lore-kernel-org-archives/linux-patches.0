Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C4F14A632;
	Thu, 23 May 2024 13:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470639; cv=none; b=hUMxQHDsfyE9b7rxUkJVJrwbyEawun6ipl3oOSrUx3w33/x19X1wsCUHFNMSNLajnNmzQq4g9+iTwcrccODCaa7Ljk5UMN6S/3fIXfMt805WJ9qY7F1TYoLVjyp4FicRmByxbFv5R+OP7mMyI7HR3i+CgQHsUZ8tgGTdj9GM9UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470639; c=relaxed/simple;
	bh=7rt1nvRsAAkAKaL6xV4wacMlnv2CN1bmY2fr4fKGTqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvXJjFvx7Kvtxi9KYeE9zMme7Be0Vgvo5V34ZfncA0yDV6ED/jVFp9y+vGayMvZSxskmukgd4kP4ls55CO1gq3WClrE4RB+KXfksjjz2JdgzQBAXxJjyZu/6G72OKX+TKvIw9pvWwkOBa3PtsBC7oaPhk/2YmWEufruYz6oPz74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/GPRlSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/GPRlSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305A7C2BD10;
	Thu, 23 May 2024 13:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470639;
	bh=7rt1nvRsAAkAKaL6xV4wacMlnv2CN1bmY2fr4fKGTqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/GPRlSwaRpH8oUDleKUBcTl1YSxuMhhtelLoHZihrI88AbWKYnLSkB8CtOGYvpy8
	 BcOsUfR2I/b+3/TLjMAqZT1+Rx3naO7I0BMEMrOyELYT+kIUGI4jhCGd5wwtGnaHyf
	 oRrcd8+DBGCP0m4uQaiSu1CoDhVFHI3B2dTm4Trk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.lee@linux.alibaba.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/102] ksmbd: Add kernel-doc for ksmbd_extract_sharename() function
Date: Thu, 23 May 2024 15:13:01 +0200
Message-ID: <20240523130343.826551206@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit a12bc36032a2f7917068f9ce9eb26d869e54b31a ]

The ksmbd_extract_sharename() function lacked a complete kernel-doc
comment. This patch adds parameter descriptions and detailed function
behavior to improve code readability and maintainability.

Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/misc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/misc.c b/fs/smb/server/misc.c
index 9e8afaa686e3a..1a5faa6f6e7bc 100644
--- a/fs/smb/server/misc.c
+++ b/fs/smb/server/misc.c
@@ -261,6 +261,7 @@ char *ksmbd_casefold_sharename(struct unicode_map *um, const char *name)
 
 /**
  * ksmbd_extract_sharename() - get share name from tree connect request
+ * @um: pointer to a unicode_map structure for character encoding handling
  * @treename:	buffer containing tree name and share name
  *
  * Return:      share name on success, otherwise error
-- 
2.43.0



