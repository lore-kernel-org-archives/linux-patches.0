Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015077;
	b=WJrGEt07EbdoNGXFjRPZ2CSqlgd4wJ2ceUsfdaw98NCyhHsQUhPPczqtJhA7BQc1TOBT
	 NgmI/SHryFRYGvS2iS5xSd149Wst745cpCFHiHNQ3LE5jtOfl3pZd4JMi0Qqr+VJGh1+E
	 ypFExpIcWG4wezxYbyIF8b+mqjh5ADnJf94/xG3JoJUHNXUgJ4MZ9PMztGsGJ41HbSoZg
	 X2gYfKYngEqNqWFaEwNFeRV4w2p4LnWwdR4z6I1w5yQ1apd5iZAYIF/2u/OBmUlBHfmff
	 fvb5EHg6ZT/0eTnuYtYnZStA3goFfR3psQxQxh7Cv0al5IiKFycMCkDseZNV3XM4n9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HW9RCj6yzjr00Xl0sLiysp4ZUeBgNSE67yWFm1PAcpg=;
	b=qARrrjWQssAF2z5tw667iTJN+WppTWLB9VaSYhN5zp/oe4AIkHqw1g8ItqtsO3CGbsGY
	 mGd3O6TZiYJ1C72uG02t0Nqv0tZcZo/fdL25HIzzp8lvGCl+u/hrpBqxVt38Ftuo4ZbfH
	 bDhOqjViv9Dsppj2ySsJlkhjgHtvSfITjZH9B5ncsLsigd9P/Q3nI13yGeomRVWkL1LLd
	 L0+teeaH916odDNYPZrgxguyaqb8vkEISuKv/YYVP4VELj7J4AzTkVtgqE+7fFQTyN0b3
	 wWb1CmYeRCZdpe2JdD1+N/Ue+UquC/1X1VAlqTy6sDRtYFB06CoBpLh+wUvoXl7074g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n6v8wRiW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A471B606A320;
	Wed, 18 Nov 2026 15:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n6v8wRiW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65CB1F000C4;
	Wed, 18 Nov 2026 15:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015077;
	bh=HW9RCj6yzjr00Xl0sLiysp4ZUeBgNSE67yWFm1PAcpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n6v8wRiW5a1Gxb76RKD7T7nec2cWuT0fBxr6odMSQ0QUJp/qxy0v7GuKsNJw8XlOd
	 eHsfMtVsWS4m3/OeKmi+kfCR0D1qzZCk4Nio3W/2HCNlToO25hZ+vy1s8vKUSyuZtg
	 EsJUQuKRXRxaWGP5TgdGzNFXRW/YWbO4N0DN4Nvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonny Jiang <sonjiang@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0027/2651] drm/amdgpu: Config VCN instance for soc_v1_0"
Date: Wed, 18 Nov 2026 15:21:07 +0100
Message-ID: <20261118150248.956235370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sonny Jiang <sonjiang@amd.com>

[ Upstream commit ab2fb550bc1fabd96c948fdbebbc05f61a9810d6 ]

Set up the default VCN instance mask and related instance counts during
soc_v1_0 SOC configuration, before IP discovery is enabled.

Signed-off-by: Sonny Jiang <sonjiang@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: a56c2536c399 ("drm/amdgpu: cancel idle work in hw_init failure paths for vcn/uvd/vce/jpeg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc_v1_0.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc_v1_0.c b/drivers/gpu/drm/amd/amdgpu/soc_v1_0.c
index 43e92e2a85e89..37e2068b6fda2 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc_v1_0.c
@@ -849,6 +849,11 @@ int soc_v1_0_init_soc_config(struct amdgpu_device *adev)
 	adev->sdma.sdma_mask = sdma_mask;
 	adev->sdma.num_instances = NUM_XCC(adev->sdma.sdma_mask);
 
+	adev->vcn.harvest_config = 0;
+	adev->vcn.num_inst_per_aid = 1;
+	adev->vcn.inst_mask = 1;
+	adev->vcn.num_vcn_inst = hweight32(adev->vcn.inst_mask);
+
 	ret = soc_v1_0_xcp_mgr_init(adev);
 	if (ret)
 		return ret;
-- 
2.53.0



