Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEEEA94A;
	Tue,  8 Apr 2025 12:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113858; cv=none; b=r32kCQn3IlC04x1kM5b5Hp1LcAfhqyWNvEcgDtDNEnElc/0Wu7PCPDAPeT5OLqWuu1FDklkBKVO1JKZnU8WImhfD9BR7zhw/BN3QG7aCkqsg9S//yyOt3P371zWCmfFqhEGdospxJMYXNkIeXXiFb9HT6VJIw9db1DbV95iGBnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113858; c=relaxed/simple;
	bh=BusHMXEzY6/ciIvI8vX48KUFIV/E9sNHhv1awQKubVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jn6iaSbKO8vMQVZRHiiVeKYn+vT25nMPPR8T/Rm5LqOBjhGCg13YBC7sr/rgt/Bk7nk16hVZ+HJ6BORgO0XDX1SG5TGZ+zkbrLlr1PXRul96K3xmxH3z+l09r97BQuRviv67suMGRX/iWHGa3SqPRUgqgsnmmxTNrNXdsPyQ9ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3/sd88M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3/sd88M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D2DC4CEE5;
	Tue,  8 Apr 2025 12:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113858;
	bh=BusHMXEzY6/ciIvI8vX48KUFIV/E9sNHhv1awQKubVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3/sd88MCRFVOMUmAZhJzbWUNJYwmBiYdGZpMw2i7xoSWQMyZ++3N6c/hfkp4r8Oo
	 Vf+etxoQnElvyL9AC5VzzlvD1kM7Bo87xneQaS+Ezl/eeR2rFWS9FQJtyYJTuwT9VP
	 dJTcWVBlV+e9rUzzlmMt0u5tn8U9j6qZOMaVXPAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/154] drm/gma500: Add NULL check for pci_gfx_root in mid_get_vbt_data()
Date: Tue,  8 Apr 2025 12:49:47 +0200
Message-ID: <20250408104816.751080359@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8ab44fec4bfa4..b76b86278e0e3 100644
--- a/drivers/gpu/drm/gma500/mid_bios.c
+++ b/drivers/gpu/drm/gma500/mid_bios.c
@@ -277,6 +277,11 @@ static void mid_get_vbt_data(struct drm_psb_private *dev_priv)
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



