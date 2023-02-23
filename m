Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718FE257C
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3237C433D2;
	Thu, 23 Feb 2023 13:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157748;
	bh=Ln/fP5or0UNHJ8oMz9pM+CTmTIv50zkcdRnZFFKAxKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLLcwGu8abbcloVbH5BqKs3un3lnNwKY2+uND3K4GCQ64xrUvGA7lHZs+ls0s0ew6
	 yERAxN7DqgDQz/xExA1sk5j0SDYAkeTUi2/fKOzGS0uSn2mFxKHqTg6Uusa7RSRokb
	 TDOqXZ8QrHzg6zKXt9KhTqHXhkxMnLWbz/dG3Nk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/46] drm/i915: Remove __maybe_unused from mtl_info
Date: Thu, 23 Feb 2023 14:06:30 +0100
Message-Id: <20230223130432.643981258@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit fff758698842fb6722be37498d8773e0fb47f000 ]

The attribute __maybe_unused should remain only until the respective
info is not in the pciidlist. The info can't be added together
with its definition because that would cause the driver to automatically
probe for the device, while it's still not ready for that. However once
pciidlist contains it, the attribute can be removed.

Fixes: 7835303982d1 ("drm/i915/mtl: Add MeteorLake PCI IDs")
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221214194944.3670344-1-lucas.demarchi@intel.com
(cherry picked from commit 50490ce05b7a50b0bd4108fa7d6db3ca2972fa83)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_pci.c b/drivers/gpu/drm/i915/i915_pci.c
index 34f2d9da201e2..fe4f279aaeb3e 100644
--- a/drivers/gpu/drm/i915/i915_pci.c
+++ b/drivers/gpu/drm/i915/i915_pci.c
@@ -1130,7 +1130,6 @@ static const struct intel_gt_definition xelpmp_extra_gt[] = {
 	{}
 };
 
-__maybe_unused
 static const struct intel_device_info mtl_info = {
 	XE_HP_FEATURES,
 	XE_LPDP_FEATURES,
-- 
2.39.0



