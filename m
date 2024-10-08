Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AC81CCB32;
	Tue,  8 Oct 2024 12:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391901; cv=none; b=HvnODfNmHhKGxArIiv9FKFcUsL0h22YTzPQacoZx7ZHFDiR76fOEP5twDfSFhRKc/cRpR8xMVR0u39OMgJ2ZFr5EdV87DXubnYRCte8VRBAS1HwUgJdbCg8EM6vSm0oMaf1mfTyXi6bqZ0JyjKRLSUURqZfex5JyTcDo1dSBJWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391901; c=relaxed/simple;
	bh=KFKngU5eU0Ww6zmqwRQCDVC0b49lGFxFKHlIpQFDxdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmpqoVaiOLTQevvPid9yGi38CN1uRNQqtSqWK6pxYJF6YZNDMcM3Uj/4mTJVY07mrNzMFe9lq0aBKhtkrpzJ8TJuIHWZ0X44VylG6WsHpvcFTuY6hziqDm1aKBYr7MtGx46D74tslFBcZKty7IRHoJMZkotV0+zAVsuC90g3HbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vBHIV1cq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vBHIV1cq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AF2C4CEC7;
	Tue,  8 Oct 2024 12:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391901;
	bh=KFKngU5eU0Ww6zmqwRQCDVC0b49lGFxFKHlIpQFDxdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vBHIV1cqAVJqTf1GOcDW6Ca2B5Mo+wHz9bPrRK3wUAwaS7Sj+m1zAU5kYvqvh7UbB
	 hfvZH8l8FXKzVuawTPfVWwKcczcCx0s4jxsnhfCQvOkMRuEP4OojYKO5MX7TRgYiW1
	 3dEwEq/NQ1aYeZaNlnN1cT66JfIBYzzw87EyG2uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 257/558] drm/amd/display: Increase array size of dummy_boolean
Date: Tue,  8 Oct 2024 14:04:47 +0200
Message-ID: <20241008115712.447511166@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 6d64d39486197083497a01b39e23f2f8474b35d3 ]

[WHY]
dml2_core_shared_mode_support and dml_core_mode_support access the third
element of dummy_boolean, i.e. hw_debug5 = &s->dummy_boolean[2], when
dummy_boolean has size of 2. Any assignment to hw_debug5 causes an
OVERRUN.

[HOW]
Increase dummy_boolean's array size to 3.

This fixes 2 OVERRUN issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h        | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h
index 1343b744eeb31..67e32a4ab0114 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_shared_types.h
@@ -865,7 +865,7 @@ struct dml2_core_calcs_mode_support_locals {
 	unsigned int dpte_row_bytes_per_row_l[DML2_MAX_PLANES];
 	unsigned int dpte_row_bytes_per_row_c[DML2_MAX_PLANES];
 
-	bool dummy_boolean[2];
+	bool dummy_boolean[3];
 	unsigned int dummy_integer[3];
 	unsigned int dummy_integer_array[36][DML2_MAX_PLANES];
 	enum dml2_odm_mode dummy_odm_mode[DML2_MAX_PLANES];
-- 
2.43.0



