Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D0C2EBBAF;
	Fri,  9 Oct 2026 14:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557285; cv=none; b=QW+HGjWWlCNSI6F/b1d0L6Ceni39mz8MafN1JCUud9BQvsAC4uRjUyTeRkHJtjwqL7HzZx12KIp4ZynnZPkXfoKaIDtbtmO6xyGRcO9vl7Wwk/Rm6BOS+zOeNS9HIISE/LtU+RiZN32V6bpYlnMjGIBLmyz78K0t/sFG0xqRsbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557285; c=relaxed/simple;
	bh=YjJNuE0DuCL13tSJXT8heSvCmWgdlU5GbpeAVHJpsEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jKhdCqeyzQnBAk/5zYKjjZmsdUhZDCyh/iMPx4g3ZxQj+T/Ll+Site0IqHgr4eTiOH34RJvBSg0/zZRbW2EDRE95TRD9aIqnBlMwEylxlm4iFukw5s59n5cQvhPv7gPUs8TUQtFlh6mPcbjdo6MbdSCIg7zu8o6AvMPYBNXA21c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jl+PCqks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jl+PCqks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819531F000FF;
	Fri,  9 Oct 2026 14:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557283;
	bh=PbU3p2E8YXtgIr3VY5kVyXz9xK5uR/D+2TYQXcbjas8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jl+PCqksQbK/JD0mjtv0t5t5S+UlAClSVM/s0IFWcyqZLO2J8l2e1BkWEQm4sbgZI
	 iHX0++WvFlFG7LVWBrMys0j5fqnKFXWmANkAARs569nqT2pN4gt23yPRt4Kiebt/fh
	 uTjiSIMQg9FlEIpt1zWuJ6D1Mg/0fg8eCpucAUTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 376/403] drm/amd/display: Fix fast updates on DCE 8.1
Date: Fri,  9 Oct 2026 16:12:17 +0200
Message-ID: <20261009141001.110381118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: omitted dc->check_config initialization because enable_legacy_fast_update remains in dc->debug. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dce80/dce80_resource.c
@@ -1121,6 +1121,7 @@ static bool dce81_construct(
 	dc->caps.max_cursor_size = 128;
 	dc->caps.min_horizontal_blanking_period = 80;
 	dc->caps.is_apu = true;
+	dc->debug = debug_defaults;
 
 	/*************************************************
 	 *  Create resources                             *


