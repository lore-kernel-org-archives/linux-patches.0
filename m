Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061375;
	b=OvmnaI+vvL2pYSpDI0gNVc4cXUNBDhHlG+Ke06TQoOYrhBX3MaIk3ZEa5sDdDskU1oXP
	 DgSJ79qJzx8VnDIf+7zjEsZPATVF5SKNoEOPxNjwGoi8uI25IUlJDFiyNL8k0WfB8BSt1
	 Ts0Ql6LtHe1vPbJBGwWjbhbO7KJs9xJCV1Bc3Xkvzm46sTDsSsP+OGx1HW6hdFbkMvXNE
	 cHenXKw4v004fhijHP0vTKPKrphYxr05GR8wE3q7XLkA+qacQ/aezicPQ3YPJ4H9M9FEN
	 HQN/xc2yndVbEMkgjHg+w63G6yVWTjFMyT0BUHR57KJ6Zbrz325KnmM6oOpKyWlt0xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dBhwOaMpbNU/cWchAz35v5Af4URM2PiMZ8Bcn0YMhNA=;
	b=jpp1NH35lskek89JfnV14Masbzb9esuiPPDMNBEIhF4aKn8/E+9zxL8zsx9IqJ6BQ8YO
	 fsh4/FGVJSIOIIkM+Xj/Fbm4GSjDxixQ994J8SIZ6DDehx3LHhFAaL1mbgOk7YbVnacik
	 aR0ZSZkkJ+xZvcMABBDC6I/ZgHhC4tzA6FaavLy2jlZVXEU4lHhDv3bjmaWcPT67kxqz1
	 2R/yGik0DKBiTdZ8vQBB3vrb+ANr3Zg0lkM0SNqWAyuLgpf8QKQlsrl9Z1NkOuLsbI5jd
	 eRYKOcGDZRRO+sp2didXnPAbjRAzWwMB6jPQh7BJNW3J2YuC+F3r35aXf193sYB/C4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WK5X5nMh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883EE606A337;
	Sat,  7 Nov 2026 14:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WK5X5nMh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342991F008A7;
	Sat,  7 Nov 2026 14:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061375;
	bh=dBhwOaMpbNU/cWchAz35v5Af4URM2PiMZ8Bcn0YMhNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WK5X5nMhwUD7rDntS9ROzHexynNb7N/PD0d/IVQOac9Doxo+UwvN3NPOZ/CmhrloJ
	 lWc7eN+uARqTm7djwdCBu2izB897DzNmkym4f7ow13LvpJhanidfk+OeOmN3vyRt1e
	 yAOCK3JCTm4u3st0e29OXaziES0zVkaw8HXxW3TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0460/1536] platform/x86/amd/pmc: Fix msg_port restoration in amd_stb_debugfs_open_v2()
Date: Sat,  7 Nov 2026 08:41:16 -0500
Message-ID: <20261107135010.443252780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit cbb32ff92f8a62212e0f7384b1de986ced92082b ]

amd_stb_debugfs_open_v2() switches dev->msg_port to MSG_PORT_S2D to query
S2D telemetry but only restores it to MSG_PORT_PMC on one path.  The early
return on the dump_custom_stb path (and the error/allocation returns) leave
the port stuck on MSG_PORT_S2D, so subsequent SMU communication - including
the s2idle prepare/restore handlers - is directed at the wrong mailbox.

Consolidate the exit path through a single label so the message port is
always restored, mirroring the fix in amd_stb_s2d_init().

Reported-by: sashiko.dev
Link: https://sashiko.dev/#/patchset/20260717162023.956346-1-mario.limonciello%40amd.com
Fixes: 2851f4f8ed4e ("platform/x86/amd/pmc: Define enum for S2D/PMC msg_port and add helper function")
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260721181756.143084-3-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ sashal: Kept this tree's older names (amd_pmc_stb_v2_data, amd_pmc_stb_handle_efr) and its kmalloc(struct_size(...), GFP_KERNEL) call instead of kmalloc_flex when applying the msg_port restoration. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/mp1_stb.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc/mp1_stb.c b/drivers/platform/x86/amd/pmc/mp1_stb.c
index d662b9b91da76..949fb99e7c37c 100644
--- a/drivers/platform/x86/amd/pmc/mp1_stb.c
+++ b/drivers/platform/x86/amd/pmc/mp1_stb.c
@@ -148,7 +148,7 @@ static int amd_pmc_stb_debugfs_open_v2(struct inode *inode, struct file *filp)
 	struct amd_pmc_dev *dev = filp->f_inode->i_private;
 	u32 fsize, num_samples, val, stb_rdptr_offset = 0;
 	struct amd_pmc_stb_v2_data *stb_data_arr;
-	int ret;
+	int ret = 0;
 
 	/* Write dummy postcode while reading the STB buffer */
 	ret = amd_pmc_write_stb(dev, AMD_PMC_STB_DUMMY_PC);
@@ -167,22 +167,24 @@ static int amd_pmc_stb_debugfs_open_v2(struct inode *inode, struct file *filp)
 	 * the enhanced dram size. Note that we land here only for the
 	 * platforms that support enhanced dram size reporting.
 	 */
-	if (dump_custom_stb)
-		return amd_pmc_stb_handle_efr(filp);
+	if (dump_custom_stb) {
+		ret = amd_pmc_stb_handle_efr(filp);
+		goto out;
+	}
 
 	/* Get the num_samples to calculate the last push location */
 	ret = amd_pmc_send_cmd(dev, S2D_NUM_SAMPLES, &num_samples, dev->stb_arg.s2d_msg_id, true);
-	/* Clear msg_port for other SMU operation */
-	dev->msg_port = MSG_PORT_PMC;
 	if (ret) {
 		dev_err(dev->dev, "error: S2D_NUM_SAMPLES not supported : %d\n", ret);
-		return ret;
+		goto out;
 	}
 
 	fsize = min(num_samples, S2D_TELEMETRY_BYTES_MAX);
 	stb_data_arr = kmalloc(struct_size(stb_data_arr, data, fsize), GFP_KERNEL);
-	if (!stb_data_arr)
-		return -ENOMEM;
+	if (!stb_data_arr) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	stb_data_arr->size = fsize;
 
@@ -205,7 +207,10 @@ static int amd_pmc_stb_debugfs_open_v2(struct inode *inode, struct file *filp)
 
 	filp->private_data = stb_data_arr;
 
-	return 0;
+out:
+	/* Restore the default message port for subsequent SMU operations */
+	dev->msg_port = MSG_PORT_PMC;
+	return ret;
 }
 
 static ssize_t amd_pmc_stb_debugfs_read_v2(struct file *filp, char __user *buf, size_t size,
-- 
2.53.0



