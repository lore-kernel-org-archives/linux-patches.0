Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8A5199222;
	Thu,  5 Sep 2024 09:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529901; cv=none; b=Lb7fuRNH26QxZ8lGkVUCEGjQtu6W7rEjyUvrVgNxcOSM5zg1yWjphA2MOPmlxu9W9hCuMSbe8igfWVoRC+8bez1h5B084U8G9G6sgwl+w7ppulkBA/APcnrZ/CFRUUUssKvixKessRf5NZ2qSfHCRsKKbMG0pJVj80F1Vczw8Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529901; c=relaxed/simple;
	bh=JXG5M4AUdJg0P97ifYxRfbitbfQun0/Jlpsw3Xf5mKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2EsFh/iac/UZB7I2RU5/YcUrMhTp4Ijq6M88P+7ezl9WmIgMjAH4aczBs09UVIYhk0KY3mOmUDrCr20ZaOq6J/hK/eT0SfhBVL8+iSja8fRXh4sVi8kfnYBhmhcs0Cmk6GlDXuR6bomRHWwdzQV5C+S+HEI5vFkT9ZHu/mpcKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNImGJ3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNImGJ3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375D0C4CEC6;
	Thu,  5 Sep 2024 09:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529901;
	bh=JXG5M4AUdJg0P97ifYxRfbitbfQun0/Jlpsw3Xf5mKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNImGJ3xKoXX4ZKlQmMActzpZ0lCOaZFhr7coPFWQUIrfgS0dJeiZnH2+GpWubNBZ
	 9/cXPegKHGD5alsS/7dwcMxHNw9tszPpXMhgWYcMKWuYn+SWRjQ8mn3zkXso2Z6zrc
	 Sf3UCAY6SJj4j/6YhV7xCkXEtrQo72UrjdkbsSn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 177/184] drm/amd/display: Skip wbscl_set_scaler_filter if filter is null
Date: Thu,  5 Sep 2024 11:41:30 +0200
Message-ID: <20240905093739.243466964@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



