Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53901D04A2;
	Wed,  2 Oct 2024 13:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876744; cv=none; b=Y6951f9k01/5ClG+LklPjvdwVEYs0EQGsJ3tKzrjlffQeO5TUQU4euM49z7lpmaTLbM/1qWehH+58I4r027Z48lT7uBKMDap6xjXHOGTpx2+JwPP+TSN6RUN0Wg2hAJhSkWUDNuKyztlG291irhGNNUyk2tI92EaTZKebnTuWE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876744; c=relaxed/simple;
	bh=KGhh41MHWdfXAfMtNzdK6T+98akvUzzzHf4GIvsNZ0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R8JE9BAogPT2MpD1C0+rB66IhBOjTH8HLl+G5dbtNcSir02LPdctOcdbyP4QmCKYt7pG3f5pmMJF4gS1PJ8M9Y/Q9UdkJM55rn7lNghI75Kt0WOAe79ndd7z0RAzR0aPp4hHOQ+lcSS4hJVSiAlOLiBHNTM7jBf3exbNjHwJjq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkqmOzNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkqmOzNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F124C4CEC2;
	Wed,  2 Oct 2024 13:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876744;
	bh=KGhh41MHWdfXAfMtNzdK6T+98akvUzzzHf4GIvsNZ0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkqmOzNPa7qdcSy3SyQ0ijCPWKcINsFIreS1f1YiEJGxKoEG49cDiVP+GaQmBDoeV
	 Q39IAxoA68DoH2XCOQT0B56MYHKt8RG4a+6fnVxM+oUb+ivugL6LeqaZnVD6QM6kq2
	 QoWHLjulKO9BEhJlEHvlvdIJe/0/El8BAfmZQfFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 548/695] drm/amdgpu: bump driver version for cleared VRAM
Date: Wed,  2 Oct 2024 14:59:06 +0200
Message-ID: <20241002125844.379019766@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 34ad56a467c320d07db22146cfb99ee01704a5de upstream.

Driver now clears VRAM on allocation.  Bump the
driver version so mesa knows when it will get
cleared vram by default.

Reviewed-by: Marek Olšák <marek.olsak@amd.com>
Reviewed-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 86cff30d5c4e..db0763ffeff7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -117,9 +117,10 @@
  * - 3.56.0 - Update IB start address and size alignment for decode and encode
  * - 3.57.0 - Compute tunneling on GFX10+
  * - 3.58.0 - Add GFX12 DCC support
+ * - 3.59.0 - Cleared VRAM
  */
 #define KMS_DRIVER_MAJOR	3
-#define KMS_DRIVER_MINOR	58
+#define KMS_DRIVER_MINOR	59
 #define KMS_DRIVER_PATCHLEVEL	0
 
 /*
-- 
2.46.2



