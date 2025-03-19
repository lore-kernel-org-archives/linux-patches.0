Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284731EF360;
	Wed, 19 Mar 2025 14:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395135; cv=none; b=qESVvp5qzmYjtK0frrL5P4vBpuJqyVjAW2aI1JZrq5dyNL/P4EmywoZMcBHQa/psQZwmm4gklGp5J15Pv3BS33XdTk+vQXtCp/DhMSTUzeKIAigXRPXm6Z8bboIOqCjBbR4UiwgaqHXH2lcLOr4c0TpVCqcPEtRtg7V8qeJRV04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395135; c=relaxed/simple;
	bh=1mpzWHJCHBqpYCHld6hvNGZjsCQitiX4LZXOpyA9NZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFwjq29w0B64jQDA9k6GbmNpcdAPow3UNTcLn8xux9TMinnizivHyP9SlnJaNxOe8UolclwVqXvDPqoUnH9P6DUivy0F7dC5CAAM2c295xGI15ry5jsikbPG3Mj3yJmx0XJiqjbLUgslO9r5w43oXf8T9LTOA73HK3hhbrc9GUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGmEGkJ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGmEGkJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98424C4CEE4;
	Wed, 19 Mar 2025 14:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395134;
	bh=1mpzWHJCHBqpYCHld6hvNGZjsCQitiX4LZXOpyA9NZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGmEGkJ31OQ9cWDyMvY3E0uEcMu3wyFwkynGMzVpcCCLLd5CWApnugTbZPNvngdNV
	 deNkAi9PDahgrm+p0V3HfihFABsfarhip6Lw58+U/qwMCCVwGhmoGk6r3aUAIXEWy6
	 sjOkPA0KDxoijhuoSRvePB5ea3Gr23jWpQZiENYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 200/231] drm/gma500: Add NULL check for pci_gfx_root in mid_get_vbt_data()
Date: Wed, 19 Mar 2025 07:31:33 -0700
Message-ID: <20250319143031.786511818@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Abramov <i.abramov@mt-integration.ru>

[ Upstream commit 9af152dcf1a06f589f44a74da4ad67e365d4db9a ]

Since pci_get_domain_bus_and_slot() can return NULL, add NULL check for
pci_gfx_root in the mid_get_vbt_data().

This change is similar to the checks implemented in mid_get_fuse_settings()
and mid_get_pci_revID(), which were introduced by commit 0cecdd818cd7
("gma500: Final enables for Oaktrail") as "additional minor
bulletproofing".

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: f910b411053f ("gma500: Add the glue to the various BIOS and firmware interfaces")
Signed-off-by: Ivan Abramov <i.abramov@mt-integration.ru>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250306112046.17144-1-i.abramov@mt-integration.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/mid_bios.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/gma500/mid_bios.c b/drivers/gpu/drm/gma500/mid_bios.c
index 7e76790c6a81f..cba97d7db131d 100644
--- a/drivers/gpu/drm/gma500/mid_bios.c
+++ b/drivers/gpu/drm/gma500/mid_bios.c
@@ -279,6 +279,11 @@ static void mid_get_vbt_data(struct drm_psb_private *dev_priv)
 					    0, PCI_DEVFN(2, 0));
 	int ret = -1;
 
+	if (pci_gfx_root == NULL) {
+		WARN_ON(1);
+		return;
+	}
+
 	/* Get the address of the platform config vbt */
 	pci_read_config_dword(pci_gfx_root, 0xFC, &addr);
 	pci_dev_put(pci_gfx_root);
-- 
2.39.5



