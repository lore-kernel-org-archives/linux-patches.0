Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59F517C7A3;
	Tue, 10 Sep 2024 10:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963315; cv=none; b=kX6mDveYsYRFMLWR4XgZ0uxIlpIsIBRN+ZLLYJDwhbB219h62eJXfDXtp+G7IjGuoVAzwZX8FgZudjvQpMtNrmZPIykGvfrzucLHbITTQoz7AHiXLq3yGyNlG9eB/UURhEGJ8BoXNZF6zhh54KXB7GiNpsVT53G4anQyDcj4764=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963315; c=relaxed/simple;
	bh=sQ1fHWO/5v4Lir6sJF4ZzGBwRNhBadQgUkTMxeIpXsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBDppFnKjrKOoZ9dnoNAsJknky5udDwZ7MWfoABDYEHWNti6GBxhGvVB4RdZH6ObH1jqLdKEBrE2peTgSSe5G2ANVgKPgRV9al+6MF6ob7dE4Ch2TZOTjlJyOlefYQMxY2MGb6cE1vJSUT/FcAVZMIaBh1UT7IuIAPgKke8IxY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7mL2+Zj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7mL2+Zj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7ADC4CEC3;
	Tue, 10 Sep 2024 10:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963315;
	bh=sQ1fHWO/5v4Lir6sJF4ZzGBwRNhBadQgUkTMxeIpXsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7mL2+Zja1Jeybzdk/iVLBdtGjkLSMpFmx3LymLNPk1yDEMxttW65KwYbufd+YnvP
	 4w4jewbeqqIXe5uB+DDLitW+H3mbmucDMW9Tm+5orYfma81+lh6fNacnjkl25n/luE
	 KXfM/TsnkrHov8c9T39pcZ/KBOWQOSViXBjJxukk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhigang Luo <Zhigang.Luo@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 016/214] drm/amdgpu: avoid reading vf2pf info size from FB
Date: Tue, 10 Sep 2024 11:30:38 +0200
Message-ID: <20240910092559.411573525@linuxfoundation.org>
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

From: Zhigang Luo <Zhigang.Luo@amd.com>

[ Upstream commit 3bcc0ee14768d886cedff65da72d83d375a31a56 ]

VF can't access FB when host is doing mode1 reset. Using sizeof to get
vf2pf info size, instead of reading it from vf2pf header stored in FB.

Signed-off-by: Zhigang Luo <Zhigang.Luo@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 8d9bdec2b700..76fc0e8dcf9c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -586,7 +586,7 @@ static int amdgpu_virt_write_vf2pf_data(struct amdgpu_device *adev)
 
 	vf2pf_info->checksum =
 		amd_sriov_msg_checksum(
-		vf2pf_info, vf2pf_info->header.size, 0, 0);
+		vf2pf_info, sizeof(*vf2pf_info), 0, 0);
 
 	return 0;
 }
-- 
2.43.0



