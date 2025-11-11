Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EA62561A7;
	Tue, 11 Nov 2025 01:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823101; cv=none; b=vBESeK3Vbzni3z/j6OHloetoUHaw1MO2KnkfcYTRvUZNSn41tff1R/EsABeDP3J/Bd3z2k6ENHli/IDe/lATFlzJgMX5RZRu+wO63YYpLS2zeBw7Mv0smBei8nm5XqaU0HTdSGWIG5wASawpIjR7MGYYlvYl6w7cPBwteEEDSzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823101; c=relaxed/simple;
	bh=zSwFhE3voOcbN6v190NsPkn8QfSp/1NXbBxJF1jURj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFFVK7flkePOVXSPZIFigZsHhOHBhH2+e3HN+v8Iq0E6dkG+p1L5VbZMBNPRwn3mj9YDZhd2s897cnpzz4ucenIcBYEMX3AVlfX31rXzKnkQCJA0Qad/1icWkROGSVRixqNi0trA+g7csm3B6MgIyU4Tdg9UBMPp/npOYlfy0Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZZuCZlX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZZuCZlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CD6C4AF09;
	Tue, 11 Nov 2025 01:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823101;
	bh=zSwFhE3voOcbN6v190NsPkn8QfSp/1NXbBxJF1jURj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZZuCZlXCXw7PXNH7nI33LaFEyDMMhN9R7z63y3/tixOQQOwO90RVSpxf1aVdfWAH
	 NVKmPL2DrI3A+22OvAaX1wTmQ/XgvseHZMbFg8LJ/UHPzLmJG7E35/dKsxecDwFB9W
	 hUdP06ivSyuQM8Vz3q9f6mg1RUS+sp99mhjC+LXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Ostrowski Rafal <rostrows@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 231/849] drm/amd/display: Update tiled to tiled copy command
Date: Tue, 11 Nov 2025 09:36:41 +0900
Message-ID: <20251111004542.029922138@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ostrowski Rafal <rostrows@amd.com>

[ Upstream commit 19f76f2390be5abe8d5ed986780b73564ba2baca ]

[Why & How]
Tiled command rect dimensions is 1 based, do rect_x/y - 1 internally

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Ostrowski Rafal <rostrows@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
index f5ef1a07078e5..714c468c010d3 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -2072,8 +2072,8 @@ bool dmub_lsdma_send_tiled_to_tiled_copy_command(
 	lsdma_data->u.tiled_copy_data.dst_swizzle_mode = params.swizzle_mode;
 	lsdma_data->u.tiled_copy_data.src_element_size = params.element_size;
 	lsdma_data->u.tiled_copy_data.dst_element_size = params.element_size;
-	lsdma_data->u.tiled_copy_data.rect_x           = params.rect_x;
-	lsdma_data->u.tiled_copy_data.rect_y           = params.rect_y;
+	lsdma_data->u.tiled_copy_data.rect_x           = params.rect_x - 1;
+	lsdma_data->u.tiled_copy_data.rect_y           = params.rect_y - 1;
 	lsdma_data->u.tiled_copy_data.dcc              = params.dcc;
 	lsdma_data->u.tiled_copy_data.tmz              = params.tmz;
 	lsdma_data->u.tiled_copy_data.read_compress    = params.read_compress;
-- 
2.51.0



