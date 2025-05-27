Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650CB1DB34C;
	Tue, 27 May 2025 17:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366954; cv=none; b=AncWRAnFvfJGXem2JxoCPlxFWMMzOyRgmAuoqgNnU1tk6mnuNxfbVe+4T/L/T1f/lM4SrBB6GtLmFFF7lNRfK2g9Bxe+bfI1BgNtSQmE8CXmvahSlgxqeSgM3PFSMpGRyT17jLCdTRCnKuGX64zp0RYC4FVkaTOaczhwXr2c13I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366954; c=relaxed/simple;
	bh=egsS7fJcPlGmjGN77UalJwtG3YNBLnGMXidlH2LxSUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMFj4Q32cQhl0y2NXKprtyeC6t46cMajuTSz0lcrrvk+3mbcx3o5SHS1lttcdsxS7JaGj+HOx/ntsXgu1Co9Lgkxh5rB+sTeLAXHAlNVnYFylMNlxfp+u8+cWesUiOaqvvf3lmdg6FREelniGzDhINqhpzZF8Fg/h5U1u6M9LLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=teusnbdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="teusnbdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB4FC4CEE9;
	Tue, 27 May 2025 17:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366954;
	bh=egsS7fJcPlGmjGN77UalJwtG3YNBLnGMXidlH2LxSUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=teusnbdJAy9LnqJ3uA1enx7aiRPX4TDUfcOOeCEMsL1SzKcoH5cYOcFz8EjoTbJXJ
	 ozINVET89n08SGGLipei0s2sAVapT6UY6Sa/oJ5VeEQfCgvBPrjmBcXZ+KM5e1BLEz
	 QbK61JLAk58j7ja7fljBhM/d1jbKxDmUu60LRSc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cruise Hung <cruise.hung@amd.com>,
	Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
	Peichen Huang <PeiChen.Huang@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 231/783] drm/amd/display: not abort link train when bw is low
Date: Tue, 27 May 2025 18:20:28 +0200
Message-ID: <20250527162522.527745596@linuxfoundation.org>
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

From: Peichen Huang <PeiChen.Huang@amd.com>

[ Upstream commit 8a21da2842bb22b2b80e5902d0438030d729bfd3 ]

[WHY]
DP tunneling should not abort link train even bandwidth become
too low after downgrade. Otherwise, it would fail compliance test.

[HOW}
Do link train with downgrade settings even bandwidth is not enough

Reviewed-by: Cruise Hung <cruise.hung@amd.com>
Reviewed-by: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
Signed-off-by: Peichen Huang <PeiChen.Huang@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/link/protocols/link_dp_training.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
index 751c18e592ea5..7848ddb94456c 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dp_training.c
@@ -1782,13 +1782,10 @@ bool perform_link_training_with_retries(
 			is_link_bw_min = ((cur_link_settings.link_rate <= LINK_RATE_LOW) &&
 				(cur_link_settings.lane_count <= LANE_COUNT_ONE));
 
-			if (is_link_bw_low) {
+			if (is_link_bw_low)
 				DC_LOG_WARNING(
 					"%s: Link(%d) bandwidth too low after fallback req_bw(%d) > link_bw(%d)\n",
 					__func__, link->link_index, req_bw, link_bw);
-
-				return false;
-			}
 		}
 
 		msleep(delay_between_attempts);
-- 
2.39.5



