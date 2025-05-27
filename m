Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6133678F32;
	Tue, 27 May 2025 17:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365377; cv=none; b=axKmS4Bip3TMc9aI7tglUZzqmrx+iQnx/pAxSE6KsS1SwDj4aigqNtfBPw7fl6WGimTEJoe00SQBHGVUHknYJABxHFh6I/kgkUWVf94xjUrJddq+9Xtpn9pq3R2E4Db76C0cBGgCnykS89VGT3g4Y1YisySDUgwrsWtfkK2jwY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365377; c=relaxed/simple;
	bh=OI5crT65KPE0w1hDBTry/V8FjhFTeNIH+gD0ECHMFcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EX4O6xnV4yJsyAKAYfB5q3VnOYYB6izO3EKOGZURgb55FqTPBNM+ZgikQJDtlKcdsr+YAyf3+uYUjn1tG1CjAZIcnodKzsBTg8/aLSC3LOafMxU+dlJpv9pue4YizDSZag29MDOBCIKSuR/1e/vmOGavnKI9Dux5ti1dadg8zYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XJ4/rT8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XJ4/rT8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E73C4CEED;
	Tue, 27 May 2025 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365377;
	bh=OI5crT65KPE0w1hDBTry/V8FjhFTeNIH+gD0ECHMFcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJ4/rT8YjXqAXqM86jA2Mkyvviwwd3Ck9VJXB0S+e5zESJvtYtgd/WyTLPHDkcAsW
	 2JhoFYjMKLnGNCWHaypKAX9D/bbKiYMONquri7LXHuuLl/NmIKuerJCFnR/3aNv73N
	 +KaoD068KbZWyvZ4EhmFGt9oe75E4gGTGlTjHgQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siva Durga Prasad Paladugu <siva.durga.prasad.paladugu@amd.com>,
	Nava kishore Manne <nava.kishore.manne@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 357/626] firmware: xilinx: Dont send linux address to get fpga config get status
Date: Tue, 27 May 2025 18:24:10 +0200
Message-ID: <20250527162459.520662964@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index add8acf66a9c7..5578158f13750 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -1012,17 +1012,13 @@ EXPORT_SYMBOL_GPL(zynqmp_pm_fpga_get_status);
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



