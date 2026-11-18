Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043150;
	b=zT0s/EnmR/A+umEs83iJKLe35FNrsEHF0P4+7856ZX569vdXTKbh0jCKTNA+KdFe2mx7
	 3b8E0RAQ6fgxjiylE3YWRPlNklfOEOaf8UdeZT92Qt7dJXIaCpUuWL1niC/tWCjgr3AaT
	 mluPYa5ZtIObPGPqo7gP6mO5mLLMTaZLMTFhFBbHGEDlHprGESGY5mdEgxI8T988J6rVh
	 Cw2pw1ePcZGnrUkwQcYi5TfyUFFHEpk7WB/mh55dx3KItnehokXYxyYCf9J2pyGpDSfxz
	 ymyw2L9C6Bxd8hz+u2ORahzvwLlda/v4egjx6MQUiPCV2dM6/wZ874smX4cy4M63jEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OfDz5TEuK58858NwKUTqOCMrW+JTVX9IzD9gdEdZhlc=;
	b=4vSMDErLkhs6gzcnc7G7TMUjqdLYv85StLSeg/epjfbwy9AO3yBLHB5N4HD8K6yIy6vW
	 tR6NKGzWa/FwLPDIyFpHkhD1bo16jwcBiObU9extmFHw9aubkmmHoAwA9mImxYUi4jcJf
	 DzIr1TGvQE0YXgAj7gfokxbgBHskocHbNUDMSgRRze3/VWKlvWsnbNvijVbFOKpPxMB+L
	 B5OluyUwNJcPz1NNu4mhR+nfTT75NBdOsd3oTxpu5oYUM38FYkESVEbH/WbYqXLrIne8A
	 6F3l9KNLotpdA7tlUIzPOI+g5+a98j1RAmU85vZevGI8+gzcB2X43yowbwpkAxkm8mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1L+ZhoZF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB29606A33A;
	Wed, 18 Nov 2026 23:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1L+ZhoZF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2981F000CA;
	Wed, 18 Nov 2026 23:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043150;
	bh=OfDz5TEuK58858NwKUTqOCMrW+JTVX9IzD9gdEdZhlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1L+ZhoZFCPQPNmBF9c9KwBqDz5Uaue1aPTCz/PIlAjFBbWhVIGISE73j0frJJF+Sa
	 b6+zqFUsxHNaBzDXpit2B2exqvwf+ekRmJ46TvNt2mWHBEyCDtroTMoDq4THGGeZF+
	 xLGR7r7w+jcKXe/Cyf/SnckvkYv0RFJ5M3C7lteI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0066/2857] drm/amdgpu/gfx11: WARN() rather than BUG() for invalid SDMA engine
Date: Wed, 18 Nov 2026 15:18:20 +0100
Message-ID: <20261118150203.707227988@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit c24edbd5ae0e4f24e0179e8c9f22a867016177bb ]

There's no need to crash the kernel for these cases.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c
index 7e80caa05060b..8f4a90080725b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v11.c
@@ -137,7 +137,8 @@ static uint32_t get_sdma_rlc_reg_offset(struct amdgpu_device *adev,
 				regSDMA1_QUEUE0_RB_CNTL) - regSDMA0_QUEUE0_RB_CNTL;
 		break;
 	default:
-		BUG();
+		WARN(1, "Invalid SDMA engine id %d\n", engine_id);
+		break;
 	}
 
 	sdma_rlc_reg_offset = sdma_engine_reg_base
-- 
2.53.0



