Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947DF3793AC;
	Mon,  9 Feb 2026 14:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647185; cv=none; b=foZO5Y4iXs7QtR14CotTVbeRDHSzumJPJQjZEUfDwDm4ipkWDcdm20dCPueJGeza8avluU6xs4MoVQKnTqTw2Bjpm+Dce4TvcNoHjqheLyz/wP+KtBsXkUb7ktZbNhmwENf7u4nQvcosCNaybVDlDQKnG4JEFQo3GsI8Caim4ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647185; c=relaxed/simple;
	bh=RDRmghd8owoHJeBXLyBBHNg6uRYEpiwxi//mRNVPddg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tJPfsFLYMrEuJ5PQqJ36p9IXK+3h719HW2NErpd8uVS78Aw9IcpB5823KtadvwWwuz7ndB7kGNnyRkln/2hhDxD+CoBxGxQyXRPvZUEizfp06eQFmoLLZ2pcmma7YtzoLSIg1qxJmZkxQ22JHJnSyE69+4/O9QkARrk7D4VwmdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxpH3u9k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxpH3u9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C397DC19423;
	Mon,  9 Feb 2026 14:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647185;
	bh=RDRmghd8owoHJeBXLyBBHNg6uRYEpiwxi//mRNVPddg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxpH3u9kJ0HJZxLyrzTy+zHZYM5Po5drxUcU6SA5fVqeW3hHdE+f222YjAmYtAjeG
	 Yzmw6or5T4Su9pO1WgXwvbYtfbGX9/OeE99jTLhFYN4egqgVOcxTG2HwtVMAEbAcNr
	 MCRAOYsfGtAvS5FwkqhMuOhYRn+v/VUq9IzzSf0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 025/175] Revert "drm/amd: Check if ASPM is enabled from PCIe subsystem"
Date: Mon,  9 Feb 2026 15:21:38 +0100
Message-ID: <20260209142321.385269001@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bert Karwatzki <spasswolf@web.de>

commit 243b467dea1735fed904c2e54d248a46fa417a2d upstream.

This reverts commit 7294863a6f01248d72b61d38478978d638641bee.

This commit was erroneously applied again after commit 0ab5d711ec74
("drm/amd: Refactor `amdgpu_aspm` to be evaluated per device")
removed it, leading to very hard to debug crashes, when used with a system with two
AMD GPUs of which only one supports ASPM.

Link: https://lore.kernel.org/linux-acpi/20251006120944.7880-1-spasswolf@web.de/
Link: https://github.com/acpica/acpica/issues/1060
Fixes: 0ab5d711ec74 ("drm/amd: Refactor `amdgpu_aspm` to be evaluated per device")
Signed-off-by: Bert Karwatzki <spasswolf@web.de>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 97a9689300eb2b393ba5efc17c8e5db835917080)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2334,9 +2334,6 @@ static int amdgpu_pci_probe(struct pci_d
 			return -ENODEV;
 	}
 
-	if (amdgpu_aspm == -1 && !pcie_aspm_enabled(pdev))
-		amdgpu_aspm = 0;
-
 	if (amdgpu_virtual_display ||
 	    amdgpu_device_asic_has_dc_support(pdev, flags & AMD_ASIC_MASK))
 		supports_atomic = true;


