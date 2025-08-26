Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1159D299959;
	Tue, 26 Aug 2025 11:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207420; cv=none; b=WHUT4c5hFFJE3+Vyz+P6Hpdpx6DzabkCQHLB9u8yDDR4btO3bV+j5IRTKQTcFkBV2q5McEvW/F7Bd8VsRmdsQA6u984b2JOGXHv7feZaxSw/ks1BWbHjGTDx8RDQzHpGDFx3zU9M78Tm0nrM2uzdSUg9mrRP1imlFkJXFwuhrpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207420; c=relaxed/simple;
	bh=iyw9OrQggBBfACmmVqfpwkp5ehxGBEC6jqGcnqVTfkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyw+jZEl05drd+rPJ8+Ha0vjq2PY712r5nYcoMDZR8EU7W9IrBaC2NB7QWAJFYwHK6PoH9dm+eBucTsTNSluij6ZRuUUsKlogmezPas4u0rcKPII4Fnd1GPOkN6qIrQVkL2DvcDHUzYf2gxpyuYfh7+m7MYsmCrdqpY44Ojn/uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=046LIpRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="046LIpRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2DEC116B1;
	Tue, 26 Aug 2025 11:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207419;
	bh=iyw9OrQggBBfACmmVqfpwkp5ehxGBEC6jqGcnqVTfkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=046LIpRAfuextBE0rmkg8rUEgw2I3fSbGPy1G9UgxYS5VektxvN60Ont9E8uX90RA
	 n4roaOx9fgRHlhbCZ8DPSiwl55dXrU+cFNrPQRFRpCVkYVwQyeMJIWF+FbKHwi+7+h
	 PoisSR4ZGID2fAhse+BoCRPCL5pzsJ95ygIM2qu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 174/457] drm/amdgpu: add missing vram lost check for LEGACY RESET
Date: Tue, 26 Aug 2025 13:07:38 +0200
Message-ID: <20250826110941.675045615@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 81699fe81b0be287fb28b6210324db48e8458d9f upstream.

Legacy resets reset the memory controllers so VRAM contents
may be unreliable after reset.

Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit aae94897b6661a2a4b1de2d328090fc388b3e0af)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3234,6 +3234,7 @@ static bool amdgpu_device_check_vram_los
 	 * always assumed to be lost.
 	 */
 	switch (amdgpu_asic_reset_method(adev)) {
+	case AMD_RESET_METHOD_LEGACY:
 	case AMD_RESET_METHOD_LINK:
 	case AMD_RESET_METHOD_BACO:
 	case AMD_RESET_METHOD_MODE1:


