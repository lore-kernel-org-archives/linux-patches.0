Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FB53D75D3;
	Wed, 20 May 2026 17:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296878; cv=none; b=XzJhh6iVlO0hjfY2InCj9jO3mv3ft5WHGQjti2/z5Sv/n5X1yKJNtCGk8FcTwDrNN1kOqkk3YzMKnPmnATb8En/tHqEAFYmxVk06rerImrjKy/jyJVkEFF8dQ0n2NE8cnUNgHnIKj5UwgdOnLGj6Z8CYJQz8gIeqjUrxiHeb2n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296878; c=relaxed/simple;
	bh=yB3kPEarXHZtMlw6xKrXu2pIhM56hIVfhxnQnCE2P4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SHWzXLGMdiQruFF8ln2blvwQauMY+1LOcBv52bi9Ryi+AKecR6ms7az8gWxagjeoVqGwLrUQmaG3yDWzpOEeP+Li9JNK4nQ9otpIIupUfGVxh7vjST2E9faHJ/CmUCuIIe2d+BaId8YXhXyua3LJdvZP4Vnzwzj7LLnoNLARfq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=konYii3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="konYii3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3734D1F000E9;
	Wed, 20 May 2026 17:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296877;
	bh=mrXUgFN9Fb8tFrYe1A0xdvSZW19/5FjDoMBCnwUeihQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=konYii3W/Aqr3+rJ4bQ+IbBzy+pxg+vyroEYrSe1zhG4hjYLxOh16So+m/BIrdDQr
	 Q1AghhAYBx4zoCmA/djK+ufjGNoMN2UCV5FxhDyROFcHu1etBgbW4huZdluld7NRRD
	 o8nftnBtlaWKazYk68vo4jzPkUnZm/ijeDDtFPtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0967/1146] drm/amdgpu/vcn: set no_user_fence for VCN v4.0.3 enc ring
Date: Wed, 20 May 2026 18:20:17 +0200
Message-ID: <20260520162210.114434871@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit 4532b52b34e4e4310386e6fdf6a643368599f522 ]

VCN encoder and decoder rings do not support 64-bit user fence writes,
reject CS submissions with user fences.

Fixes: b889ef4ac988 ("drm/amdgpu/vcn: add vcn support for VCN4_0_3")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ff1a5a125c5a70c328806b9bc01d7d942cf3f9aa)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
index e78526a4e521e..210e41cf29374 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -1758,6 +1758,7 @@ static const struct amdgpu_ring_funcs vcn_v4_0_3_unified_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v4_0_3_unified_ring_get_rptr,
 	.get_wptr = vcn_v4_0_3_unified_ring_get_wptr,
 	.set_wptr = vcn_v4_0_3_unified_ring_set_wptr,
-- 
2.53.0



