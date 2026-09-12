Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA2947045A;
	Sat, 12 Sep 2026 11:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214203; cv=none; b=KzukKuHXTEx/S3fqCQPfKy3GR9WtOpq4rhqZ8pWxdnugbA77BsdX5wu88pISwgGvnD4IUTX2d71+0tWH91bLNmPk7Lpz8w0BLZw8KRGJIHoNSAUk1zP1ScxwXTybBbNl7QSBXWBtgfYD7RVm5sH6JQR4YUIbpaaQIYBGk5xKBaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214203; c=relaxed/simple;
	bh=eit6ldxwj7YUddh3vvkyHQBv1FGfUjn13lZ8dnP8PuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMnSb6uH5XaHPEJRhS5pZypG4ZuC+Zqy8gOfIwT36GCcCVXPbrvkIYl88WS1NfbDDVItLiRksAyWncU3BoC+8m6wLIewvZUp2A9XNAsNBPQUYg3RJ5wYzAmov3Gee/4tSWiL4f2rFsA4YglyfeDo+s2IBMCp7QzcHFqKk0O0lO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZrkbLzS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZrkbLzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8201F000FF;
	Sat, 12 Sep 2026 11:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214202;
	bh=vK5F/hzpo2xmOO49x4WjUD/iekzfVp4krVQp5rA7nv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZrkbLzSokIVn5jIsfq6fnnFIPbA2dyrlsFyZLPsXJH0W2izf8n0Mz3SlPj0wL+HA
	 FYQljRD3hf1ZY1AJkRtGFesa+/61yAa5YntJpaKeaWtYOAP5xBcITjgcwUfvTshVPZ
	 /1M2jDiaxfmosdUhv3Wgnij97HPYYLHnod+sI1UA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 0278/1376] drm/amdgpu: use AMDGPU_GPU_PAGE_SHIFT instead of PAGE_SHIFT
Date: Sat, 12 Sep 2026 08:45:04 +0200
Message-ID: <20260912065613.742340447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1933,7 +1933,7 @@ int amdgpu_vm_bo_clear_mappings(struct a
 			after->start = eaddr + 1;
 			after->last = tmp->last;
 			after->offset = tmp->offset;
-			after->offset += (after->start - tmp->start) << PAGE_SHIFT;
+			after->offset += (after->start - tmp->start) << AMDGPU_GPU_PAGE_SHIFT;
 			after->flags = tmp->flags;
 			after->bo_va = tmp->bo_va;
 			list_add(&after->list, &tmp->bo_va->invalids);


