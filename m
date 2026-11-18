Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044743;
	b=UHDTkIkFyZ+TZF/4yrOaPB2NS/es5/XQmVihw4RPQBxT08AwnzxRXReWNDKGS+k5nO9+
	 Jzh8JLkySBk0C5SoafpycHrqfGkw5a7Zw5Y5+uIdaHmWV8XpIkx4QrY9kqP2OyUgR8/Nk
	 K7stm+J0GR7Y95/LgyJ7SgYVwCFMwC3gH7ayxCN8Gwd7WxOcj2TCIroBSf4oX+XsvPJWT
	 ZKnd/UAgxfPA8AwMzby2dHeYePFqYNzYihRjM2vEi4AsbnfZBtN4iqASq3OF1Xnir780H
	 pRXvZCJ+SyQqfzbj4QAotVkhNqbmGb4oYoG5ysBvofY22tj1z5xLE6Pue1IEBuRhHGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n8rmG6oyJbkc+2JCkTZYzUPTjmvpwbDfD+YWAC5jYuE=;
	b=pmAhVQaGKJ1/p5N7+jb3sYxS5m8pGDs6XgfZLW33kwIgxNntyRIbTC6TTTbAeUQe1QKl
	 CxQH/IbnHGUyKJEY0WzDN5fOhWV03Yq+WFef5pMwyVG8Cm93a9E2RtjkzKbXJerepLrQa
	 ikTLXGK9TIw82y96LBwXzmX301RjdFAzmwWfMDTET7OSd1Q827ymQagM0PzO2Pn949V59
	 gfLEYNXimHHbgXODE4+BJvUAW0qh2xNV6ho+fAFDvYgG8TVNnGI8zOhX417zx0cZ5ystq
	 bcTWHm12Okzo9eUY8k5WiWy3YvUMo6atMMGKgUK/Uod9z4IYxKFt6m3tO+R3H+UkZDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ShehoEgB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFF9606A33F;
	Wed, 18 Nov 2026 23:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ShehoEgB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EC81F000C5;
	Wed, 18 Nov 2026 23:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044743;
	bh=n8rmG6oyJbkc+2JCkTZYzUPTjmvpwbDfD+YWAC5jYuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ShehoEgBg7zGNjpe6q5rdyR129t4j5NNKpMfrVpl9f6ZpxNX0VzAiG4Pn3PiZRt3A
	 cMI0mcZTGmYS/E/YiIrfOC6/BAQ85W2RG0auX1mG3mTAMTpDEeVn/PGAZ5is/lm40S
	 MWgyZJCWgL09AMZPr4H3WYbdGalqisLK3whBKMns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Zachariah Mithani (AploSec)" <zachariah@aplosai.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0673/2857] ksmbd: prevent share root removal through empty paths
Date: Wed, 18 Nov 2026 15:28:27 +0100
Message-ID: <20261118150225.795446705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 9fd1fcbbf84986a7bcf601a2b90540899069d263 ]

A FileLinkInformation request can supply "/" as the new link name.
smb2_get_name() strips the trailing slash and passes an empty string to
ksmbd_vfs_kern_path_start_removing().

ksmbd_vfs_path_lookup() resolves an empty pathname as the configured share
path, without LOOKUP_BENEATH. With ReplaceIfExists set, smb2_create_link()
can therefore remove the share root from its parent before link creation
fails. An authenticated client with a writable share and DELETE access to
a file can trigger this if the share root is empty and the mapped user
has write and search permission on its parent directory.

Return -EINVAL for empty pathnames when for_remove is set, before
resolving the share path or acquiring removal resources. Ordinary lookups
continue to accept empty pathnames for opening the share root.

Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
Cc: stable@vger.kernel.org
Reported-by: Zachariah Mithani (AploSec) <zachariah@aplosai.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Moved the empty-name check from ksmbd_vfs_path_lookup() to smb2_create_link() because the lookup helper lacks for_remove. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ef70f17ac9303..6b24448a55e18 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5841,7 +5841,8 @@ static int smb2_create_link(struct ksmbd_work *work,
 	link_name = smb2_get_name(file_info->FileName,
 				  le32_to_cpu(file_info->FileNameLength),
 				  local_nls);
-	if (IS_ERR(link_name) || S_ISDIR(file_inode(filp)->i_mode)) {
+	if (IS_ERR(link_name) || link_name[0] == '\0' ||
+	    S_ISDIR(file_inode(filp)->i_mode)) {
 		rc = -EINVAL;
 		goto out;
 	}
-- 
2.53.0



