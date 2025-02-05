Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AAF14A4E9;
	Wed,  5 Feb 2025 13:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763744; cv=none; b=OusRB5aFl+RBXIiP9hVLe6QXR1oA9SOHH3TvL9JBQ6/C1Eh9hOMz6TYW+kNW1EPT5+4BeCaUxAPJxOw/Moat/he1asn+cOeNNTpGYA1QXabkzMmCc13Ay+3Gq3fxVC/0dqI3ru172o+VgQfw0JOGtZiN5RESZIrwguwd32T9Rdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763744; c=relaxed/simple;
	bh=MKMB5Q7L14StdL2Bj9EO3r9CcVA3cczFQE48XvceKOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hV44WiOinWfRRiD8FnxoEXajciB223rWgnv/lqm6FFBhZrgi/EQQ2bxAVJunKirJUgSlBqdgJR3lCTWW+wBtPiHGMcB7GFY9nP2VHN+syPDBZmyMnbjND7XlCDjWV+pZY3Df8q9GgRWw1iK0nDVybJqIzkmsS2TRLurIFT6Gk1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Up5Yw41n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Up5Yw41n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD4AC4CED1;
	Wed,  5 Feb 2025 13:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763744;
	bh=MKMB5Q7L14StdL2Bj9EO3r9CcVA3cczFQE48XvceKOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Up5Yw41nsgX5hbqFVXlu+eTvcDoyvzAXjOQYi29R7/yVmRcQwUSvq7ovA6l5lb2gg
	 KOKL7Q9VemaB83zXwWgm5XY0c3kS/8iLQ0EIL6EHI0uVAGrLZldZX1xwfePl5d3YzM
	 LW2PB13zkuFBQ4K5IpgAawbfKR8q0VMKCzHWo4bA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@linaro.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 014/623] pstore/blk: trivial typo fixes
Date: Wed,  5 Feb 2025 14:35:56 +0100
Message-ID: <20250205134456.774987611@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



