Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C4D41A8F;
	Tue,  2 Sep 2025 13:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820709; cv=none; b=mucBig/YDEaIpuTwByba2k26arfo8Af2sYWtG86ReNTV1JACdxV30gNsANQbCcIggEDVdFI2+JmzrOj8W79xYtoac3VG9tDOGvleS3thoZDmB4IbhzBMDJrDqBsPZA7kAFOBUCDcggeTnZS+8ByT3QujNb/m0nLC/jsf/mMtIGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820709; c=relaxed/simple;
	bh=eQq2nAFZTeJhbDPDIK8nMD490iWJHQYNEtytL05rdMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGs0aupkUhst4dBRp4ivaRDwermWB/nr28uhDpyHeVVB6roLUKku1F29Fm97RSLGpLvsQY+6IOysGRdWOFON3zjbPf6VYvbiNMvc1vkr9lvuxfp0GHwQm/oMaxLiCyWXgJFGmVXP8n5OLM29K+uH0DDVNJNs8oJ2CU73eLNpWJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyBNLuGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyBNLuGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABA6C4CEF7;
	Tue,  2 Sep 2025 13:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820709;
	bh=eQq2nAFZTeJhbDPDIK8nMD490iWJHQYNEtytL05rdMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyBNLuGJ0CmCTfvf/2kaTnPRehoW4JSV8PuPvAGJqsSCbH1BZN3dQ9xRWOFrKnBbP
	 2WniQ2tdylJJ3a5pM5Td+SoxIvlbnk5gEMWdgLJzeaYkTz5FaAWoWrgs3O7orOaSRm
	 D9gjbvuIti7FE/h/LivRUz39DnFfxWHWunRWwozo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 5.10 29/34] Revert "drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS"
Date: Tue,  2 Sep 2025 15:21:55 +0200
Message-ID: <20250902131927.773792816@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

This reverts commit 89d17a2d89a83c5b7643ca934651a3f9229e4734 which is
commit a40c5d727b8111b5db424a1e43e14a1dcce1e77f upstream.

The upstream commit a40c5d727b8111b5db424a1e43e14a1dcce1e77f ("drm/dp:
Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS") the
reverted commit backported causes a regression, on one eDP panel at
least resulting in display flickering, described in detail at the Link:
below. The issue fixed by the upstream commit will need a different
solution, revert the backport for now.

Cc: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: Sasha Levin <sashal@kernel.org>
Link: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14558
Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_dp_helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_dp_helper.c
+++ b/drivers/gpu/drm/drm_dp_helper.c
@@ -299,7 +299,7 @@ ssize_t drm_dp_dpcd_read(struct drm_dp_a
 	 * monitor doesn't power down exactly after the throw away read.
 	 */
 	if (!aux->is_remote) {
-		ret = drm_dp_dpcd_access(aux, DP_AUX_NATIVE_READ, DP_LANE0_1_STATUS,
+		ret = drm_dp_dpcd_access(aux, DP_AUX_NATIVE_READ, DP_DPCD_REV,
 					 buffer, 1);
 		if (ret != 1)
 			goto out;


