Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645CF3EF0A2;
	Tue, 31 Mar 2026 16:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976029; cv=none; b=jsGKHb+zPQ89OqKIGhUYz5m1o11O9rR+QXakWSmvGvBuMWkOkn1n/Z2nJPsilVrPgIHlMWEFidSSkO2PT0GydSoGpmifL6bxUPrQTW/ls9l+oRqLaV1HG4Qgz5CRDGHnTO4mqtqRStFkF7i8ymGsG4dqG5RtnCONuYLDFh7Kc2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976029; c=relaxed/simple;
	bh=oezdWL/0DswYLeL9e5nLBLUw4w0BWEFkgJxdE1YzjMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WoX0/8at53ShxYYujqQeWln1ijy8q8x6EX+frWgu1DiTbgSFm3GODLH9XwNYxUXCWjWrAEEIAE3dtWus8+iWnbxomK9a0m3ENNjcPEgY7KV168HarRG9/R8emWBqefgieL44guvrGbA2YB6CZCyl9rXc9yxyZUZc2CSU4zgUM9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8/maZ2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8/maZ2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC30FC2BCB1;
	Tue, 31 Mar 2026 16:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976029;
	bh=oezdWL/0DswYLeL9e5nLBLUw4w0BWEFkgJxdE1YzjMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8/maZ2PSW+VNXiBMG3aNiwJpVdCoFOleX8PeEtoiwQOjp+w2BmFdkmVqyFQDx/Oi
	 2dgHDbbqLpkz8GAS42R4IFXZ3ljZzXvYy3t2n1011YbmynexTpTZteS9nRUsXB4rGW
	 ziQZajCvyk6Tv2BEa5fyEZsJ4fqFyB54lPapmTPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 147/244] platform/x86: ISST: Correct locked bit width
Date: Tue, 31 Mar 2026 18:21:37 +0200
Message-ID: <20260331161747.194648161@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -866,7 +866,7 @@ static int isst_if_get_perf_level(void _
 	_read_pp_info("current_level", perf_level.current_level, SST_PP_STATUS_OFFSET,
 		      SST_PP_LEVEL_START, SST_PP_LEVEL_WIDTH, SST_MUL_FACTOR_NONE)
 	_read_pp_info("locked", perf_level.locked, SST_PP_STATUS_OFFSET,
-		      SST_PP_LOCK_START, SST_PP_LEVEL_WIDTH, SST_MUL_FACTOR_NONE)
+		      SST_PP_LOCK_START, SST_PP_LOCK_WIDTH, SST_MUL_FACTOR_NONE)
 	_read_pp_info("feature_state", perf_level.feature_state, SST_PP_STATUS_OFFSET,
 		      SST_PP_FEATURE_STATE_START, SST_PP_FEATURE_STATE_WIDTH, SST_MUL_FACTOR_NONE)
 	perf_level.enabled = !!(power_domain_info->sst_header.cap_mask & BIT(1));


