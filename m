Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212851;
	b=4EgkV3hL5WffuCgP1Ov8xgPLv45N0mHV+KyV/4O6Gsi8lnG1mW9Vipm1tG42xS7wSf/E
	 32/U/xXxqEPKn/dMujBXvnrfaIOs7i8wUzxSqFCRR4XhdO1qlUzmvP12v3r5BKfnTpIeq
	 KRolpMZLScE/tW0czpU+5EGlWlzAvBfohUEO8gZ/ODEBQqhL1uW4dTiJjqtCw8tKv0B6g
	 r+tF21bVn0PA9LO/ehuJ1UX89MxIY4REMSCHdWD4sQwMDi+ThtWBfxF8NOjEQIOP7RyaD
	 1YTy7USI+O0QyJvvpkaDNUJDDHAVUMHP8KwhswFPeiY64XlazVoSVgyhRC7aKVHvsyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CR26gf9GkTBNIUYwf0Nvn4HTDulMUqRnnH7CixRDp5g=;
	b=31NGjEN8IrpfnrFUQDDEL4YtR4GnfhyLJf+N7AOwYfsxs4YE4byg12RqAsyRmJykarcw
	 i1TmbVnRv3c5gcs58pemuxdBW83XL1tBm3lw0iwsmeA/3LMHsu5E82WJtlfH89XQNybcX
	 NLV22RZtbyABF83JXG7t5CmVVlNzQ4w+taRZTMl8MJ5C+b2y9Oe/tHHux6WqKQ2u+nSJX
	 QmvFxPY3nxcyO89ZwAeAPHyL7jDymR74VonIOnrbdTflYeIHw+BR1CkwXLzNQwt/aGshW
	 AKhtLhT21VrPTfBQbnkWyPB8GqCegPp4iunr+Ek43UmvV4AQCfBt7MRYZHS6wINl0hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztwKC8YL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A0C606A31A;
	Wed, 28 Oct 2026 18:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ztwKC8YL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA541F01825;
	Wed, 28 Oct 2026 18:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212851;
	bh=CR26gf9GkTBNIUYwf0Nvn4HTDulMUqRnnH7CixRDp5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztwKC8YLRutGlZiCU9eWCv85yeMVwXeU84MIGgpT9UlQPi3VfMmcZypqzZcWlgAgb
	 Q3O0cj9RY9C+0e6hKK7y9OunVGru1+Eyv5mhengGpTdQnm+YTl9RPyNLDOJgsJAY3I
	 lbJlcmeY+eSB4pI0HQuiZQG7TGQSiJ1Y520NOwjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 0256/1887] drm/amdgpu: fix ACP MFD device leak on init failure
Date: Wed, 28 Oct 2026 17:39:12 +0100
Message-ID: <20261028170505.056188584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit f0013046151b7467e62c471c1c83d63ea255799c upstream.

acp_hw_init() registers ACP child devices with mfd_add_devices() before
attaching them to the ACP power domain and initializing the hardware.

If attaching a child to the power domain fails, or if the ACP reset or
clock enable operation times out, the failure path frees only the
source cell, resource, and platform-data allocations. The child
platform devices already registered by mfd_add_devices() remain
registered and are never released.

Remove the children from the power domain and unregister the MFD
devices on failures that occur after mfd_add_devices() succeeds. Keep
mfd_add_devices() failures on the existing cleanup path since the MFD
core already rolls back partially registered children itself.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: 25030321ba28 ("drm/amd: add pm domain for ACP IP sub blocks")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 63da68d6a2279ec945581c990c5a59a5ae8b5560)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
@@ -324,7 +324,7 @@ static int acp_hw_init(void *handle)
 		r = device_for_each_child(adev->acp.parent, &adev->acp.acp_genpd->gpd,
 					  acp_genpd_add_device);
 		if (r)
-			goto failure;
+			goto failure_remove_mfd;
 		break;
 	}
 	default:
@@ -446,7 +446,7 @@ static int acp_hw_init(void *handle)
 		r = device_for_each_child(adev->acp.parent, &adev->acp.acp_genpd->gpd,
 					  acp_genpd_add_device);
 		if (r)
-			goto failure;
+			goto failure_remove_mfd;
 	}
 
 	/* Assert Soft reset of ACP */
@@ -464,7 +464,7 @@ static int acp_hw_init(void *handle)
 		if (--count == 0) {
 			dev_err(&adev->pdev->dev, "Failed to reset ACP\n");
 			r = -ETIMEDOUT;
-			goto failure;
+			goto failure_remove_mfd;
 		}
 		udelay(100);
 	}
@@ -482,7 +482,7 @@ static int acp_hw_init(void *handle)
 		if (--count == 0) {
 			dev_err(&adev->pdev->dev, "Failed to reset ACP\n");
 			r = -ETIMEDOUT;
-			goto failure;
+			goto failure_remove_mfd;
 		}
 		udelay(100);
 	}
@@ -492,6 +492,11 @@ static int acp_hw_init(void *handle)
 	cgs_write_register(adev->acp.cgs_device, mmACP_SOFT_RESET, val);
 	return 0;
 
+failure_remove_mfd:
+	device_for_each_child(adev->acp.parent, NULL,
+			      acp_genpd_remove_device);
+	mfd_remove_devices(adev->acp.parent);
+
 failure:
 	kfree(i2s_pdata);
 	kfree(adev->acp.acp_res);


