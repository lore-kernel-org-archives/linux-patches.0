Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017819;
	b=bQO+Lb+nqYvPs7mZ1LwKk/rDoSKHRr6k2o3PGMiePPcW+uX2SY1B4v9RBazOn+ty4WcN
	 debHCtFpNV0yWFaCt5OgnZTQwjuNpeyYXRy8JUVKDoSBmdiT5E8xyKOlVBm6WafOdUrOV
	 IZzv5c73EnyFasGmjXeVVRkAkmQXPWXiQ1YDiMmRaxEM0Ye5c44QyPfk/D7rS73ESQWZ6
	 GDiLJuJmLOHbrxrzW4UHiGHcQjpDpLs1Z9GpRHLRGI3L0Bt/8SoEF7s6UFLF9R8bWEYll
	 j08YxlSagcR+Db1IogFQRlZrBfCTT61NUY11S65kF/Go1puRNsfqoEPgPQOUTO2y7sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KQpJG7x3WIca3RcjH5OOzgYakDoEygWQ2O+tSlcSP7M=;
	b=Chb2D56qskQ7nCHxkLw247RxGePhw2deGI+b7XbbMrV1CqmAe4TedQYvBL8jgNCZxWYe
	 efLUmClgfVXwzxWgHfdlALODl87QhNpNxslZvesVi9JLO7aBsCKxvoAhrhZEScFnBoY9R
	 yApSC3igWmGJXEJFQTaZxJFF+LdrfQBK+rTcdBpQ+5+1LW93kjYK2aj+mXBudTRMlvQgE
	 g7HdSxTdWH7ZbZUIsWTRDn0jmxok4eZntKzZicFrSxeDpf9C75nYXm2cVshZUONZUZLbt
	 VXdU9SQxoRcb06sDIBu8SsCleJvK64hGXqLOcTuNRPXYstxKJ/y1jnqb5SOk+eAxwEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQKpvmoX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA7F606A31C;
	Wed, 18 Nov 2026 16:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MQKpvmoX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15AB1F000C4;
	Wed, 18 Nov 2026 16:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017819;
	bh=KQpJG7x3WIca3RcjH5OOzgYakDoEygWQ2O+tSlcSP7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQKpvmoX1SetOqjSnPBCNTl+UrDL235PHOc8/AEWdmcqKTjkvVdWcdXTO7VpBC9O4
	 nc16jsxuPx2p4623JvFsDVxGHsOPk9Oko3cttn3fg1ODHJbox/8MP+Ppfmg9pQkPDo
	 glN4+du3AdEAtvSYaLfabdnofhb9bUMKMkEmFByg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1020/2651] media: iris: fail firmware boot on invalid uc_region
Date: Wed, 18 Nov 2026 15:37:40 +0100
Message-ID: <20261118150324.658087611@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit f301102c17f22f4a140bd9a50281473e6b782f0c ]

iris_vpu_boot_firmware() polls CTRL_STATUS while the firmware boots. When
the hardware reports an invalid uc_region setting, the poll loop breaks
early with count still below max_tries. The following timeout check
(count >= max_tries) is therefore false, so the function skips the error
return and falls through to return 0, reporting a successful boot. The
caller then enables host interrupts and proceeds to use firmware that
never came up, which can lead to unhandled timeouts or hardware hangs.

Return an error directly from the uc_region error path instead of breaking
out of the loop and reporting success.

Fixes: abf5bac63f68 ("media: iris: implement the boot sequence of the firmware")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_vpu_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/iris/iris_vpu_common.c b/drivers/media/platform/qcom/iris/iris_vpu_common.c
index c9f5dc851d9f7..7e4fcf79a01da 100644
--- a/drivers/media/platform/qcom/iris/iris_vpu_common.c
+++ b/drivers/media/platform/qcom/iris/iris_vpu_common.c
@@ -84,7 +84,7 @@ int iris_vpu_boot_firmware(struct iris_core *core)
 		ctrl_status = readl(core->reg_base + CTRL_STATUS);
 		if ((ctrl_status & CTRL_ERROR_STATUS__M) == 0x4) {
 			dev_err(core->dev, "invalid setting for uc_region\n");
-			break;
+			return -EINVAL;
 		}
 
 		usleep_range(50, 100);
-- 
2.53.0



