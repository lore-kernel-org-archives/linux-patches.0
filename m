Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8508D78B61;
	Tue, 27 Feb 2024 14:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043329; cv=none; b=gm7d7tx4Qm9LAS1DTaF7O8ntTB+FcRorXCP7wvrd83KFK/zZWhU6KISGPeXA4MlXFnEPGwwafbAdcZUE8qI+yEhw3UvkgTvnZ2cR4kCWl+rv2cI3Lqa04mymTX+mPXk7UGL9FCJWhixyaq9mwZpU0KQNPIQfs4BS3ZqsvUrXNZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043329; c=relaxed/simple;
	bh=81VC0zTFDkeqapCThWzDkYAqj76acHiF1ZVs8XFHjNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mi90IJHfFYHq2HO3SS8KbcO/3zNvHHY914NVHJR0oMKTFOvOSXGMwzUxalexTxjO/ZiDRWzHBaZiBHXGPCrE+4/3cjVNRb+yMNZB9CAXXh+KLsPdhG4BJqnEyWqvasAyov/cUNpxLoryBzSne+ERlMQgW/mBvMU0aUnqigjxdS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFoBRj3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFoBRj3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC92C433F1;
	Tue, 27 Feb 2024 14:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043329;
	bh=81VC0zTFDkeqapCThWzDkYAqj76acHiF1ZVs8XFHjNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFoBRj3oBleMgHwtf6tC1moo71smzMZU579uGzC+eNm4HkwcNjLAzg5B7tCESnzwg
	 ExeK868VozaJElsGNzBud5Om17RKj/YUhwaiFzMES4kqFjJw51TjmlpxoJFI8zeioA
	 iifXTKr8DFTiTvudb24ymAB/jHIXv0lRCWk7gef8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Dhere <chaitanya.dhere@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Sohaib Nadeem <sohaib.nadeem@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/195] drm/amd/display: increased min_dcfclk_mhz and min_fclk_mhz
Date: Tue, 27 Feb 2024 14:25:01 +0100
Message-ID: <20240227131611.714270412@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sohaib Nadeem <sohaib.nadeem@amd.com>

[ Upstream commit 2ff33c759a4247c84ec0b7815f1f223e155ba82a ]

[why]
Originally, PMFW said min FCLK is 300Mhz, but min DCFCLK can be increased
to 400Mhz because min FCLK is now 600Mhz so FCLK >= 1.5 * DCFCLK hardware
requirement will still be satisfied. Increasing min DCFCLK addresses
underflow issues (underflow occurs when phantom pipe is turned on for some
Sub-Viewport configs).

[how]
Increasing DCFCLK by raising the min_dcfclk_mhz

Reviewed-by: Chaitanya Dhere <chaitanya.dhere@amd.com>
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Sohaib Nadeem <sohaib.nadeem@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
index 85e0d1c2a9085..baecc0ffe7580 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/dcn32_fpu.c
@@ -2123,7 +2123,7 @@ static int build_synthetic_soc_states(struct clk_bw_params *bw_params,
 	unsigned int max_dcfclk_mhz = 0, max_dispclk_mhz = 0, max_dppclk_mhz = 0,
 			max_phyclk_mhz = 0, max_dtbclk_mhz = 0, max_fclk_mhz = 0, max_uclk_mhz = 0;
 
-	unsigned int min_dcfclk_mhz = 199, min_fclk_mhz = 299;
+	unsigned int min_dcfclk_mhz = 399, min_fclk_mhz = 599;
 
 	static const unsigned int num_dcfclk_stas = 5;
 	unsigned int dcfclk_sta_targets[DC__VOLTAGE_STATES] = {199, 615, 906, 1324, 1564};
-- 
2.43.0



