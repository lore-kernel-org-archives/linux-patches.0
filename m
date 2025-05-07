Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561FC1E1DF6;
	Wed,  7 May 2025 19:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644880; cv=none; b=ECLRB0wTGApy70k2k1BL6ChLbawlUOwpd10D0dcrFnPs45qvYQsU+gBD08z3158M1wSptoaPkykTH5mjBJQGFsS7FEzECvw6z386pJIkYGEdFssKeMiDpp2F7Z/bDoa/gB9rueQ5QalhQJY1pfoKltl/plFAOfgrTKgPHPrOzFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644880; c=relaxed/simple;
	bh=EFUYb/vqpucnDdykkTUonNrQIRyxQmzVo9JcBcLFbTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fb0mYD4si12bwpGG4lXmsuxPObd6S1QJgYXB18rUOjC1kJuXZyw2Ex0mFGK0A6VKnMbwPpz9BbTWMlx2ikcGoeFyDnP7T+8CVaZXhtGCbnkEidw8Rwd7dvxwBx5RDxYcCg92dioOa7k1MeJNRrVBr1R/KkbL7fSshSG+EsEUSbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSKaM3oq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSKaM3oq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AECC4CEE2;
	Wed,  7 May 2025 19:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644880;
	bh=EFUYb/vqpucnDdykkTUonNrQIRyxQmzVo9JcBcLFbTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSKaM3oqHnTCAylH8AnYZvLEpS/acLwnTlB8o8GZckm6zTFg6iL8KNttdu3zgRjId
	 I5ORgiKcLvcbLfOEnmfLvPsl5POyC9hs9sl9B/taAFst6Mmi+iTBSyU4e5X1FqaDe/
	 Vb9MeIVWaEJM6kjzoMICg4Cy83+8SL4ogxxiR7Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumar.l.rabara@altera.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.6 007/129] EDAC/altera: Test the correct error reg offset
Date: Wed,  7 May 2025 20:39:03 +0200
Message-ID: <20250507183813.829776719@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


