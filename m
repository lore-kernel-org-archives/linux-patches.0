Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1415563101;
	Tue, 23 Jan 2024 01:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974987; cv=none; b=E2Pkz2lia8fOiNk9hJVXJ/LQKEn6FZrNJtnMWO1P+nuzzsUO8n7Idof2sJpQCnYagpg0CvoKMmBTUqMnwNM1AdPH8kabcGXDtnBePore4vfV9TH2PwgmrTW3kKqvMWASDJKdPknzw28cJ9cD6k5i6YE0HKVbmq1tlEP7r6sGvCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974987; c=relaxed/simple;
	bh=hrRWEwujJ+RG+lzYR/rE2VCnq8jEL+OQIGOoD+Tak8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3V67niHTc4slOJM6gPzwFveNNW/vs1ZpFoyXcZEYaQkwf8nJu3It1n2G4Sf/MA6DyNQOla9uJ9WJlCKKw4AB9SYkvKrR9L4YM8/pL6ip+IhtaQkTL5kPFuEi1L/7n7gIYr2UCA+FBOrJ/kfnyO3rJDWWz4XSqbTaQxX5jMBY6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gh9JWe3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gh9JWe3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA01CC43399;
	Tue, 23 Jan 2024 01:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974986;
	bh=hrRWEwujJ+RG+lzYR/rE2VCnq8jEL+OQIGOoD+Tak8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gh9JWe3uBNlXPsKPT8aK9dUG46qjgOnrWIjjmQ8jQvt3JvWx9U2eFTrauaJFR7v9x
	 cg0DpG+E0m23pSCr6BIl+umFkbB8VXNFJU4GTh1cAZG3fF9Fc1bScevspCqpZIQyCl
	 eRTHJyE9TN3TDlil1YjpvPXBAW6jv31H4u7DloCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Halaney <ahalaney@redhat.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/583] scsi: ufs: qcom: Fix the return value when platform_get_resource_byname() fails
Date: Mon, 22 Jan 2024 15:53:30 -0800
Message-ID: <20240122235816.914008235@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 3a747c5cf9b6c36649783b28d2ef8f9c92b16a0f ]

The return value should be -ENODEV indicating that the resource is not
provided in DT, not -ENOMEM. Fix it!

Fixes: c263b4ef737e ("scsi: ufs: core: mcq: Configure resource regions")
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20231208065902.11006-4-manivannan.sadhasivam@linaro.org
Tested-by: Andrew Halaney <ahalaney@redhat.com> # sa8775p-ride
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index fc0fa1065a30..0cbe14aca877 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1675,7 +1675,7 @@ static int ufs_qcom_mcq_config_resource(struct ufs_hba *hba)
 		if (!res->resource) {
 			dev_info(hba->dev, "Resource %s not provided\n", res->name);
 			if (i == RES_UFS)
-				return -ENOMEM;
+				return -ENODEV;
 			continue;
 		} else if (i == RES_UFS) {
 			res_mem = res->resource;
-- 
2.43.0



truct iio_dev *iio_dev = private;
+	struct ad7091r_state *st = iio_priv(iio_dev);
 	unsigned int i, read_val;
 	int ret;
 	s64 timestamp = iio_get_time_ns(iio_dev);
@@ -234,7 +234,7 @@ int ad7091r_probe(struct device *dev, co
 	if (irq) {
 		ret = devm_request_threaded_irq(dev, irq, NULL,
 				ad7091r_event_handler,
-				IRQF_TRIGGER_FALLING | IRQF_ONESHOT, name, st);
+				IRQF_TRIGGER_FALLING | IRQF_ONESHOT, name, iio_dev);
 		if (ret)
 			return ret;
 	}


