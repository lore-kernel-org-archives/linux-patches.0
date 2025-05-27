Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C130E2750E8;
	Tue, 27 May 2025 17:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367801; cv=none; b=p9MjmmJhky1K82WwvtaNGnhCGlLa11f9SNmLZ3lmm1/9jhuFmcY/VrbGVaywLwX57gowA1+FZlhKcaQBP847MC4miltjbryBHgaCDqmyzlFqImliW6Ptcl0ArtuWmldpqwjQHFT5oaDcqTRjpPqrv+VTvE1WUwficIlNz5lJwl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367801; c=relaxed/simple;
	bh=upFiYiG345xuLFkV5k9M8cxEQknNj91Tk01ppjYjVQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6FKycNUDDNpzMbeVn5I0kxRa+K7vMmAMwyBEnVO1pmMX5MgNAnJ2gmhEDmquSXU7gNu/UE04ReVd6EWpl6pwMhyvnlFN9IaNz0b7eO4SjnjA2/fXhvxy+ikKGCF9Uj1jrGUwdozuG7eruxB6MTNUcj/IHZ00S/7G20X9BYDJ2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSX+IxzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSX+IxzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B644BC4CEE9;
	Tue, 27 May 2025 17:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367801;
	bh=upFiYiG345xuLFkV5k9M8cxEQknNj91Tk01ppjYjVQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSX+IxzKe/QrPheshzoXmxkqG3qDo9veANRLah2WXqW6sfyJkKlVWfhgkYNh6grod
	 pxZnNy4p0skNHCvR3SWKYYexcJ/Wcss5+eaApZF5RUUw7G5izTz7AkJu5OgI7nKbH8
	 5gzSqKwCmFPxtwx2QqN1RnRZLK5HXfuap8K7s9/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 503/783] drm/amd/display/dm: drop hw_support check in amdgpu_dm_i2c_xfer()
Date: Tue, 27 May 2025 18:25:00 +0200
Message-ID: <20250527162533.619235576@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 33da70bd1e115d7d73f45fb1c09f5ecc448f3f13 ]

DC supports SW i2c as well.  Drop the check.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 2cfc18401f3f2..7b1fd3b28e9b5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8382,7 +8382,7 @@ static int amdgpu_dm_i2c_xfer(struct i2c_adapter *i2c_adap,
 	int i;
 	int result = -EIO;
 
-	if (!ddc_service->ddc_pin || !ddc_service->ddc_pin->hw_info.hw_supported)
+	if (!ddc_service->ddc_pin)
 		return result;
 
 	cmd.payloads = kcalloc(num, sizeof(struct i2c_payload), GFP_KERNEL);
-- 
2.39.5



