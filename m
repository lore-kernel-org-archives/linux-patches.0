Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24E71C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57073C433C1;
	Wed, 23 Nov 2022 09:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195406;
	bh=lVxztbdhR8r9C+L6fx7lC9VlKZ6hqZuFCXdNheytFPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOuyMASC8dqhjbCibirwy07M+IKqTHDY3iAlf0cs8eUGZj00dYl0kTAeeVCi/vjMJ
	 nK8J4nnxE219DmUkzABKvSHqDByJsfBqWeJdaB0SVckpUHmG+ASeHX+KgCfwNE8/di
	 M083MUYVBxHO8sqdnevlL/mXoD0a4Hh+8Oi0rPs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Belova <abelova@astralinux.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/149] cifs: add check for returning value of SMB2_close_init
Date: Wed, 23 Nov 2022 09:50:59 +0100
Message-Id: <20221123084600.687164709@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anastasia Belova <abelova@astralinux.ru>

[ Upstream commit d520de6cb42e88a1d008b54f935caf9fc05951da ]

If the returning value of SMB2_close_init is an error-value,
exit the function.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 352d96f3acc6 ("cifs: multichannel: move channel selection above transport layer")

Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 11efd5289ec4..1cc823e96065 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1266,6 +1266,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst[2].rq_nvec = 1;
 	rc = SMB2_close_init(tcon, server,
 			     &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
+	if (rc)
+		goto sea_exit;
 	smb2_set_related(&rqst[2]);
 
 	rc = compound_send_recv(xid, ses, server,
-- 
2.35.1



