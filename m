Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE6426B755;
	Tue, 11 Nov 2025 01:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825038; cv=none; b=SBFtDtvQzgrEW+LnkoUI3LGgsgRuqzTizkjOD+G/bLVu8RaHsPNBnaj5SM26b4W9mhoRfFK83Qtv16ctgdIdLKYvTInOa8+1t8vywXovTW0T6Bat8srb1e00EGw/B7jrVb7CncvlUFPWIekcYaNW9HgQpzIHjbS+g80fPAjJOjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825038; c=relaxed/simple;
	bh=e25/eCKx2vHwL6+dph/9ii+L5PKz+qmC7qf1ZT2F4WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrs2h+UMfseMtU3tSPskfmfzUNL5m2pfvRqG7gao2+SnSzTJ4b+fmuktXkz2FkWzMMvfbEBWyabhXUUn/02CcLMe8zVm6U30nPYvQYD3jxOt7qg1whNkAmuXHZYCjhx02lRseoiLUSZxFRWB/hMnxy9/eGdeFNbDs0ftYWoyenQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbDRWaxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbDRWaxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2385C4CEFB;
	Tue, 11 Nov 2025 01:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825038;
	bh=e25/eCKx2vHwL6+dph/9ii+L5PKz+qmC7qf1ZT2F4WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbDRWaxdmZWEBeEsVni+B22tUpmaKW2FWMohe1bo4lqjjwjLL0xk5X+QzNBrB1/px
	 5bgKqTIoXGx/mMdlHA3fBL9xhlMHLyTEhOAmQny0OjIaU2CTMwnU3FAb3cYnGolsqA
	 2ooCi+xF82UTbpadvLsq15cLH2JsW6SEulI5Cees=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vered Yavniely <vered.yavniely@intel.com>,
	Koby Elbaz <koby.elbaz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 635/849] accel/habanalabs/gaudi2: fix BMON disable configuration
Date: Tue, 11 Nov 2025 09:43:25 +0900
Message-ID: <20251111004551.784561978@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Vered Yavniely <vered.yavniely@intel.com>

[ Upstream commit b4fd8e56c9a3b614370fde2d45aec1032eb67ddd ]

Change the BMON_CR register value back to its original state before
enabling, so that BMON does not continue to collect information
after being disabled.

Signed-off-by: Vered Yavniely <vered.yavniely@intel.com>
Reviewed-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c b/drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c
index 2423620ff358f..bc3c57bda5cda 100644
--- a/drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c
+++ b/drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c
@@ -2426,7 +2426,7 @@ static int gaudi2_config_bmon(struct hl_device *hdev, struct hl_debug_params *pa
 		WREG32(base_reg + mmBMON_ADDRH_E3_OFFSET, 0);
 		WREG32(base_reg + mmBMON_REDUCTION_OFFSET, 0);
 		WREG32(base_reg + mmBMON_STM_TRC_OFFSET, 0x7 | (0xA << 8));
-		WREG32(base_reg + mmBMON_CR_OFFSET, 0x77 | 0xf << 24);
+		WREG32(base_reg + mmBMON_CR_OFFSET, 0x41);
 	}
 
 	return 0;
-- 
2.51.0



