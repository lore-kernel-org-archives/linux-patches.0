Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1154C30EF76;
	Mon, 13 Oct 2025 15:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369666; cv=none; b=jif1FtXWVGJUK4mReV6vBUI62K3cGtFLDQZ14UROF0uy5XLfHKOyu/2K7TWMsblQLee9M3s3F/5pKkqePeAzxmhSMuscPgjll9z4eBhft8MO63GmdIBLre2eykbEzKgFNx/3oiBgZZG1acWkpMJu8kIVAd4h4FUiqJB+jZ86ml0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369666; c=relaxed/simple;
	bh=J1xrWt4ycXF/iUAjSHDYYNAJiYlmP6b3IjqRNQ5dNVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jy/0nqSNy8GIkksTNgBnSKB3Sixfyq3v17ZLBEE4KuelOERtReAkbTW+d+EARjesZWqi6bRDRp7jUVv3nUONYkhLQMBB89rqQMfqoLzJwFAMjnuVSdP3ScfZL+azHGCL3guQXVypBkKjy4Fz94ckA2k6JhLRW7DxOOPjUWetdP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTYENZns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTYENZns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC25C4CEE7;
	Mon, 13 Oct 2025 15:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369665;
	bh=J1xrWt4ycXF/iUAjSHDYYNAJiYlmP6b3IjqRNQ5dNVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTYENZns5PcthXP7wxd9tHLFPMuxewAGx3NVNrEYTNPU9EPjCPsSMIx8TryqF0LBJ
	 c3Ap9WUuagGSjQP4LcbPhV9zeN07s2o+oxi9HW7bGGHGtsMMM75qRd95oqFc8aPdak
	 SiOIJg363qFptRU6EAQ7wJsBwcZ/caPUuR/rfdkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Yuanhong <liaoyuanhong@vivo.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 326/563] wifi: iwlwifi: Remove redundant header files
Date: Mon, 13 Oct 2025 16:43:07 +0200
Message-ID: <20251013144423.072160879@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liao Yuanhong <liaoyuanhong@vivo.com>

[ Upstream commit b4b34ba66443696cc5f3e95493f9d7597259b728 ]

The header file "fw/img.h" is already included on line 9. Remove the
redundant include.

Fixes: 2594e4d9e1a2d ("wifi: iwlwifi: prepare for reading SAR tables from UEFI")
Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Link: https://patch.msgid.link/20250819121201.608770-2-liaoyuanhong@vivo.com
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
index a07c512b6ed43..735482e7adf56 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/regulatory.h
@@ -12,7 +12,6 @@
 #include "fw/api/phy.h"
 #include "fw/api/config.h"
 #include "fw/api/nvm-reg.h"
-#include "fw/img.h"
 #include "iwl-trans.h"
 
 #define BIOS_SAR_MAX_PROFILE_NUM	4
-- 
2.51.0



