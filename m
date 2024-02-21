Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C417F499;
	Wed, 21 Feb 2024 14:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524280; cv=none; b=bAtTJHfsQkUhHhCr3qIiBfB1SMUJGkd9qBv+zN2HG9xCb3Y/NowduUONPv4BkQEHIzieDgijMgBE0moLCAOJvqZpW5xEWC7lG1xCE22po6HO4vtgYjOZQdKgLyUdvuvmkUMfONTiWjtcfv7mrovvPD9mnlwPE5OGt9vnEpd/94w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524280; c=relaxed/simple;
	bh=4NHno09OMqubAQ5H1jvTu/ZpHpoi6/OCPnHutzasOGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agJXeSN44cmOPPMmusHyUBG89+Mupj3AfoRbA9mrDKLlgKEOEmJ59PvNlBt4WiWQkF6AMV03BbFnrfs3TTYFzekuJBB1KOSMMdpn+gp02v3CSSwPTxVDPiR/TcCR43dgK71UoGCNu5NGK2gvRTprtJOG7bHyNflsb2Pw2n7Y+JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4aSIM0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4aSIM0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862C5C433A6;
	Wed, 21 Feb 2024 14:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524280;
	bh=4NHno09OMqubAQ5H1jvTu/ZpHpoi6/OCPnHutzasOGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4aSIM0H+ZGj7hvKXN12dh8Y/U8T/OSb+sE4MB/HYivcTC6EQkuK0HU9TgM6K9Ndo
	 YHtgFX4dp0nLLVuySfVROQCi7EQi6fvbnFDeVz5oU6j/730PdoaGO1YaKXcaTzKJPE
	 qGjvnueqJ4k2d6puLKty1wDX7kmODqGX6oRQ/W40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Josip Pavic <josip.pavic@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 197/379] drm/amd/display: make flip_timestamp_in_us a 64-bit variable
Date: Wed, 21 Feb 2024 14:06:16 +0100
Message-ID: <20240221130000.731649940@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josip Pavic <josip.pavic@amd.com>

[ Upstream commit 6fb12518ca58412dc51054e2a7400afb41328d85 ]

[Why]
This variable currently overflows after about 71 minutes. This doesn't
cause any known functional issues but it does make debugging more
difficult.

[How]
Make it a 64-bit variable.

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Josip Pavic <josip.pavic@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dc_hw_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
index 1a87bc3da826..b36d4c5d0eca 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
@@ -426,7 +426,7 @@ struct dc_cursor_position {
 };
 
 struct dc_cursor_mi_param {
-	unsigned int pixel_clk_khz;
+	unsigned long long pixel_clk_khz;
 	unsigned int ref_clk_khz;
 	struct rect viewport;
 	struct fixed31_32 h_scale_ratio;
-- 
2.43.0



