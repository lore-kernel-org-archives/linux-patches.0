Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2DA233710;
	Mon, 10 Mar 2025 17:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626587; cv=none; b=Iu8We/aM4/DGtb18Xng3+AVaJd/2vdeVf7G5/+SDskMlWYeqhMQvAyAwmnpth8AxDQ4DfDxprLLzIAa5Wz+gsPC2RuK/KuM2ymHmzdza8OAx6XgTbkzJPoY6FGMA08yAkeH1hT5L8Q/rutoNuzP1yn8611i3H9Is7v7nQbKgJa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626587; c=relaxed/simple;
	bh=JzGrlxkpqQCUAyOwRXaeGQnxuDs9tMhWajShR4N8Fxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvOABDLJi8jvcYF5hB8+mwCCpLEB25yYXBIfHiAwXk8lX/ZcMlUXo4lUtt/+Ne/rWyPBiO+WVZXDsumA4sBSScsR2iZaKw6nbHkVm+8majLGw/576IUGYXK7ObUnAJtKF7dHfbBJmT1bt1oUB59fa/DD050RLFruRE4ko6fTeh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHaJO/BH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHaJO/BH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B16C4CEED;
	Mon, 10 Mar 2025 17:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626587;
	bh=JzGrlxkpqQCUAyOwRXaeGQnxuDs9tMhWajShR4N8Fxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHaJO/BHXMyxVFySrsmcks2e6Zd+rwwLSUxbwhn3TsqHlcB7MF1WX5/FzePRC29nK
	 EK7vwiOgFBf4tln0PMq80K6YOSizVCfAmsmPmh/G/H+NFNH+roPW7Ot25kxHcjOofD
	 XyqLNtJWaKUV5iIpGUjS/m1XgASupilAk1nrwuaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 036/207] drm/amd/pm: always allow ih interrupt from fw
Date: Mon, 10 Mar 2025 18:03:49 +0100
Message-ID: <20250310170449.209077446@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Feng <kenneth.feng@amd.com>

commit da552bda987420e877500fdd90bd0172e3bf412b upstream.

always allow ih interrupt from fw on smu v14 based on
the interface requirement

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a3199eba46c54324193607d9114a1e321292d7a1)
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0.c
@@ -1899,16 +1899,6 @@ static int smu_v14_0_allow_ih_interrupt(
 				    NULL);
 }
 
-static int smu_v14_0_process_pending_interrupt(struct smu_context *smu)
-{
-	int ret = 0;
-
-	if (smu_cmn_feature_is_enabled(smu, SMU_FEATURE_ACDC_BIT))
-		ret = smu_v14_0_allow_ih_interrupt(smu);
-
-	return ret;
-}
-
 int smu_v14_0_enable_thermal_alert(struct smu_context *smu)
 {
 	int ret = 0;
@@ -1920,7 +1910,7 @@ int smu_v14_0_enable_thermal_alert(struc
 	if (ret)
 		return ret;
 
-	return smu_v14_0_process_pending_interrupt(smu);
+	return smu_v14_0_allow_ih_interrupt(smu);
 }
 
 int smu_v14_0_disable_thermal_alert(struct smu_context *smu)


