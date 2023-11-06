Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4261C22EED
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smmOm+1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B090CC433C8;
	Mon,  6 Nov 2023 13:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277243;
	bh=BC6nPA9F28AufuW5YFLy6TAApNIl7mkh9vZkkO4efkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smmOm+1iJkOv/ub5t0XNdEc0Obp3/Iks4wSGfnb4lqX0jZTaayQ+te3M8LqFNJkR3
	 U5UwmRQiQ+IoAXXvfoqUtgy1h6P77WuHStsjwdT/ve+YTrnVhhQXrYiZyX+LOE//EN
	 Gicpy7UxDUyMdW0p9h6Jyce9N8NOHAZCAVQ9pwi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/128] fs/ntfs3: Fix possible NULL-ptr-deref in ni_readpage_cmpr()
Date: Mon,  6 Nov 2023 14:04:06 +0100
Message-ID: <20231106130313.048979602@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 32e9212256b88f35466642f9c939bb40cfb2c2de ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 73a56d7ac84b7..b02778cbb1d34 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2100,7 +2100,7 @@ int ni_readpage_cmpr(struct ntfs_inode *ni, struct page *page)
 
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
-		if (i == idx)
+		if (i == idx || !pg)
 			continue;
 		unlock_page(pg);
 		put_page(pg);
-- 
2.42.0



