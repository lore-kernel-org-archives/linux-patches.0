Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFE6565112;
	Wed,  9 Sep 2026 14:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963610; cv=none; b=Xiqx5P8drkF7ucZL3chm0aIcfCvuJdGClrZMUj6gi0YuEFE6i5nyDaMrmzBnYSncbdl+d4nCxS+o+8j8bnGwR5+bKu3JN7cC0Uxa+7l8PDixrmJz4m3aZm8agVSMRRlUW2xeT+fNJldcAHNdNqc1+TW/kdsSG0ffSj82ium7KCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963610; c=relaxed/simple;
	bh=JFoCtDjodkqfnX2b2ubhSPnVX6ambHa8uvr7Grn9dq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjAuCQ54yLde56OgwqzQcWa1vhAaNcsYEqU57/5aBTq2gEdWaTCPKNEuvsZunzbMEFPQx8DMf0JAMAvpdcUVHCHQqpLzZb/tZ9qSNm95Z8e/FNb5nUhw4Wuv/sv+Yu+mLHBb1rzCjCINe6F0L8aZJ5s6B4pTsRmnvFuMPemRB98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nS0Okdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nS0Okdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108421F00A3E;
	Wed,  9 Sep 2026 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963609;
	bh=JX5egIxNspdNhOGTPR6SqfNaNT1j0sWlC7K3tib2HH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2nS0Okdwu8T1afUEV+pIFyuasJd142G8wKNJyfT9GbTF9yb8j8aIp9bKIZUF5E3Fc
	 2viL+g/wiGI5an9RC8tHLabx+WvmPmnorkoEBiWZ8qZW6ROW2goneF+xSJfbujH+OS
	 AFhurme0X4ZeZbA+kFTdw1PSfE7tOyWl14KZHHAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 138/583] mtd: nand: realtek-ecc: add missing MODULE_DEVICE_TABLE()
Date: Wed,  9 Sep 2026 15:37:03 +0200
Message-ID: <20260909134242.930158334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 5b2444b4d575d8117809c57801562ef37ca2d4af upstream.

The Realtek external ECC engine driver has an OF match table wired into
its platform driver, but the table is not exported with
MODULE_DEVICE_TABLE().

When the driver is built as a module, the missing OF module alias
prevents automatic module loading from the compatible string.

Add the missing MODULE_DEVICE_TABLE() entry.

Fixes: 3148d0e5b1c5 ("mtd: nand: realtek-ecc: Add Realtek external ECC engine support")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/ecc-realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/nand/ecc-realtek.c
+++ b/drivers/mtd/nand/ecc-realtek.c
@@ -448,6 +448,7 @@ static const struct of_device_id rtl_ecc
 	},
 	{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, rtl_ecc_of_ids);
 
 static struct platform_driver rtl_ecc_driver = {
 	.driver	= {


