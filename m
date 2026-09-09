Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0C7579828;
	Wed,  9 Sep 2026 14:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963085; cv=none; b=GQKfc01nQ6tI/r3r6rmoMEJL1q9hw7EWpHEpXfXZxWiGAP+J0tPk+7ZaWN3f+cOmG7EA/5GxDpDP/5VzTSQvH8t6Ya6wSjWun/2mpDlBt+U5mYhWfDVZrmCUvtghmzs8DXjZlqpRxJNiVZQAT9GQzWWz233pwAtQDAMCXvpog7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963085; c=relaxed/simple;
	bh=CPgPR1d3PMRsKQ2WrdORFe4hz3EWlwYSzAlOvVyzvQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHI7uUXzPxYkZkCA12bGtf45yttNx3xtlDMxV56sRHZ818w38OZivtzAJeBH4pHIBpnzY9SEmgusoaflYovDeWOsljPw3oj0ORvmIhC+uu4uVh/8A4S8zZtZLOwaaLBlcfa+b6dFnQrKGarO2fyRtkJIlVIqiF6vtffItBl93p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aebx5Y/P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aebx5Y/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900E71F00A3D;
	Wed,  9 Sep 2026 14:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963084;
	bh=uNcVAh3l19aiy2uc1VyTkG4VokmdKuhloIQ/vIHAmyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aebx5Y/P/D0MaT6ojqiJ8nhz6UwAVDid2LO/toQgm0ho+/A10nfihnVRt8AgUmSfE
	 34RX3w18HZJPhfHcD+WOtOfwMlA7/GL1dWa7KHl3IpoG5puAtswl/UhR30P3JMIv+H
	 Wr7Jvi3NKMeK63Va+6R312xxzZRY3Qf0yMuLx608=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 513/556] drm/amdgpu: use AMDGPU_GPU_PAGE_SHIFT instead of PAGE_SHIFT
Date: Wed,  9 Sep 2026 15:43:13 +0200
Message-ID: <20260909134248.491574028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

commit d6e16df7df4d2c39e2b04b355d0434fb90e2d62c upstream.

For different address types the variable PAGE_SHIFT might
not work well and it's better to use the GPU specific one

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3494b77d10375e0f9ab784e9b20763339844b55b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2064,7 +2064,7 @@ int amdgpu_vm_bo_clear_mappings(struct a
 			after->start = eaddr + 1;
 			after->last = tmp->last;
 			after->offset = tmp->offset;
-			after->offset += (after->start - tmp->start) << PAGE_SHIFT;
+			after->offset += (after->start - tmp->start) << AMDGPU_GPU_PAGE_SHIFT;
 			after->flags = tmp->flags;
 			after->bo_va = tmp->bo_va;
 			list_add(&after->list, &tmp->bo_va->invalids);


