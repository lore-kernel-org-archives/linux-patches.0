Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09732EAE5;
	Thu, 12 Dec 2024 15:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016639; cv=none; b=a8NmQyDYkvTvr6j7WYvy7Rns8DfEsEkIdbdIYw7wnE1Q1llizavygNGxRfW67Y2MDhHPzct5OAXoFNOobWSX3A/jgn0wYME9iZft+9x9Yd4DYb15l7+7ua7ON4Z/y25vp+uWJl7iBJzL/Rv+OT9FQ6ZKUqB1nZLn155HZ7n3TSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016639; c=relaxed/simple;
	bh=kJJr+R0wj/IPqXneRa5Bk09HszHWq7qmp44GTYmpp1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+oPdF95/Pp2d4gCLprv5CLaZVgNR6YB7uWmCIAkEHnQ87Kio3wlo6cykL+5yywUYc9Ou3r6XIYN1vzLnUnHVe/pwj2d5vHu8ex9k5nf915YhxOaT0aGfS/MRjmk7f6OOyMFSlddzXLDoBxtRoFAYMTT2Jqkj+Xo+OFsECCaC1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIkC5hPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIkC5hPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8D0C4CED4;
	Thu, 12 Dec 2024 15:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016639;
	bh=kJJr+R0wj/IPqXneRa5Bk09HszHWq7qmp44GTYmpp1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIkC5hPG0uN4Zy6TV1f1UX5bk8POgrfQuOdEz7oeQhBGjaMHsWtEC7Sgumkyh5fF8
	 ghKkSV1J6xlX445+EHA1JoO9WfH+nWdjq5ydph3xCw/dkb79QqefAr7gfTGWusrbCP
	 37vrVi/z8sQoYmLvCT5se+PoIJL2SG2luQPa+psI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shekhar Chauhan <shekhar.chauhan@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 254/466] drm/xe/pciids: separate ARL and MTL PCI IDs
Date: Thu, 12 Dec 2024 15:57:03 +0100
Message-ID: <20241212144316.824212969@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit cdb56a63f7eef34e89b045fc8bcae8d326bbdb19 ]

Avoid including PCI IDs for one platform to the PCI IDs of another. It's
more clear to deal with them completely separately at the PCI ID macro
level.

Reviewed-by: Shekhar Chauhan <shekhar.chauhan@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/a30cb0da7694a8eccceba66d676ac59aa0e96176.1725443121.git.jani.nikula@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pci.c   |  1 +
 include/drm/intel/xe_pciids.h | 13 ++++++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_pci.c b/drivers/gpu/drm/xe/xe_pci.c
index 8563206f643e6..025d649434673 100644
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -388,6 +388,7 @@ static const struct pci_device_id pciidlist[] = {
 	XE_RPLS_IDS(INTEL_VGA_DEVICE, &adl_s_desc),
 	XE_DG1_IDS(INTEL_VGA_DEVICE, &dg1_desc),
 	XE_ATS_M_IDS(INTEL_VGA_DEVICE, &ats_m_desc),
+	XE_ARL_IDS(INTEL_VGA_DEVICE, &mtl_desc),
 	XE_DG2_IDS(INTEL_VGA_DEVICE, &dg2_desc),
 	XE_MTL_IDS(INTEL_VGA_DEVICE, &mtl_desc),
 	XE_LNL_IDS(INTEL_VGA_DEVICE, &lnl_desc),
diff --git a/include/drm/intel/xe_pciids.h b/include/drm/intel/xe_pciids.h
index 7ee7524141f10..67dad09e62bc8 100644
--- a/include/drm/intel/xe_pciids.h
+++ b/include/drm/intel/xe_pciids.h
@@ -174,16 +174,19 @@
 	XE_ATS_M150_IDS(MACRO__, ## __VA_ARGS__),\
 	XE_ATS_M75_IDS(MACRO__, ## __VA_ARGS__)
 
-/* MTL / ARL */
+/* ARL */
+#define XE_ARL_IDS(MACRO__, ...)		\
+	MACRO__(0x7D41, ## __VA_ARGS__),	\
+	MACRO__(0x7D51, ## __VA_ARGS__),        \
+	MACRO__(0x7D67, ## __VA_ARGS__),	\
+	MACRO__(0x7DD1, ## __VA_ARGS__)
+
+/* MTL */
 #define XE_MTL_IDS(MACRO__, ...)		\
 	MACRO__(0x7D40, ## __VA_ARGS__),	\
-	MACRO__(0x7D41, ## __VA_ARGS__),	\
 	MACRO__(0x7D45, ## __VA_ARGS__),	\
-	MACRO__(0x7D51, ## __VA_ARGS__),        \
 	MACRO__(0x7D55, ## __VA_ARGS__),	\
 	MACRO__(0x7D60, ## __VA_ARGS__),	\
-	MACRO__(0x7D67, ## __VA_ARGS__),	\
-	MACRO__(0x7DD1, ## __VA_ARGS__),        \
 	MACRO__(0x7DD5, ## __VA_ARGS__)
 
 #define XE_LNL_IDS(MACRO__, ...) \
-- 
2.43.0



