Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9132E7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6AEC433CB;
	Sun, 17 Sep 2023 20:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981216;
	bh=Sc4bmG5Pg/2Ra4H2zYlKoJaIBWIAkpr1S/+ZbTawGds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1FnBNHYecvFnstF5LNU9oIQvSuh8AJiaveyM7Zugyr/eaB2aDajes+l/jOmfRkIO
	 hg4k60N/DxduTo1gafV3tA3d5Sltw94PktqVD9LOIAofQiw7isB+zImvFlsJx3oJwL
	 dpdjPIuFvowGx/lu0NlHR0B54bbJZAA+6Uq9u95A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Katya Orlova <e.orlova@ispras.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/219] smb: propagate error code of extract_sharename()
Date: Sun, 17 Sep 2023 21:13:33 +0200
Message-ID: <20230917191044.086196591@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Katya Orlova <e.orlova@ispras.ru>

[ Upstream commit efc0b0bcffcba60d9c6301063d25a22a4744b499 ]

In addition to the EINVAL, there may be an ENOMEM.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 70431bfd825d ("cifs: Support fscache indexing rewrite")
Signed-off-by: Katya Orlova <e.orlova@ispras.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fscache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/fscache.c b/fs/smb/client/fscache.c
index f6f3a6b75601b..e73625b5d0cc6 100644
--- a/fs/smb/client/fscache.c
+++ b/fs/smb/client/fscache.c
@@ -48,7 +48,7 @@ int cifs_fscache_get_super_cookie(struct cifs_tcon *tcon)
 	sharename = extract_sharename(tcon->tree_name);
 	if (IS_ERR(sharename)) {
 		cifs_dbg(FYI, "%s: couldn't extract sharename\n", __func__);
-		return -EINVAL;
+		return PTR_ERR(sharename);
 	}
 
 	slen = strlen(sharename);
-- 
2.40.1



