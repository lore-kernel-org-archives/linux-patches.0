Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258B21C57B1;
	Tue, 15 Oct 2024 12:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993654; cv=none; b=AYOaAFzDq8rlf08UbSl1dbZhSlnyxlrHG4S/hPrA4Sxv+qylObeRT3mrSgAFXXqGQrHb+lFcos2TCS0stuoCHg78RNUWNJ4mEwWdOevCIN6b1lG8+g9IbARzyMH9S1W1gGGcFEtW+nnGW3m3ucj39VOFs2xgNtG/4rnLY1kImXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993654; c=relaxed/simple;
	bh=x5Ga3ddhibrCdCIUFUm6N33acZ3UZZfFwQnMbHdrCFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iW5XHCUUAhctWqGYkwWfXmT9BwDGCAJyQ+tiAbX78yBlW18bbJm/drVoAzFHfAyt15Tm2b5sd89tnfh90LcbakIUKfkixpMqNfyEQYmiRxje/ok0LLWyyVB2ZamSKcXgh95ufDI9Tuc1bM7Au4Hvg3nMrPTJVdxPIdU5xIiJis4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOJrGGfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOJrGGfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359D7C4CEC6;
	Tue, 15 Oct 2024 12:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993653;
	bh=x5Ga3ddhibrCdCIUFUm6N33acZ3UZZfFwQnMbHdrCFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOJrGGfgPbxLHd2lWm3jOEwRp3FRc9iMOkwRr6v5FzeReitkZHmx1PMjfD0GpIHll
	 yAqohzNFhtMyJ6aE6gcnuKe/qkqNvLXMy+0j3HbOyHoGBmxH+Ab2xrJnficxYhj8Rn
	 A+XQ3IhupUSAPTXhBBhSMygws0QZPZ6eREwjI8k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 475/691] blk-integrity: use sysfs_emit
Date: Tue, 15 Oct 2024 13:27:03 +0200
Message-ID: <20241015112459.194701748@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

Upstream commit 3315e169b446249c1b61ff988d157238f4b2c5a0.

The correct way to emit data into sysfs is via sysfs_emit(), use it.

Also perform some trivial syntactic cleanups.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20230309-kobj_release-gendisk_integrity-v3-1-ceccb4493c46@weissschuh.net
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-integrity.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 85edf6614b977..cbc77a2de0376 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -248,20 +248,19 @@ static ssize_t integrity_attr_store(struct kobject *kobj,
 static ssize_t integrity_format_show(struct blk_integrity *bi, char *page)
 {
 	if (bi->profile && bi->profile->name)
-		return sprintf(page, "%s\n", bi->profile->name);
-	else
-		return sprintf(page, "none\n");
+		return sysfs_emit(page, "%s\n", bi->profile->name);
+	return sysfs_emit(page, "none\n");
 }
 
 static ssize_t integrity_tag_size_show(struct blk_integrity *bi, char *page)
 {
-	return sprintf(page, "%u\n", bi->tag_size);
+	return sysfs_emit(page, "%u\n", bi->tag_size);
 }
 
 static ssize_t integrity_interval_show(struct blk_integrity *bi, char *page)
 {
-	return sprintf(page, "%u\n",
-		       bi->interval_exp ? 1 << bi->interval_exp : 0);
+	return sysfs_emit(page, "%u\n",
+			  bi->interval_exp ? 1 << bi->interval_exp : 0);
 }
 
 static ssize_t integrity_verify_store(struct blk_integrity *bi,
@@ -280,7 +279,7 @@ static ssize_t integrity_verify_store(struct blk_integrity *bi,
 
 static ssize_t integrity_verify_show(struct blk_integrity *bi, char *page)
 {
-	return sprintf(page, "%d\n", (bi->flags & BLK_INTEGRITY_VERIFY) != 0);
+	return sysfs_emit(page, "%d\n", !!(bi->flags & BLK_INTEGRITY_VERIFY));
 }
 
 static ssize_t integrity_generate_store(struct blk_integrity *bi,
@@ -299,13 +298,13 @@ static ssize_t integrity_generate_store(struct blk_integrity *bi,
 
 static ssize_t integrity_generate_show(struct blk_integrity *bi, char *page)
 {
-	return sprintf(page, "%d\n", (bi->flags & BLK_INTEGRITY_GENERATE) != 0);
+	return sysfs_emit(page, "%d\n", !!(bi->flags & BLK_INTEGRITY_GENERATE));
 }
 
 static ssize_t integrity_device_show(struct blk_integrity *bi, char *page)
 {
-	return sprintf(page, "%u\n",
-		       (bi->flags & BLK_INTEGRITY_DEVICE_CAPABLE) != 0);
+	return sysfs_emit(page, "%u\n",
+			  !!(bi->flags & BLK_INTEGRITY_DEVICE_CAPABLE));
 }
 
 static struct integrity_sysfs_entry integrity_format_entry = {
-- 
2.43.0



