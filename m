Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DDC127E18;
	Wed,  5 Feb 2025 13:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763275; cv=none; b=fvgMUwGjWCuSyQnNMwEpA1PZBaICdNmrID5viLD2ILqMWufKzYSImZ3iJnCJvXpIqZ3McHsm8jxJ0hCySWGD2XLaKIcXptY9Fo1gB9s9r0zAO9fdIDESh6NmDqR9Upa3CC+rk7rrpBAziM40eQ8dOL977J8GUaHFE42XQf/1Y0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763275; c=relaxed/simple;
	bh=cxatB5jejVfqclSQ6c/MHcki0EPL0/p2GGc1Tch+8aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAKzoVboWyfCSv79uXFcRu/tnTBov/U1KzIPwtTyi6sfbdn8ZMFUOmETqZrqM6CJuRwP8YldQ/xE9RkfULYXKPOOimjZrrtYDghdSpbh8QzNb4gXqr6ZJWHq1sZTBW+PWU1CJqiMUvMBygCmzpkjwr499C/hGrxrk97g1lFrdNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EynJpdOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EynJpdOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F282C4CED1;
	Wed,  5 Feb 2025 13:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763274;
	bh=cxatB5jejVfqclSQ6c/MHcki0EPL0/p2GGc1Tch+8aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EynJpdOojLm6COyOLOn2HYjyK4Z7Qasrb8JIbd3LOOyvKPkUTqXZHJgwboUwriyB/
	 yqCONSZALf+hWMbA7api5Eu91Oy7FvdouLuHBygi/j/u0Kp90P9I1skAQq6kI8qdXz
	 KWJNAcyzC0XuPPZr1vRWvzRvvtDP4NeQnCpGvCbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@linaro.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/393] pstore/blk: trivial typo fixes
Date: Wed,  5 Feb 2025 14:38:48 +0100
Message-ID: <20250205134420.649144020@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index de8cf5d75f34d..85668cb31c3d2 100644
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



