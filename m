Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22763BF30A;
	Thu, 15 Jan 2026 17:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499183; cv=none; b=AWgurzD1G38iDxflvShE2GPB801cquz6JUW5F/cCyQf2DdIEpfh8kI/OUfvG2pojIAsq0o6hYQNVn1lNlOWJeXOdAcFoRg/AXCAtAJ5uxylRAwwLHIMEyTzZNjSzpUGPJgiJJQ25j00xRhDG2RP1lUN8E5L33FEGy1OoDTgCAN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499183; c=relaxed/simple;
	bh=ujs+g/royXtupfMHhdJ6ZKOHUuEeA/SUZ+4i3/kitHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUN1EkwA0Jo2VKlEsa6Y2H8LPfPjoEvS7ki0/Zy5Z7jx6cuB19svU4YR2k7xU08rOArHAdmiVQd7Oxl49GiHQ+eYXKZ1ATZ0+vmrzTordiyWQAxP26EQspwWWLOZ68enLOR5yjjOoVfbvupvd0USMbXJexaiTSgFVPYPYw3OuNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYLIn4LT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYLIn4LT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CC1C116D0;
	Thu, 15 Jan 2026 17:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499183;
	bh=ujs+g/royXtupfMHhdJ6ZKOHUuEeA/SUZ+4i3/kitHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYLIn4LTJIxRypxf36GhImVTd3DsIG4Rmf0PrUyHdO8GSFqj+dFrsXli0js+NVbIE
	 440fsYrsWkYO/FAN/sBcCCDftHMqx626QV+4Zgm7KObT1/JzQx6tEYWB1LUPF3/FQ/
	 /xKqocYM+duBH1guS3cyNlyA31HrPAaA7tfkZVG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shechenglong <shechenglong@xfusion.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/451] block: fix comment for op_is_zone_mgmt() to include RESET_ALL
Date: Thu, 15 Jan 2026 17:45:39 +0100
Message-ID: <20260115164235.910414091@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 40839ae52f61e..11c03df4709f4 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -487,10 +487,7 @@ static inline bool op_is_discard(unsigned int op)
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



