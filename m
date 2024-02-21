Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A1779DBC;
	Wed, 21 Feb 2024 13:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522697; cv=none; b=E7pxopkuJp+xR4avWUJxFGXiAmPSMHXL1rFSRbMgG9LecJqSvJkNStJa3v0bfo532Kf7ifSDiUXJZdCBO0BdoyNLzsuvwZ8SXPQUHEDli6xTH5snSxGD85lF3d6s22cj7mmPJwkmnKDBf4zZD/MqpZa3AN0L3PaHWFxeyL3lOuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522697; c=relaxed/simple;
	bh=8wEGm6NZVea5MRaDfJ/3uDt+AoBF5iu3nSAxJaGKoiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELj6LwHqzcsRUZ9yqv96rDW0l4neRNCpyv1e6YH3l3mixCNFsT7Uypjk6DBez7u0BF1/SirfZ/xd7vuT6ijruZbrmZOD/Bal7g3xIMoAt9U8R1uxKUK4DZvaE2DRNqDR/ePTS6QdhwWqLBZzxE0ecox0hJfPWpYbLRVMYBdRgQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCGdEA2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCGdEA2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAE1C43390;
	Wed, 21 Feb 2024 13:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522696;
	bh=8wEGm6NZVea5MRaDfJ/3uDt+AoBF5iu3nSAxJaGKoiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCGdEA2LSuoB9yoF3isVzH2BmsaXYyiPiGi5OQWc52PrNMjC3XZJuPyfMLP0PA29o
	 UXv3KJsKYInrVQe3UgX4x62Jpx3NzS9M9sbEEf8kI0u7QcI39OI/4RrwLZg5AJE5F7
	 +w0iABFCR8ah0S94wAzQv5fjJr9TF1oLlIge9uio=
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
Subject: [PATCH 5.15 234/476] drm/amd/display: make flip_timestamp_in_us a 64-bit variable
Date: Wed, 21 Feb 2024 14:04:45 +0100
Message-ID: <20240221130016.536891156@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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
index 52355fe6994c..51df38a210e8 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
@@ -417,7 +417,7 @@ struct dc_cursor_position {
 };
 
 struct dc_cursor_mi_param {
-	unsigned int pixel_clk_khz;
+	unsigned long long pixel_clk_khz;
 	unsigned int ref_clk_khz;
 	struct rect viewport;
 	struct fixed31_32 h_scale_ratio;
-- 
2.43.0



