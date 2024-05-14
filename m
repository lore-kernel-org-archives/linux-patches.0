Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2352647A6C;
	Tue, 14 May 2024 11:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686585; cv=none; b=e1ewfFL7F0F+gW52B3Nwa8OGEbNXateXRjkcWBtUoJUFgeIGg5QdC+hHjHOdnmPFwa4KrqgyeYhzNjsUgexnk8p3NZ1PvglJ4+raxxQHIGNWRKsni8lTxCz1m4k+g6QmmppwXhm1gd12xWow00jrK/RZJORpUubHxgmXZ3ElAec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686585; c=relaxed/simple;
	bh=vINcPJcetYMcAyEtMa4dFwq0Ki+VoDpIv7EsUMLnVlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYFdA48hCe+VUJVXLbFfe7LPLVLAePcTPlriGbQHUsH+20BOiMZmneiXZQwr8XWP8JMgJoO/HtPcMND6IsIACnem9ZFUdNqb8161V4F1/CKUdGb9wVT+JPFoUT4bE1qExNiTshjJDOodT35oB6v9XvYlIHwbOhP0IUloiPQvIcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNu2FV2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNu2FV2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48027C2BD10;
	Tue, 14 May 2024 11:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686584;
	bh=vINcPJcetYMcAyEtMa4dFwq0Ki+VoDpIv7EsUMLnVlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNu2FV2fDV66gJ8dAWyT4LS29Ndp6JiSmm69OE6bB+MV7gfB5OIaHbbM94UJbdSpi
	 TmH+6HtDuyAIkW6JCsmqVUXiT9d8/Uc0vE2bIPiJepo2XWZZk8zrx2I62bvzkD4Gub
	 K7ovvNmVPmJJ4TLSMKfh+0d06PmeFmN/QYVoeivk=
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
Subject: [PATCH 6.1 181/236] drm/amd/display: Atom Integrated System Info v2_2 for DCN35
Date: Tue, 14 May 2024 12:19:03 +0200
Message-ID: <20240514101027.230927123@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 93e40e0a15087..4d2590964a204 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -2962,6 +2962,7 @@ static enum bp_result construct_integrated_info(
 				result = get_integrated_info_v2_1(bp, info);
 				break;
 			case 2:
+			case 3:
 				result = get_integrated_info_v2_2(bp, info);
 				break;
 			default:
-- 
2.43.0



