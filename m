Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11771F16B;
	Sat, 17 Oct 2026 17:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256870; cv=none; b=RNDjQxs22s0n/q/FbdemhTBTnfKtbSQJeumgACgHJ6Lqv7eDtQ1rLve2s+IM1yNnjeBvNRebF1kFIkp0fMW1mNTfQco5vkD9vn8Z2P6UhV/9lSxqyQvUSDQS/yXRUfUdkHT7SNn9hicHsHMoDWX7BsS0u7Szp0Mbsoy5Vu3acn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256870; c=relaxed/simple;
	bh=Xl+4uPvCw5T4FIlpDodeSsIMHtomnKKz2lxRQu74fu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bTvjjCrl6VwCGiY8t3rLqPlMaVDaL8I0MEjG1b9jt+evFuCMJX6ZTtfZVhEaKafF3cM0/S9vUR8gGT0SZTW8bxvHnpmra+L0Gi3ZmkKlHl0s76SGzs4Z7BMeuzvE9pN5ySf309Y4FvdSgTi8fukTUDYRAiq1MUxm16WTPNL+dAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FBRMLER; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FBRMLER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB891F000C4;
	Sat, 17 Oct 2026 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256869;
	bh=Z7/f1d9GHXUxGtGc7npKxtW1IC86/FbzRwfXmOsvYgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2FBRMLERDdcTxmavazQ1PpXGXlp6U8KkQBg8nMUisn54CJSuMhPxpeqhsFQBBWP8M
	 V5NUQKFQqqekIarftWqSMsBIXr9U6aJQf/guZaaU+NeQ84lWvRrVdUxZ9GdrK2m6+G
	 VSTMe2s5zGuiihesX1LmrcACFxtAW8h6s4nQESw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0377/1674] drm/amd/display: Fix fast updates on DCE 8.1
Date: Sat, 17 Oct 2026 17:44:09 +0200
Message-ID: <20261017160440.790610238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Omitted the unavailable `dc->check_config` assignment because `debug_defaults` already contains the flag. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c b/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c
index 061221394ce07..616cf2cfcc383 100644
--- a/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce80/dce80_resource.c
@@ -1174,6 +1174,7 @@ static bool dce81_construct(
 	dc->caps.max_cursor_size = 128;
 	dc->caps.min_horizontal_blanking_period = 80;
 	dc->caps.is_apu = true;
+	dc->debug = debug_defaults;
 
 	/*************************************************
 	 *  Create resources                             *
-- 
2.53.0



