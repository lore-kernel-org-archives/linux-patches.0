Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAA22571DC;
	Tue, 25 Mar 2025 12:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905721; cv=none; b=fjIkYwS8QjRhwm8sWYySo0G5i3LzoElMoNfBSAWySgfXK2zlHFJBbYEMUP9peleq79Fsole/9sXAwr+B43jdZvh5otAczQswwpOpdt/sRyBt7x0sy+71fCbV24JLOGv1jMaE6CrHPhrSIPOL1XthjHprAsDFE89ciLCw9ykFKp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905721; c=relaxed/simple;
	bh=SES/wls+wQAxyGV3mJ3jxTmRJj8DJxU41vL+o98Y/eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ja3TOsRsgXixWPQh5qEKJ7h/n3hpS5q3rxiYRtzMZXU5XKgAmZVr6MPXyXnp5XWMkgWZpYx6Xt6paKrl5hA67jor3nIRKC4xeB6Y7x/C4V6XeOybBQXPpOA3NMMK2+/emDrYJ5I8h6haXyjGHuyxR/3tAVUbwvM57ojQtMcRMNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4/h1OPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4/h1OPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77BDC4CEE4;
	Tue, 25 Mar 2025 12:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905721;
	bh=SES/wls+wQAxyGV3mJ3jxTmRJj8DJxU41vL+o98Y/eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4/h1OPcpJh1z/WPy0erzJO8QiyY9fSaSkE9GzpZJOEUKc2Ef5BEMEy0ksWQgDwwv
	 s/YDXvnHucDXG1jNs4r5a2bsdGvLs/d0LOjlYkLxA8zwJ/CJrG/Eoh0rWRVpvK1/VC
	 +boEEIgNchV4K0J2R6gnmfWirS6uwVnI2SDo6/So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/198] drm/gma500: Add NULL check for pci_gfx_root in mid_get_vbt_data()
Date: Tue, 25 Mar 2025 08:21:29 -0400
Message-ID: <20250325122159.983644921@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



