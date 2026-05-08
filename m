Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C1341C2F6;
	Fri,  8 May 2026 21:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778274712; cv=none; b=MAxiMqquJkebCGC+404fr5CM0yVwaxR3sPyytLAjFeZBIUyprJzkTBVOgK3cu6N+gaen0L6eNB27SJiiM9unwTM9T97TUxZfovjekVA39lqXvcTPpCniuSo4cRea+K/4EytX1DnsHGcHT9KUQjETS7rN0lu5EynGVheOBAgnOfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778274712; c=relaxed/simple;
	bh=CgBnBDmdkqvx8nTgl5Mp3KpqinE1WaOcJGs2i3jhD10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0l0DrTBF+PTqJrrJPavFpwB3Iv9fUs1rIaK3loQo/Y7m5/oMHRC7vhSUiKv1r4wo7cjSrAkke0LG+xA9278YrY1l7v5zJZ1hDWMvgZOdMDSDlKuxPFZZXZMUwXlmf6s2PddQKDTINo5k4EVnhQ0e3nkADU9YDLR+2mc/ExKRkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nh43N0dz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nh43N0dz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CAFC2BCB0;
	Fri,  8 May 2026 21:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778274712;
	bh=CgBnBDmdkqvx8nTgl5Mp3KpqinE1WaOcJGs2i3jhD10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nh43N0dz8PHuBTkQmma420H1eyihOXkbglB+IaF81WJIm74qn2gZyQNK189fCbfOW
	 o7xIk+VEKHp1fpKlc6PIvwSuSRKB6qNVpLZvSEfbzfJtK/iOBQCYZM5foZiIMOVKKB
	 SZ246dr9gmguxkCi21S/7hXzN62IIQRKkGgdgT/v19zcx+HPSw5cJxE9ZyTl4QS3Ul
	 zgiN+3IutVhy2LfM3MMYv4KX34T5XABIzXYtSgr4xQ4PEUMCetIoRkzk5dhok2W+E4
	 3zqPxeR8JypLjxYmGodzNUtP8emJ0bpnrZO9fBWKt4DBv0JWibkhqoCzcheFXVZmsw
	 hfeUJDrife11g==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	dev@pp3345.net
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	Rodrigo.Siqueira@amd.com,
	alexander.deucher@amd.com,
	christian.koenig@amd.com,
	Xinhui.Pan@amd.com,
	airlied@gmail.com,
	daniel@ffwll.ch,
	ray.wu@amd.com,
	Wayne.Lin@amd.com,
	mario.limonciello@amd.com,
	aurabindo.pillai@amd.com,
	timur.kristof@gmail.com,
	jdhillon@amd.com,
	hersenwu@amd.com,
	Roman.Li@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	Fang Wang <32840572@qq.com>
Subject: Re: [PATCH 6.6.y] drm/amd/display: Do not skip unrelated mode changes in DSC validation
Date: Fri,  8 May 2026 17:11:39 -0400
Message-ID: <1e7ec2f7bb732f43-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_CCDB1B23FED831830856396BB4DF59D1B106@qq.com>
References: <tencent_CCDB1B23FED831830856396BB4DF59D1B106@qq.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Subject: [PATCH 6.6.y] drm/amd/display: Do not skip unrelated mode changes in DSC validation
>
> commit aed3d041ab061ec8a64f50a3edda0f4db7280025 upstream.

Now queued for 6.6 and 6.1, thanks.

--
Thanks,
Sasha
