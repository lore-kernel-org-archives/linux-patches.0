Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B62250C1F;
	Wed,  5 Mar 2025 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198144; cv=none; b=m4oKb4hyxaNRW5wpqgV1NkHnJnxxorcOYaBQUw8QOTJuXO0EjyjB2aeodnUPVZ6qK0fBA6YZp7iNlu+xYRvaXAOf+vDd/BEahOmpjFXVFivKWl5n41I1Lk/S/aCggp8lhabPIRmZN4+GdZovttnpIHqTyl7rQPQ3eP4W6mqBKbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198144; c=relaxed/simple;
	bh=nhWzzkD6psF7gJtJab64KrxAnj3cJmqSp62EordTOhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXZAfxXLJyPXEIWsP0pSnp8/IPeTpPSLO2T77vCv7dHimdVkF3pDXvNYxE8Hka2NZlc82g7KRlHJLLZ6Q6Vddy1RK+TLXL7mVGES4fcRpwdKxG+1OxkDYwUQ0p+hxFTVFP7wRQ0KnJ8ZeNfmyBQ9WUEt6ZWIuszQMeIa/q+jJis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7S6nmly; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7S6nmly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C05C4CED1;
	Wed,  5 Mar 2025 18:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198144;
	bh=nhWzzkD6psF7gJtJab64KrxAnj3cJmqSp62EordTOhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7S6nmlyeEY9vxHpoLnqMD8cNtAhIwxlKBNe0thrPaXYiXFex4BeoN1uokbqsye/r
	 kc7zzDn9vQ92k83mGpSUDAcmGUa3pUguPdQ3Ra1oqKlDhkZxzkd/BmWH3wz/5p+ex4
	 XwPo0UxDn2S8v7NCkfuA5KJZzT7DFRzCA05oJCOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/150] drm/xe/oa: Allow oa_exponent value of 0
Date: Wed,  5 Mar 2025 18:47:57 +0100
Message-ID: <20250305174505.754743607@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

[ Upstream commit 5bd566703e16b17d17f4fb648440d54f8967462c ]

OA exponent value of 0 is a valid value for periodic reports. Allow user
to pass 0 for the OA sampling interval since it gets converted to 2 gt
clock ticks.

v2: Update the check in xe_oa_stream_init as well (Ashutosh)
v3: Fix mi-rpc failure by setting default exponent to -1 (CI)
v4: Add the Fixes tag

Fixes: b6fd51c62119 ("drm/xe/oa/uapi: Define and parse OA stream properties")
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250221213352.1712932-1-umesh.nerlige.ramappa@intel.com
(cherry picked from commit 30341f0b8ea71725cc4ab2c43e3a3b749892fc92)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_oa.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index 210b8bae59102..448766033690c 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -1716,7 +1716,7 @@ static int xe_oa_stream_init(struct xe_oa_stream *stream,
 	stream->oa_buffer.format = &stream->oa->oa_formats[param->oa_format];
 
 	stream->sample = param->sample;
-	stream->periodic = param->period_exponent > 0;
+	stream->periodic = param->period_exponent >= 0;
 	stream->period_exponent = param->period_exponent;
 	stream->no_preempt = param->no_preempt;
 
@@ -2002,6 +2002,7 @@ int xe_oa_stream_open_ioctl(struct drm_device *dev, u64 data, struct drm_file *f
 	}
 
 	param.xef = xef;
+	param.period_exponent = -1;
 	ret = xe_oa_user_extensions(oa, XE_OA_USER_EXTN_FROM_OPEN, data, 0, &param);
 	if (ret)
 		return ret;
@@ -2056,7 +2057,7 @@ int xe_oa_stream_open_ioctl(struct drm_device *dev, u64 data, struct drm_file *f
 		goto err_exec_q;
 	}
 
-	if (param.period_exponent > 0) {
+	if (param.period_exponent >= 0) {
 		u64 oa_period, oa_freq_hz;
 
 		/* Requesting samples from OAG buffer is a privileged operation */
-- 
2.39.5



