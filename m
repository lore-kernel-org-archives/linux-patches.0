Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CA574C09;
	Mon,  8 Apr 2024 13:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584092; cv=none; b=sndx3XhA+Oo0rpOjRMsS5P6rzqy0O8PDyk7lHYuwNzCwQu01eoHFsYQ6thS9bK/zR0yr9ceDmitaTYt1isOonAjZ094oepxBOhl5cb4ZLxyp2k4ocP9Z0rMi6l2lQT3qQfXzifVZHTrxTDb/zUxtipGyy9O+Kxe96HrRW3Ec5Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584092; c=relaxed/simple;
	bh=uAOepB3I9Yyh4ONCho3/oPyvYnNDJZtLQnp2i+N2HTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6WmQiTBtxF1LjWwYXSSs6eRIU2j4WRMSeyj848KpgRVhFIrFs/ugcrMwPEDU1KymiwncyfKHVOjpwVklZJGhihdVTI0C7u95f+/PF4uMgHHPCrormaRvP4J1ISp/78cPLnxeL2UVHXJo6A3kzvuujLTbKG4WJ36eno3VVaW1yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10WHhml4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10WHhml4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09D2C43394;
	Mon,  8 Apr 2024 13:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584092;
	bh=uAOepB3I9Yyh4ONCho3/oPyvYnNDJZtLQnp2i+N2HTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10WHhml4ryVMgPtRfdeXJB6KFr1U9c62+oJhW3GzzUZznlCJLnXljt127E8JUJhLH
	 wH+n+5J+RF1CSv6Xs9Dj8PX4Zb8r1S9lJYmAE5wR6gym4SG+ndR3i5rm72O063AMFm
	 JWSDqZv8ioWm8RL1VhXP96O6A6q+V0kfy5NZw30o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.8 260/273] drm/i915/dp: Fix the computation for compressed_bpp for DISPLAY < 13
Date: Mon,  8 Apr 2024 14:58:55 +0200
Message-ID: <20240408125317.553547993@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

From: Ankit Nautiyal <ankit.k.nautiyal@intel.com>

commit f7caddfd558e32db0ae944256e623a259538b357 upstream.

For DISPLAY < 13, compressed bpp is chosen from a list of
supported compressed bpps. Fix the condition to choose the
appropriate compressed bpp from the list.

Fixes: 1c56e9a39833 ("drm/i915/dp: Get optimal link config to have best compressed bpp")
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.7+
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/10162
Signed-off-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240305054443.2489895-1-ankit.k.nautiyal@intel.com
(cherry picked from commit 5a1da42b50f3594e18738885c2f23ed36629dd00)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1916,8 +1916,9 @@ icl_dsc_compute_link_config(struct intel
 	dsc_max_bpp = min(dsc_max_bpp, pipe_bpp - 1);
 
 	for (i = 0; i < ARRAY_SIZE(valid_dsc_bpp); i++) {
-		if (valid_dsc_bpp[i] < dsc_min_bpp ||
-		    valid_dsc_bpp[i] > dsc_max_bpp)
+		if (valid_dsc_bpp[i] < dsc_min_bpp)
+			continue;
+		if (valid_dsc_bpp[i] > dsc_max_bpp)
 			break;
 
 		ret = dsc_compute_link_config(intel_dp,


