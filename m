Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D07477E36;
	Tue, 16 Jun 2026 16:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627751; cv=none; b=fxr0JUtT3Gzx7I/84+gUyXvJmgUHDxK7BCBqjNh0q83fngoLQloJ5E1Yh6uHzVMxzPZMCDakIgDSw6lLHFJ48PRoHLfyVZ5w8yMm9nAsgsgZvgU7tryoxWemvmZHFT4IluwdaJIm0bINrz7E+q98VcHg5A2I0DzwADxxn/O08O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627751; c=relaxed/simple;
	bh=oystQV7XJzbZXaQrMomWyWEfNLnkXMzHIz/ypO1n+fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVvXYxt7bcIIkebjj2xBO0BJa4pHz/45sgC1wtmfVSYq6Ttx8ivnla/r02l+n+mmkFTF8DK3+Kz5lTfrkdQshPDXuElUKwkhph9oOVu4AcKkzgiCTppS8DE7TcKhw080wrPN/e2CYi4/3OpY37b2mI1hDHbEI1xBFxVTdGTb9bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8O60gHH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8O60gHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB651F000E9;
	Tue, 16 Jun 2026 16:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627750;
	bh=UHNgBeHSIWOE+A/gy/slamHdFu2EYW4VoybU8wjhbo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8O60gHHedePP5p/ApqYML1BXJoWzKQm3I6do/oms4Os7v2ROhJVnuOWfE551oxNW
	 Nm89hAe8yLMwHI209j0AYceE3u8xt0Uf2g20Ntr2gc5tQ1m8vYrJU5z6uCL7xPZd8l
	 KLyAX7JbEWuEvJWor2fM/lAXopiy1KPQbOAgkR8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 221/261] drm/amd/pm: mark metrics.energy_accumulator is invalid for smu 14.0.2
Date: Tue, 16 Jun 2026 20:30:59 +0530
Message-ID: <20260616145055.263426205@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2208,7 +2208,6 @@ static ssize_t smu_v14_0_2_get_gpu_metri
 					       metrics->Vcn1ActivityPercentage);
 
 	gpu_metrics->average_socket_power = metrics->AverageSocketPower;
-	gpu_metrics->energy_accumulator = metrics->EnergyAccumulator;
 
 	if (metrics->AverageGfxActivity <= SMU_14_0_2_BUSY_THRESHOLD)
 		gpu_metrics->average_gfxclk_frequency = metrics->AverageGfxclkFrequencyPostDs;


