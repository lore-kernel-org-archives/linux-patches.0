Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B99314A4C7;
	Wed,  7 May 2025 18:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643333; cv=none; b=m3hoeL1FABq/iUFBr+B7FW9+lB3Tc0orgbR/0QquNXwRKwwd+tiTf2LsZuyIU2VbiVthOxcAMuqZJ5uf98xL+F8dDDTOpjMLSobCKaBfcuqyyEi4zxmsYLoP4KGHxc6trzQRQn8vQzJCZi31zmaL4LGHxeNsgk6oxzg04HUDj8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643333; c=relaxed/simple;
	bh=zRMbQVAlc/LmM08T2h4P0JkV9haAKnjaqBwhDrnwjas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPRdEGvFP7VUrdmvURHgM35Z504j3kPLfSBud55RBw9qLSqUZAnullIvfI0nL1AKIYP8wTVfQvQsjRJUKeTQ2cpBQtxwvr3UrURYydKWhm6YlSJnaMmknsZIKCkOiYZuAVbDEAHY5zIHl5jMglTLVCldNz5mt7wkKa99buD8yDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAsSmO8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAsSmO8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45272C4CEE2;
	Wed,  7 May 2025 18:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643332;
	bh=zRMbQVAlc/LmM08T2h4P0JkV9haAKnjaqBwhDrnwjas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAsSmO8m2mmtjXW2/pAhlKDQlHLIfIHR6QS+cUku9gwoszeMZ5VZ1XUyQi3yzl1XW
	 xt7DtD965a8pnohAKODHaEfVqlYSTcpTyRvl6gjkwwzrsuvSH4dpSE0AKZuEVg3JSb
	 vkEI8MT6Ou1mq4ty6kYVpOvxMfpFHJv1UP6VuMgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@altera.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.15 03/55] EDAC/altera: Test the correct error reg offset
Date: Wed,  7 May 2025 20:39:04 +0200
Message-ID: <20250507183759.192695994@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -98,7 +98,7 @@ static irqreturn_t altr_sdram_mc_err_han
 	if (status & priv->ecc_stat_ce_mask) {
 		regmap_read(drvdata->mc_vbase, priv->ecc_saddr_offset,
 			    &err_addr);
-		if (priv->ecc_uecnt_offset)
+		if (priv->ecc_cecnt_offset)
 			regmap_read(drvdata->mc_vbase,  priv->ecc_cecnt_offset,
 				    &err_count);
 		edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci, err_count,


