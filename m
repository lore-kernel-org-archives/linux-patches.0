Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D9639282C;
	Tue, 16 Jun 2026 15:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624504; cv=none; b=AzsQ4qaFCRlNa22pVQ1vnNPTxGj5ue1oeA0ra3jttBhq2Hoj5DWkZqOQm3ssskgqKCI7GDyC9FOoKpAO60USdklCu+YH5WXDUkNttlKJ/b0HYtTEzRpuZrGISBpdrjScLUVYnXs1m96tpHX+DkoG0+LZu6D3moTtja6EYESx3d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624504; c=relaxed/simple;
	bh=ZzPM4lwuWwOR0AraG5UVua/T6Xio8lKrcowpExziwFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUkSMW9cDldDl22V1xX/t8EMwKkZQdQAeefbzqfm5HnQBHDZ9QO39Kz+SwHWWoGnJn7Octt5F9e4RwJSAx8zfuv+qNEY9aSaj2pFTGwjXFFf24k4k223NhrxvbnTFVGOYNs38iqpewWeII9zwJDIjW1zFaZ9pFgBZSRDsMKOSgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UE0lkQOi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UE0lkQOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957C61F000E9;
	Tue, 16 Jun 2026 15:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624503;
	bh=NJHoTRewKkmIyLZnucxnV9FHrz0BZyla3oCI8bOfFQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UE0lkQOiKZ9CWoJO7yzsMxaAUvvdQHPp/qFi8tNhB6gH1xl5X9bfPWXp08AKKjTUL
	 QtgHaiqYIRc9OmxmceHWam8nCxx/R6DX9blPTgbxmoovpMLYDgBm+38fFhMTHoes4Q
	 88Et0n13ZRtUhL/djGcjnhadUJkTQF9H4JSfGgTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 350/378] drm/amd/pm: mark metrics.energy_accumulator is invalid for smu 14.0.2
Date: Tue, 16 Jun 2026 20:29:41 +0530
Message-ID: <20260616145128.577304711@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

commit ee193c5bbd5e2b56bbeb54ef554414b43a6fc896 upstream.

EnergyAccumulator is unsupported on SMU 14.0.2, mark it invalid.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 646b05043eeed04b51c14aad22a400a8250af4b7)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -2150,7 +2150,6 @@ static ssize_t smu_v14_0_2_get_gpu_metri
 					       metrics->Vcn1ActivityPercentage);
 
 	gpu_metrics->average_socket_power = metrics->AverageSocketPower;
-	gpu_metrics->energy_accumulator = metrics->EnergyAccumulator;
 
 	if (metrics->AverageGfxActivity <= SMU_14_0_2_BUSY_THRESHOLD)
 		gpu_metrics->average_gfxclk_frequency = metrics->AverageGfxclkFrequencyPostDs;


