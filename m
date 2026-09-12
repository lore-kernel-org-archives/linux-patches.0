Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743345475F;
	Sat, 12 Sep 2026 15:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225395; cv=none; b=PQT3yfmYKWOcmFYtKxv+Jhqb0EXLs2uUCe71kDbf9IFc9+I0O7jQepNnnfbVS7EVHhTOAB02j/jzFQB2g4oUwpfQHRbn+3RSe08GjUJWLi9DyAqVCiovvSWIjQuAaFJ0puSDfQp/7iKVuf+Cb7mVeFrYK3Z8pcUPDOFCjYSr9tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225395; c=relaxed/simple;
	bh=9GnTF6BEzntkaqCCddh5r9IwkImYcSgnhVoDYS35ZGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJU1bhiJLd2m9pS5FU5tolDB69HUQh3oM8MpWAQBdAxILceu2DfzHryc5ai44E0UTEU2g9MtluLA9R8552nx+fYNj43aIU94TA9BM/oixfV2g3Zorocez74QUUrfrVn9bw5MJ7ksYkyY3YRpjhJT70M3Jxnhm8GV5LzJvjN76Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GseWm8bU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GseWm8bU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1339A1F000FF;
	Sat, 12 Sep 2026 15:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225394;
	bh=gpKYTcrGlne60u2Acwi/GJUcSVkve7Z52YZoCMLK4ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GseWm8bUgKn7fdW8+aqKlkefOiHK7IfSTgurNNak195MzB+tfSgnPRzFDblOKgu7l
	 NV9vOVbDlcw6DtuBe6XmQ4ylkMsWfySnPXn0Mito2ciTeptALC8isSoU5QZB1GANC5
	 iaoUANXhb6NardeH1TtdUitFYqf8Q+HL5ZdtviKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ran Hongyun <ranhongyun1@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1190/1424] UBI: fix two issues in the ubi.mtd MODULE_PARM_DESC
Date: Sat, 12 Sep 2026 09:00:22 +0200
Message-ID: <20260912065633.937234875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Ran Hongyun <ranhongyun1@huawei.com>

[ Upstream commit ff7937d14f5333ec7e6fb50d00a152d7974f4105 ]

Fix two issues introduced before:

 - The parameter format string was missing the enable_fm and
    need_resv_pool tokens introduced in an earlier commit.

 - The bad-block reservation note was misplaced after Example 5
    instead of after Example 3. It was misplaced due to an earlier patch.

Fixes: 83ff59a06663 ("UBI: support ubi_num on mtd.ubi command line")
Signed-off-by: Ran Hongyun <ranhongyun1@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/build.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 8c74020c8ce2a..bb25d50a2c7bd 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1505,7 +1505,7 @@ static int ubi_mtd_param_parse(const char *val, const struct kernel_param *kp)
 }
 
 module_param_call(mtd, ubi_mtd_param_parse, NULL, NULL, 0400);
-MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: mtd=<name|num|path>[,<vid_hdr_offs>[,max_beb_per1024[,ubi_num]]].\n"
+MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: mtd=<name|num|path>[,<vid_hdr_offs>[,max_beb_per1024[,ubi_num[,enable_fm[,need_resv_pool]]]]].\n"
 		      "Multiple \"mtd\" parameters may be specified.\n"
 		      "MTD devices may be specified by their number, name, or path to the MTD character device node.\n"
 		      "Optional \"vid_hdr_offs\" parameter specifies UBI VID header position to be used by UBI. (default value if 0)\n"
@@ -1518,9 +1518,9 @@ MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: mtd=<name|num|pa
 		      "Example 1: mtd=/dev/mtd0 - attach MTD device /dev/mtd0.\n"
 		      "Example 2: mtd=content,1984 mtd=4 - attach MTD device with name \"content\" using VID header offset 1984, and MTD device number 4 with default VID header offset.\n"
 		      "Example 3: mtd=/dev/mtd1,0,25 - attach MTD device /dev/mtd1 using default VID header offset and reserve 25*nand_size_in_blocks/1024 erase blocks for bad block handling.\n"
+		      "\t(e.g. if the NAND *chipset* has 4096 PEB, 100 will be reserved for this UBI device).\n"
 		      "Example 4: mtd=/dev/mtd1,0,0,5 - attach MTD device /dev/mtd1 to UBI 5 and using default values for the other fields.\n"
-		      "example 5: mtd=1,0,0,5 mtd=2,0,0,6,1 - attach MTD device /dev/mtd1 to UBI 5 and disable fastmap; attach MTD device /dev/mtd2 to UBI 6 and enable fastmap.(only works when fastmap is enabled and fm_autoconvert=Y).\n"
-		      "\t(e.g. if the NAND *chipset* has 4096 PEB, 100 will be reserved for this UBI device).");
+		      "example 5: mtd=1,0,0,5 mtd=2,0,0,6,1 - attach MTD device /dev/mtd1 to UBI 5 and disable fastmap; attach MTD device /dev/mtd2 to UBI 6 and enable fastmap.(only works when fastmap is enabled and fm_autoconvert=Y).\n");
 #ifdef CONFIG_MTD_UBI_FASTMAP
 module_param(fm_autoconvert, bool, 0644);
 MODULE_PARM_DESC(fm_autoconvert, "Set this parameter to enable fastmap automatically on images without a fastmap.");
-- 
2.53.0



