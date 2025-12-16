Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F0A221F0C;
	Tue, 16 Dec 2025 11:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884972; cv=none; b=oAnA7GbNIQ1orFFC204TABA8zlMn1DqzQXogONkC1LihqbQkGcmlI2UHglBIWymgkfbrmV04UkEzjw5H0wQ160+zuoPGDi05wK1v6W9Yx8BQEGUOlF0OZjJhwDwOAxknVwJ4VA9lDIL7z5hmnWzjfkymrsKj6+HQJ+jzsj/3UBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884972; c=relaxed/simple;
	bh=nh+cYVayt2gswzdmkjyGIqd0ksCANGhO/qDF8hrWdIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0viqvuqxgeKTewO+did6akFPWG6A/84ujOcROXMugcpWnw01JHdFuMOHdvePMjqQlf+P1+XE2C2Wvuv4vGMOObEGpYLrXK/N+SY9BTOzElTNtKU+naXQBVes3KrPZkfdezoiu6o1DZVaLLl3GfFBEWWTgcA+UDXTwG9fIR8XSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZHOuCe3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZHOuCe3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AC7C4CEF1;
	Tue, 16 Dec 2025 11:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884971;
	bh=nh+cYVayt2gswzdmkjyGIqd0ksCANGhO/qDF8hrWdIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZHOuCe38JBFaIn8i6PPuLr7Bb/UUzfkyWtkftuUaVgZPl5L9sVRLadMbAsY9FlWG
	 qjLYouOBz+9/v0qFE1AMoWAN3kwnYg7wgGYt+IK1Kk/MiACiU+Lro6piPIVBIPYEYb
	 7rEV4T+E+umGrpEGKdCKxwdHxObNxLpYQwacKJ4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shechenglong <shechenglong@xfusion.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 321/354] block: fix comment for op_is_zone_mgmt() to include RESET_ALL
Date: Tue, 16 Dec 2025 12:14:48 +0100
Message-ID: <20251216111332.540171678@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: shechenglong <shechenglong@xfusion.com>

[ Upstream commit 8a32282175c964eb15638e8dfe199fc13c060f67 ]

REQ_OP_ZONE_RESET_ALL is a zone management request, and op_is_zone_mgmt()
has returned true for it.

Update the comment to remove the misleading exception note so
the documentation matches the implementation.

Fixes: 12a1c9353c47 ("block: fix op_is_zone_mgmt() to handle REQ_OP_ZONE_RESET_ALL")
Signed-off-by: shechenglong <shechenglong@xfusion.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blk_types.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index ce395ea451a25..f535a86aafcd6 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -464,10 +464,7 @@ static inline bool op_is_discard(blk_opf_t op)
 }
 
 /*
- * Check if a bio or request operation is a zone management operation, with
- * the exception of REQ_OP_ZONE_RESET_ALL which is treated as a special case
- * due to its different handling in the block layer and device response in
- * case of command failure.
+ * Check if a bio or request operation is a zone management operation.
  */
 static inline bool op_is_zone_mgmt(enum req_op op)
 {
-- 
2.51.0



