Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7C07172F;
	Mon,  8 Apr 2024 13:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582165; cv=none; b=oGIQGEPsDFTZkKq3qPVDkwnOYzLUxnvoXWvGEBCCVY1uMhY4FC8gJlkMyE+hvDExBLkx2TM+n8IveDd4+5fYZJiS0SqrdO2bqkip0FtZfTtAHlKNQYKmDRY2NSJsyc9Z+A0E642iWG+JaDGa7ki+nop6t+Hht5nAjtJ5XOcHQjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582165; c=relaxed/simple;
	bh=Gvj5QVuqTtYzDab1K8J5jWyFdXSGcxUvYowTFHHQRcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fppb+Q4bh+2NXlnnRUZnmi5reQkd4y2KGIuiGVrnZNebtcxBu6Kl/9M28dRcMto5eMHDFPqkG24yGhR5tgX+KJhp5HW9bcguz+/jzWdXurrB8Q4ofnBhSW4//tJs4YtOw4TCpuiMRpV5XnClhqtpswDmKu3wKZb3G3oLrw7EFCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbWuOg2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbWuOg2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40E6C433F1;
	Mon,  8 Apr 2024 13:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582165;
	bh=Gvj5QVuqTtYzDab1K8J5jWyFdXSGcxUvYowTFHHQRcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbWuOg2xLv8XbRXIs+7ZYL2OWMiOICtV0GjWzl1Fmp0bUBWUZH0AhzU+JPNzXXu40
	 qXuV3LFvxL+XEVp+qbsVfkjtIE1QlSQEA6kCRAwCv3qySjl4jb8x0fCmQRMwx+vdwH
	 Xs5XjFzEh0FIxW9f3r2YmkduJGgcD0eLJtIV/P+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 116/690] net: ravb: Add R-Car Gen4 support
Date: Mon,  8 Apr 2024 14:49:42 +0200
Message-ID: <20240408125403.741318124@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 949f252a8594a860007e7035a0cb1c19a4e218b0 upstream.

Add support for the Renesas Ethernet AVB (EtherAVB-IF) blocks on R-Car
Gen4 SoCs (e.g. R-Car V4H) by matching on a family-specific compatible
value.

These are treated the same as EtherAVB on R-Car Gen3.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/2ee968890feba777e627d781128b074b2c43cddb.1662718171.git.geert+renesas@glider.be
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/renesas/ravb_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2067,6 +2067,7 @@ static const struct of_device_id ravb_ma
 	{ .compatible = "renesas,etheravb-rcar-gen2", .data = &ravb_gen2_hw_info },
 	{ .compatible = "renesas,etheravb-r8a7795", .data = &ravb_gen3_hw_info },
 	{ .compatible = "renesas,etheravb-rcar-gen3", .data = &ravb_gen3_hw_info },
+	{ .compatible = "renesas,etheravb-rcar-gen4", .data = &ravb_gen3_hw_info },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, ravb_match_table);


