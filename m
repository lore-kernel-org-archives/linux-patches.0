Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE197284693;
	Wed, 23 Apr 2025 15:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421656; cv=none; b=IuzaGyK/IH97XyQSawX/3suKTZ3l4h8PU+ZJAoyNAgJrMH9/fGFjdPbijjjSU6ENrC8aXG2tbxDJxWs644ZoIcEd4SlMMhJst7Kpo5PD25rHt+7EZh05eC7ZCyGdyf+bSf1iNaBmqfuwEvrd7rwr6llOiBQO86BfZyZ8o2Y/DJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421656; c=relaxed/simple;
	bh=wGPd+3cV6mWVsVnmAtbyatKzw0uz+6n9PbHT7c/mAlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKX/29VFnD0DwDn/RgF9h5NS2jdICsqqlqMSJGKyDuToOmhb58Nljl+utvNNjR3ynU+wk03Ih6kDbTN3dBRJZbKog8qYt+59IQnTJiXSp9usNKGWGI0ZkxgvK9HF/Jo79t0XsMsgjIhVOORi9XYeykG52U56RBPPuTEJGln/DaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFEBmJCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFEBmJCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723AFC4CEE2;
	Wed, 23 Apr 2025 15:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421655;
	bh=wGPd+3cV6mWVsVnmAtbyatKzw0uz+6n9PbHT7c/mAlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFEBmJCmDjRQ/nGB6I6jglWIoLBPWf7n9yyVbe3pKzAIi132Z6LGebsJED7lClgJh
	 fhHbNaJsuy8RRG+OQHX5t/0N6rBaxjEKNxxm+mBlQIY1wmHJrOrgArSX0K2slj/SYk
	 +Kw8LqMfn94YUAnpSCpqozCbEvh9714alSIqCS3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.14 216/241] drm/i915/dp: Check for HAS_DSC_3ENGINES while configuring DSC slices
Date: Wed, 23 Apr 2025 16:44:40 +0200
Message-ID: <20250423142629.386620426@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

commit 3a47280b768748992ee34bd52c394c60b2845af3 upstream.

DSC 12 slices configuration is used for some specific cases with
Ultrajoiner. This can be supported only when each of the 4 joined pipes
have 3 DSC engines each.

Add the missing check for 3 DSC engines support before using 3 DSC
slices per pipe.

Fixes: be7f5fcdf4a0 ("drm/i915/dp: Enable 3 DSC engines for 12 slices")
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Suraj Kandpal <suraj.kandpal@intel.com>
Cc: <stable@vger.kernel.org> # v6.14+
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://lore.kernel.org/r/20250414024256.2782702-3-ankit.k.nautiyal@intel.com
(cherry picked from commit da9b1c61e7f7b327dd70c5f073ba04d419a55ef8)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1050,10 +1050,11 @@ u8 intel_dp_dsc_get_slice_count(const st
 		u8 test_slice_count = valid_dsc_slicecount[i] * num_joined_pipes;
 
 		/*
-		 * 3 DSC Slices per pipe need 3 DSC engines,
-		 * which is supported only with Ultrajoiner.
+		 * 3 DSC Slices per pipe need 3 DSC engines, which is supported only
+		 * with Ultrajoiner only for some platforms.
 		 */
-		if (valid_dsc_slicecount[i] == 3 && num_joined_pipes != 4)
+		if (valid_dsc_slicecount[i] == 3 &&
+		    (!HAS_DSC_3ENGINES(display) || num_joined_pipes != 4))
 			continue;
 
 		if (test_slice_count >


