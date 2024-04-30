Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AA412C46B;
	Tue, 30 Apr 2024 10:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474167; cv=none; b=edoEvdB3E1Io0NeX9S59x06niSRTTk8eY9GHl02Md7CDiCommcnthgIQwWpUwdnNtyflhrT1NrMhpUOMXfQBSokGIYRDW15zGgTH0sxYCUaw2ShvnF0Cl/HrK0daf2LcVA06rJboWiRjXVc0bAANC7JGXlTb0gyCon7/+yHympk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474167; c=relaxed/simple;
	bh=1NkSb3140fAQkD0UgFg4fKs+7ezNfQCFtD554OchSWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLd8f+JplecqTMYhB//Ri4p3Mii7z9Xtz6pkJsSF3k1yYZDZMfFESoAQY8dC8aCBtnmCnin6K0Sc25g3+KXZ1ljr0wHxGeynWLWpyXVKJhgQ8BpnYwdU2HTq1RpUTpN1yle+eXMgcnMnzkphPzMYp8qWhunJKRgmmcZ9Vi4ALUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVTfli/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVTfli/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74A8C4AF1A;
	Tue, 30 Apr 2024 10:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474167;
	bh=1NkSb3140fAQkD0UgFg4fKs+7ezNfQCFtD554OchSWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVTfli/qFt9tZPt63KCHZwFE2ml3erqXfX0G5s/c2Pd5PPiutRQGIJdI4zXdK+3ah
	 W+6F5mRnXoJODSeSmZFCHHReO8cRzAtdCFBltWF488G1B29NHjC+wH9+gY7WjQRAzP
	 AWbBeZP49U+8mK1qZ4efO7BGWKojddvxqvfLgKHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 076/228] drm/xe: call free_gsc_pkt only once on action add failure
Date: Tue, 30 Apr 2024 12:37:34 +0200
Message-ID: <20240430103105.998171851@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>

[ Upstream commit f38c4d224aa37fce1e3fe05db4377ef888f0737f ]

The drmm_add_action_or_reset function automatically invokes the
action (free_gsc_pkt) in the event of a failure; therefore, there's no
necessity to call it within the return check.

-v2
Fix commit message. (Lucas)

Fixes: d8b1571312b7 ("drm/xe/huc: HuC authentication via GSC")
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Signed-off-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240412181211.1155732-4-himal.prasad.ghimiray@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 22bf0bc04d273ca002a47de55693797b13076602)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_huc.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_huc.c b/drivers/gpu/drm/xe/xe_huc.c
index eca109791c6ae..01b2d0bd26a30 100644
--- a/drivers/gpu/drm/xe/xe_huc.c
+++ b/drivers/gpu/drm/xe/xe_huc.c
@@ -53,7 +53,6 @@ static int huc_alloc_gsc_pkt(struct xe_huc *huc)
 	struct xe_gt *gt = huc_to_gt(huc);
 	struct xe_device *xe = gt_to_xe(gt);
 	struct xe_bo *bo;
-	int err;
 
 	/* we use a single object for both input and output */
 	bo = xe_bo_create_pin_map(xe, gt_to_tile(gt), NULL,
@@ -66,13 +65,7 @@ static int huc_alloc_gsc_pkt(struct xe_huc *huc)
 
 	huc->gsc_pkt = bo;
 
-	err = drmm_add_action_or_reset(&xe->drm, free_gsc_pkt, huc);
-	if (err) {
-		free_gsc_pkt(&xe->drm, huc);
-		return err;
-	}
-
-	return 0;
+	return drmm_add_action_or_reset(&xe->drm, free_gsc_pkt, huc);
 }
 
 int xe_huc_init(struct xe_huc *huc)
-- 
2.43.0



