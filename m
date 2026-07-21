Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4874446AA62;
	Tue, 21 Jul 2026 15:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648048; cv=none; b=DpMmGslNy3deDZzD4xLxLvnsx1iWqzHRFEI1XDCI2I1wmMl6Q97+N4K4SugUBkrjy4IX9zMSudKua4sAkBnX81z+FzrMVEpwwb7KWigybsVHnF2N6aGB+A+QHMdvGyffUO5nuROwkt+a6ncEqmqR9kxTre/8p9bbApJXS0eP3j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648048; c=relaxed/simple;
	bh=GBtC+lPEN2T5WR20rftNQNtRXvQNc0Ic0CRu+leTT3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLHvJfGZI+POxxBMgN8WfHFbJSEZDilAh0cQ7xsPzusn3EGI1j/+q+bAB34GgEqkR0C5ZeO8vzyBVRNEdT7yWptlDdzmm3wIow5SxrL7+VA9Qwe9BEwOOs3KpK2Fvp1AyygP80xn3pgwLIGB8jwbdsja8ulrnfHOgC4l2gj9Muk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAdbrci3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAdbrci3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA721F000E9;
	Tue, 21 Jul 2026 15:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648047;
	bh=EkSh6hU/i6i6yGzV+HNFWEVyG1wxd21OkmJY1j1/QEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GAdbrci36esrDYf1DJvx1BRWumuhyKSscm8F8VFBrV2KTKn9jwaGWbxSpIiHaTiQP
	 nUmG3Qtjmku+7mubhs8kJPKbVsahmQHu6+mFh3wm+EFIk4nB/lQWBhSzcXdMNpPogD
	 6TnAP4H04GA1zf1KfQ4vdKmg8kEtCTwNCYJ0CecA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0053/2077] accel/amdxdna: Handle DETACH_DEBUG_BO through config_debug_bo path
Date: Tue, 21 Jul 2026 16:55:26 +0200
Message-ID: <20260721152553.942996738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Zhen <max.zhen@amd.com>

[ Upstream commit f844177c6811fd322aa84ed5c32f0e39743446c2 ]

Route DETACH_DEBUG_BO through aie2_config_debug_bo() the same way as
ATTACH_DEBUG_BO.

The scheduler switch in aie2_sched_job_run() already handles
ATTACH_DEBUG_BO with aie2_config_debug_bo(), but DETACH_DEBUG_BO was
not included in that path. Add an explicit fallthrough so both attach
and detach operations use the same handler.

This fixes debug BO detach handling by ensuring the detach command is
processed by the expected configuration path.

Fixes: 7ea046838021 ("accel/amdxdna: Support firmware debug buffer")
Signed-off-by: Max Zhen <max.zhen@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260406211403.4011988-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_ctx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/accel/amdxdna/aie2_ctx.c b/drivers/accel/amdxdna/aie2_ctx.c
index 2dc69900ca0107..d719000c453252 100644
--- a/drivers/accel/amdxdna/aie2_ctx.c
+++ b/drivers/accel/amdxdna/aie2_ctx.c
@@ -360,6 +360,7 @@ aie2_sched_job_run(struct drm_sched_job *sched_job)
 			ret = aie2_sync_bo(hwctx, job, aie2_sched_drvcmd_resp_handler);
 			break;
 		case ATTACH_DEBUG_BO:
+		case DETACH_DEBUG_BO:
 			ret = aie2_config_debug_bo(hwctx, job, aie2_sched_drvcmd_resp_handler);
 			break;
 		default:
-- 
2.53.0



