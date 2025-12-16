Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1C43587B1;
	Tue, 16 Dec 2025 12:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886633; cv=none; b=vBQz5ecUICs1UTDUdSMPu9pbe83L/D/RgxPdpHUaRuYi5crrjp/GDRe7L7L95DBLEDu0pwkpUbt9GgKE/8qmZq9a7xlqwm0Te58ip5CBmCknZCcZWU0s6+Fw3dtju1KSXNdlxh9PRpzZ+D3uy5t0V6GUQFwmiNRbTIqNapD8pV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886633; c=relaxed/simple;
	bh=9hXnDeE9npJfX6/ezxP4fWFO2+51RN1T120kuQlbazI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buD98HtviKZLuK+vbw8kDP3PNU++2yCKLAQg1kMYP9LJQ20UmcWVykVPztRoZmg9UbwH54geXRMEUOApuIfRyrYRK4wC9S7N5e41fzhcXyWBfTk+A7Fb6ewCAn7Y6zsowa0KZgcaegXDXl5B6D4wT4qV2oTsV3aZFRAAPwH5rk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXWZE/4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXWZE/4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA57C4CEF1;
	Tue, 16 Dec 2025 12:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886633;
	bh=9hXnDeE9npJfX6/ezxP4fWFO2+51RN1T120kuQlbazI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXWZE/4BdwsRPxXPGtObdNtCrZbOrqisx+bSRat4ZvAJIMTAw3aw8peI+2ykOrb05
	 mISjzduamBCXWH62lPXZ62nb1b3EhOXuhiiAIGR2kLfByUfhgwEitBgNxezr7whlf0
	 fIUfJOZDEvBQJkuQUyc6eSIR5MZO6gUMPqc5uEHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shechenglong <shechenglong@xfusion.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 461/507] block: fix comment for op_is_zone_mgmt() to include RESET_ALL
Date: Tue, 16 Dec 2025 12:15:02 +0100
Message-ID: <20251216111402.148402640@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 1d6e2df0fdd31..93d83aba236bf 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -471,10 +471,7 @@ static inline bool op_is_discard(blk_opf_t op)
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



