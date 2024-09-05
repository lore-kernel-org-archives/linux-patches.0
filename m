Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0B5195FCE;
	Thu,  5 Sep 2024 09:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529459; cv=none; b=WRYFyagGUEIfESX04FLa5mmWZurZFvq2EzXruGeA4zXnfDq1rECJuKWHodW7G50ykVsL5x8XiCqHloseVb9rwxamNRiBk3/gGBhx0h8dApjdB0OwEZPxLucvaWTQpANfJu4gQ8y6y6YtkoBSrgl//DQBrSampzJKhWJNWGiiwKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529459; c=relaxed/simple;
	bh=6h4dXN64Ul9iEAPF2HB/QQQPC7I5u7jWKxf4CPBXaEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnB4/2JaXZ9CcYGoSlVazfjHv1NSrfylrARQEhaXRj8aCWyy4OAnxyQ2XTKIlhcpUXuVOY09GfJJZldqklLuad9Rc01ml0eBFxJ5TyRmYHZ8yznVBCw5OWBvntFjuowQXJibnfn6i2EJOYXNqYiLW2gZw9K4YOxEdObsIr8G/Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imHfsCPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imHfsCPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66399C4CEC3;
	Thu,  5 Sep 2024 09:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529459;
	bh=6h4dXN64Ul9iEAPF2HB/QQQPC7I5u7jWKxf4CPBXaEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imHfsCPUBNZQRG9zxUuQCZ8tZYzc5taAqg/bhnuNALqWUyr1mhSEK2xAu8aLeaeZ0
	 qnPb17gLpnXqvpZYWGYGktSdsDPYHy+JYWeYK8zg+6VJtdAsDCCLJ/RYhl2DIkEmEx
	 Jy02I8HZXvZDswRvxjLG+roQhlojFQKFAaS1oCH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 040/184] drm/amdgpu: Fix uninitialized variable warning in amdgpu_afmt_acr
Date: Thu,  5 Sep 2024 11:39:13 +0200
Message-ID: <20240905093733.813724550@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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



