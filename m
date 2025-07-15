Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8DA7261B;
	Tue, 15 Jul 2025 13:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585372; cv=none; b=O+5k2pzwzJh5j0KOd1eERhkaSoDSwnS9HYIBVKbTfsFo6Qm0epH+UJ/FYo0lycIPsN0FVGf8ZPBxt8NHtd0ABxVeaUC+schzEjOTNwKdbE67GdoVNBIXHeyArNP0h1RLemZPX4l8FdvEsADDT3HKFqk1Uw0DNOtvPlqN0yjMKwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585372; c=relaxed/simple;
	bh=glxWDdrLPpiDLpPijdWqeG7qEg2zRJ9kKiZ8nL/pGjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/ziVGosTETkbuTj8JxOU/w5JU6icugkqddTCvrFzcZc+d/DV2WjTE3hbPOa8r+wmo3Ztr4KUp45FbC2OC3A+l3GIDEkvBOcw62TwhDwS/ioeAkNgKAauQqetfLTTglyy/jRIqZMGkz7OFRJgpqBZg1gShs5Uv2xnb1tWgv14ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LslOsf+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LslOsf+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30C5C4CEE3;
	Tue, 15 Jul 2025 13:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585372;
	bh=glxWDdrLPpiDLpPijdWqeG7qEg2zRJ9kKiZ8nL/pGjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LslOsf+qK1p8SzuU+jx1mRPa3iTeEcPVZh8cdYsY5ZPURId3n251SGMVsJ4pwJy4m
	 c3gaHSRIVgSftejuDSkJdjvaGIc8rJDb3WNIrRjTkmn1L02hHyMT/ld8BpsVXsJyg2
	 JZkswuy2kHxZqO/FsoMSUoyjHoTbyHUhgDhkv5Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Flora Cui <flora.cui@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jonathan Gray <jsg@jsg.id.au>
Subject: [PATCH 6.12 003/163] drm/amdgpu/discovery: use specific ip_discovery.bin for legacy asics
Date: Tue, 15 Jul 2025 15:11:11 +0200
Message-ID: <20250715130808.918080565@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Flora Cui <flora.cui@amd.com>

commit 25f602fbbcc8271f6e72211b54808ba21e677762 upstream.

vega10/vega12/vega20/raven/raven2/picasso/arcturus/aldebaran

Signed-off-by: Flora Cui <flora.cui@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Jonathan Gray <jsg@jsg.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |   28 +++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -112,6 +112,12 @@
 #endif
 
 MODULE_FIRMWARE("amdgpu/ip_discovery.bin");
+MODULE_FIRMWARE("amdgpu/vega10_ip_discovery.bin");
+MODULE_FIRMWARE("amdgpu/vega12_ip_discovery.bin");
+MODULE_FIRMWARE("amdgpu/vega20_ip_discovery.bin");
+MODULE_FIRMWARE("amdgpu/raven_ip_discovery.bin");
+MODULE_FIRMWARE("amdgpu/raven2_ip_discovery.bin");
+MODULE_FIRMWARE("amdgpu/picasso_ip_discovery.bin");
 
 #define mmIP_DISCOVERY_VERSION  0x16A00
 #define mmRCC_CONFIG_MEMSIZE	0xde3
@@ -400,7 +406,27 @@ static const char *amdgpu_discovery_get_
 	if (amdgpu_discovery == 2)
 		return "amdgpu/ip_discovery.bin";
 
-	return NULL;
+	switch (adev->asic_type) {
+	case CHIP_VEGA10:
+		return "amdgpu/vega10_ip_discovery.bin";
+	case CHIP_VEGA12:
+		return "amdgpu/vega12_ip_discovery.bin";
+	case CHIP_RAVEN:
+		if (adev->apu_flags & AMD_APU_IS_RAVEN2)
+			return "amdgpu/raven2_ip_discovery.bin";
+		else if (adev->apu_flags & AMD_APU_IS_PICASSO)
+			return "amdgpu/picasso_ip_discovery.bin";
+		else
+			return "amdgpu/raven_ip_discovery.bin";
+	case CHIP_VEGA20:
+		return "amdgpu/vega20_ip_discovery.bin";
+	case CHIP_ARCTURUS:
+		return "amdgpu/arcturus_ip_discovery.bin";
+	case CHIP_ALDEBARAN:
+		return "amdgpu/aldebaran_ip_discovery.bin";
+	default:
+		return NULL;
+	}
 }
 
 static int amdgpu_discovery_init(struct amdgpu_device *adev)


