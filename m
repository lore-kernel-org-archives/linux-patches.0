Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83616E571;
	Tue, 21 Jan 2025 18:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482545; cv=none; b=dXS8GiXnQWfrXTr3Doo34PxBEbmVU3uC2oPaTjhcClkVHsjqky7uV9R5LakUQeKkGedmgVZu8RyfRxfFMuV2dMnq2oZu5dYfesaD3UVzQvrw5uOJODEIUeKMqQujp8xFlW6oEDBh8DFTal9Yj2s+qlBglUJaKuaTqCcBxDzkN5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482545; c=relaxed/simple;
	bh=IdVkltVoqI445IukCtZ5gdoTJJejFDtDTAnIx8YcLFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GmzVqDqsmnyVkU9MT1KS/azJRKrhhEXcxeS/3AQqtox9gmsMAVmBGegxGNuKS9muw0YkH/Epq69cldI1D68aN0B+vKyKz+mLtHnPGR2GZpVozFXN4bPuY7DI4nAEvP6ZoXr90wuZdaEDCqoD9yV/jJs1WmwTtw5Ao+2pHDET13w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tpc+acmB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tpc+acmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE03C4CEDF;
	Tue, 21 Jan 2025 18:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482545;
	bh=IdVkltVoqI445IukCtZ5gdoTJJejFDtDTAnIx8YcLFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tpc+acmB4SJ+Di3p1reMMvYU7n2IsGOYASAadlvLVf0sF66K4zScCTKdCvI6HlXol
	 LbgsRLrMbbY1zZOcseLeC3yYHbWUQfcw5UXQBCOnFV+K5+y0/3HhVhFxJCsquvV4yJ
	 pPCl0nL0aL7Y3bT1jVfhBP/TXO5gZ9s0zO9Y/Ono=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui Chengming <Jack.Gui@amd.com>,
	"Frank.Min" <Frank.Min@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <Christian.Koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 114/122] drm/amdgpu: fix fw attestation for MP0_14_0_{2/3}
Date: Tue, 21 Jan 2025 18:52:42 +0100
Message-ID: <20250121174537.448383448@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui Chengming <Jack.Gui@amd.com>

commit bd275e6cfc972329d39c6406a3c6d2ba2aba7db6 upstream.

FW attestation was disabled on MP0_14_0_{2/3}.

V2:
Move check into is_fw_attestation_support func. (Frank)
Remove DRM_WARN log info. (Alex)
Fix format. (Christian)

Signed-off-by: Gui Chengming <Jack.Gui@amd.com>
Reviewed-by: Frank.Min <Frank.Min@amd.com>
Reviewed-by: Christian König <Christian.Koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 62952a38d9bcf357d5ffc97615c48b12c9cd627c)
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fw_attestation.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fw_attestation.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fw_attestation.c
index 2d4b67175b55..328a1b963548 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fw_attestation.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fw_attestation.c
@@ -122,6 +122,10 @@ static int amdgpu_is_fw_attestation_supported(struct amdgpu_device *adev)
 	if (adev->flags & AMD_IS_APU)
 		return 0;
 
+	if (amdgpu_ip_version(adev, MP0_HWIP, 0) == IP_VERSION(14, 0, 2) ||
+	    amdgpu_ip_version(adev, MP0_HWIP, 0) == IP_VERSION(14, 0, 3))
+		return 0;
+
 	if (adev->asic_type >= CHIP_SIENNA_CICHLID)
 		return 1;
 
-- 
2.48.1



