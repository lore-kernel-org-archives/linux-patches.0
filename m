Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C507CF9D7;
	Sat,  3 Feb 2024 04:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933629; cv=none; b=B+smVkvnze/y9nuSuZbDUgHShK3iBbX5BqfqGg8n/5y8PazSA5cLhN3rufmyS60emYb8kQSoStnbO3EaxSMVfQu1qbi7YMLM0hw1ZHBqyZjbXhCDUku2yWVYLlc6HxIJK9UwbLRjt4NqnbnaDYkBNYCrQHAl28T2uY6ryzjTqUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933629; c=relaxed/simple;
	bh=xgCgnDrRLitg/2cmlw6IEnPhWjoI3MevoeidrEW8y+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWPD+FHydZ42S/mi2IZ8/96tyvQbPSflpuZpHK3a2OWZEPOcpmdv/KepXmIgxx38XsoZGAa7djlkjrbkawjHPSRdkoOAAG7kBRtvN0LlGJQSB/H43EADeCLujrbd6vW62H1DKpoUQbHgjOw/nMKfSqDut0MLuIFluWzaYVoBQSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhJ8fXUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhJ8fXUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294FCC433C7;
	Sat,  3 Feb 2024 04:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933629;
	bh=xgCgnDrRLitg/2cmlw6IEnPhWjoI3MevoeidrEW8y+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhJ8fXUk9xQwZXtAlG6l71quNqeEDtSlSAuhRM7S2+Y0CCaOsObE+kiInxdYbniSi
	 364sicHgPyKlyqUzbNzs8jNCiZyffNNNj+4eboVAlEy1wIDejSWnWwJ3HEzols+xhf
	 ZbNyYd+soa7rWwT9SNoGUolj2NvxM8AEryo4ZH/8=
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
Subject: [PATCH 6.6 206/322] drm/amd/display: make flip_timestamp_in_us a 64-bit variable
Date: Fri,  2 Feb 2024 20:05:03 -0800
Message-ID: <20240203035405.902550103@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 99880b08cda0..00de342e5290 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_hw_types.h
@@ -244,7 +244,7 @@ enum pixel_format {
 #define DC_MAX_DIRTY_RECTS 3
 struct dc_flip_addrs {
 	struct dc_plane_address address;
-	unsigned int flip_timestamp_in_us;
+	unsigned long long flip_timestamp_in_us;
 	bool flip_immediate;
 	/* TODO: add flip duration for FreeSync */
 	bool triplebuffer_flips;
-- 
2.43.0



