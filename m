Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF03BFC0B;
	Wed,  5 Feb 2025 13:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763608; cv=none; b=ZGaHIKdWKNu4vYeoiLbEFGHqr70GIMovjBePVPHwW7F7/eFjlNVkSsU/umObrXXQNHi1ZN8ddK9ZvDpIlGNHWCWQABVJEoThEP5dzcmiXyFZLJnS0T4hlWrB65brPvEAGtfYhLhVs2eFb+5KyHB+mE6HHsBRlUINMkPAjm3swDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763608; c=relaxed/simple;
	bh=i80OQGG5ojTejDH1eTVBUgHgwsW91yLOPQuGfVaO2d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8CB4nIzoUE3FeZkHDe83dPPFJ2DyM4P/pGYXS1sefy6ZmKoZb9qltbxMKDB8FNpMgmk46F9PTFb4pOQUkIGYFIqZfDCWM+qePRIf81/1LWXjJ0BeddINuEntnq0AL9qcLmGDG/CpJqIZHOsD6iIC/KMVlnY/Gco9CEBsoBx9SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bqm0VnRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bqm0VnRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23806C4CEE2;
	Wed,  5 Feb 2025 13:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763608;
	bh=i80OQGG5ojTejDH1eTVBUgHgwsW91yLOPQuGfVaO2d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bqm0VnRHgyDTTc1xLqgNyJo+fpkl+f4AUyAsw6sPOtyReD9LK3+sL1oitjiCAGvju
	 v/9J8NVu5jpVP2Y1oYhUmfZv/0bda3EnEWfZd3UPLTyb9QagmFlY0CqTJ0PeowxXCF
	 p7/CcadPXQ0D9vbRnqUFxWrg/CPnmysF/YNPFiSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@linaro.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/590] pstore/blk: trivial typo fixes
Date: Wed,  5 Feb 2025 14:36:08 +0100
Message-ID: <20250205134455.745744019@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 65b2473e22ff9..fa6b8cb788a1f 100644
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



