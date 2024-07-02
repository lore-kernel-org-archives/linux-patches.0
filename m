Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E041BE249;
	Tue,  2 Jul 2024 17:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940557; cv=none; b=BQ9ZgQ0yGkHAbP0y/unXFoXWAUyVcOOyZHRYgITJG90CSbAIGy6MwgYdRAgGuELNjvJZjU6DrkTHnu+m9iMopWX8ybAxewsjfw8wZBcrJdQEOuyq+21AqGHzcFZU3FLfc8NqCNFTjNxUieHHLQzj4ESksFQeqKb2JlUy9HdW4n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940557; c=relaxed/simple;
	bh=9wlabYvIucez4QbkhCREE+h1musnbdtCCINC04o3wl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GlAcWhRpgQeeiBM9521gAkgzYpEPrqvSCTFbv1Rwx4jxkQIA3DGtdzVxgHgHM9rC0ghqrr6NCrWEuAsjgERUSyAgC9ec15QtLsctbW0rtj8pnDojy/Yn+Ms5tuiX+yLjGRXfFmShQOqp5oUyP0uHDFxkA8UmWU6ipprlaNV3blE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CyrWkRue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CyrWkRue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F276AC116B1;
	Tue,  2 Jul 2024 17:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940557;
	bh=9wlabYvIucez4QbkhCREE+h1musnbdtCCINC04o3wl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyrWkRueMiJxSPPLWgkq5SHwG1LY45Gw3FztubDqpYOf8AUfKtx6CsLMHWn5zjevL
	 BkVzx5guaklHZiFruCBj1DjHA60bHAmPOcJ1b7PPWWvrClDfpM9VMh4HV6oUcAPR8s
	 UKhcDM0aY4hKRCNK6/3awnt0d+4/8WElTfpWdDzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Maggio <alex.tkd.alex@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.9 191/222] ata: libata-core: Add ATA_HORKAGE_NOLPM for all Crucial BX SSD1 models
Date: Tue,  2 Jul 2024 19:03:49 +0200
Message-ID: <20240702170251.285804789@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit 1066fe825987da007669d7c25306b4dbb50bd7dd upstream.

We got another report that CT1000BX500SSD1 does not work with LPM.

If you look in libata-core.c, we have six different Crucial devices that
are marked with ATA_HORKAGE_NOLPM. This model would have been the seventh.
(This quirk is used on Crucial models starting with both CT* and
Crucial_CT*)

It is obvious that this vendor does not have a great history of supporting
LPM properly, therefore, add the ATA_HORKAGE_NOLPM quirk for all Crucial
BX SSD1 models.

Fixes: 7627a0edef54 ("ata: ahci: Drop low power policy board type")
Cc: stable@vger.kernel.org
Reported-by: Alessandro Maggio <alex.tkd.alex@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218832
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20240627105551.4159447-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4181,8 +4181,7 @@ static const struct ata_blacklist_entry
 	{ "PIONEER BD-RW   BDR-205",	NULL,	ATA_HORKAGE_NOLPM },
 
 	/* Crucial devices with broken LPM support */
-	{ "CT500BX100SSD1",		NULL,	ATA_HORKAGE_NOLPM },
-	{ "CT240BX500SSD1",		NULL,	ATA_HORKAGE_NOLPM },
+	{ "CT*0BX*00SSD1",		NULL,	ATA_HORKAGE_NOLPM },
 
 	/* 512GB MX100 with MU01 firmware has both queued TRIM and LPM issues */
 	{ "Crucial_CT512MX100*",	"MU01",	ATA_HORKAGE_NO_NCQ_TRIM |


