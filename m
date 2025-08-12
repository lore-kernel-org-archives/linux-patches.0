Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E38F217F35;
	Tue, 12 Aug 2025 19:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026426; cv=none; b=U/1IFLIt2VnkzhJxbICSGpG8JWhtH75Z8LUDNkFSy+BnhaoUev9drzv8IESjXTvBzx3RRX6J/+iRCRtXHgTyaxVlQF9XpslDRrqC3wO58zGhnnZUGyy2L/5mrLw7322MWTCOEWrlzfeLuawYGkD8OHmAe71oZdV8UVlFBf+RvaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026426; c=relaxed/simple;
	bh=4sg/xbzWKfl7nz6khxbXgUh1hMZxVcUk1fa+on0OPyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WC/orkH5ihDGfiyNeEHLyxdUTfl6LBLLeNj4h5270EJxgPCq1TWYU8baBczGOrYcSry8czyUn5E2jjQShIzTqGEuzykmjNe1Ncc4ZuAX/SHeDCc0uZsieiGE7LWQlVDKOqtMzWIevFP0jR8TQ/GpkdjBmast7/dZZgf4ZyX1rqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1F7VXg8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1F7VXg8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E47C4CEF0;
	Tue, 12 Aug 2025 19:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026425;
	bh=4sg/xbzWKfl7nz6khxbXgUh1hMZxVcUk1fa+on0OPyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1F7VXg8oZXQ4hnMRbzdQBgXrUPI62fQR6EL+80k6Sh5doorwJMsLIe8v9D7HElUme
	 XDuDuEFqD94J1mCuD454ogLx2oDiHMNXXJm9+6M/o1UUbUbfaUtCT51s+lrbuZaILH
	 gHNc8E8lr9MEarVnH1ApPDfKgZoNeIj36vQ4LWsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanmay Shah <tanmay.shah@amd.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 300/480] remoteproc: xlnx: Disable unsupported features
Date: Tue, 12 Aug 2025 19:48:28 +0200
Message-ID: <20250812174409.803561606@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tanmay Shah <tanmay.shah@amd.com>

[ Upstream commit 699cdd706290208d47bd858a188b030df2e90357 ]

AMD-Xilinx platform driver does not support iommu or recovery mechanism
yet. Disable both features in platform driver.

Signed-off-by: Tanmay Shah <tanmay.shah@amd.com>
Link: https://lore.kernel.org/r/20250716213048.2316424-2-tanmay.shah@amd.com
Fixes: 6b291e8020a8 ("drivers: remoteproc: Add Xilinx r5 remoteproc driver")
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/xlnx_r5_remoteproc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/remoteproc/xlnx_r5_remoteproc.c b/drivers/remoteproc/xlnx_r5_remoteproc.c
index 5aeedeaf3c41..c165422d0651 100644
--- a/drivers/remoteproc/xlnx_r5_remoteproc.c
+++ b/drivers/remoteproc/xlnx_r5_remoteproc.c
@@ -906,6 +906,8 @@ static struct zynqmp_r5_core *zynqmp_r5_add_rproc_core(struct device *cdev)
 
 	rproc_coredump_set_elf_info(r5_rproc, ELFCLASS32, EM_ARM);
 
+	r5_rproc->recovery_disabled = true;
+	r5_rproc->has_iommu = false;
 	r5_rproc->auto_boot = false;
 	r5_core = r5_rproc->priv;
 	r5_core->dev = cdev;
-- 
2.39.5



