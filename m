Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E102C22424C;
	Tue,  8 Apr 2025 11:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112434; cv=none; b=DI9RvQLc9zTj9jP5flr1sBZ7z4AdkiPHOkhUat14tHVwqnY+h4tUkuddZoDVU16sO1DHhm+dOwe80BSM1O0MPLamThPN/GbStDFdt7ZuK5K1DRPRfV6r/QnENGVhG5f14qLv2STgULcWJDJkwANRBejoTuinCyXQFXltfGVd6rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112434; c=relaxed/simple;
	bh=EEueIMvJnGT75uzv7AiJsm5k0rK/v9P/JRIkgdXaUAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6Gnv1MxeZ74b+1brR6+ASPTxfvqmT9KRdeqMUY3ueD/3q1E0fhOaVdsQuH29nNJYRuE7J1YGUFknqKP76QxQU/n/z5VSpWk0cCBEGQ7ltEoYnoUs0uUVjjapaZGnvt7nlu6FdnZAT21NMWMCO40ESnb4d3rXEMZ3B0r6lxKocU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqiXIZ3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqiXIZ3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73624C4CEE5;
	Tue,  8 Apr 2025 11:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112433;
	bh=EEueIMvJnGT75uzv7AiJsm5k0rK/v9P/JRIkgdXaUAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GqiXIZ3THQs0XE9wImmv/n6LTv949gTNrdDFVZ+UtWqy+aRrGaJ5uYYxiIi3JRGdM
	 nmHIyrd4tGYAClT2Qclj4lUmBJPMuOZBrhrLapkJl//txpjfmA9IesJF280Y0m0xxW
	 MhipiF71ZZwvqoioE43cHxzOUZK9RGp11Yzfhtek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Abramov <i.abramov@mt-integration.ru>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/279] drm/gma500: Add NULL check for pci_gfx_root in mid_get_vbt_data()
Date: Tue,  8 Apr 2025 12:47:29 +0200
Message-ID: <20250408104828.122979018@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 68e787924ed04..1ba33f9518da2 100644
--- a/drivers/gpu/drm/gma500/mid_bios.c
+++ b/drivers/gpu/drm/gma500/mid_bios.c
@@ -280,6 +280,11 @@ static void mid_get_vbt_data(struct drm_psb_private *dev_priv)
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



