Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025039;
	b=EiO7TJ3z+7PVak/+Tbcuk+5gb/zMA8gGXKUBMtpBTO4BhttD3WigWY+tiUpKT56JlHH0
	 yEN94NXrJnBE2i1Pf92Fk1yraM0SyFg2yDSlN99bELULM/MyjY6ypA/RTL9K0+QBsCRiq
	 rZNLm9v+6v4VBG0v2Gu/miVsPiGAUB7i+g8Yh4Kygxow2HJ177iRPkRkbOD+Orks2WKPn
	 psRIqX/NrmvZNExGnjZpfnGkmjPELU47iM8/vg86PjzpoF4ryJGHxwKDbih1gOC70mKKt
	 XLFA07j8AI1fqzN3MeLRDin7BQwZNb/HjKA1v5cCBMK6imCPHi9NBWuBRQx+6itGsjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IgtvRTsRgUi9tTYAFy2H7qzhb6onYiCEJI75+4v3EDE=;
	b=wi696kxNBGKCaFKDpbai6jIVienzp4gUaIkjut/zl2jaX9HQdkTo4GQx5v+WguaJmqbt
	 oHEmT/zjd5gAyJlsFGFkS244V/JojoY80dOaVp6xMMRQjptEQ/qivf1W8AgTTkUCXiflq
	 aPfABMDIQ7cws7h8RbcJd7asLvIWyaUYdaRglGzz6/7mEJcxn4ZEmTc0gtjIoqfSCB6XG
	 Zm6Sd0xBdgvthbRAp2tc1hy5qMgxZ762KowqJRYPRw41KWwD7NPN8kq6w4uOrOZlHSno7
	 iUo6DiDsWnCK9Zrk7BYO+MnY3wSd70CGCqZhekD2bQbQmH+72AEU3hgGy4uL4CfeN/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HhcYSXQ1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B228606A31C;
	Wed, 18 Nov 2026 18:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HhcYSXQ1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BE81F000C4;
	Wed, 18 Nov 2026 18:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025039;
	bh=IgtvRTsRgUi9tTYAFy2H7qzhb6onYiCEJI75+4v3EDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HhcYSXQ1R5nYdmlyFj+nfLypckroNVrnu6xtBzstnq205x+fjs0Eg1rJkdH37ONXC
	 uXCT7cstxUyX58WDNYfDnrpWiNuFaYwZ8FHgkwgWXuuQeqzJ/JXMJYtPqdPMyjuXf5
	 AfSoAbFbUWju+EnMssAAtvIfq1MwYd9zYA/vw4mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	"David (Ming Qiang) Wu" <David.Wu3@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0939/2151] drm/amdgpu/userq: need to unref bo
Date: Wed, 18 Nov 2026 15:44:34 +0100
Message-ID: <20261118150156.685806779@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David (Ming Qiang) Wu <David.Wu3@amd.com>

[ Upstream commit b665f29a2f93a266183dc8cd5d732f203157613b ]

unref bo after amdgpu_bo_reserve() failure as it has
called amdgpu_bo_ref() already

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: c7ae3b204328 ("drm/amdgpu/userq: fix reading the WPTR at a non-zero BO offset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
index 73e1827816a0c..8310cbebcaf32 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -391,6 +391,7 @@ static int amdgpu_userq_fence_read_wptr(struct amdgpu_usermode_queue *queue,
 	amdgpu_bo_unreserve(queue->vm->root.bo);
 	r = amdgpu_bo_reserve(bo, true);
 	if (r) {
+		amdgpu_bo_unref(&bo);
 		DRM_ERROR("Failed to reserve userqueue wptr bo");
 		return r;
 	}
-- 
2.53.0



