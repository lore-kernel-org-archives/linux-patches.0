Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B7126B0BD;
	Thu, 13 Feb 2025 15:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460392; cv=none; b=DLzNIpWJNdKSQd5ULsE99piZmUuEDAUNB3OEfopCYY9Kf50hdOxS2FeTPtGLYFzXMinNIsnNY1vK1pPlc3jMJB/GHZ3sM6Nzh4g+iveerYSNstgSpNzUbev1mE5sROqF1999KxCnOsiEA4+dDikI1SvcB9Z+X/kQEjRcLX1z3Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460392; c=relaxed/simple;
	bh=eATrRtH1AaPpBKtsn1CtiJon/Ft6U0EonOqsOD7jc1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXUAubKr43ydL1ietAVZ7nDTwL9bmxjRiKOgIbXo/hE1MXsATDveywMExX5eHYACUaBRrdI4ney3K1r8if2iF7XpS6aZiv78xSFcE8AItmPTmEwVJbt1hM0a4kDp/R3FQmCQEZa7+fohKnFJR+XpEC1WTFF5rqBtwein1DPj0hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TLTBMhaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TLTBMhaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E24BC4CED1;
	Thu, 13 Feb 2025 15:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460391;
	bh=eATrRtH1AaPpBKtsn1CtiJon/Ft6U0EonOqsOD7jc1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TLTBMhaFipEQRsJ4mHyUMtNouqglM/SUKGKoimw+Fg9X2ZOzCcHZvsqo+hSSua3BZ
	 HsOlKEw9WoFU81lcSyW1MS3cGuVngebQhk+F03nhZb4d6Uzk2wLDDsKeu2/M+X+cu+
	 ndtIr2LBj2LnxzQcIrUufMVjRJOl3sXawEhrFQQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 097/273] drm/amd/pm: Mark MM activity as unsupported
Date: Thu, 13 Feb 2025 15:27:49 +0100
Message-ID: <20250213142411.175264571@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

commit 819bf6662b93a5a8b0c396d2c7e7fab6264c9808 upstream.

Aldebaran doesn't support querying MM activity percentage. Keep the
field as 0xFFs to mark it as unsupported.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1752,7 +1752,6 @@ static ssize_t aldebaran_get_gpu_metrics
 
 	gpu_metrics->average_gfx_activity = metrics.AverageGfxActivity;
 	gpu_metrics->average_umc_activity = metrics.AverageUclkActivity;
-	gpu_metrics->average_mm_activity = 0;
 
 	/* Valid power data is available only from primary die */
 	if (aldebaran_is_primary(smu)) {


