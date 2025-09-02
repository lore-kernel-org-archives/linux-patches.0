Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02635326D53;
	Tue,  2 Sep 2025 13:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820498; cv=none; b=ZTeIhqkHhvGF96SlH9wUfxgoSDTuzndKgR+fuqCRs8LP+7a+6qGwKPaKt50EK82Spqa9cOTMK47IK0oALPTa8eVaIms7rpeVnAbBYtZ/TN7PkMZ03JpgF/LMgPxQ4pGUsT8e6vdfsxTmsegN8wJkDF2LGn91MospS0jCSXdVYx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820498; c=relaxed/simple;
	bh=6ihEJn/wqId2Lscq1vHIBqzkiWtZADhWKiJDnGZn5tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhSGSe2BEXII6VgIvP/FL6s7yHS5LmWTMfEwwB8meD6CFXqiBL0NGtcppBRJZ6Rlr/cuWawZb8FJ94NnaGaRudFRnYm/gbfydEmmFLH88UXkSBh0mrpycHHz8AVyWjOy6mwQ9Dq11umA6oRucyBzZRyE/weP/c46N85cNZaCpP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b8Xqakuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b8Xqakuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81229C4CEED;
	Tue,  2 Sep 2025 13:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820497;
	bh=6ihEJn/wqId2Lscq1vHIBqzkiWtZADhWKiJDnGZn5tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b8XqakuhgQNgA0zJpDBKx+VfsSL5m3BE78sQbGq5mk4DtPK//CV5Kb+Swo83H1QXP
	 7g+8OBBm2bu1GSca//H9rekhOEhoH/gGmW9vfq3DAUHaGXhycki/Mj6r3yc4F97Em/
	 g8XQ35p3UUeuVUwJPfQckrlfFRqPMlxmSCHR+CSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.1 49/50] Revert "drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS"
Date: Tue,  2 Sep 2025 15:21:40 +0200
Message-ID: <20250902131932.457260541@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

This reverts commit 4f546a77671076a0a49c08b4c6a7d0888d72f7d2 which is
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


