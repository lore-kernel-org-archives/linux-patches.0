Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BD71B4153;
	Thu, 17 Apr 2025 18:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916116; cv=none; b=T01bvEhLUJIG4iVmvI+hV/glAVcMdHTWKClgD/UVotNoAbs62G2pfiCZxicglYW8AUsq1VJUMh9jeDSxbkBKg3qLFxELYeReYji2W3d7ip4/EOD88FgV9ACDw75VWZ35SpW+PeP+cYZ5OJwFhSlqZ+gVJOe+pvjrEYn1+cqfacs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916116; c=relaxed/simple;
	bh=gijVzA+SOKS3jgFJI5D8zeDWcRSlMIPdRdvgNA8sJRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QozGBwfc6AOhFCPKS4johiJDrUwgcYdHp4SMoQqZI5Yi9iwlNtUdOqOT8/JckGm51A30NA2+z+jzi1B/ULcuR6DWP3d2hjHEtZKohhFymAVSVy7llmYMr2DfdjMzxCxCeLI3oamjthvPEFcDHiT9COHMCuQeou2HCUSugxmDVV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yg2GsDw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yg2GsDw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A181C4CEE4;
	Thu, 17 Apr 2025 18:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916114;
	bh=gijVzA+SOKS3jgFJI5D8zeDWcRSlMIPdRdvgNA8sJRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yg2GsDw9RGCQ2Kq3dzAJpJk0dzeiFLYegsP15hhcVJwFkvUydrY580mlOdKduCWBy
	 PiW9PJMy/6yFkTBEvsvW+LLYhJNr89r4U3HROBwhACidl49jmLJZWBUnO0B1zcqLso
	 f6uBUeBlhVGzEjZR1Oso823DTqHil1b6IRRFzXCY=
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
Subject: [PATCH 6.12 346/393] scsi: ufs: qcom: fix dev reference leaked through of_qcom_ice_get
Date: Thu, 17 Apr 2025 19:52:35 +0200
Message-ID: <20250417175121.519027006@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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
@@ -118,7 +118,7 @@ static int ufs_qcom_ice_init(struct ufs_
 	struct device *dev = hba->dev;
 	struct qcom_ice *ice;
 
-	ice = of_qcom_ice_get(dev);
+	ice = devm_of_qcom_ice_get(dev);
 	if (ice == ERR_PTR(-EOPNOTSUPP)) {
 		dev_warn(dev, "Disabling inline encryption support\n");
 		ice = NULL;


