Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC421E8320;
	Tue, 16 Jun 2026 15:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623590; cv=none; b=kpQFBjvslNh3SvDT3gC/ylrT2cWr7zH03hdMoL9bFokA67hNq8XT9v6Kx2qpQ6nWYFwVahz4ZTrL6F4Kgr0EtJRYqKzQtRjVDOz0WlmKnKemOwluQCGWrc3ZeuaJ0GAjPr1Z57EmPBoxij0bu6/t4UNI1ahhcVtCQpeZumTbvdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623590; c=relaxed/simple;
	bh=GKseS2nDQqsH2EfBMmsEfE7zvMCoGTUd/ftM2Y06XN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofHiEkpJzH7wWjR3DdQk3IWMUQ4p4JiRifZ3zW//YGm/nqCiQj1w0IqHpw8CDrxI4ZLpb7qVxRGVTnoRx4g0NfMk2TC9hAy3TJYqNToCSvdfq5IMRSuHM3XRLUZfFk39a5PwJMrhbNaW/lgO/xAEqG0kJBg/tfJYmiONZmd1XXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8kZOODx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8kZOODx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486D61F000E9;
	Tue, 16 Jun 2026 15:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623589;
	bh=Paghg2JuevHuXRSlecRZPXH3NdgoMipYRh04YECAFMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8kZOODx7wEUzVBmEr4nN7hTZffpBcUfawbhfUMaES6Z7PB6ydHXBqok0/bBMQ2jv
	 KltSFgwG1GdRTax3PmhEUALeaFiITZ8xvzhv9S2xrKbRHBI6NhK2Y4dj6N0vlGb+FI
	 Y1isuFjaOGMNLa3FCysSS1a7Yj+CGtBUHIOIAAbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>
Subject: [PATCH 7.0 176/378] Revert "drm/xe/nvls: Define GuC firmware for NVL-S"
Date: Tue, 16 Jun 2026 20:26:47 +0530
Message-ID: <20260616145119.637881964@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

commit 42445de1765547f56f48d107c0b8f3482c98458e upstream.

This reverts commit 4e88de313ff4d1c67b644b1f39f9fb4089711b71.

The early GuC FW definition meant for our CI branch was accidentally
merged to the drm-xe-next branch instead. This GuC FW will never be
released to linux-firmware, so we do not want the definition to be
available in the mainline Linux codebase.

Fixes: 4e88de313ff4 ("drm/xe/nvls: Define GuC firmware for NVL-S")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Julia Filipchuk <julia.filipchuk@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: stable@vger.kernel.org # v7.0+
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20260529193558.185436-11-daniele.ceraolospurio@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 65b8e0ac86e48cfc9128c04dfc53ea3395d030dd)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_uc_fw.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_uc_fw.c
+++ b/drivers/gpu/drm/xe/xe_uc_fw.c
@@ -115,7 +115,6 @@ struct fw_blobs_by_type {
 #define XE_GT_TYPE_ANY XE_GT_TYPE_UNINITIALIZED
 
 #define XE_GUC_FIRMWARE_DEFS(fw_def, mmp_ver, major_ver)					\
-	fw_def(NOVALAKE_S,	GT_TYPE_ANY,	mmp_ver(xe,	guc,	nvl,	70, 55, 4))	\
 	fw_def(PANTHERLAKE,	GT_TYPE_ANY,	major_ver(xe,	guc,	ptl,	70, 54, 0))	\
 	fw_def(BATTLEMAGE,	GT_TYPE_ANY,	major_ver(xe,	guc,	bmg,	70, 54, 0))	\
 	fw_def(LUNARLAKE,	GT_TYPE_ANY,	major_ver(xe,	guc,	lnl,	70, 53, 0))	\


