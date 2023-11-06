Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B24522EED
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jd4YIl+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B55AC433C8;
	Mon,  6 Nov 2023 13:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277246;
	bh=sc16UnH8BIGF1yXOHMevOr3/9bp4vkYpVwOjxo5jSlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jd4YIl+j5XgecSlcYvBqDIro2ktKe9xyG86QtbS390lkwhRcnv6xF6eumUulmsqF0
	 y100iLXVfwTX795QlWKKUY6gpCTkhg1t72Iv/Ru1Q/fK1cVXWkGQUtA7xgY7VWbCIc
	 2mZRF20O4KzbEG/zqgBMVyGOTogPL9dkaQh94FWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/128] fs/ntfs3: Fix NULL pointer dereference on error in attr_allocate_frame()
Date: Mon,  6 Nov 2023 14:04:07 +0100
Message-ID: <20231106130313.097303901@linuxfoundation.org>
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

[ Upstream commit 9c689c8dc86f8ca99bf91c05f24c8bab38fe7d5f ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 321d55b3ca17d..1d5ac2164d94f 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1583,10 +1583,8 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
 			le_b = NULL;
 			attr_b = ni_find_attr(ni, NULL, &le_b, ATTR_DATA, NULL,
 					      0, NULL, &mi_b);
-			if (!attr_b) {
-				err = -ENOENT;
-				goto out;
-			}
+			if (!attr_b)
+				return -ENOENT;
 
 			attr = attr_b;
 			le = le_b;
-- 
2.42.0



