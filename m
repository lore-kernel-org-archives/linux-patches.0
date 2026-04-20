Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FAE34216C;
	Mon, 20 Apr 2026 16:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701210; cv=none; b=rR71ncHKVom+6bW3AoUZ46qyvTCK8U661dQxGhit65Vya6vEEqr3AjSDd7iaZsm00PBZG2H/ZX0K6UZXIEbK4qFSIDEwc5UVYMIN1ztimuuoPKtsaQJakuwz1Gp/EDgk8EXdDlj4+yCBWzeA70UkhaosuHJrlHP7SxuKtEtCz1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701210; c=relaxed/simple;
	bh=Hm/Ir3lG8ovCjfvPyxCgkzyqx81bHb0mVoTLCag6NWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8ifXRTDNUX7o0pvTxu5BvsmRWoeIqdq/lIewHC4MkKDqR/uvMxDpdOifsCbf9wps+HUsRv+j+4uh0Da59v6gtU/XnX1PnR1x47wFFY3sfFx4hDAxM1dGVlJ+eiBeOSQ1QR/5sl759gTZ0qAjfLMdkVRuLIux1ZBNCEaxnLCPGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlJa1CH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlJa1CH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D347C2BCB4;
	Mon, 20 Apr 2026 16:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701209;
	bh=Hm/Ir3lG8ovCjfvPyxCgkzyqx81bHb0mVoTLCag6NWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wlJa1CH59xyk9c/vU2uR5qTMB+p0b7STeRq+SeBjtPrdu3c762dwFGfEo5G9RKhWY
	 Ddzco3UfO3FfOvgrjoIG6kojpmW/CENE6M/uNt2AZnkdajWc2wgsZiC0SpbuEggfQF
	 LvmKiQqZR2epCB1xFsxIb9b/dLshHkMnKHWAbWzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/162] pinctrl: intel: Fix the revision for new features (1kOhm PD, HW debouncer)
Date: Mon, 20 Apr 2026 17:40:57 +0200
Message-ID: <20260420153927.932550246@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit a4337a24d13e9e3b98a113e71d6b80dc5ed5f8c4 ]

The 1kOhm pull down and hardware debouncer are features of the revision 0.92
of the Chassis specification. Fix that in the code accordingly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index f8abc69a39d16..5d147a3a49389 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -1588,7 +1588,7 @@ int intel_pinctrl_probe(struct platform_device *pdev,
 		value = readl(regs + REVID);
 		if (value == ~0u)
 			return -ENODEV;
-		if (((value & REVID_MASK) >> REVID_SHIFT) >= 0x94) {
+		if (((value & REVID_MASK) >> REVID_SHIFT) >= 0x92) {
 			community->features |= PINCTRL_FEATURE_DEBOUNCE;
 			community->features |= PINCTRL_FEATURE_1K_PD;
 		}
-- 
2.53.0



