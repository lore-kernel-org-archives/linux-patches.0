Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3ED17BEAE;
	Tue, 10 Sep 2024 10:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962425; cv=none; b=o9H89SLielXhYwJByT+9CFZqqfciwRVT6h7pHOABmpBXgxL1swGEeXXgS1CymiST6geQLnuJp4dc/4Ziq2O4GU5ExRiajoxYqNamBU43nO5gmfujIdVVUH8jOIgIHSUAP0Wym1oc0Y9WeELiOzFQkdygXpcxjRWV2iUXDccL2zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962425; c=relaxed/simple;
	bh=FQkBVqotzXFodUmxtmpK9GcowS0LTATdBVmhgM0SVlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iA5V1A9hC6o4Vxz6uHixD4H77RZvo8BTU+KQmtZSNtq0YoJuG3sZS/D2if0vT31Q3nEqHP/CZ+p9+dIOf9rqyM7/VHH3O6cIOkGfuqlzow23aXQrDz1HdnCia1b4MfvqulkG2xT361Nnt8bljljrbgyq/rYVIzcb7y7/Dfx6D1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrLAEizY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrLAEizY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A417CC4CEC3;
	Tue, 10 Sep 2024 10:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962425;
	bh=FQkBVqotzXFodUmxtmpK9GcowS0LTATdBVmhgM0SVlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrLAEizYBiCvmSC70pzq3Ky9meZx74bdatfMrzkV2ZwBFzFAekyRAluyRzUCceeM+
	 +D+gnXKbqShPV/E9d6yaJ2zREl7FSueWhgVE78DcGuugtL5Xb3T00HDp7Gblq0kMk+
	 rnXNsRe4iqRHSsS7jfVEMqxjoZb7zm4hGaKlMqrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 004/121] drm/amdgpu: Fix uninitialized variable warning in amdgpu_afmt_acr
Date: Tue, 10 Sep 2024 11:31:19 +0200
Message-ID: <20240910092545.950523471@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit c0d6bd3cd209419cc46ac49562bef1db65d90e70 ]

Assign value to clock to fix the warning below:
"Using uninitialized value res. Field res.clock is uninitialized"

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c
index a4d65973bf7c..80771b1480ff 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c
@@ -100,6 +100,7 @@ struct amdgpu_afmt_acr amdgpu_afmt_acr(uint32_t clock)
 	amdgpu_afmt_calc_cts(clock, &res.cts_32khz, &res.n_32khz, 32000);
 	amdgpu_afmt_calc_cts(clock, &res.cts_44_1khz, &res.n_44_1khz, 44100);
 	amdgpu_afmt_calc_cts(clock, &res.cts_48khz, &res.n_48khz, 48000);
+	res.clock = clock;
 
 	return res;
 }
-- 
2.43.0



