Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1741131A062;
	Tue,  2 Sep 2025 13:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819785; cv=none; b=YJ01lNPmSsPYPf+lZFrOyKdAbO/Qj9Eaqn7t4exH0U1B3VN7oBlC5v63pHrbG0S0EkqptNY0t9+vofwXnSw72RLfE0MkI+WMMvEQZaUM14b1GSKTNE2DhyUPFVei8Lg7ZHfymTsWZKUfuAuChONYXoB+f2RBjMLzSNKJkAIVQzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819785; c=relaxed/simple;
	bh=lw+2f1hzugIWKiSdRUqh3aCTm8vSpr9XFbb2GjRXs1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urhwzX8+kxuZpJ46e7nJekQOrr+gOFD8wlwsytGNW0p1+DjRGHc3y11rPLWEpyPzsTnFZHTlOiRRnJXGNeNsPnMSJvqJJn0W2bdblTsrwNgXW7wV6cplpWWNvF/7XJnzGF+7Nji+lu8b+wJYA+MIY3CFl1I/WPOw0iDivHQiwkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJP6ul3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJP6ul3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4137EC4CEED;
	Tue,  2 Sep 2025 13:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819784;
	bh=lw+2f1hzugIWKiSdRUqh3aCTm8vSpr9XFbb2GjRXs1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TJP6ul3d4sFJmGvDImEGVjRG2Qp21m8rev7ib7WhCxGbXAzMJR9CiEDSGlxWBX2HE
	 ORkDzvo6JwwN54bMuhEvCGXYe8T6feHwzFVR/M5IUydXrl6sXvinSftsqjUHNJ1AH9
	 kkzaQz1rHY/q2DLpXSFIr2fKF1QA+0a+TZRXdNe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.16 139/142] Revert "drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS"
Date: Tue,  2 Sep 2025 15:20:41 +0200
Message-ID: <20250902131953.603872091@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

This reverts commit 944e732be9c3a33e64e9fb0f5451a37fc252ddfc which is
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
@@ -725,7 +725,7 @@ ssize_t drm_dp_dpcd_read(struct drm_dp_a
 	 * monitor doesn't power down exactly after the throw away read.
 	 */
 	if (!aux->is_remote) {
-		ret = drm_dp_dpcd_probe(aux, DP_LANE0_1_STATUS);
+		ret = drm_dp_dpcd_probe(aux, DP_DPCD_REV);
 		if (ret < 0)
 			return ret;
 	}


