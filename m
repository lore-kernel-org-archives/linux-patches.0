Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DC43271F5;
	Fri, 21 Nov 2025 13:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732881; cv=none; b=urxSAGWP1L/2hrWnWPtTj2NR9GBhrrKoh5ZCvLvngmbvEx6p/8BTk+py3L8QFnJarfvjRBEL43Rfq7Rm8SJCn0WC0BqhK+oAk2LaDKMjOiRZI9lI2O7OyEMogcPGmu5FTxtP2qZmzAuW3PQZhxALYNCggjwwytQ383oK0cCPvVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732881; c=relaxed/simple;
	bh=Y4RW3940pkCXCJ8ciOIwAGi/qioV9nqRCU1QFjLOp1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4T1XFwXsVBYd2MBGJtD57UX3yei7KMuuukIqyq0U6dcVNTMzXXwUvuzC4rTBo/LVe+7rIceThC7E1XGHTeFoQA68VlgGzzsr5qq7+AnXEAvf1TiwCDXkUPvMdMP9EbaUZfJboH+PxEUWAtXDJH8j5KohiUcMEBC4IUo3ZO17zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ul3SJhvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ul3SJhvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E26BC4CEF1;
	Fri, 21 Nov 2025 13:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732880;
	bh=Y4RW3940pkCXCJ8ciOIwAGi/qioV9nqRCU1QFjLOp1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ul3SJhvP7VmW222h68CykHR85i3Qzmd1OWaVuKsMQCBxV+Pg2jJsSmIA1PSIcnmyZ
	 lphjoAmnzbqSBZYcgAboIRG1eJyAby619rZDxWrVNAQS6Vt7YxxWGu4B/E5CPHB4kP
	 rzp8+4w9d1K1QicFx39rXBAQvMYH0TuBBcxc1PqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vered Yavniely <vered.yavniely@intel.com>,
	Koby Elbaz <koby.elbaz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 274/529] accel/habanalabs/gaudi2: fix BMON disable configuration
Date: Fri, 21 Nov 2025 14:09:33 +0100
Message-ID: <20251121130240.771161898@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 25b5368f37dde..9ff00b65ae34b 100644
--- a/drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c
+++ b/drivers/accel/habanalabs/gaudi2/gaudi2_coresight.c
@@ -2409,7 +2409,7 @@ static int gaudi2_config_bmon(struct hl_device *hdev, struct hl_debug_params *pa
 		WREG32(base_reg + mmBMON_ADDRH_E3_OFFSET, 0);
 		WREG32(base_reg + mmBMON_REDUCTION_OFFSET, 0);
 		WREG32(base_reg + mmBMON_STM_TRC_OFFSET, 0x7 | (0xA << 8));
-		WREG32(base_reg + mmBMON_CR_OFFSET, 0x77 | 0xf << 24);
+		WREG32(base_reg + mmBMON_CR_OFFSET, 0x41);
 	}
 
 	return 0;
-- 
2.51.0



