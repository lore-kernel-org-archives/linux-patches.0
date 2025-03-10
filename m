Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27072356C3;
	Mon, 10 Mar 2025 17:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628714; cv=none; b=bRyXUzxogeJw8j239lJQOOHa16eX2jFS9laLXbswPBidsd8Wy2ws0tRXqj2dGu7hwM79tM3Yxb3Lyisd+uARDnrwaxZIDUSvtAoRT5jWfwG50/qlL1sBVu9efvKucH6/AufwoTxxH0TlPENNgXFstM4Fxh7PeDSJlg4FglYC9nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628714; c=relaxed/simple;
	bh=BS34qGHapdKo2x9ubnDWtHbDqbuvLCeaaJSvFC4UDQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lc6vnjaezAKC2QDF6V7A8MWbBb6GfmCcUp2OjxAEfMeIKBBrfihW2GFlo8bEAkCusXi20pYsVFCWsc+eJruYCopdk4mf7TNGhjjbIPV7VPnRbGmoz1KwKrydsdfP9EC+v6XGzTbiFtepGFWDgwPB723Klo5ru4V5zCzZWYXiV+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJ0xyq09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJ0xyq09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D992C4CEE5;
	Mon, 10 Mar 2025 17:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628714;
	bh=BS34qGHapdKo2x9ubnDWtHbDqbuvLCeaaJSvFC4UDQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJ0xyq09lLIu+Rih1NRs0qz+z/IJe2QHJ/mL6OJ86ThT+6pi0wPp5pec3NUJ60Wp2
	 Tocw9qTe9E98QWt6cyy5lvopk1DA9nE/z1CSc3qmT2Tf8Qz3dEMNzNADd67YWC1MtT
	 MUPnGgJ3elG8tR35vJFhDkoZS/OOJ/0SfzNXr8Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@linaro.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/620] pstore/blk: trivial typo fixes
Date: Mon, 10 Mar 2025 17:57:38 +0100
Message-ID: <20250310170546.062161202@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eugen Hristev <eugen.hristev@linaro.org>

[ Upstream commit 542243af7182efaeaf6d0f4643f7de437541a9af ]

Fix trivial typos in comments.

Fixes: 2a03ddbde1e1 ("pstore/blk: Move verify_size() macro out of function")
Fixes: 17639f67c1d6 ("pstore/blk: Introduce backend for block devices")
Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Link: https://lore.kernel.org/r/20250101111921.850406-1-eugen.hristev@linaro.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/blk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/blk.c b/fs/pstore/blk.c
index 6093088de49fd..cb5fe2f28c708 100644
--- a/fs/pstore/blk.c
+++ b/fs/pstore/blk.c
@@ -89,7 +89,7 @@ static struct pstore_device_info *pstore_device_info;
 		_##name_ = check_size(name, alignsize);		\
 	else							\
 		_##name_ = 0;					\
-	/* Synchronize module parameters with resuls. */	\
+	/* Synchronize module parameters with results. */	\
 	name = _##name_ / 1024;					\
 	dev->zone.name = _##name_;				\
 }
@@ -121,7 +121,7 @@ static int __register_pstore_device(struct pstore_device_info *dev)
 	if (pstore_device_info)
 		return -EBUSY;
 
-	/* zero means not limit on which backends to attempt to store. */
+	/* zero means no limit on which backends attempt to store. */
 	if (!dev->flags)
 		dev->flags = UINT_MAX;
 
-- 
2.39.5



