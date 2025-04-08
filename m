Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E43C2192F2;
	Tue,  8 Apr 2025 11:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112145; cv=none; b=SL77/09gIuuUjE22M/GZEkKyH6ahQAtUnHXhAEi715sDGE2vZuoCU14Oq+Ukc5uEbm+YaxdhH6ZmBzpcl0DGsHgizAexWKC/oTnmNqsg1qyPJiH4ipGbHPvzsNlp2BjnHLUtZ3WU96e5Fa1XAOtkQ3hvdeuOIVemlZuo16758ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112145; c=relaxed/simple;
	bh=nDmL6XNdbFdwHMF91uN1i31V71yqi+E8kHaqo71qJuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGSovXsM1jYgEP0Sd17m4G/UG+XbuAR9l+3Uk1Lztik/a4ByfNaWykQ5VV6k7i6O5Tt+42x7s066k+kkCwOTrQlX8vmjqIkER0HQMkAsJVzlGRXg1T70SxTat8Pm812xZKHWkv8Iku1ymhyG6egB0UWA43igCo5If/BFdAAIZdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBeNXEdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBeNXEdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BA2C4CEE5;
	Tue,  8 Apr 2025 11:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112144;
	bh=nDmL6XNdbFdwHMF91uN1i31V71yqi+E8kHaqo71qJuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBeNXEdFSPbA5BYKaC8NQimsvAHJR54DkUXz8whrefHcJ1KmHlEe38VktlGjVwfhT
	 vM6Gz5eWf4NZ5lZnFOhjOCnP/jWZYQc/frCsiHI4ayyUclLId+FSA2YHPPFtbBiKI7
	 njxBO/Owo39+X7xolVx1+DULSeD/NEf+i4bX/Lbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 693/731] Remove unnecessary firmware version check for gc v9_4_2
Date: Tue,  8 Apr 2025 12:49:50 +0200
Message-ID: <20250408104930.387495808@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


