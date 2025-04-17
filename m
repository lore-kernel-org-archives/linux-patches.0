Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136D32561C7;
	Thu, 17 Apr 2025 18:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913640; cv=none; b=bxdxWw0yqqnS6YThYkv9nemx72sKCT9zNzNxyb49r9V6cc1ozwf/kRfSpuc0hP+Iu1hH8Uhlrj61rWTz2vWEyNdtBzeIMQpAfhfq75Nmjm5EjaBo5oYkvNvGB4zjkXYfRUOihZFuHKV2BzeE6pbazdDDNPn5mbaHGNKShdraPiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913640; c=relaxed/simple;
	bh=kdmQVCsdUIwMYeTmbLqI3PDbIR1G5N75KZE9HmvSOEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9HC3lmw/vP2mBGbZXfUtefICq8/T3mk5q/SIk4QRXPvJEAkRt26ClVei80lY7MnqIBRuQV9N8pUjzn1Gb/SfN2rlHNyx1Td2iTjd47MYUcuF75+zcbK8GC5hbpS8dUpxU51JS3hPePIdOOyvtT7BqrXhU0iYTqhLHYxiHi7ZbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+Os+lEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+Os+lEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A760C4CEE4;
	Thu, 17 Apr 2025 18:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913639;
	bh=kdmQVCsdUIwMYeTmbLqI3PDbIR1G5N75KZE9HmvSOEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+Os+lEfgecyBBfNvQKVNLmFKcPb54hRNdBCYdpgyJ5tELFa5cHm/D844Ey4WH984
	 oE3L183UXavq88PZJlXtykASJZ5wRmpotfBBXh5ab8gnDhxwjBZ0PFZO7yDxJ2bQoj
	 5HbdBUFi2Yqi1uHDf9Ail+F7r98u+RMu78MmEpnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.14 405/449] scsi: ufs: qcom: fix dev reference leaked through of_qcom_ice_get
Date: Thu, 17 Apr 2025 19:51:33 +0200
Message-ID: <20250417175134.577020991@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Tudor Ambarus <tudor.ambarus@linaro.org>

commit ded40f32b55f7f2f4ed9627dd3c37a1fe89ed8c6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufs-qcom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -125,7 +125,7 @@ static int ufs_qcom_ice_init(struct ufs_
 	int err;
 	int i;
 
-	ice = of_qcom_ice_get(dev);
+	ice = devm_of_qcom_ice_get(dev);
 	if (ice == ERR_PTR(-EOPNOTSUPP)) {
 		dev_warn(dev, "Disabling inline encryption support\n");
 		ice = NULL;


