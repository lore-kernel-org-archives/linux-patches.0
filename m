Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F16247282;
	Tue, 20 May 2025 14:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750006; cv=none; b=W5LvU3tF/f2555IJ0AmesDaAWliHXs+S2iF8y2Gk+Mrce+/4CuTdD5Qdd9d1t10eEqV1C6kDa7jvFZ1RgYOp9g6U/nC7t0QXINPJJ3eTsSrBE4wBKD4AgL0+AK3YmqH/Z6ez5/iQZWK3+KUrvJ9lWkV13AJOyxjfXLOO3rTTT0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750006; c=relaxed/simple;
	bh=aUdKM/avpG/dElcFw4A3FpVX7HrXOkwycwaUvV1ph5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gwYYW0MmvzE72JAWxkQmGd3sVu2kTxFI2IVdBwN/z6oMm/XIGk9vIRFxY+cH0sh/tNSjVWJNpGB74SAJDkHkXEWC9LhHoYN7Wdhtag2pvzJjmR1tnbZXqcUOo2XyDPp3nONQ2CxhYUTqFWckjtDLEvysM1Y1KhElvWN9Pn6siF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPyjPX3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPyjPX3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D39C4CEE9;
	Tue, 20 May 2025 14:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750005;
	bh=aUdKM/avpG/dElcFw4A3FpVX7HrXOkwycwaUvV1ph5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPyjPX3iHdKokwNi0j8a3Wnii/7r2c/pt1TawnsQAxjHP/ZEP77LBU42kkMIHlNU9
	 twLHx0sS09QJ3qVAtcLvTf51QqW0xlJzqU8j5RvQ4TEHnwgYdVzfan0hEk146smplN
	 52Vwdw2PFgee9gT15ivOh/r9PKFEm3+ya8AbFlHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Heusel <christian@heusel.eu>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/143] drivers/platform/x86/amd: pmf: Check for invalid Smart PC Policies
Date: Tue, 20 May 2025 15:49:19 +0200
Message-ID: <20250520125810.217736286@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 8e81b9cd6e95188d12c9cc25d40b61dd5ea05ace ]

commit 376a8c2a14439 ("platform/x86/amd/pmf: Update PMF Driver for
Compatibility with new PMF-TA") added support for platforms that support
an updated TA, however it also exposed a number of platforms that although
they have support for the updated TA don't actually populate a policy
binary.

Add an explicit check that the policy binary isn't empty before
initializing the TA.

Reported-by: Christian Heusel <christian@heusel.eu>
Closes: https://lore.kernel.org/platform-driver-x86/ae644428-5bf2-4b30-81ba-0b259ed3449b@heusel.eu/
Fixes: 376a8c2a14439 ("platform/x86/amd/pmf: Update PMF Driver for Compatibility with new PMF-TA")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Christian Heusel <christian@heusel.eu>
Link: https://lore.kernel.org/r/20250423132002.3984997-3-superm1@kernel.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/tee-if.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/platform/x86/amd/pmf/tee-if.c b/drivers/platform/x86/amd/pmf/tee-if.c
index 804c4085b82fb..b6bcc1d57f968 100644
--- a/drivers/platform/x86/amd/pmf/tee-if.c
+++ b/drivers/platform/x86/amd/pmf/tee-if.c
@@ -334,6 +334,11 @@ static int amd_pmf_start_policy_engine(struct amd_pmf_dev *dev)
 	return 0;
 }
 
+static inline bool amd_pmf_pb_valid(struct amd_pmf_dev *dev)
+{
+	return memchr_inv(dev->policy_buf, 0xff, dev->policy_sz);
+}
+
 #ifdef CONFIG_AMD_PMF_DEBUG
 static void amd_pmf_hex_dump_pb(struct amd_pmf_dev *dev)
 {
@@ -361,6 +366,11 @@ static ssize_t amd_pmf_get_pb_data(struct file *filp, const char __user *buf,
 	dev->policy_buf = new_policy_buf;
 	dev->policy_sz = length;
 
+	if (!amd_pmf_pb_valid(dev)) {
+		ret = -EINVAL;
+		goto cleanup;
+	}
+
 	amd_pmf_hex_dump_pb(dev);
 	ret = amd_pmf_start_policy_engine(dev);
 	if (ret < 0)
@@ -533,6 +543,12 @@ int amd_pmf_init_smart_pc(struct amd_pmf_dev *dev)
 
 	memcpy_fromio(dev->policy_buf, dev->policy_base, dev->policy_sz);
 
+	if (!amd_pmf_pb_valid(dev)) {
+		dev_info(dev->dev, "No Smart PC policy present\n");
+		ret = -EINVAL;
+		goto err_free_policy;
+	}
+
 	amd_pmf_hex_dump_pb(dev);
 
 	dev->prev_data = kzalloc(sizeof(*dev->prev_data), GFP_KERNEL);
-- 
2.39.5



