Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7601D5141;
	Wed, 25 Feb 2026 01:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983653; cv=none; b=n1S3+Ma7FyNljoJdxzUDUcBaiLnxGzD1DkBCna3TdTgixCyQ84lj3/vpFUu8m23dkm0qerGQYui2OoBR/NJpr3axc2s6aIu4nDcVovOm6Ty0cvzbaxPEBmK9pXeuBZjG3AOnO65JQNOuoxSEUdNjEn9rgpZGoIPZgLUk6lO/QJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983653; c=relaxed/simple;
	bh=+2X4W8iFPo43N15eqBLVAfJughp7cpJ+9LAqx+udoHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QFasYAA2PN6pf9eH51jdo7FlOEixlC2qCSIc/FJd2IF1Az4MBjDUnotPPg4pPFIbeF7upOGOsy2MW13r6Lfy8zbYQ5zSHpg6eMCGfiPdFMv8LZxmV7sGDvgp6j2ea9OPVOIM8E8VW0Q/wIEf3VkIqXc6YqP0zOBhdzrPIQ/lWt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFzqXsbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFzqXsbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E8DC116D0;
	Wed, 25 Feb 2026 01:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983653;
	bh=+2X4W8iFPo43N15eqBLVAfJughp7cpJ+9LAqx+udoHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFzqXsbGAIC9t7QvwoBmHC7GwTvWSLluBrFDkxSR8sCptueo4SkDWn0Bp1dLsbIdq
	 vI8ltNl9DhmF8IJhwzJGdsAtBq0tU9CkMAL8k0G7iPugFzOReznVpTneQ4yiMdL4B7
	 s6bZBhKNPByRyu4xlQlYgb5nUAi8S6wCsQasmIyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 739/781] drm/amd/display: Use DCE 6 link encoder for DCE 6 analog connectors
Date: Tue, 24 Feb 2026 17:24:08 -0800
Message-ID: <20260225012417.853885104@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 2de34fbcab2063cd3d52e5872a801b9a5fc755d0 ]

DCE 6 should use the DCE 6 specific link encoder.
This was a copy paste mistake.

Fixes: 0fbe321a93ce ("drm/amd/display: Implement DCE analog link encoders (v2)")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
index f0152933bee2c..068fb1df8d889 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce60/dce60_resource.c
@@ -734,7 +734,7 @@ static struct link_encoder *dce60_link_encoder_create(
 		return NULL;
 
 	if (enc_init_data->connector.id == CONNECTOR_ID_VGA) {
-		dce110_link_encoder_construct(enc110,
+		dce60_link_encoder_construct(enc110,
 			enc_init_data,
 			&link_enc_feature,
 			&link_enc_regs[ENGINE_ID_DACA],
-- 
2.51.0



