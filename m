Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AAD1494DB;
	Thu,  5 Sep 2024 10:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530554; cv=none; b=K+EAMey8JECv4xgm7Iwi82LU4rqzOYEhP5cZQvhfpviTT3losAlZsVUXNx2LGaUEoZS8KpviBvhcfVxtip7XUBZHnNEuvV1PUanz1eEjf1lhub1XRjvH242RO3sWp4ERSLYRjV3ozxyx1S0YZH6veeVX2YN0zUVZhH/tG0rz8YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530554; c=relaxed/simple;
	bh=PGwy5XMLbb/3UoJm/VtT4QTZggNZ+Enk1gncIRlOrHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkSJjzRcewkAhnG3Ab9DE6XXp6BfAw7CmPdr1eo2/afzG+Yaar66uomr0AL62GNzR4vK/Hr0nD70BOPrH2RtraVIK/DSQ/lqsMu/THzwQhLcGbZ9liJD8kDnLDEvXAOGfqxFRiPJnqu+aOL4gW39/kDzlkUQMzxXm1QLRRf2Ebw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkA3NTY6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkA3NTY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CCFC4CEC3;
	Thu,  5 Sep 2024 10:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530554;
	bh=PGwy5XMLbb/3UoJm/VtT4QTZggNZ+Enk1gncIRlOrHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkA3NTY6LVCvSps/aOBoTkkz5qyB/tO81YvIxUCxZyerjtAr0y/TvWKYEuUCX6zME
	 3wcnc7L1M3mtWU8Yw5QjB6q0E3EYG829mRlq/EGfPQjx3p7fY7SkE2BTN0aM7FOtlK
	 BwP4wGwa0eadC7M91pd3InDlr/pk+kuMDM1lYX/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/101] drm/amdgpu: Fix uninitialized variable warning in amdgpu_afmt_acr
Date: Thu,  5 Sep 2024 11:41:01 +0200
Message-ID: <20240905093717.269052753@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit c0d6bd3cd209419cc46ac49562bef1db65d90e70 ]

Assign value to clock to fix the warning below:
"Using uninitialized value res. Field res.clock is uninitialized"

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c
index a4d65973bf7c..80771b1480ff 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c
@@ -100,6 +100,7 @@ struct amdgpu_afmt_acr amdgpu_afmt_acr(uint32_t clock)
 	amdgpu_afmt_calc_cts(clock, &res.cts_32khz, &res.n_32khz, 32000);
 	amdgpu_afmt_calc_cts(clock, &res.cts_44_1khz, &res.n_44_1khz, 44100);
 	amdgpu_afmt_calc_cts(clock, &res.cts_48khz, &res.n_48khz, 48000);
+	res.clock = clock;
 
 	return res;
 }
-- 
2.43.0



