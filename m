Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F062D21CC5A;
	Thu, 15 Jan 2026 17:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497745; cv=none; b=C0IJo6T/JukloJx/ROLW4dqc1tIj2derkI/7gdVemUJSU2jLLxhX1cJFoMXOfxbmA3Ttq98bLEBa+Cg/7hf2opfZ2M7RYtG69z7XsCgES6J2USaIn0bcQUCWEWJ4myLWcsuBCMsu7hkjUo0EZtjVphc77TFdQ4vapY4qP6rOVv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497745; c=relaxed/simple;
	bh=mag79QyMBlcp/Nbm0snQvDBjHnusVAV/+4grBQ3Ni3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RROBzHb9yPScK6oS+SObMFJLx1LYLH8ZhnFKIXUlikGRSRMuKJb/4ZVSmVuPAaGlHT8//hHsd1QilQ80pRhvjL6XjniDkww+ju7cEfarAh6sbUUiTBW5TmYg9B56NZ59Pib0CpCwtxlR0ARomiS7CPp2tMOL30kZz0HoNqQNEwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pW7690jA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pW7690jA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE2AC116D0;
	Thu, 15 Jan 2026 17:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497744;
	bh=mag79QyMBlcp/Nbm0snQvDBjHnusVAV/+4grBQ3Ni3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pW7690jA2AHuLs9N0YJ5xtTqpV2UqWpQMJ9sp9dIW2/CeqtgHN7WRyiVaG9uRn+Jj
	 DSEMUoI6Jf3yy3KEom2lMwHsdk6uEHiMMvILV9E3/dxOCiwnRHfkizRidcO1jGVDCj
	 gaM5zQe1Tw04ECfdyHgQ61n0+Efn8FNEFO2BzCwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shechenglong <shechenglong@xfusion.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 188/554] block: fix comment for op_is_zone_mgmt() to include RESET_ALL
Date: Thu, 15 Jan 2026 17:44:14 +0100
Message-ID: <20260115164253.065915451@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2d21af10a9df9..a9e554ef3c4a8 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -472,10 +472,7 @@ static inline bool op_is_discard(unsigned int op)
 }
 
 /*
- * Check if a bio or request operation is a zone management operation, with
- * the exception of REQ_OP_ZONE_RESET_ALL which is treated as a special case
- * due to its different handling in the block layer and device response in
- * case of command failure.
+ * Check if a bio or request operation is a zone management operation.
  */
 static inline bool op_is_zone_mgmt(enum req_opf op)
 {
-- 
2.51.0



