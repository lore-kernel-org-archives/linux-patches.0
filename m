Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F1926B089;
	Thu, 13 Feb 2025 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458406; cv=none; b=fpAOxZYomBtiE3O+C3n2JHEMkx1s3tmhAt121qUaibFR6XuWI0ki14J4uhIyDyHmWQm2zKguyWgLgreaq7hSiZfwA9SBHz9BHM/88j0SlxSFUfI+/xrS7NH+F32GjHgvBjjsgEHXtgu+qFMzSX0svtna+vJWlFwIfDQyreAWA4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458406; c=relaxed/simple;
	bh=VMmB4nEuJCWKLnrikrozvy3YuQAaLFC4WVnz5XLQl8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoFK3EYHGa99gDZNaFhFbLAVBjzZ3IbSGkwqPv3sHcGSRjnvhb7gcQ6mpNbhxoGQG/AFu7XLBXrUtHUAWnbezz6PgTdTsf4lYrX3nai84Ode9l4TYCGqF1DoxVOAvuiHgMLBIc1PG/8Vm4BjsG0X2M0O3GZcHMpbhcfgyHpEFoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHE1LK5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHE1LK5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C868AC4CEE5;
	Thu, 13 Feb 2025 14:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458406;
	bh=VMmB4nEuJCWKLnrikrozvy3YuQAaLFC4WVnz5XLQl8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rHE1LK5+SjSk0ObIYoHZVGsHAH7TAfWRL61KEiWXzIODU+kLSftagqeGKqdvs3DcB
	 RXVcBMsdFKwNO6IfKzZ19rNPlkne8+Lm6sDvahYES6uxbBBR54mIUMysQi4se5vM5L
	 15imYi9iqKAZJvoA6QUNNMiVCkCyC5MBYu2YT4PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hien Huynh <hien.huynh.px@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6.12 390/422] pinctrl: renesas: rzg2l: Fix PFC_MASK for RZ/V2H and RZ/G3E
Date: Thu, 13 Feb 2025 15:28:59 +0100
Message-ID: <20250213142451.598759816@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit accabfaae0940f9427c782bfee7340ce4c15151c upstream.

The PFC_MASK value for the PFC_mx registers is currently hardcoded to
0x07, which is correct for SoCs in the RZ/G2L family, but insufficient
for RZ/V2H and RZ/G3E, where the mask value should be 0x0f.  This
discrepancy causes incorrect PFC register configuration on RZ/V2H and
RZ/G3E SoCs.

On RZ/G2L, the PFC_mx bitfields are also 4 bits wide, with bit 4 marked
as reserved.  The reserved bits are documented to read as zero and be
ignored when written.  Updating the PFC_MASK definition from 0x07 to
0x0f ensures compatibility with both SoC families while maintaining
correct behavior on RZ/G2L.

Fixes: 9bd95ac86e70 ("pinctrl: renesas: rzg2l: Add support for RZ/V2H SoC")
Cc: stable@vger.kernel.org
Reported-by: Hien Huynh <hien.huynh.px@renesas.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250110221045.594596-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -155,7 +155,7 @@
 #define PWPR_REGWE_B		BIT(5)	/* OEN Register Write Enable, known only in RZ/V2H(P) */
 
 #define PM_MASK			0x03
-#define PFC_MASK		0x07
+#define PFC_MASK		0x0f
 #define IEN_MASK		0x01
 #define IOLH_MASK		0x03
 #define SR_MASK			0x01


