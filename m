Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F8F35F619;
	Wed, 20 May 2026 17:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296913; cv=none; b=XQ2Fc3exEU1szvMobnM7F7F3iX4LE74rY+VBbur/C3Et+F6mr8qeNw0vyB1PmGTxwSa7JbkaKXna9N6kr0a91ocgEhB444VqZhGUEeKywjVocmWU5Ca3j/uaqElbV576BR5Cvzsu0iLadHMKS+CmVxAsCr0wA3GrIgncHoAmZWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296913; c=relaxed/simple;
	bh=UE2JmJBy0ELgYkoOsff91Wj9XHv1QMDpXFg357nvR+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cT2dDnizamWKyL56eY3SLDQEWBoxo9+J7rRdXvXE0lC51c70lSSeZHdzd8m6B9lg5xLw5wgPkqljtsonPJIBygyx6nCOcRBJBXmJO0irYtassA6UxAAJ4B/wlh3ESMYmWeSHv4gx6hFHsPo+6okJv2toARk7PIIkV9qRs70i5Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmgTpG0U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmgTpG0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798831F000E9;
	Wed, 20 May 2026 17:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296912;
	bh=W95LTnKulb1K6NoW0PWXiV02l8HlkYae12XmakIULbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmgTpG0UkWFEQoZG5+BmAwteD1gM5E0wERc8Tf+lDoV68I6TNME3Aja5vj0Sodnu2
	 loi6c0Ln5bO+yYyyVDv998GwUNEMeo8m8z15wR8mOoHA11v9Ln1rRvxfEeNMn3xQ+m
	 GyFeAzo6222mLfvIET/hEi92fdgGS+KV8vQ9UQUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0979/1146] drm/amdgpu/jpeg: set no_user_fence for JPEG v5.3.0 ring
Date: Wed, 20 May 2026 18:20:29 +0200
Message-ID: <20260520162210.388543459@linuxfoundation.org>
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

[ Upstream commit 3b0ea2021351b6b813b34fac940957f1f4fad85b ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: 4aeaf3cbfa9f ("drm/amdgpu/jpeg: Add jpeg 5.3.0 support")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 86ac011ae234c03fb872f4945913391ea1d8862e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_3_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_3_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_3_0.c
index 1821dced936fb..e7546816baba3 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_3_0.c
@@ -661,6 +661,7 @@ static const struct amd_ip_funcs jpeg_v5_3_0_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v5_3_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v5_3_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v5_3_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v5_3_0_dec_ring_set_wptr,
-- 
2.53.0



