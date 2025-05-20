Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812E624337C;
	Tue, 20 May 2025 14:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750448; cv=none; b=b0gXeeUeJU8u1tf39hVd2O0N+mE/+W8npPu1PDoAtmNmRhymc0qIFvVk9G0tPVZNKrGDvYhy3R08mMfMzQbUWRUm9DxEtMZ7HPvfQPwex6VHzjXGIiFhrFvWNHh8I3FE60IzEx+UPvvghBGypYEf0xdCLneKLuZhrGhCdVsNkpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750448; c=relaxed/simple;
	bh=q09StbpRNK8iifx1Lbf5RIAKF2SglG0xBt5ZB7GdZeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R2ndtFRxNT1zz2ywGqE/y2QtUUYy7tPPqb8/e8uoQCyETY75F7vNRy3JNbTEcLrOXpNFZlf6Pt9UXHP6TTpIB7TEaoHoChXZCiscGDtgFgyFIUnUNCDt8fAPLwYoeWmKBp+ZCKlr+pOHgbYJV40CmJObNjxqiRpTH4aGk/AyEGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7NmD7EH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7NmD7EH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B54C4CEE9;
	Tue, 20 May 2025 14:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750448;
	bh=q09StbpRNK8iifx1Lbf5RIAKF2SglG0xBt5ZB7GdZeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7NmD7EH2nuxnDr+mHJ6iDrcvR0Ti5u6BhvLKwx0y5D+7H5B58NtSAKfiBgQoT59W
	 HHCTxiSA136OtODP67NqmxfmSj2sdFwzDGVTREU14c43H0Unf4e4+LQeT4iO89rW/7
	 8zcG+7eCm9ECXcuuFtvLk+usjbzmQEMlyt5OvaeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Heusel <christian@heusel.eu>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 004/145] drivers/platform/x86/amd: pmf: Check for invalid Smart PC Policies
Date: Tue, 20 May 2025 15:49:34 +0200
Message-ID: <20250520125810.718597952@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index e008ac079fade..d3bd12ad036ae 100644
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



