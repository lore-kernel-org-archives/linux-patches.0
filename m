Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1C8FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC27C433D2;
	Mon, 15 May 2023 16:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169534;
	bh=DUAofuEgBYri9/TaQeoogxL8Kixj5fbCL0lUumpKaHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQvzPpnFumId4WC+zONYaS60VoaDmbH9VWr4/qh5IwBFE9JyP7WtoAKteZLLhins0
	 UNQiXKeg7NtMo15Nf148iFRDAvhdnperIdFz+wkCe/u9TB1G7j+q+b18FHfpxS8V2N
	 wpJ9lwHIWJJPfjLSQ/4XJpK7oHkmbj7ygHa6gCyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
	Haridhar Kalvala <haridhar.kalvala@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 059/246] drm/i915/mtl: Add the missing CPU transcoder mask in intel_device_info
Date: Mon, 15 May 2023 18:24:31 +0200
Message-Id: <20230515161724.351799326@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Radhakrishna Sripada <radhakrishna.sripada@intel.com>

[ Upstream commit 6ece90e3665a9b7fb2637fcca26cebd42991580b ]

CPU transcoder mask is used to iterate over the available
CPU transcoders in the macro for_each_cpu_transcoder().

The macro is broken on MTL and got highlighted when audio
state was being tracked for each transcoder added in [1].

Add the missing CPU transcoder mask which is similar to ADL-P
mask but without DSI transcoders.

[1]: https://patchwork.freedesktop.org/patch/523723/

Fixes: 7835303982d1 ("drm/i915/mtl: Add MeteorLake PCI IDs")
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Acked-by: Haridhar Kalvala <haridhar.kalvala@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230420221248.2511314-1-radhakrishna.sripada@intel.com
(cherry picked from commit bddc18913bd44adae5c828fd514d570f43ba1576)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_pci.c b/drivers/gpu/drm/i915/i915_pci.c
index a8d942b16223f..125f7ef1252c3 100644
--- a/drivers/gpu/drm/i915/i915_pci.c
+++ b/drivers/gpu/drm/i915/i915_pci.c
@@ -1135,6 +1135,8 @@ static const struct intel_gt_definition xelpmp_extra_gt[] = {
 static const struct intel_device_info mtl_info = {
 	XE_HP_FEATURES,
 	XE_LPDP_FEATURES,
+	.__runtime.cpu_transcoder_mask = BIT(TRANSCODER_A) | BIT(TRANSCODER_B) |
+			       BIT(TRANSCODER_C) | BIT(TRANSCODER_D),
 	/*
 	 * Real graphics IP version will be obtained from hardware GMD_ID
 	 * register.  Value provided here is just for sanity checking.
-- 
2.39.2



