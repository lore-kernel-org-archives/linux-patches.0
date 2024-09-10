Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51528191F91;
	Tue, 10 Sep 2024 10:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963350; cv=none; b=G/GVeCMd2AzqkTZYcMycUijUxu1b+T0sTJzhOwTvi1/GC5awtupK7zSmIQTPDIpR989cnH4FcT7+WiV4g7Llbx3jsBuEPsNc5/mB/kqLAth3cpKXfn3Cjxzz/3fnnydaIiOwb60btFzDNw97xAsbcm7r+3zoZPWFBJFUPrjD4nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963350; c=relaxed/simple;
	bh=C6ZGSBnIPsrBTy51a4DvtF6id2YksjAwmvMB2yjtW98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeGw47McqDor9Dze0Vq5tbwLBoM7vDtvXwV50OGz9bDikT7CEE/sPfrihEc1m5jUslItlEuxDEEjYbiEBe6E8bqPCnOQx6tc32evrGmyr1R8h7DMqNnhHzfcrEhCcX/L0vMVOuBWa+4Kq/ZI8AZqUHSQo/WuZRJ0PaDaqud16DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfI3vWeQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfI3vWeQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1248C4CEC6;
	Tue, 10 Sep 2024 10:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963350;
	bh=C6ZGSBnIPsrBTy51a4DvtF6id2YksjAwmvMB2yjtW98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfI3vWeQNWeSsaXfJiB8GZ8n8mbgxjU8eoU21N3UfLvct3q2/lOh2kQQEFy/wLntE
	 s72sM1KFPt4o+A2IpYY81l8g9ufR2GpsNcI+EtSRiV2hQl7KdoPYxBFfXk8htOTYB0
	 /psHY+Nsxl+bkpkUW2vGPuBR7MqkVTyx2ccxHn1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/214] drm/amdgpu: Fix uninitialized variable warning in amdgpu_afmt_acr
Date: Tue, 10 Sep 2024 11:30:29 +0200
Message-ID: <20240910092559.011462094@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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



