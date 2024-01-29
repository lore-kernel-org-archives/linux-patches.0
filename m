Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F3B15B984;
	Mon, 29 Jan 2024 17:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548292; cv=none; b=SViRz+2Rsg7aWkO3OxIXU3sO1s79ZaItTA0//zS01hZYC8BUpJ/njpiyhc+cTWWS08GHVQWOOPdtUgqowLjBJ/G4Hgzq4LF14JzFF6ZcNl1zlChACXNrHPOnfFoA7uyGwh7hmKYT9A1SCVybYlYWrKH5NVaF5/R1eKzOy2s8a8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548292; c=relaxed/simple;
	bh=SLDJYWERrcKrJE8oB3JXzpK9X7B7cAvnRRCTc9DdRGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4dh9X8oxXiKQBIN5TQGQ/erAUPrbTK3JDdJ1oEyaPbtf+pfGfwQLpBEdwRe7PhDXqJoeR9yo0lenBc9/jbr/xpwCbPGWibsYXa/p+JZALrG6Ye7mt1hDUcusASUsDUgYvgOZ505Cz0e9waMzn/nrP8eEAx4X1FZNb+u1WnInY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxrj2zlF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxrj2zlF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A18C433A6;
	Mon, 29 Jan 2024 17:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548292;
	bh=SLDJYWERrcKrJE8oB3JXzpK9X7B7cAvnRRCTc9DdRGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hxrj2zlFpWHAsLtT72P6jWrMVPntEjtvpGlaFzpDIKB3kaENRhbPH/HROU2i3Xf+v
	 d+3NToW2X8ogOeLg5hL9/kC/q1TN0u7bGtS6Ltx5xSoggSRk4n9s4HDngT5VKx6yjk
	 txqnr04tnqsJiQ2sC1IqXcOyvrnKUoiyjOnWfDmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Gray <jsg@jsg.id.au>
Subject: [PATCH 6.1 074/185] Revert "drm/amd: Enable PCIe PME from D3"
Date: Mon, 29 Jan 2024 09:04:34 -0800
Message-ID: <20240129170000.982017312@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Gray <jsg@jsg.id.au>

This reverts commit 0c8d252d0a20a412ec30859afef6393aecfdd3cd.

duplicated a change made in 6.1.66
c6088429630048661e480ed28590e69a48c102d6

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Jonathan Gray <jsg@jsg.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2202,8 +2202,6 @@ retry_init:
 
 		pci_wake_from_d3(pdev, TRUE);
 
-		pci_wake_from_d3(pdev, TRUE);
-
 		/*
 		 * For runpm implemented via BACO, PMFW will handle the
 		 * timing for BACO in and out:


