Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8232C15A3;
	Tue,  2 Sep 2025 13:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820807; cv=none; b=Na2YyykL5aYBu+7PWpBmo5Tk95g4GEPcfDvTklc3iyL5h4syWcKOCemZ4iyD4jKtVd/9HhQQUcL6UbZbIO5CNkffBbzk6bgoe29+ThkABtADe7zJrxIV1AM86G/Ta0xM/y6TQSvKq0eb4PSwkueyhEWaLqMnJvjR2ZPHs/9rR/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820807; c=relaxed/simple;
	bh=bAeXueErPR9FkS1aVpvm+MMOl2yBOa/fjOiWjXbDGL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaw2khzZ7M/FlwmTCYMqYeMWrVvy+XdAa/pXhauX+1i6BkbkO2mwANOMBn5s6YjlUEaqrP4rDtyP51nb8/4fCDU1JOCrHZ7NoQNqY4nY9hLWWoEiIJiqWlDIj+o10sAAeCxhIQF1SgAFGiRxwYUnVIT0fozEa90iyp96+6ppqjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAbbfz/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAbbfz/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2446AC4CEED;
	Tue,  2 Sep 2025 13:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820806;
	bh=bAeXueErPR9FkS1aVpvm+MMOl2yBOa/fjOiWjXbDGL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAbbfz/BfllIGjxeaTYvYWAtfCWDX8J3HPvG5zM3tReajV2NZ6EVmZRJlVzSqGBf8
	 Ysx/ACfbEwxMl66X9v3sRSpS3996sFtJXH+jw5fyvvuKMcdhFl5sYTkwdNIaR3pqyx
	 VixO4td4+eTl7xk/5qQLrBTvqQH2U9qw+bn0KQBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 5.4 23/23] Revert "drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS"
Date: Tue,  2 Sep 2025 15:22:09 +0200
Message-ID: <20250902131925.659286447@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131924.720400762@linuxfoundation.org>
References: <20250902131924.720400762@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

This reverts commit 2402adce8da4e7396b63b5ffa71e1fa16e5fe5c4 which is
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
@@ -280,7 +280,7 @@ ssize_t drm_dp_dpcd_read(struct drm_dp_a
 	 * We just have to do it before any DPCD access and hope that the
 	 * monitor doesn't power down exactly after the throw away read.
 	 */
-	ret = drm_dp_dpcd_access(aux, DP_AUX_NATIVE_READ, DP_LANE0_1_STATUS, buffer,
+	ret = drm_dp_dpcd_access(aux, DP_AUX_NATIVE_READ, DP_DPCD_REV, buffer,
 				 1);
 	if (ret != 1)
 		goto out;


