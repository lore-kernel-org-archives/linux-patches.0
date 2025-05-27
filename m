Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7B425A627;
	Tue, 27 May 2025 17:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367592; cv=none; b=dzywA+BW6Nm4rY0tYYCOzLeKzGat8/ev4v3iQ5WJ4auGJwJOlWljCXyzvL/JOr9ac++c5UfW8yQ5n4qdp/he9V/AJLnu/Vh/ww3sts1CZstMfB3OfPl4JyT4luCOcv30+Otzoorrs88S2mPRsCnC8RNf72eIucgAd3SqR1by6sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367592; c=relaxed/simple;
	bh=6zlf3GUti69iTzWRSjI8GeAYJhAwIeBBPTJQ5wBBBA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUJnCMp7HfErFxJ02clH4sWnxb4QvMaR8soTbpEmly89VXPh8vaMUDvVLMwxwnBJu9eCP2k3KcPXO/1CHDwLTz+4wp9W4S7BbZgYnDanmf2wfbtBcGng0kQb5eFndAnPIDN1XYB70G0Hnvh6ZYh6Xh1HFeHClXnycQR1kajG8EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ueV+nzmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ueV+nzmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE1AC4CEE9;
	Tue, 27 May 2025 17:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367591;
	bh=6zlf3GUti69iTzWRSjI8GeAYJhAwIeBBPTJQ5wBBBA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ueV+nzmwoCRLDQ8yD2/UKVnSEMJRtxmRfWUsahRd5ovUr0JOFkPVNLcCiaQS5sn/D
	 YtsAUbnXdWlnVmj82lTlEHq4ALdiUljyiTdgT8Sh8OgW/URZZNXzqb9X43OmbvuCZO
	 6G4JH9LozQAC0gjj0hRQEmoU8AyeaCb4GGiP9ZkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siva Durga Prasad Paladugu <siva.durga.prasad.paladugu@amd.com>,
	Nava kishore Manne <nava.kishore.manne@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 436/783] firmware: xilinx: Dont send linux address to get fpga config get status
Date: Tue, 27 May 2025 18:23:53 +0200
Message-ID: <20250527162530.881506736@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Siva Durga Prasad Paladugu <siva.durga.prasad.paladugu@amd.com>

[ Upstream commit 5abc174016052caff1bcf4cedb159bd388411e98 ]

Fpga get config status just returns status through ret_payload and there
is no need to allocate local buf and send its address through SMC args.
Moreover, the address that is being passed till now is linux virtual
address and is incorrect.
Corresponding modification has been done in the firmware to avoid using the
address sent by linux.

Signed-off-by: Siva Durga Prasad Paladugu <siva.durga.prasad.paladugu@amd.com>
Signed-off-by: Nava kishore Manne <nava.kishore.manne@amd.com>
Link: https://lore.kernel.org/r/20250207054951.1650534-1-nava.kishore.manne@amd.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/xilinx/zynqmp.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index 720fa8b5d8e95..7356e860e65ce 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -1139,17 +1139,13 @@ EXPORT_SYMBOL_GPL(zynqmp_pm_fpga_get_status);
 int zynqmp_pm_fpga_get_config_status(u32 *value)
 {
 	u32 ret_payload[PAYLOAD_ARG_CNT];
-	u32 buf, lower_addr, upper_addr;
 	int ret;
 
 	if (!value)
 		return -EINVAL;
 
-	lower_addr = lower_32_bits((u64)&buf);
-	upper_addr = upper_32_bits((u64)&buf);
-
 	ret = zynqmp_pm_invoke_fn(PM_FPGA_READ, ret_payload, 4,
-				  XILINX_ZYNQMP_PM_FPGA_CONFIG_STAT_OFFSET, lower_addr, upper_addr,
+				  XILINX_ZYNQMP_PM_FPGA_CONFIG_STAT_OFFSET, 0, 0,
 				  XILINX_ZYNQMP_PM_FPGA_READ_CONFIG_REG);
 
 	*value = ret_payload[1];
-- 
2.39.5



