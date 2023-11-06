Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58ADA20316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+ku9Nvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9645C433C7;
	Mon,  6 Nov 2023 13:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276438;
	bh=Xl8eRNXqdCHcrhAQ220ds7SkR4j/K1MqE55/hNFKWOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+ku9NvhioWZcHcyyRmNyJDPHaW8NFtRWmX2BJaqHiyaeC6FAIjRHtLcSGoTwAd8D
	 mDgV4VioKa5K2wBOGxYxYHjERy56C+13H9ndb4idG1VUnG5Nu3p2E3F9sL9M/ugzM8
	 g9oQ/bl2GdFRbH3/n6BXH9H2BpcwZ+czImHbRT/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 14/62] fs/ntfs3: Fix possible NULL-ptr-deref in ni_readpage_cmpr()
Date: Mon,  6 Nov 2023 14:03:20 +0100
Message-ID: <20231106130302.340821618@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 32e9212256b88f35466642f9c939bb40cfb2c2de ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 166c3c49530ec..bb7e33c240737 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2149,7 +2149,7 @@ int ni_readpage_cmpr(struct ntfs_inode *ni, struct page *page)
 
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
-		if (i == idx)
+		if (i == idx || !pg)
 			continue;
 		unlock_page(pg);
 		put_page(pg);
-- 
2.42.0



