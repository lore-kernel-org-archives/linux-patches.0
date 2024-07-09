Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94FD156F45;
	Tue,  9 Jul 2024 11:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523581; cv=none; b=AUD4u7aFzYdjWJ97TNQFTbxSGxZbk9MpjHPLCCNZFMBlqrzJkIQOnDOqhuWSnDi7rRXgzkW45xXu8mmzrVBJoIowvAvpIn153GskJRzeVMMAA1YLDc3yimAnZsYgBpGjNkr2+3b8S6VUCSvSQS4dTQqUU0RwS/VDWZV38Ma6moo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523581; c=relaxed/simple;
	bh=l5g4Q0nVkHLZ0VexsTFwoBMX2EbHbPrj7+et0GfKN8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZZZre6TBtwE3ej10rbezJ9c6+oz6CVfiWf9pTjlovyM6LjxEkC+QBUH3HwRHfS917aW5Ti5sfEKhBiHHFChBLeJinBlu4FlDifCqMVngUGuwWRqiL6OSZkw/bMF/7eJFw57oTr4OCOtkgauHxTv6KPSQH1O2kCFkhM7JxZnRQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhwFtTp1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhwFtTp1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4113AC3277B;
	Tue,  9 Jul 2024 11:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523581;
	bh=l5g4Q0nVkHLZ0VexsTFwoBMX2EbHbPrj7+et0GfKN8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhwFtTp1vkoXC6WjKTK0dsfidKIAmXBMamLk/XTWnEe5skFkeNE9WdWQfUmPcawED
	 bFpHQk6PiUeE0bhgV65B+MPifIRgsfGolMu1gxxa+j/jHmFlewELwFdnDIRwVPqTUR
	 z7Hr6iqBkfbPA95U4Uhu4ddM1jxN7tzlYy1AKjq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/139] i2c: i801: Annotate apanel_addr as __ro_after_init
Date: Tue,  9 Jul 2024 13:09:00 +0200
Message-ID: <20240709110659.714559001@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 355b1513b1e97b6cef84b786c6480325dfd3753d ]

Annotate this variable as __ro_after_init to protect it from being
overwritten later.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index f6bc37f5eb3a3..3410add34aad2 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1052,7 +1052,7 @@ static const struct pci_device_id i801_ids[] = {
 MODULE_DEVICE_TABLE(pci, i801_ids);
 
 #if defined CONFIG_X86 && defined CONFIG_DMI
-static unsigned char apanel_addr;
+static unsigned char apanel_addr __ro_after_init;
 
 /* Scan the system ROM for the signature "FJKEYINF" */
 static __init const void __iomem *bios_signature(const void __iomem *bios)
-- 
2.43.0



