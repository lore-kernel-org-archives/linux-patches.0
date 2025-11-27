Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDC128CF42;
	Thu, 27 Nov 2025 15:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255793; cv=none; b=gNyCOqrY4TZ2cHKWK3Gn3tUhyPtpz9y+J+ihRnIJSzMntroYYjB48d56zhhT1Bq42hOfg6THsjOUXKeZE5FXl9HScxlzlheCAmhBti9jyX7xIzyNeI0l/WFLLGBu3MIY437eyffNtUqbur+4MSo8988KiBGi+ektLWnrf7pQp84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255793; c=relaxed/simple;
	bh=eM5ldj8Hv3txioUrylweYOndz0RObWAIWjxl7IFjBvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/CZLm9S9s54L+9bDEs8qTziZWMqNtpGIOPW+u6jhPTfNpyXIPbmDzVjWkdJfTV1yxQVMXSKM7DULVidhJ0ECs0SVHKoxKqkEGGXQkgTrayU/KRrHbRUb0W/OmRxwp5hZvW5ZWGXoQALKB9izDbS0tVCc4ZS5PVZpqB0FsqVur0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7xgu/p/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7xgu/p/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39848C4CEF8;
	Thu, 27 Nov 2025 15:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255793;
	bh=eM5ldj8Hv3txioUrylweYOndz0RObWAIWjxl7IFjBvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7xgu/p/bm2CivoqcMGPcxsa7BX9RP2sgsdj0Kzf58OfVdjTsRmG+rcerXf5004KI
	 PyeCmaxX4GPcaD7iSWhwBcPbACtlZUlDsFTaukRDmYwpNW+L7TGNp9EutLCbZom178
	 /U0GN6aRTeaCWPhHh+ZsyvbYeL6IAywW1SXb0riQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 116/175] drm/xe/kunit: Fix forcewake assertion in mocs test
Date: Thu, 27 Nov 2025 15:46:09 +0100
Message-ID: <20251127144047.196699802@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 905a3468ec679293949438393de7e61310432662 ]

The MOCS kunit test calls KUNIT_ASSERT_TRUE_MSG() with a condition of
'true;' this prevents the assertion from ever failing.  Replace
KUNIT_ASSERT_TRUE_MSG with KUNIT_FAIL_AND_ABORT to get the intended
failure behavior in cases where forcewake was not acquired successfully.

Fixes: 51c0ee84e4dc ("drm/xe/tests/mocs: Hold XE_FORCEWAKE_ALL for LNCF regs")
Cc: Tejas Upadhyay <tejas.upadhyay@intel.com>
Cc: Gustavo Sousa <gustavo.sousa@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patch.msgid.link/20251113234038.2256106-2-matthew.d.roper@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 9be4f0f687048ba77428ceca11994676736507b7)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/tests/xe_mocs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/tests/xe_mocs.c b/drivers/gpu/drm/xe/tests/xe_mocs.c
index 0e502feaca818..6bb278167aaf6 100644
--- a/drivers/gpu/drm/xe/tests/xe_mocs.c
+++ b/drivers/gpu/drm/xe/tests/xe_mocs.c
@@ -49,7 +49,7 @@ static void read_l3cc_table(struct xe_gt *gt,
 	fw_ref = xe_force_wake_get(gt_to_fw(gt), XE_FORCEWAKE_ALL);
 	if (!xe_force_wake_ref_has_domain(fw_ref, XE_FORCEWAKE_ALL)) {
 		xe_force_wake_put(gt_to_fw(gt), fw_ref);
-		KUNIT_ASSERT_TRUE_MSG(test, true, "Forcewake Failed.\n");
+		KUNIT_FAIL_AND_ABORT(test, "Forcewake Failed.\n");
 	}
 
 	for (i = 0; i < info->num_mocs_regs; i++) {
-- 
2.51.0



