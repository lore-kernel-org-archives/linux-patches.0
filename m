Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B5D2DFF2A;
	Tue, 17 Jun 2025 15:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175264; cv=none; b=AP3Rvhjtn6JFJBf96ujfesVQMw1hjNzIF3K+xuZ4T8K9ayz3bomSAMQfLYmm6aGFZCfrzbH4xVIOJ2YwGaY2bRQgcpjDOtuhF92qP0Lm0Ea+VSkqnLgI3rQfT7Vq76ntl0V2lMYqrUgfeBTrCtwdL78XwTeWrJ88iHLaDUJjq/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175264; c=relaxed/simple;
	bh=Q/EsvUV8HUPMpy83DQEEwuwRf9id1feptKRXT3JGbeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqkJsu0y6822q4ZUILo/rUlWpUPXFP0UfaY7AazR3XQLQXOJCMdTnDqtLcTof1NzSCyuWrLs9DNA4Hf2F+0IlVfx947aaNZmegn4izgZHSnva/GRdyGdENL0fN3YFEwL0LlOGCmf3haLFBo4s06J3K+H/Tw/lfIeriyq4CUMEJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCECPBoF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCECPBoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F743C4CEE3;
	Tue, 17 Jun 2025 15:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175264;
	bh=Q/EsvUV8HUPMpy83DQEEwuwRf9id1feptKRXT3JGbeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCECPBoFkK75310/dkpL6OLre/dPAKu1mwVt8+kFQjQ1FdkxzWylDOuq1Y9PSYvYu
	 ufJyMBphZ+gMHVjHRqD1ZZeY23m58B7NVkLM/w3mi3e+1emuiJZk4VCGximvQw+ZLV
	 C8kYuZWL0yEc8Zr4zEF6q8hGVero2gTq3VGUc5Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Jameson Thies <jthies@google.com>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 068/780] platform/chrome: cros_ec_typec: Set Pin Assignment E in DP PORT VDO
Date: Tue, 17 Jun 2025 17:16:16 +0200
Message-ID: <20250617152454.279255738@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Benson Leung <bleung@chromium.org>

[ Upstream commit a9635ef0ca12e7914f42bfa7ca6a019f606c2817 ]

Pin C and D are used on C-to-C cable applications including docks,
and for USB-C adapters that convert from DP over USB-C to other
video standards.

Pin Assignment E is intended to be used with adapter from USB-C to DP
plugs or receptacles.

All Chromebook USB-C DFPs support DisplayPort Alternate Mode as the DP
Source with support for all 3 pin assignments. Pin Assignment E is required
in order to support if the user attaches a Pin E C-to-DP cable.

Without this, the displayport.c alt mode driver will error out of
dp_altmode_probe with an -ENODEV, as it cannot find a compatible matching
pin assignment between the DFP_D and UFP_D.

Fixes: dbb3fc0ffa95 ("platform/chrome: cros_ec_typec: Displayport support")

Signed-off-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Jameson Thies <jthies@google.com>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Link: https://lore.kernel.org/r/20250428174828.13939-1-bleung@chromium.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index d2228720991ff..7678e3d05fd36 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -22,8 +22,10 @@
 
 #define DRV_NAME "cros-ec-typec"
 
-#define DP_PORT_VDO	(DP_CONF_SET_PIN_ASSIGN(BIT(DP_PIN_ASSIGN_C) | BIT(DP_PIN_ASSIGN_D)) | \
-				DP_CAP_DFP_D | DP_CAP_RECEPTACLE)
+#define DP_PORT_VDO	(DP_CAP_DFP_D | DP_CAP_RECEPTACLE | \
+			 DP_CONF_SET_PIN_ASSIGN(BIT(DP_PIN_ASSIGN_C) | \
+						BIT(DP_PIN_ASSIGN_D) | \
+						BIT(DP_PIN_ASSIGN_E)))
 
 static void cros_typec_role_switch_quirk(struct fwnode_handle *fwnode)
 {
-- 
2.39.5



