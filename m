Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296EBC129;
	Mon,  1 Apr 2024 16:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988928; cv=none; b=tnlkKF/FNuEOB92+VvWthjCcMjq347qtX0Y4D0Ivg0y4QTI/ZjhuL6x4MkdLcXBK0nMkbZtp9IyxiO7ntfA+mHSwwIr7iyH/6flVdrrqG9PYUbsGBsCZv+r1h36ZUM6eRgqIDt0K7Wf4EG/8SeTP/JAw/seBWAexny7qYrAiKhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988928; c=relaxed/simple;
	bh=rEnWWW4B3+B2Ljj+OMmwAV+uwzVdzc1wqfydazmmB9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCEj9B9OjVD2yFuS9p4lEHiL9UadXj+8C2MI6UOltLZVFVVy6cQhdEsRP7J6HADgH5EDRl8Cnyvw8bq5Ue/zuUx6RB3JQFl7q7opkhpi2ZMBaMCuuVXul1jGW1bvFfqUuQsNtbl6OL5nTjsk419HFV+UPAHmSk/rRnkbu/Hu468=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNuRlcZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNuRlcZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4B6C433F1;
	Mon,  1 Apr 2024 16:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988928;
	bh=rEnWWW4B3+B2Ljj+OMmwAV+uwzVdzc1wqfydazmmB9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNuRlcZn6o94C+p4NrEuaypHQpXPp50vjsrF+vIyO/yezj0jzPrYCf+3pIsbWmlus
	 42G+eZ4d231q5WYXFKQo0EPIhcNXRCjyGUN2nMhw7dE9unmDtN/89JFcrpKRNmy4up
	 F/Zulqs4/NSHQs9Ku/tujwhJkDxacL3MPfMOS0/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Chris Park <chris.park@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.7 331/432] drm/amd/display: Prevent crash when disable stream
Date: Mon,  1 Apr 2024 17:45:18 +0200
Message-ID: <20240401152603.085626890@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Park <chris.park@amd.com>

commit 72d72e8fddbcd6c98e1b02d32cf6f2b04e10bd1c upstream.

[Why]
Disabling stream encoder invokes a function that no longer exists.

[How]
Check if the function declaration is NULL in disable stream encoder.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Chris Park <chris.park@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1184,7 +1184,8 @@ void dce110_disable_stream(struct pipe_c
 		if (dccg) {
 			dccg->funcs->disable_symclk32_se(dccg, dp_hpo_inst);
 			dccg->funcs->set_dpstreamclk(dccg, REFCLK, tg->inst, dp_hpo_inst);
-			dccg->funcs->set_dtbclk_dto(dccg, &dto_params);
+			if (dccg && dccg->funcs->set_dtbclk_dto)
+				dccg->funcs->set_dtbclk_dto(dccg, &dto_params);
 		}
 	} else if (dccg && dccg->funcs->disable_symclk_se) {
 		dccg->funcs->disable_symclk_se(dccg, stream_enc->stream_enc_inst,


