Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E325296FA2;
	Mon, 12 May 2025 17:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072309; cv=none; b=bdp4qIQY85l5XzKi/HDlA+jeXb5RMBcDQ6gWaBThKhdvydFKtyKCnDKUZM6GqXdUt19ASYi53DqEIBWjQ90gHQlC4QGuoGIZZx966pbit/ikwyojGekrsA+Tca2/8HEDAYAw45WmfNxy8Ql5u/P/MefiSagX2PffUwu7BQyWGNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072309; c=relaxed/simple;
	bh=oKkSJ5T1ghB9AR/pKFee9QS557CgeMTphwVm5Mpvz0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXVC9Ho9MfjQXjd/4L1boofWiUpPh8a84y2Z6LdyE89wIOPSRS3T562Xfp+hrgmiy+WTiLLJtMQb9wkIq9PHhLoVC/27DDBMa1ORS2rTbscXqOFRI9VbEF/1ggUJCHWsSrVZt+o/4mOnL5XMY+AXADsqqPOD3DTmdw7XekD9DZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SuPhpFYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SuPhpFYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EF2C4CEE7;
	Mon, 12 May 2025 17:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072308;
	bh=oKkSJ5T1ghB9AR/pKFee9QS557CgeMTphwVm5Mpvz0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SuPhpFYxaiQeSckK5eKjAM1B3wLD15EKFdlCfZPHLkgaaT92LZHIDeeUk8U71ouCF
	 kdJQsrxfHUcq09BINIEUjDLZ+UlvTbGBHRUbOtce+rO9vvyYjJJnrPjmeNUQlD+UJ+
	 InAH8HbRvdmFQdcbfOYbwwNUjla3LJRkncCl5OGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 168/197] drm/xe/tests/mocs: Hold XE_FORCEWAKE_ALL for LNCF regs
Date: Mon, 12 May 2025 19:40:18 +0200
Message-ID: <20250512172051.223788629@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

[ Upstream commit 51c0ee84e4dc339287b2d7335f2b54d747794c83 ]

LNCF registers report wrong values when XE_FORCEWAKE_GT
only is held. Holding XE_FORCEWAKE_ALL ensures correct
operations on LNCF regs.

V2(Himal):
 - Use xe_force_wake_ref_has_domain

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/1999
Fixes: a6a4ea6d7d37 ("drm/xe: Add mocs kunit")
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250428082357.1730068-1-tejas.upadhyay@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit 70a2585e582058e94fe4381a337be42dec800337)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/tests/xe_mocs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/tests/xe_mocs.c b/drivers/gpu/drm/xe/tests/xe_mocs.c
index ef1e5256c56a8..0e502feaca818 100644
--- a/drivers/gpu/drm/xe/tests/xe_mocs.c
+++ b/drivers/gpu/drm/xe/tests/xe_mocs.c
@@ -46,8 +46,11 @@ static void read_l3cc_table(struct xe_gt *gt,
 	unsigned int fw_ref, i;
 	u32 reg_val;
 
-	fw_ref = xe_force_wake_get(gt_to_fw(gt), XE_FW_GT);
-	KUNIT_ASSERT_NE_MSG(test, fw_ref, 0, "Forcewake Failed.\n");
+	fw_ref = xe_force_wake_get(gt_to_fw(gt), XE_FORCEWAKE_ALL);
+	if (!xe_force_wake_ref_has_domain(fw_ref, XE_FORCEWAKE_ALL)) {
+		xe_force_wake_put(gt_to_fw(gt), fw_ref);
+		KUNIT_ASSERT_TRUE_MSG(test, true, "Forcewake Failed.\n");
+	}
 
 	for (i = 0; i < info->num_mocs_regs; i++) {
 		if (!(i & 1)) {
-- 
2.39.5



