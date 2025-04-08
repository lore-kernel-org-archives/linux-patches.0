Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26008267B8C;
	Tue,  8 Apr 2025 12:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115408; cv=none; b=uAtGxHE5ugMX8SJ4Ze64Gv/kuH+SO5pVh9nwO8pt4I4IAOJt1yfH1c89FuYCFhawWQRtasWu/5u/AdDj9hKHROhc9Vtvq9ZM5C/S1soRNTYZJ0QkMo/mufcGX+vx3O3Ttd2onRyFVEndlydW9R0xSi8ohcj1WXmqxxNUHJcwJkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115408; c=relaxed/simple;
	bh=kyRSZvBx4je1ZwKGCawvcvPemdr/C9G0f/qY/nH3410=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+Wugb9WZ2pqjvfU5AIxCEWKsJXARLGkk1Yzxhl6KFMMwfOsw2xk3+Z4RBlsBMX8M9rRQVYPDHNaXSdAt62UEEmaN4e2mEfPE1PZUT+WfPAvxB2TXhDc3dLQv/VhxWH2uv675njAJO+MVAb/K4i2Pald7d6xF0vPX2qIzlQrVTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VIWaI+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VIWaI+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48064C4CEE5;
	Tue,  8 Apr 2025 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115407;
	bh=kyRSZvBx4je1ZwKGCawvcvPemdr/C9G0f/qY/nH3410=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VIWaI+kV7zeKBlglD9H06UzXpdpeq9UxzPhQA2oE469uzFS1smoGF2/I4VsU3viB
	 2AqmDN8OT47giuujtGRuBqh26nVk+Ym2rNK2CwFr3O4PdObIuqHSZym2cMoqBuwSB/
	 pdGeTl99gZqesGvXGgkw8ZvA+6X6qfruRwx7Qtac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 461/499] Remove unnecessary firmware version check for gc v9_4_2
Date: Tue,  8 Apr 2025 12:51:13 +0200
Message-ID: <20250408104902.736088004@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Candice Li <candice.li@amd.com>

commit 5b3c08ae9ed324743f5f7286940d45caeb656e6e upstream.

GC v9_4_2 uses a new versioning scheme for CP firmware, making
the warning ("CP firmware version too old, please update!") irrelevant.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1269,6 +1269,7 @@ static void gfx_v9_0_check_fw_write_wait
 	adev->gfx.mec_fw_write_wait = false;
 
 	if ((amdgpu_ip_version(adev, GC_HWIP, 0) != IP_VERSION(9, 4, 1)) &&
+	    (amdgpu_ip_version(adev, GC_HWIP, 0) != IP_VERSION(9, 4, 2)) &&
 	    ((adev->gfx.mec_fw_version < 0x000001a5) ||
 	     (adev->gfx.mec_feature_version < 46) ||
 	     (adev->gfx.pfp_fw_version < 0x000000b7) ||


