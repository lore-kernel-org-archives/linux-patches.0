Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFE34EB862;
	Tue, 13 Oct 2026 12:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895577; cv=none; b=WlwmEFMLMYWen9KhRfvET8Xef0Ll4aHvL67Yxy7YqdYtqR+8caMvOFFwxSGmiQNSRn7lZAqRRKngzhLpCVO3uY5vl0ZO9XXgWy1oWzoJG8YXGjYHhDQJ9gBzR1f0HYSVLOIo7UE0RX5+mxKOGrRf4pxQdAOqZoAOebPllcMNCXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895577; c=relaxed/simple;
	bh=5dFz8fFB2DtRI7xSMpYwP8IwRrKVHse2fklXUgpLxnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4v4eNEIn1aN91ItboNt+n8dCDgwVHFmHP9O/vfdOZ0iVXS6q8VhB0I0YtSNuKx018mcGPevAg0NzTb/BWqTV1sdhDgCFP8PMNmqxQFD0/vBvaxg7SFH1dZQE23zUU1m6d4nA8+iyTg5iyAgelaqnT3CMwVc/Hnd/iUNfSYie3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wA5ruKZP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wA5ruKZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8506D1F000FF;
	Tue, 13 Oct 2026 12:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895576;
	bh=2RVmzcaj2mhsEWjpt3Uq+GZxL+UxIF0eiQDSaUF+qog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wA5ruKZP1Cgg6k1FWHH2k8x91DkEIYgJnZpV5/AKi81NbdEvB/bDz4/7uEDLVjXiq
	 AlWnT5cuL2h1dCVyDX+HAB5jE57KgG6LHaORliIl4dchadIgxKvON6K4zzXjQCRwDL
	 hPJmszLKA4XC1VRNauuS9mn+BT7WFlrpOatVk0qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 277/497] drm/amd/display: Fix fast updates on DCE 8.1
Date: Tue, 13 Oct 2026 13:37:24 +0200
Message-ID: <20261013112914.468546207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 687d31ea9ac76b299817060fa1e5582d6c752ae0 ]

DCE8 should use legacy fast updates.
This was already set for DCE 8.0 and 8.3, but it seems
that DCE 8.1 (found in Kaveri chips) was forgotten.

This fix should be backported to all kernel versions that
have "Refactor fast update to use new HWSS build sequence",
but this patch won't apply cleanly to older kernels due to
another refactor in "Remove dc param from check_update".

Fixes: 0baae6246307 ("drm/amd/display: Refactor fast update to use new HWSS build sequence")
Fixes: 9ec11bb842b6 ("drm/amd/display: Remove dc param from check_update")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260923122033.1046651-2-timur.kristof@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 57605379559e3b5044c8274a1010ec658e5e73af)
Cc: stable@vger.kernel.org
[ sashal: Omitted the `dc->check_config` assignment because `enable_legacy_fast_update` remains in `dc->debug`. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
index a73d3c6ef4258..100a68778c922 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
@@ -1173,6 +1173,7 @@ static bool dce81_construct(
 	dc->caps.max_cursor_size = 128;
 	dc->caps.min_horizontal_blanking_period = 80;
 	dc->caps.is_apu = true;
+	dc->debug = debug_defaults;
 
 	/*************************************************
 	 *  Create resources                             *
-- 
2.53.0



