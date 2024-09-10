Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5281974EA;
	Tue, 10 Sep 2024 10:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964818; cv=none; b=FOA5HkNcUQe0H31sV6ivFbCVnPQySolqsiYXBFSu0nja6hCJpEWWEycmFisjhEPl7eQALstuf7TBzyFWqygzUatIFGS1a9exyTO/5xGejbdunMd7MQWqOwtcnuH/Sr41rUzN9KNhuKDFq3YIh4KOlGXqR+aJk7+qXiBuXoS2Fic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964818; c=relaxed/simple;
	bh=z+8tp9jCzf/fdrbR2ykl7OLgYacfOJ1ihKi2hs8d5wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8ymFPgifvCKE5EBITjwGw8XMvNQeBFltYQ+a3dBQMbiMRdedKpPDioA6sWQvN0lWsPyhwp8xjz0CxuU0uLKrpWHKgW2O8flzaqKKMaUp9ZQebYyu7/SYQmZ1mi+uw8u1r1JLQnaUkjXnwDezP2yky8V9pdIQBda4zNNixbO/fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXFgKlO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXFgKlO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CFCC4CECD;
	Tue, 10 Sep 2024 10:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964818;
	bh=z+8tp9jCzf/fdrbR2ykl7OLgYacfOJ1ihKi2hs8d5wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXFgKlO9yKbD0wqtSBKyN/BnM7RZdumpPGpuJN7An78VwIrixmdI/QG7EPiknjLdt
	 jHR3+RTwDBSsLmZxxcMtKyHITPEozusHXyM6z/xvRAgfoRog+2nPbClDEf1urfioT5
	 SeNi64N/DiiyWALPI+mUy3KOCo1FxfuP3dwEWrnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/186] drm/amd/display: Skip wbscl_set_scaler_filter if filter is null
Date: Tue, 10 Sep 2024 11:32:17 +0200
Message-ID: <20240910092556.263338927@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 880954ac0b02..1b3cba5b1d74 100644
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



