Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5136635209B;
	Tue, 26 Aug 2025 14:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218679; cv=none; b=UxM4XszO1TO/uAI1yK6MzLiDiJqroSXZ5YmLIFT6B/LseWdtx8XAD75L1yZB2rqx04vb1Nm9HcrsMoSVGE6ddHJtFXyT9c4AbOLVdc4Kfu9nIVM6HTCBzzWArwvfCUU2SyDOXwO5KJUndE6eR53K910yimA5mt3I+oiCObcDFaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218679; c=relaxed/simple;
	bh=kyTjIkcEIt3nrxbBT33t5eviiC79XzHwWsnm/JVWTWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gK0QclG0yY0oYe9rv1TN1t+FSrr++YSMDFaYgKct08zgyG4phaNVBjd+tt8UV1IhGQOgkl46xChu3HvcFNpb7CTDZWbXHWQ0PrQU17u1drlfCqJ78dc64vFvcicL36WlvDKb4UtQZAzcdrLJ71biemxy2YfDCcAXQZTVysPBv2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJ1GCTrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJ1GCTrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D547CC113CF;
	Tue, 26 Aug 2025 14:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218679;
	bh=kyTjIkcEIt3nrxbBT33t5eviiC79XzHwWsnm/JVWTWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJ1GCTrG8F0O9Q03QEye8ne23xRk/vJW8YfHFhRE5KCcTGHu7AOgTP756KVE1YARn
	 a3xB/Z6c6YwoPBzF0zJIp0eFNWr95CEt94fR0si8hKI4QqeTacSG0RBmQE4Q5DONLr
	 YI7z5NcD1BMNoamM/yVyboU4JU0/eSEOHxmBv4e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/403] drm/amd/pm/powerplay/hwmgr/smu_helper: fix order of mask and value
Date: Tue, 26 Aug 2025 13:06:58 +0200
Message-ID: <20250826110909.210742937@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit a54e4639c4ef37a0241bac7d2a77f2e6ffb57099 ]

There is a small typo in phm_wait_on_indirect_register().

Swap mask and value arguments provided to phm_wait_on_register() so that
they satisfy the function signature and actual usage scheme.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

In practice this doesn't fix any issues because the only place this
function is used uses the same value for the value and mask.

Fixes: 3bace3591493 ("drm/amd/powerplay: add hardware manager sub-component")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
index d09690fca452..8a1ad9305a21 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu_helper.c
@@ -148,7 +148,7 @@ int phm_wait_on_indirect_register(struct pp_hwmgr *hwmgr,
 	}
 
 	cgs_write_register(hwmgr->device, indirect_port, index);
-	return phm_wait_on_register(hwmgr, indirect_port + 1, mask, value);
+	return phm_wait_on_register(hwmgr, indirect_port + 1, value, mask);
 }
 
 int phm_wait_for_register_unequal(struct pp_hwmgr *hwmgr,
-- 
2.39.5



