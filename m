Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B457B1D04B4;
	Wed,  2 Oct 2024 14:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878681; cv=none; b=KXVOFFp6p6gvIEnaRsYxbA2Xq+bL86OmPY8Ghpw9vr0C5GSTL4j+PEGmIdcaOGtK7evAreN6nj3L/iPnkuOUJNUgg2hzekE6HMfHaJ97aWtpi63FYLbfAvr0HsXIzMsb2swziZB8uoUTOTEKDEG5yquzlkJuvwbPlZ3/cI/lxyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878681; c=relaxed/simple;
	bh=M2baPwBCdqqFdsSlXuIdEQQW7kM8cvBiI62FKxGkeZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKy5JmpSOM+QVmVeofYsWesLOyysYuQ7jq1sorOPOZyiqbeiBOz0TJCZ/zYRtgQDUoXa1FFQiKKm7yX8dsiEaCpXOyYT9n3erBC2tKGy5x8be1RKxu6CEQw65ae77mqLou1rjDxhUHl9rfQ7deEWtiuk2t6iuduJXKZUj0DmxfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHmMMsCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHmMMsCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAB8C4CEC2;
	Wed,  2 Oct 2024 14:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878681;
	bh=M2baPwBCdqqFdsSlXuIdEQQW7kM8cvBiI62FKxGkeZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHmMMsCzC6z6m7xETcAChuY58iEbvr0QieQAnhgvOARM5qlt/sTBmIW32O5tAcWJ2
	 HrFFmAt/3K87qZmbdAnwwyLLPlwctJ8cPGWmenxri2kS7WQ0cAwQufuCToDkmWT/GO
	 JvdsYQseMafkStmEkH94mv0ymK4teWquESWBH5cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Sung Joon Kim <Sungjoon.Kim@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.10 496/634] drm/amd/display: Disable SYMCLK32_LE root clock gating
Date: Wed,  2 Oct 2024 14:59:56 +0200
Message-ID: <20241002125830.677118774@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sung Joon Kim <Sungjoon.Kim@amd.com>

commit ae5100805f98641ea4112241e350485c97936bbe upstream.

[WHY & HOW]
On display on sequence, enabling SYMCLK32_LE root clock gating
causes issue in link training so disabling it is needed.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Sung Joon Kim <Sungjoon.Kim@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
@@ -736,7 +736,7 @@ static const struct dc_debug_options deb
 			.hdmichar = true,
 			.dpstream = true,
 			.symclk32_se = true,
-			.symclk32_le = true,
+			.symclk32_le = false,
 			.symclk_fe = true,
 			.physymclk = true,
 			.dpiasymclk = true,


