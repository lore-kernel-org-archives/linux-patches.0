Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4F71EA65;
	Mon,  2 Jun 2025 14:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875098; cv=none; b=rLVLrZ/jtbWX5piVN5tK/0bOmQLs8eOVhLf4T8BBgX2xtavOuweLoPJbUpgEWxgoEEco55rUsRl28kNcsfgj2JluH2hAe+39HAOzrAojdyR2nVyoI+G+V7D3+Fj+mCnkrnwqYnBLRbTow+NJXtt9GyXQdA5YhFINue54O4obznE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875098; c=relaxed/simple;
	bh=YZ4Jl+lox84mMUhS3J8UvUyBsPTGoBx4iXToy3m3a/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAf3+h8msaMFUlnbdwvpB3IMpvZfdOM9+sNIKYuh8LlTiyZ4E9cBSaiDwFXPqQmqRO69Pnw5H6BO0de/61epXjLD0Z85sK9H9GQ6E3f0ZsWtoqidPFdtoOIRiWwmStyu+nv89hKRjbRFsP3RrwbCwsbCjc6dvZIrFdGQ3PKt3cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+5X4VpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+5X4VpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00D8C4CEEB;
	Mon,  2 Jun 2025 14:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875098;
	bh=YZ4Jl+lox84mMUhS3J8UvUyBsPTGoBx4iXToy3m3a/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+5X4VpLvtt9asCRcTmFhTkYEhelSz8gSolzYO+DRIEecVCLCM3y1OCmgXFP59a7a
	 ULNLtLnBGbf+KEn/irGkVaL+lVegXy2c0OeiRH0/p20dcPuiEEe+uM/QYltCv2OsTP
	 Tr1BaCJ6R6opgLIvhD0qJMTknB+3MVtbIygwX+h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@altera.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.10 003/270] EDAC/altera: Test the correct error reg offset
Date: Mon,  2 Jun 2025 15:44:48 +0200
Message-ID: <20250602134307.338431528@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Niravkumar L Rabara <niravkumar.l.rabara@altera.com>

commit 4fb7b8fceb0beebbe00712c3daf49ade0386076a upstream.

Test correct structure member, ecc_cecnt_offset, before using it.

  [ bp: Massage commit message. ]

Fixes: 73bcc942f427 ("EDAC, altera: Add Arria10 EDAC support")
Signed-off-by: Niravkumar L Rabara <niravkumar.l.rabara@altera.com>
Signed-off-by: Matthew Gerlach <matthew.gerlach@altera.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Cc: stable@kernel.org
Link: https://lore.kernel.org/20250425142640.33125-2-matthew.gerlach@altera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -97,7 +97,7 @@ static irqreturn_t altr_sdram_mc_err_han
 	if (status & priv->ecc_stat_ce_mask) {
 		regmap_read(drvdata->mc_vbase, priv->ecc_saddr_offset,
 			    &err_addr);
-		if (priv->ecc_uecnt_offset)
+		if (priv->ecc_cecnt_offset)
 			regmap_read(drvdata->mc_vbase,  priv->ecc_cecnt_offset,
 				    &err_count);
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, err_count,


