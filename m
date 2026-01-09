Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ED635A95B;
	Fri,  9 Jan 2026 12:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962104; cv=none; b=siXlDtZu3SuHu22STGsFIy+A4TRtiP1l8es2yQbZDc8HKw0hMyhrX7f4qH6DLIv+qv8gkYcdyScj6lhByOtrcdmzC1yK3PKPRng5l7gfTNQe7jqQz1VDaHBtUFAujCJnDp6KI/axdMlMHn+5HmfuzQnk1U5nkxNKlgox89GTtQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962104; c=relaxed/simple;
	bh=a6UpgP+VOgxYYSb9qcfp+s6su7rxjIk15ov2jE48pZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3xEj64NRQRkiFDKi8EERJBM61P8fsnubtv6pVt+rez8LrGk+Ul5coLlRaCYEakoObZsWcRGAMPGdOF2ebkajcQ3MM36mqs2ACRPOcl3NHteadXeTAtYz2VoWOH+PqYg86bsUt9ikV+ZOo3rZJrRs9ycvNZMxD5VJuWG0JKg27o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnrf9t8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnrf9t8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD1FC4CEF1;
	Fri,  9 Jan 2026 12:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962103;
	bh=a6UpgP+VOgxYYSb9qcfp+s6su7rxjIk15ov2jE48pZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lnrf9t8ePLossyNfJIoUq/B33rIpKwEAZpP8gDOEAXajh6XnryDlfDMScnaTPsZfz
	 bsQ3Ajoulp7zzMkgq7/BkLKn2dOE0khHWs6EtSPtjTEYm07tBZ9TMby2zpqskh3VHM
	 BK0xaA31OpKNqgK1jkymyPS7U6yUtUpTepYa/TMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shechenglong <shechenglong@xfusion.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/634] block: fix comment for op_is_zone_mgmt() to include RESET_ALL
Date: Fri,  9 Jan 2026 12:38:03 +0100
Message-ID: <20260109112125.153348117@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 83ede90bb106f..335bd6d0f6a5e 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -510,10 +510,7 @@ static inline bool op_is_discard(blk_opf_t op)
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



