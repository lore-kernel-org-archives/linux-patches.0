Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FA846444;
	Tue, 10 Sep 2024 09:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961007; cv=none; b=YGx3jaDH0MmhIGVPQHrOqT2/3sL2m5UkXjdFOSsIokmIwFyScGDkeefJDnDFJNJa5Y14ueHB8bPCZ4sLRcIOAT/CDk4mrkdXTl3JYWfG3vkKyfF/svnlI+uV488cKkG3ObgUN/veSnBkaPB3/AsULOYhrrl3cdfRj4JSaR81cA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961007; c=relaxed/simple;
	bh=6Z2vtakT2vBUDIcntVSRLaE9xLstPxW6gXKXiFh4jQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2zygxb0Sz8dTZgdU1U3UOtOPNYpUijv7lwgfe8kyO6hawVFr0/mxKdIVKnv4X/297nBQDIw43o+Ye6Y+Dzs3oafncDNfsEEGIhhd0vGB3H8EHCe85yu5sAod2Kg0LLd1Hj5LkcOfzflCmdX3kI65dwjxy4OV+cckWqo2UMSEdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GomO0VBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GomO0VBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7DEC4CEC3;
	Tue, 10 Sep 2024 09:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961007;
	bh=6Z2vtakT2vBUDIcntVSRLaE9xLstPxW6gXKXiFh4jQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GomO0VBp2zrm4IgKIqu92yXGVJM5q6T9xWm2jBCHlSRlkCYo93aY5Aljam4UiLQo3
	 jqglwZMs4khJcANGpm+6kcPC8gFYoQmTGDujaCtPXKCoBxqUzS3STlZn4NvXrRtM4v
	 pX00Q4odL0i+Bl0jtrDkhUV7Qyr/8PkfWpz/F9Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 04/96] drm/amdgpu: Fix uninitialized variable warning in amdgpu_afmt_acr
Date: Tue, 10 Sep 2024 11:31:06 +0200
Message-ID: <20240910092541.576143289@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit c0d6bd3cd209419cc46ac49562bef1db65d90e70 ]

Assign value to clock to fix the warning below:
"Using uninitialized value res. Field res.clock is uninitialized"

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c
index 3889486f71fe..5272cf1708cd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_afmt.c
@@ -100,6 +100,7 @@ struct amdgpu_afmt_acr amdgpu_afmt_acr(uint32_t clock)
 	amdgpu_afmt_calc_cts(clock, &res.cts_32khz, &res.n_32khz, 32000);
 	amdgpu_afmt_calc_cts(clock, &res.cts_44_1khz, &res.n_44_1khz, 44100);
 	amdgpu_afmt_calc_cts(clock, &res.cts_48khz, &res.n_48khz, 48000);
+	res.clock = clock;
 
 	return res;
 }
-- 
2.43.0



