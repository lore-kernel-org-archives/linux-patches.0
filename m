Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69EE1C5793;
	Tue,  8 Oct 2024 13:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392934; cv=none; b=U8V2iuTFNvjYZnFaCuef35yXmNty+oEy3lOYKT6vl12Ig4Nu0DX1dwnxgrw0vJGQhJBuoEabtlO6kgBtRqPrmbu69mgCcNIocxe4RsN1/gQTS10+6wIztkdda7ui3qA+VwL9pCyeGarcSLHYdT3RYxYS2uhgjOoxTlMfWN5Qd9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392934; c=relaxed/simple;
	bh=7p/o6feugNoEzGTIto/LGehXidmZ3It1LOd1HQDEkdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xj5J27BgigCBT/VJxoZhfy9zPkA5/gfzcrs2oHrSW4uJ3T6csF7bsJ1kLB2DFOf/VZaJJR2fDo4BZYRWGVEED6m4Nf2D6hSd+xw6a9x0dJlESMraMYFVZI+8LyLWN8lU/nbxa8KDmnjNDKpkw06PpmTKACDkYBFk8Ub/8x8lEJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4H54mF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4H54mF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094E6C4CEC7;
	Tue,  8 Oct 2024 13:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392934;
	bh=7p/o6feugNoEzGTIto/LGehXidmZ3It1LOd1HQDEkdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4H54mF5XKdRlKWP5UoUid1B3uUz012DEti8gkPLIAwzPl8RpojZiCMqocAlNZUp0
	 8tuBwKiTuKkd3wjn7BQgf8PEgbntQRFutuHncP4reU8bIbZ9YHYxsJ55EMe7Yq9ET1
	 OPv/NBZdHWk7hNXf4zPPC/ZlUTUkqJ1QYhPRwiUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Gray <jsg@jsg.id.au>
Subject: [PATCH 6.11 550/558] Revert "drm/amd/display: Skip Recompute DSC Params if no Stream on Link"
Date: Tue,  8 Oct 2024 14:09:40 +0200
Message-ID: <20241008115723.877662411@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Gray <jsg@jsg.id.au>

This reverts commit d45c64d933586d409d3f1e0ecaca4da494b1d9c6.

duplicated a change made in 6.11-rc3
50e376f1fe3bf571d0645ddf48ad37eb58323919

Cc: stable@vger.kernel.org # 6.11
Signed-off-by: Jonathan Gray <jsg@jsg.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1353,9 +1353,6 @@ static bool is_dsc_need_re_compute(
 	DRM_DEBUG_DRIVER("%s: MST_DSC check on %d streams in current dc_state\n",
 			 __func__, dc->current_state->stream_count);
 
-	if (new_stream_on_link_num == 0)
-		return false;
-
 	/* check current_state if there stream on link but it is not in
 	 * new request state
 	 */


