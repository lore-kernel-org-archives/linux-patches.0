Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CA1ECC
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F6AC433EF;
	Mon, 12 Jun 2023 10:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566173;
	bh=eEMDT4gqV3r30hmY/IrIGV4L+N31mCMAqkx/Uze+LCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQPLTeDIvSYaHHQqOUryW3q0nGyxMmnP3wEQo5YAuEoFbn4nkp7u0+I0n0un2c2O7
	 b5h3fSeoMOr0hPsBAl0ziGFrkhy6cIw6j+4pZkcoFgFJrlmCoY4ILxMXN0hLvkBqdm
	 WVIxS2FF67OH1f082yIPv1X6nOgLHexLq4W6JbBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 23/91] drm/i915: Use 18 fast wake AUX sync len
Date: Mon, 12 Jun 2023 12:26:12 +0200
Message-ID: <20230612101703.060282118@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 2d6f2f79e06571d41eb1223abebe9097511c9544 ]

HW default for wake sync pulses is 18. 10 precharge and 8 preamble. There
is no reason to change this especially as it is causing problems with
certain eDP panels.

v3: Change "Fixes:" commit
v2: Remove "fast wake" repeat from subject

Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Fixes: e1c71f8f9180 ("drm/i915: Fix fast wake AUX sync len")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/8475
Reviewed-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230530101649.2549949-1-jouni.hogander@intel.com
(cherry picked from commit b29a20f7c4995a059ed764ce42389857426397c7)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_dp_aux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_aux.c b/drivers/gpu/drm/i915/display/intel_dp_aux.c
index f0485521e58ad..d507a20822db1 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_aux.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_aux.c
@@ -129,7 +129,7 @@ static int intel_dp_aux_sync_len(void)
 
 static int intel_dp_aux_fw_sync_len(void)
 {
-	int precharge = 16; /* 10-16 */
+	int precharge = 10; /* 10-16 */
 	int preamble = 8;
 
 	return precharge + preamble;
-- 
2.39.2



