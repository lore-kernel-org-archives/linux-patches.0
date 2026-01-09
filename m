Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52FA33032C;
	Fri,  9 Jan 2026 12:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960078; cv=none; b=kLxmBMoWnpbGEd/qGjshGFjyuWgdr4DuJqxDzQXRtGkEN5V0iXTZOszob0ENjvvuAFHHnMKItnQuaqrygF1ye1vf8Aed17ciplfrokB0gMca9GeUtFMWFS2LbyqMKLH4u43iDa1027fZFRVkZ8qlK3iwQkdczmmY5zanvNbGgcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960078; c=relaxed/simple;
	bh=kOfAXC/ScHT/Mg0nRkLSzVb+DMpJCOEkNet82ngGqXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qLFGhIscE1sCZtuiMyDGx0zhrYTRxgql+Z2DwSJSlhE1E5n3LxVIpkxkumlGuEMDu91PS3aIUMSnEJceuagQq148T3HqSH/xtYQDimGjQpPnFCXw4xYE8SWK/wPHkCCT20VH+3BW3x2Ker6lS662ZxrlOKY54sdbXq7q6ULvyzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziz9uBGe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziz9uBGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F991C4CEF1;
	Fri,  9 Jan 2026 12:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960078;
	bh=kOfAXC/ScHT/Mg0nRkLSzVb+DMpJCOEkNet82ngGqXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziz9uBGepVaEqpsg4jUdXYKfWhasDsAnzPW9dRJe7NCGIgCur0NRBBAxCdYoXrpqW
	 3JPLhwzzLSiUHJYDl6S/7/Vwohtsk9F27SEfJFtSJUayAPOkOv1zYWilUQOdYcenLv
	 yqOVb4MpFXEbtU/GQp5amWrAM8/laV/ZgSD0fdxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shechenglong <shechenglong@xfusion.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 276/737] block: fix comment for op_is_zone_mgmt() to include RESET_ALL
Date: Fri,  9 Jan 2026 12:36:55 +0100
Message-ID: <20260109112144.388778168@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d328b318e44b1..b8ef39ca3d74f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -508,10 +508,7 @@ static inline bool op_is_discard(blk_opf_t op)
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



