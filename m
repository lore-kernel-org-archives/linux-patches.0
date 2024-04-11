Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94152145B2C;
	Thu, 11 Apr 2024 10:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830178; cv=none; b=X8fuzSRCDohvmqNNUKjV38pkW1imsb/OQuz9nQ6vwq1XbmngYwamGmflNSlSrRoxMp5YklsQLJU/ylf17y7xdXAXEaPs5dX4ne1xJHG6wZpY/Yit9H/syQQ2QCrlSyrAP66u/5ctJZV6K+lzoURyyHnxzM2JpUBrWYf9GS7B2Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830178; c=relaxed/simple;
	bh=zTKbr0AbXMdykA1JRZvxkDGdiF8REl2liAiXkNXhO/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2dkx7mi2IwH56squXq5Z5RTHcSmnqXu9VXziLO5t/RYz9U+gzIlRhvO3GfSBrXgqauBkY6c0MNIq+aWFJ9y9eyEXsW3+fpfV4G1TCtKl77iHE2jvY3kj6gwTRD0N8oIeR7BX/bsktOBECii7f2UDo7RSNAa4AKo8BDEidAsCGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrcNCXe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrcNCXe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17985C43390;
	Thu, 11 Apr 2024 10:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830178;
	bh=zTKbr0AbXMdykA1JRZvxkDGdiF8REl2liAiXkNXhO/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrcNCXe95ofIJHPZZQUfgl5o4Yj8PAHF6kz0fK64+8gWalE+E9qaz9VXwdrPqUGF/
	 e2bE4og+Bx+3SN0pu4WI+6Q/kPuBLRrnzqIrpS36a+5QWclzsdcdE5Aick0csiYLcf
	 fN8Ez94V5iK4xh4xlS6rz7iGqflOkoOJ+dOAOfjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Emil Velikov <emil.velikov@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 062/143] ASoC: SOF: amd: Optimize quirk for Valve Galileo
Date: Thu, 11 Apr 2024 11:55:30 +0200
Message-ID: <20240411095422.782041282@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit a13f0c3c0e8fb3e61fbfd99c6b350cf9be0c4660 ]

Valve's Steam Deck OLED is uniquely identified by vendor and product
name (Galileo) DMI fields.

Simplify the quirk by removing the unnecessary match on product family.

Additionally, fix the related comment as it points to the old product
variant.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Emil Velikov <emil.velikov@collabora.com>
Link: https://msgid.link/r/20231219030728.2431640-7-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/amd/acp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/sof/amd/acp.c b/sound/soc/sof/amd/acp.c
index 2c242ef9f23c1..1b6f5724c82b0 100644
--- a/sound/soc/sof/amd/acp.c
+++ b/sound/soc/sof/amd/acp.c
@@ -31,11 +31,10 @@ static struct acp_quirk_entry quirk_valve_galileo = {
 
 const struct dmi_system_id acp_sof_quirk_table[] = {
 	{
-		/* Valve Jupiter device */
+		/* Steam Deck OLED device */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Valve"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Galileo"),
-			DMI_MATCH(DMI_PRODUCT_FAMILY, "Sephiroth"),
 		},
 		.driver_data = &quirk_valve_galileo,
 	},
-- 
2.43.0



