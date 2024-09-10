Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5BE18E021;
	Tue, 10 Sep 2024 09:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962393; cv=none; b=Jq9u6fADGtSVH7nMIWHQev6BZmA/8jhnlJASTJeMnw5rDRWN2pxGigx+KHxv8BdGdYNpsA8IApxccM399eF23fJOiok8cM2uQumq6HB7qT+7cuMe6Lf+AfxPe0MJYkIuWsEq+9mIpAQ9b16mtw6/3QDWvIAhlGwOVlvpIUJRK6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962393; c=relaxed/simple;
	bh=y+CqunXr7QOfN9uC5L3r5y4Ai9Eb5aYgPue6cEisr7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pm6uxHPSYtdrjdH+5F4LWsXoeMRjmV8mKdMn0yzIFGLjNUMdOBcUW2joyRJplC0l7seGX1buSlZdiaueiWBJUP5IA63TkEtMESHsn7eK5RGfcSaFffWZYNhjb8LWnxrVD4Rzj9Tp3VVhhqNGULOP/wdpeIs4Tm1Rsu5FMB3iLaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZSXBgSty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZSXBgSty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50357C4CEC3;
	Tue, 10 Sep 2024 09:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962392;
	bh=y+CqunXr7QOfN9uC5L3r5y4Ai9Eb5aYgPue6cEisr7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZSXBgStydrBO4CqOm7ckSjOHQpA7umMw8ZYNGbfH7Vxn4h+ygjytr2+l6nJZfqfKo
	 v9NI0veJWOt/ryqoJSDBFcJvCQ46IJ5+aMjePtiMl3winld7xJ/YWhPxWl3LsjUaNF
	 PiftXzvmniyTB5bnaouo31jw1W6AUX2xhkzfdyWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/121] drm/amd/display: Skip wbscl_set_scaler_filter if filter is null
Date: Tue, 10 Sep 2024 11:31:34 +0200
Message-ID: <20240910092546.638691438@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit c4d31653c03b90e51515b1380115d1aedad925dd ]

Callers can pass null in filter (i.e. from returned from the function
wbscl_get_filter_coeffs_16p) and a null check is added to ensure that is
not the case.

This fixes 4 NULL_RETURNS issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dwb_scl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dwb_scl.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dwb_scl.c
index cd8bc92ce3ba..4058a4fd6b22 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dwb_scl.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dwb_scl.c
@@ -690,6 +690,9 @@ static void wbscl_set_scaler_filter(
 	int pair;
 	uint16_t odd_coef, even_coef;
 
+	if (!filter)
+		return;
+
 	for (phase = 0; phase < (NUM_PHASES / 2 + 1); phase++) {
 		for (pair = 0; pair < tap_pairs; pair++) {
 			even_coef = filter[phase * taps + 2 * pair];
-- 
2.43.0



