Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78287261593;
	Tue,  2 Sep 2025 13:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820365; cv=none; b=q3+pAxECnkdZ2qNX1Au/TVlJWqgHcmnnTIRXQMcgAkp0Z+obsaa0Nmjqff69ZORZt5VG11sjgO6wcB1QX/VEIDcaBa0hX3aJ+Pg+6LJiE7t6YihNMxCVNc53sH3zQ0hCAImEYgF5u4ONVvmzpNBFO8bDRhAfHHE2+OGuvj8jrVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820365; c=relaxed/simple;
	bh=MfXlxgU/pB7sWuRfIrTK6XK/eqbcQRhIjEeDlX+Uz08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJsVCTcGOVHK3n6MV3yl1jG7jPin5V7R+ayA1+GYoQ8kfOLQa1qTZ+MWOtny6SkWAmKp0+bwcK2lAnrsdtLKCrgBm7Lgd8jf0ZAZPeBtbvL4gloV5LKYYsgTB9y6XUiL4aV552cYbZ0E3O+gEz8AJNRC6gmvNYNK3XxHKv9mzRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYIMpBUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYIMpBUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EDEC4CEF4;
	Tue,  2 Sep 2025 13:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820365;
	bh=MfXlxgU/pB7sWuRfIrTK6XK/eqbcQRhIjEeDlX+Uz08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYIMpBUxQWUGesa9jLG7n7lw3JnV5ERWhLhYhj8l4TkJ7gG9HUqgUC/fyPktiaXvF
	 qVhwAlSLl44IZwuF/OwAw51ZPpH1txas8Rc/aQx3QR6gFTUprbvNQrdxzhzSLQSdL5
	 mlEC5J85nuRzn262TeTdIB5KmtVN9JW5zR/43dzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.6 74/75] Revert "drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS"
Date: Tue,  2 Sep 2025 15:21:26 +0200
Message-ID: <20250902131938.008357049@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

This reverts commit 65e46aeaf84aa88539bcff6b8077e05fbd0700da which is
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
 drivers/gpu/drm/display/drm_dp_helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -663,7 +663,7 @@ ssize_t drm_dp_dpcd_read(struct drm_dp_a
 	 * monitor doesn't power down exactly after the throw away read.
 	 */
 	if (!aux->is_remote) {
-		ret = drm_dp_dpcd_probe(aux, DP_LANE0_1_STATUS);
+		ret = drm_dp_dpcd_probe(aux, DP_DPCD_REV);
 		if (ret < 0)
 			return ret;
 	}


