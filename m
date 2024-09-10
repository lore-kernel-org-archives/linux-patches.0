Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABECE19066E;
	Tue, 10 Sep 2024 10:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964797; cv=none; b=UsjYFN4ofg9AY70IR+KjNlZxiH7Ng/WbVxexnoRoMnIEY/rWaRjTfaktUMU/lLh6HeE3sXiYZA8TRs55W1dSWfm9XMmBX5hPeGZJiGpdK34LBVvsJqP7sizq7bw8pas+P0Q4yU4zZeWniZmlke6Rf0gq3lcO0iGZ++VLSeF7MOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964797; c=relaxed/simple;
	bh=6/wI1GVoK+tXy+Roey1SeAo5w/lkhhI38yCNX5FxLZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hb2aM9Zr6HFgCXnO/OAE1lAHf3E5YXv+6bbfoQa4b3bLXBgNbM5pCHZAKwSlF6c4jS38g6TNGClfGNnV8IIrmjRHtqTO28pVqv2dMTnLdhdmf+N9a1T4Ob5m9oV6DJEvAteEH3W8Z0gtdiC+/gFdWpoCybKLZ9RM40rl2/FTjw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTYZjhDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTYZjhDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADC2C4CEC6;
	Tue, 10 Sep 2024 10:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964797;
	bh=6/wI1GVoK+tXy+Roey1SeAo5w/lkhhI38yCNX5FxLZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTYZjhDFZZ24BQ7flE5W+i/F2ZRXgFGN6BmdNHi06eDdK7mxTT+DMwH2dc9VPrAtu
	 uk+QLBB5IaZ/toXuKH+9fPOHba1SxLThbB4CwUes2fStedsvd9pdSaNZQuHj8W2s3j
	 GPYyMd7NgvnGPvOGLkPtmBcTeGdgpU8tWZV/jyKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/186] drm/amdgpu: Fix uninitialized variable warning in amdgpu_afmt_acr
Date: Tue, 10 Sep 2024 11:31:42 +0200
Message-ID: <20240910092554.957104416@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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



