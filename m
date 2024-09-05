Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6D883CC8;
	Thu,  5 Sep 2024 09:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530383; cv=none; b=WN5lqNLE3spOWRZaQkLAJ4tWmL0HdKAZOybLn0qC8JXhROQrUlpRaLwCtGYxGqmfxB5y16i0B6hZSBxioboHm1cctTJW/7fRJRJS9UPnyXrEDTmDYqFIeIOnpelKSQR8X2xmjL841E2zLvR4cuR+V//caLB65H0K8NzyOUkg18s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530383; c=relaxed/simple;
	bh=zmEsjU/Dlw1vicDrusbUhvgXK9zeDP533lv0GPsMEag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXziyQyrua+E8YBZ7OXf2IE9i4ZZXectBVZnoy+H5R8VGePVAjSnPL8BDGrr7bMQ6Jo9ZfQx8vx0PVhKWztxXm/hEKlBOHqIXXAsFeVHSiNBHv5hkfBYXsF5fMo7RjipaOklVscrSEgwCrjOYGsQohRif5wxpD6ynjh1KLbM20Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LmozLa+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LmozLa+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96051C4CEC3;
	Thu,  5 Sep 2024 09:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530383;
	bh=zmEsjU/Dlw1vicDrusbUhvgXK9zeDP533lv0GPsMEag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmozLa+LumoJ9JN/qbkRsAWAHta0KAd18BTOtfLUSJ7w3pzwned8l7tgMpplludWs
	 lLWk/F3SqCocf8TA/BHteAnSh9yNx2IppxAmdPtaIxF2rmrWSKNwp6/W1+dcMs7Rff
	 FV+GVvA24Ib9vq0YBfytW8lARFhSNEJZ/gFMhKQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/132] drm/amd/display: Skip wbscl_set_scaler_filter if filter is null
Date: Thu,  5 Sep 2024 11:41:55 +0200
Message-ID: <20240905093727.191050410@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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
index 994fb732a7cb..a0d437f0ce2b 100644
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



