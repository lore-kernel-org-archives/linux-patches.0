Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7E62222BD;
	Thu, 13 Feb 2025 14:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457600; cv=none; b=shF5GS9D1+uqKUugUQYRBU99E2MlX94N9FFq+/m3g8TsvWks5ulq39t3ekET4bZIRQjySrc5AmVSIelEbatc1/SawyiuqkBnwokyQ7Du3n24k/R+Jd6+NNvrfqRLsRZ7Fw4XbhoYhL038UOgYE9U4A5Yi9JNCat1XKzjd6r5Pu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457600; c=relaxed/simple;
	bh=LZrms4Lcxq7AR2sWUNKgquJwa8qTpv24BmILgWk64Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdprsrRs9/0x70mKJPfUEFNgbuwAzVr+PIN1e+JsbXnOCwcM43Qo+6jXmkl5yJr6FfLLSYIesgswxUxVMIWc7X8gd71LbA8mpyoHxaZMjMs5y4crz+AzqpHseb2aFqVe/iKupsh17arIvG1RbpA2DbIF6wAhcRPGiES6gLeOGvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rSxKsGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rSxKsGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B8AC4CED1;
	Thu, 13 Feb 2025 14:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457600;
	bh=LZrms4Lcxq7AR2sWUNKgquJwa8qTpv24BmILgWk64Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rSxKsGUaYrBjJN2jcXAJuDZxfb9s6smWxhZuH7nfkK8NQd9UCMijejmum4eopgy+
	 /VIf6Uod62okxEYVfo1H8Gi/96wxFDh+25hIhKDvS42U9/Fv5OftaO0/puh9sEUQot
	 QzKdznxFeTaUN8klguXNxVjAjj7CjExA/YrP5WM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 157/422] drm/amd/pm: Mark MM activity as unsupported
Date: Thu, 13 Feb 2025 15:25:06 +0100
Message-ID: <20250213142442.604032952@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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
@@ -1731,7 +1731,6 @@ static ssize_t aldebaran_get_gpu_metrics
 
 	gpu_metrics->average_gfx_activity = metrics.AverageGfxActivity;
 	gpu_metrics->average_umc_activity = metrics.AverageUclkActivity;
-	gpu_metrics->average_mm_activity = 0;
 
 	/* Valid power data is available only from primary die */
 	if (aldebaran_is_primary(smu)) {


