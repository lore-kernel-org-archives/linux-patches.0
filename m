Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC712BAF7;
	Wed, 25 Feb 2026 01:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983086; cv=none; b=Yhsb4cUgnFALlAFPNK0umMUhXpasmKIrQ23dl0wUk9Jso+1JNLWOyr2HG0wzpAa3aSlV9RLBVdXS3rKTj+VnLNyyflqvV5+upixmlgatzfaXIif/Jbsb0d8tJFnpT8fCiMM9MCxMNflnWPxQSkSS/kMiOhIpzh6is4L24c/gbyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983086; c=relaxed/simple;
	bh=0WkPLJQYYF0dwbdpHG9B8GU0aoScBAjwgZ2+hpo5sNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLij5ClCeOIDqFQRzwuz3A4LQG4TJ+YLayyWinqzchJcmwAxRhHLvmJCi01Y1ynM0pkngWsmu5RvzVk7Hy/6bVNtsfV+qkt3DrYRcd720WtnwlEMZOMxCrX7nqNMr9a3FfzHE3Dk7cfP/FBPx17n3tpn9/9A8hLyhkcA+IczpwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDtZ8hdV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDtZ8hdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7363C116D0;
	Wed, 25 Feb 2026 01:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983085;
	bh=0WkPLJQYYF0dwbdpHG9B8GU0aoScBAjwgZ2+hpo5sNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDtZ8hdV9qrnj8jy7uC7RGCoZ8F1vOAcsKSYLUyVCh9XDVj4ynyQq+6IRD1EbJmik
	 /pS3dFHARrn0Mcl1sOnv0+iiPHq0GCXAyHw1EWKbarincI20tVXyEt875piZqTxB2F
	 RJcFn27nCll8jjIbOR43kLPA6SyJEkYaVHrHZ1eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akif Ejaz <akifejaz40@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 210/781] spi: cadence-qspi: Remove redundant pm_runtime_mark_last_busy call
Date: Tue, 24 Feb 2026 17:15:19 -0800
Message-ID: <20260225012404.864923852@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akif Ejaz <akifejaz40@gmail.com>

[ Upstream commit 28d21dfcea0121afec04451733a6c553fd319c8e ]

The pm_runtime_mark_last_busy() call is redundant in probe function
as pm_runtime_put_autosuspend() already calls pm_runtime_mark_last_busy()
internally to update the last access time of the device before queuing
autosuspend.

Remove the pm_runtime_mark_last_busy() call from the probe function.

Tested on StarFive VisionFive 2 v1.2A board.

Fixes: e1f2e77624db ("spi: cadence-qspi: Fix runtime PM imbalance in probe")

Signed-off-by: Akif Ejaz <akifejaz40@gmail.com>
Link: https://patch.msgid.link/20251203181921.97171-1-akifejaz40@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index 965b4cea3388a..b9a560c75c5cd 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -2012,10 +2012,8 @@ static int cqspi_probe(struct platform_device *pdev)
 		goto probe_setup_failed;
 	}
 
-	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM))) {
-		pm_runtime_mark_last_busy(dev);
+	if (!(ddata && (ddata->quirks & CQSPI_DISABLE_RUNTIME_PM)))
 		pm_runtime_put_autosuspend(dev);
-	}
 
 	return 0;
 probe_setup_failed:
-- 
2.51.0



