Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253483FF8A7;
	Tue, 31 Mar 2026 16:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974501; cv=none; b=dxlFJMVSwhVhYCubarDmguBhzZFuSp10vRVFD08dxMVOUlhHpO9PNT/bmKmeikWZVKHLVlN2SluzBRCD0F5fsVUHCTICiaxgJUM0X0ROywTsgbc5qXlyKYZul/VFPUvAvXrjVE3uuD3FvXLKPHxZ2Iwe85ZQu6A74j9hroEd+i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974501; c=relaxed/simple;
	bh=yf0aIvuNxwi9WN0WfrQXYMr+RXFLTcn+nd4kqY08I6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BSBuxNe7UDK/bEQP7ZHG5kkx2fquDxyBpUgza0jRm3cjAgjnrKGRuRqPOtAhtmFL7AdRrGxh3U+vkyDRzJs5h/qf7dEp47MJyhdr6Kej7zTOeQ44xaWEDKgQEMQz+dpZxrvSrW3Ib36o18eeIwxEWnDtf7OJX5Q5v3axHmWwbRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zG8uXSsp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zG8uXSsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AF6C19423;
	Tue, 31 Mar 2026 16:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974500;
	bh=yf0aIvuNxwi9WN0WfrQXYMr+RXFLTcn+nd4kqY08I6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zG8uXSspoyUDahhq1JSv0EekuhZknFkmU60vR1WjJ7JS0VSRsx4N/N2HaHzQ/1SAW
	 RXPb6fwwYwzgvx4KtfpGK6pAPPToTVIDuxl8hT4C3wbthTqlc6aOX/VVmit5eyDbTx
	 PhYjscAw+3/1QStRzFsEJQiJBmE2i2HG3nDdFVNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 108/175] platform/x86: ISST: Correct locked bit width
Date: Tue, 31 Mar 2026 18:21:32 +0200
Message-ID: <20260331161733.748390863@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -709,7 +709,7 @@ static int isst_if_get_perf_level(void _
 	_read_pp_info("current_level", perf_level.current_level, SST_PP_STATUS_OFFSET,
 		      SST_PP_LEVEL_START, SST_PP_LEVEL_WIDTH, SST_MUL_FACTOR_NONE)
 	_read_pp_info("locked", perf_level.locked, SST_PP_STATUS_OFFSET,
-		      SST_PP_LOCK_START, SST_PP_LEVEL_WIDTH, SST_MUL_FACTOR_NONE)
+		      SST_PP_LOCK_START, SST_PP_LOCK_WIDTH, SST_MUL_FACTOR_NONE)
 	_read_pp_info("feature_state", perf_level.feature_state, SST_PP_STATUS_OFFSET,
 		      SST_PP_FEATURE_STATE_START, SST_PP_FEATURE_STATE_WIDTH, SST_MUL_FACTOR_NONE)
 	perf_level.enabled = !!(power_domain_info->sst_header.cap_mask & BIT(1));


