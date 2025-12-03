Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC375345CD7;
	Wed,  3 Dec 2025 16:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777614; cv=none; b=NHHeukDpziuk7ouR4nt3IJDLD24d0wudf+iACcGrVn+HeTJadSrhJIgOxnLas3nz/N9MuyNJRGvgUqla4HD208rdhR6Hk+wicUUX5VeQLnw9EGBnbvr5Z3aVR6qrAg7HKULfGYS8Yyi8zB+g6rfcqtyo69wg3ST4KR9RGUHb7/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777614; c=relaxed/simple;
	bh=+hbiw1VwnxS5ZsR02pUYq07nk0lxEIIPlpAideG/5Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sk1H5vVFi46dBStsaRuw9dclnn2b3Y9az+BsSWEsksgQKWT7Tumq0p6P9wi31X7rvsM9C2ZYDFXge3JvvVG8Q3nrJ3nQSeso/an1VdDzayhGOv4MYRo2GwSAtOYTWeORiRD6clj9AMMNUjyk/BUnPzHk0VXZWEkNS5xvmHzfwVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gc17o5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gc17o5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E2FC116C6;
	Wed,  3 Dec 2025 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777614;
	bh=+hbiw1VwnxS5ZsR02pUYq07nk0lxEIIPlpAideG/5Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gc17o5eTzQLFtCSUGPgTrEnfXqvJHIOWx832xpIu1sOZfnjaV3vabTtIsYSof1/M
	 qDG/y97kPoYkI3YGTHabas+7dPY0mfEHjNWjx/ocKTTVAANfBSZGjzFgc0dQ2ZdAz2
	 TFUl4TeQf2R7HVbbTuwIei3EDGfcHDst+hWK1Em0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/392] drm/amd/pm: Use cached metrics data on arcturus
Date: Wed,  3 Dec 2025 16:24:01 +0100
Message-ID: <20251203152417.453137010@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 2f3b1ccf83be83a3330e38194ddfd1a91fec69be ]

Cached metrics data validity is 1ms on arcturus. It's not reasonable for
any client to query gpu_metrics at a faster rate and constantly
interrupt PMFW.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index a6df00aa5767a..da032700cb985 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -2346,7 +2346,7 @@ static ssize_t arcturus_get_gpu_metrics(struct smu_context *smu,
 
 	ret = smu_cmn_get_metrics_table(smu,
 					&metrics,
-					true);
+					false);
 	if (ret)
 		return ret;
 
-- 
2.51.0



