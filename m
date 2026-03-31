Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9024426D08;
	Tue, 31 Mar 2026 16:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975249; cv=none; b=OPcNEw5ffSi0VVB62BIz55TbI6YaUZ6czDDEOK0G7Yu3XD6pr0W7XVEclLFk2mRdS92AyznJ6RmshBocJnDL6eMSvLDLCBMakKUOvNYJIAc+qYpxB3fW6+eJ0PeptrAbk2g36qaxJF8Ui74vaJY5HITP8clEy9er2oYtZV9hqDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975249; c=relaxed/simple;
	bh=+B0+KrS9R0p3RP6k0X1d217YdSo+P2NxBrBatwcoz4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mce4SCyFne214NkJ0DsFqpTyaU4/o8P8Bid4+UbyBLvBBetD5dzkpTG/KuZ6yFlOR62Jt3OSrx7m5hWUG4yx/Q5vqN60gSnrcPiR1HRreAS8v33xE64XUA9qI9oThJHXU5Cb14itfmLhMb3XXt2j9bA+d59/SHBOJCKwBKHqS3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2cC0FWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2cC0FWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50867C19423;
	Tue, 31 Mar 2026 16:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975249;
	bh=+B0+KrS9R0p3RP6k0X1d217YdSo+P2NxBrBatwcoz4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2cC0FWqTzkqGLi5CqhUUHVqjlXgeAH27l9Br9oXXftOy2B9EpunVXcczJ+YzC2s6
	 1nUQERIIW3FzGtjEc2fKL2wEusDctUlHU0S7c6+hlWg7wvVxK9PUM/PdvtBlGWNbPI
	 lRh+j0K3PgDCO4gIm0Sf+R6t+q7b9zc8O7NRwqPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.19 221/342] platform/x86: ISST: Correct locked bit width
Date: Tue, 31 Mar 2026 18:20:54 +0200
Message-ID: <20260331161807.106190425@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit fbddf68d7b4e1e6da7a78dd7fbd8ec376536584a upstream.

SST-PP locked bit width is set to three bits. It should be only one bit.
Use SST_PP_LOCK_WIDTH define instead of SST_PP_LEVEL_WIDTH.

Fixes: ea009e4769fa ("platform/x86: ISST: Add SST-PP support via TPMI")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260323153635.3263828-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -871,7 +871,7 @@ static int isst_if_get_perf_level(void _
 	_read_pp_info("current_level", perf_level.current_level, SST_PP_STATUS_OFFSET,
 		      SST_PP_LEVEL_START, SST_PP_LEVEL_WIDTH, SST_MUL_FACTOR_NONE)
 	_read_pp_info("locked", perf_level.locked, SST_PP_STATUS_OFFSET,
-		      SST_PP_LOCK_START, SST_PP_LEVEL_WIDTH, SST_MUL_FACTOR_NONE)
+		      SST_PP_LOCK_START, SST_PP_LOCK_WIDTH, SST_MUL_FACTOR_NONE)
 	_read_pp_info("feature_state", perf_level.feature_state, SST_PP_STATUS_OFFSET,
 		      SST_PP_FEATURE_STATE_START, SST_PP_FEATURE_STATE_WIDTH, SST_MUL_FACTOR_NONE)
 	perf_level.enabled = !!(power_domain_info->sst_header.cap_mask & BIT(1));


