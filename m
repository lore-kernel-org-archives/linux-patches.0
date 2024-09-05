Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD751494DB;
	Thu,  5 Sep 2024 10:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530686; cv=none; b=Wvlrb9h36Id8E8EVw0F0GIkD/jdW8Gw4sfGxcHRNZVugdKBgbhaGJN8mpgrfjQYal1rU68rYMIB+yb3rKofxmtZ79m6lsw+VbRp9s74wyjQv4RqBYiIAVf8gkKC/Na2st2+hHZW+6xF7F8GLh+uQntEvAR4GTsvpUvqYb5ycRDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530686; c=relaxed/simple;
	bh=THWQaUU66EdXipGvEMjmkf8B8uV4nP3AQFI0YH5XJKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ircKcvVg1w2czqbGlqP61ak9AFJXq4mIKZBOWj56dk8qdmZwAraaNUQCjF34KcPouotJdkCYBeKnDSXiaCUIVJ3Ed9/xKzQitJvcpIN/VW7muGpTe25rpvgVPxwj9WC84yZsf5SivXuZXjhzOHTiQwK2JVEpCCVdLM0GeV+Pggk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYvpVak+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYvpVak+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2060FC4CEC3;
	Thu,  5 Sep 2024 10:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530686;
	bh=THWQaUU66EdXipGvEMjmkf8B8uV4nP3AQFI0YH5XJKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYvpVak+vx1+y8UNBAKjY5ptDP/u7kGlP/+Wd0tenrNpQe+X3xDvH5sJ2F/O8fONq
	 1Wdf/x1qmCu+UVF+J1yb/OZb+64NrgSfms+QeDslK+F5xiSwqCXU+83DwR4/UAFv5o
	 +ulU+XiFT7oyu4QP90yS6rvfYe/ynCAu4ed10SWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/101] drm/amd/display: Skip wbscl_set_scaler_filter if filter is null
Date: Thu,  5 Sep 2024 11:42:04 +0200
Message-ID: <20240905093719.724551589@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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



