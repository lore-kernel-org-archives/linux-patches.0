Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C745272E7C;
	Tue,  2 Sep 2025 13:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820612; cv=none; b=ms1KzL3yCczYuJn+QpH+qFAcSSLbAOjzJ4OkZCRJ5ScIolZwJWqZD3JrjyD8OINYM34wabdI/vSvzXQU9/gpFaPL5uMpUxlHocOB890acczdg4btKVhQsd6H/ygFfN9kOAH9H+6zNTDd2E9s5Zeb/vPJIpdqZ5BTjX17rkV50Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820612; c=relaxed/simple;
	bh=qsUoQhd88B3F7R2cgLAf+NBGQ163XINWd7rq50PFSV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddbuk/qHQir5TR+yuQ4x5iEY7BXrFZxid0LwkAUpGf24e9YhQNWBZLzhglgZcSmgcNNPIt6bPLf6z52ls3bmQSZVbppWtbRjlrkPUaPytb/fygt25GmlU4Kt8CBlhGmkpmXMF/t9y/VUTLVrh3y3BvTwsQNJukDt6mdsuqoPsKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlTszYdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlTszYdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DDDC4CEED;
	Tue,  2 Sep 2025 13:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820611;
	bh=qsUoQhd88B3F7R2cgLAf+NBGQ163XINWd7rq50PFSV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlTszYddk/zq4yBu4cc6e5AxGXtT/nTmQ83toS8r30C1H0zwno0JLfSYm04T9oIer
	 9HtoZrmtZDd7HrlNXcM5CJp8nUO7Q35/7iF+QbgHJJk6goZQXW3CV1DIjvXEFDQWk5
	 ZfZM6dCidAxJliZSHMeQgeuwOyoeWcTPRxaW054c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 5.15 32/33] Revert "drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS"
Date: Tue,  2 Sep 2025 15:21:50 +0200
Message-ID: <20250902131928.323789346@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

This reverts commit a19b31f854a8992dfa35255f43efd19be292b15c which is
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
@@ -336,7 +336,7 @@ ssize_t drm_dp_dpcd_read(struct drm_dp_a
 	 * monitor doesn't power down exactly after the throw away read.
 	 */
 	if (!aux->is_remote) {
-		ret = drm_dp_dpcd_access(aux, DP_AUX_NATIVE_READ, DP_LANE0_1_STATUS,
+		ret = drm_dp_dpcd_access(aux, DP_AUX_NATIVE_READ, DP_DPCD_REV,
 					 buffer, 1);
 		if (ret != 1)
 			goto out;


