Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D4551C53;
	Mon, 11 Dec 2023 18:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6c1PihG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22205C433C9;
	Mon, 11 Dec 2023 18:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319831;
	bh=+z3Zflr3hkOuymA9vBtcu5skzPc/W7sIGYa+WceYtjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6c1PihGjopPqaOUDehb/NZvWtsDdOg3jKZz0AW4zEOscjpHlisNssJsEleL9DofN
	 VwREelXxlAvFSH21zS7ijhuwXpNgyBNkuGvXtKd5ULywf0/Gg5wGWeYB/RqIlpz6Pt
	 muCD7ErGf9X9KpnHdLxwQPESAy1v7ytuWbYtv1mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 242/244] drm/amdgpu: Fix refclk reporting for SMU v13.0.6
Date: Mon, 11 Dec 2023 19:22:15 +0100
Message-ID: <20231211182056.871611043@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 6b7d211740da2c3a7656be8cbb36f32e6d9c6cbd ]

SMU v13.0.6 SOCs have 100MHz reference clock.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6fce23a4d8c5 ("drm/amdgpu: Restrict extended wait to PSP v13.0.6")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc15.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index f5be40d7ba367..28094cd7d9c21 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -325,7 +325,8 @@ static u32 soc15_get_xclk(struct amdgpu_device *adev)
 	u32 reference_clock = adev->clock.spll.reference_freq;
 
 	if (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(12, 0, 0) ||
-	    adev->ip_versions[MP1_HWIP][0] == IP_VERSION(12, 0, 1))
+	    adev->ip_versions[MP1_HWIP][0] == IP_VERSION(12, 0, 1) ||
+	    adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 6))
 		return 10000;
 	if (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(10, 0, 0) ||
 	    adev->ip_versions[MP1_HWIP][0] == IP_VERSION(10, 0, 1))
-- 
2.42.0



