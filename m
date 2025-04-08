Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE0F2676C9;
	Tue,  8 Apr 2025 11:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110986; cv=none; b=Jd7VGlsXtM0mysyeMq1DmfFyMBDw0C7CHQYIWKtusHw3gGgnb1X5TR8jf21ZuPGnwkGYTKd8Ntut2R0EvPrPJ3DIBo7zbJVmj0VDu8RSJigxmrEY34gOrc2xljpb/Ehbgm5JexnrB2yBc74lDESlcNFZaareDTJQjYs4T6p/29o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110986; c=relaxed/simple;
	bh=fo6y+RwAcFPdAh94DEXr7QH59BH86q4Pjbxps4lBZKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUNTxsh6K5fJL01lhC0rn259CgcHcG7j66vqBAsO6tcMXjwGhDn8en89SAAR4T1tgMjyKNVJ0iHTHfhBmLBT2I2uiJfue0U7F/2cdPsWcJGIBcAFDFJ6tOil5iJFhA9b+MczQA1kxpogCoDA/X95GXMrP+HDdq+Qin/Q9JVjkRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOfuhSPH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOfuhSPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CE9C4CEE5;
	Tue,  8 Apr 2025 11:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110986;
	bh=fo6y+RwAcFPdAh94DEXr7QH59BH86q4Pjbxps4lBZKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOfuhSPHAqJ9C7l5IzS8TE1MYKMgMYNm92MRono4bA2whXfo6r1tXOCZMwxOCEoTn
	 8L5uxqn0zsFZ03UA1jFeJMi6G5L2p/9baz99+euwDT7dcbcFVANpYnkF91yZ8VF6uF
	 NIy+STMQW/Vgxq3+SXqzB/F9Kb7RCrIozcjarNWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 268/731] accel/amdxdna: Return error when setting clock failed for npu1
Date: Tue,  8 Apr 2025 12:42:45 +0200
Message-ID: <20250408104920.513547602@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 0c2768bf818904db705ff18674f771c3c4d8bbca ]

Due to miss returning error when setting clock, the smatch static
checker reports warning:
  drivers/accel/amdxdna/aie2_smu.c:68 npu1_set_dpm()
  error: uninitialized symbol 'freq'.

Fixes: f4d7b8a6bc8c ("accel/amdxdna: Enhance power management settings")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/dri-devel/202267d0-882e-4593-b58d-be9274592f9b@stanley.mountain/
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250109194811.499505-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_smu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/accel/amdxdna/aie2_smu.c b/drivers/accel/amdxdna/aie2_smu.c
index 73388443c6767..d303701b0ded4 100644
--- a/drivers/accel/amdxdna/aie2_smu.c
+++ b/drivers/accel/amdxdna/aie2_smu.c
@@ -64,6 +64,7 @@ int npu1_set_dpm(struct amdxdna_dev_hdl *ndev, u32 dpm_level)
 	if (ret) {
 		XDNA_ERR(ndev->xdna, "Set npu clock to %d failed, ret %d\n",
 			 ndev->priv->dpm_clk_tbl[dpm_level].npuclk, ret);
+		return ret;
 	}
 	ndev->npuclk_freq = freq;
 
@@ -72,6 +73,7 @@ int npu1_set_dpm(struct amdxdna_dev_hdl *ndev, u32 dpm_level)
 	if (ret) {
 		XDNA_ERR(ndev->xdna, "Set h clock to %d failed, ret %d\n",
 			 ndev->priv->dpm_clk_tbl[dpm_level].hclk, ret);
+		return ret;
 	}
 	ndev->hclk_freq = freq;
 	ndev->dpm_level = dpm_level;
-- 
2.39.5



