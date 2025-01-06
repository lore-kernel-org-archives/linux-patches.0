Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB88146D40;
	Mon,  6 Jan 2025 15:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177005; cv=none; b=O7ZnhF/SJYsbj4OuX7FkGOJVQcJIhCD9HJk0E3XdFKefA2ViWFw/hufeoSJ0lif12+/jz/OdMBQ4Pf26XLjUT6B6uadK2MnJT1RZPkT+JccJP/oSnp+NWL37PXKgnIznZAEuq3odNqF93GTd6HsGzLgSHBLMK7NXAspB0zQRVMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177005; c=relaxed/simple;
	bh=7PCml4w9SfvHEOCxFSVcro6zKFhxsWtuqAMwauXD1W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRrTOjGuo51Ue7Xd/ZRpHSM5ktL65KlFN7MTEhcNhQ9l+/CBSrmmDs1sfE2Q1Qdi3KOyl6WNXkJ1sXls78Uc2CQsDVKCm/ODKUUY/7v67Dj9DMHA825UK9QxRuReQq1lEPN/0UmPIvN0oK6dqMMjH9fdWCjYgFeC8EXdRl3kS64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohhBEwjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohhBEwjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5326AC4CED2;
	Mon,  6 Jan 2025 15:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177005;
	bh=7PCml4w9SfvHEOCxFSVcro6zKFhxsWtuqAMwauXD1W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohhBEwjnrrCJMmaNgNgUD8UgzeBB5XzhObJxcD0j4MTDqdsgOBxXOCcr5fxvsuUdz
	 mLg1gIJUu1+c6uBEPX6L9FtwEShj4Eq4rb1OWLZzrNaQ5nLfs8TmQujE8qjlfJjEf/
	 yX/jXrWdbwLLTaR0zIjDQPZMdRNd+x9FlVwYk6Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/222] drm/amd/display: Fix incorrect DSC recompute trigger
Date: Mon,  6 Jan 2025 16:13:26 +0100
Message-ID: <20250106151150.686057624@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit 4641169a8c95d9efc35d2d3c55c3948f3b375ff9 ]

A stream without dsc_aux should not be eliminated from
the dsc determination. Whether it needs a dsc recompute depends on
whether its mode has changed or not. Eliminating such a no-dsc stream
from the dsc determination policy will end up with inconsistencies
in the new dc_state when compared to the current dc_state,
triggering a dsc recompute that should not have happened.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index b4bbd3be35a6..385a5a75fdf8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1236,7 +1236,7 @@ static bool is_dsc_need_re_compute(
 			continue;
 
 		aconnector = (struct amdgpu_dm_connector *) stream->dm_stream_context;
-		if (!aconnector || !aconnector->dsc_aux)
+		if (!aconnector)
 			continue;
 
 		/*
-- 
2.39.5



