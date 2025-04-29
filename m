Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B092459EA;
	Tue, 29 Apr 2025 17:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947542; cv=none; b=QRl2pM5C8MoEpnLD0r0ZvrAAecearLSqvSCXVpuZU1tqbRd3Pn7rwRPpPBPzrzH+DA4tAsmo9bDS7WQfWRcAhAhe/zpOWm3FjiE/TKrm2uLNiTdRQAavMFgrzPRRCGpUWfXpE0/DYWTzl8CyJUe/ln4c0Xa2kvnp7h/n2Cda0rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947542; c=relaxed/simple;
	bh=kVrQQdiBSzP8sfIXPbTq4Z5mfvBkWzO5h3skU70nGDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThiSHjCFJQKj27QT79NVd4cAnZUbs2A41REp4tSVRChBWKJtzJ1FnfvcRZM4FMTSgue0jKPUwRsXmh0Hd1b3vlDx8suR0qzU77YAEDT3C6v/gB8eSk7AoODevN6c8u2DZSSmKgjxBPp6y+XKPma28HaRvojsK7UOsDKxZhAmsxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9bFfrRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9bFfrRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66A51C4CEE3;
	Tue, 29 Apr 2025 17:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947542;
	bh=kVrQQdiBSzP8sfIXPbTq4Z5mfvBkWzO5h3skU70nGDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r9bFfrRp7Qao8STsmbYqaX1ujMqguIzzDX0aaf5JHyhDUwuF6LiC/jhUXJUx28pye
	 oB3fxowntu22qAKr13t2nLPfwihnXaUpnmAC3LM4ZSfShGZ7F6vftpHJs97dIzW32N
	 09w8vxX85StWbMeK2YBtRotRWYRPlfHUndrvkxM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 027/280] scsi: ufs: qcom: fix dev reference leaked through of_qcom_ice_get
Date: Tue, 29 Apr 2025 18:39:28 +0200
Message-ID: <20250429161116.214803911@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit ded40f32b55f7f2f4ed9627dd3c37a1fe89ed8c6 ]

The driver leaks the device reference taken with
of_find_device_by_node(). Fix the leak by using devm_of_qcom_ice_get().

Fixes: 56541c7c4468 ("scsi: ufs: ufs-qcom: Switch to the new ICE API")
Cc: stable@vger.kernel.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com> # SCSI
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20250117-qcom-ice-fix-dev-leak-v2-3-1ffa5b6884cb@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index e12c5f9f79563..4557b1bcd6356 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -118,7 +118,7 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *host)
 	struct device *dev = hba->dev;
 	struct qcom_ice *ice;
 
-	ice = of_qcom_ice_get(dev);
+	ice = devm_of_qcom_ice_get(dev);
 	if (ice == ERR_PTR(-EOPNOTSUPP)) {
 		dev_warn(dev, "Disabling inline encryption support\n");
 		ice = NULL;
-- 
2.39.5



