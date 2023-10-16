Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0216928DD5
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VD9GX2Rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446D7C433C7;
	Mon, 16 Oct 2023 14:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697466330;
	bh=0DXoca8GYb+lgJOMB5Qdbk71DJaBaAeIPen+wRTfSMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VD9GX2RnyjvBeDpB9mS/4qB00Yt23hUpAZaq+gcWILaggJtKwuIH9ofnaeK8v/Igu
	 eWCDQ6r4Q8OU07dNEdASEEMTnGtNdJfl9GbWWpQmj1G2MqAuNibaRQH6yONQ3jsjcy
	 dfWrBa4ADaFNaUSQBXocLdVwy25oqYsZHZUfMkNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 008/191] drm/amdgpu: Fix a memory leak
Date: Mon, 16 Oct 2023 10:39:53 +0200
Message-ID: <20231016084015.596605581@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit 5d061675b7538e25d060d13310880c01160207c4 ]

Fix a memory leak in amdgpu_fru_get_product_info().

Cc: Alex Deucher <Alexander.Deucher@amd.com>
Reported-by: Yang Wang <kevinyang.wang@amd.com>
Fixes: 0dbf2c562625 ("drm/amdgpu: Interpret IPMI data for product information (v2)")
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
index 4620c4712ce32..1005edeea39e5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c
@@ -169,6 +169,7 @@ int amdgpu_fru_get_product_info(struct amdgpu_device *adev)
 		csum += pia[size - 1];
 	if (csum) {
 		DRM_ERROR("Bad Product Info Area checksum: 0x%02x", csum);
+		kfree(pia);
 		return -EIO;
 	}
 
-- 
2.40.1



