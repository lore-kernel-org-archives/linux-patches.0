Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CFBF9D4;
	Tue, 14 May 2024 11:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687870; cv=none; b=twOsOdYyQOGDw31LfaW6BxOCbFnVlMvEDJWTYoCLlyn4s+0m3Jv715oCgT5uuW2XjEkSFjWKQ/IhOzF2H1dc5mG5ETIBdkyhgi5W0ryiZoH9WShl8ag6jTJ/t7t/VKMw7htpS0OCC8mX4/rsQ3yx2euKOjIBl1qLBRFbUt6hYUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687870; c=relaxed/simple;
	bh=iPDtvHJeh5if4d+/JEUYkWFTChPjfttHxYCP1h5B3Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIOEprByfWSsh5M51U7VGaweKC5kkS5VPxp5nkVxxPsJWWHJdIq5dT6aWdSp49ee+Lt0XhvQzLCVB+c97Zi/qcU3U+95tIEMPZR5XzD5KnJmjv1AYALVeeWCGo1vZ247/VEDLDzwbXDKpVbaU9+xNpr7dywJeey0IexlMWX4HGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vj8ihD1L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vj8ihD1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD6EC2BD10;
	Tue, 14 May 2024 11:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687870;
	bh=iPDtvHJeh5if4d+/JEUYkWFTChPjfttHxYCP1h5B3Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vj8ihD1LtqaDaNl7pu1zB6qs9Womv7lDHmAXNkrVBT5fiE/uNmMMVL1BVPizwgeCS
	 XSbsfquO+LneotZ6RM7x1C0LPJECYDqXuztiCumOKYyOS9yEEEBFai/E6Z6NKGfm6G
	 o2Y2B7/acdv8vD4CmLR4YrUzHbLGxAmNSF8tHW9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Gabe Teeger <gabe.teeger@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/168] drm/amd/display: Atom Integrated System Info v2_2 for DCN35
Date: Tue, 14 May 2024 12:20:31 +0200
Message-ID: <20240514101011.703177011@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

From: Gabe Teeger <gabe.teeger@amd.com>

[ Upstream commit 9a35d205f466501dcfe5625ca313d944d0ac2d60 ]

New request from KMD/VBIOS in order to support new UMA carveout
model. This fixes a null dereference from accessing
Ctx->dc_bios->integrated_info while it was NULL.

DAL parses through the BIOS and extracts the necessary
integrated_info but was missing a case for the new BIOS
version 2.3.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Gabe Teeger <gabe.teeger@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
index 228f098e5d88f..6bc8c6bee411e 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -2303,6 +2303,7 @@ static enum bp_result construct_integrated_info(
 				result = get_integrated_info_v2_1(bp, info);
 				break;
 			case 2:
+			case 3:
 				result = get_integrated_info_v2_2(bp, info);
 				break;
 			default:
-- 
2.43.0



