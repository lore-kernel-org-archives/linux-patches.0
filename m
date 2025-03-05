Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA0924CEE3;
	Wed,  5 Mar 2025 18:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198475; cv=none; b=paBGIpGlX5KjAX9wowj6SUEu40A9uQiceZ5E5DNBKOI+8mN0Uolo+jVnR32+R6+gslQpVKjx60YP9b39AR3O7LyZVF1Xr0jHIjtseEU8N2LFFKjXrYEXRxHsB7XV/KVLb0KrS7BpZX5skatrt3Ke5Ko75dSmpu1CpVfaeKrswY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198475; c=relaxed/simple;
	bh=8fNIKGLTTDm+MLG/vyuE383JeueB5gnVUJjsjOYZ+W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzbYQJPKVRyX8XLjaWGGIdrF06bEwCDZVl2IKo7pJe/tKtw/j65FljAZkXIdjEvsOLbVytbvBws8bABvHSnS38m+lVrsY8P+ZsFfjaUQ18xTfCVB2iH1PY5M2sRfodaiflM+kH5XUF4ft4Be3Ttj/mNprEIk7ZPbtC5F1WtuYYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbIkGeni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbIkGeni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98173C4CED1;
	Wed,  5 Mar 2025 18:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198475;
	bh=8fNIKGLTTDm+MLG/vyuE383JeueB5gnVUJjsjOYZ+W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbIkGeniK8hGGuAWDeaqVFxAMp4vzK4vjgW1HVwE8Jo04i1ABM3FaPEPLuauupVp3
	 QgsffIaw1EXijIrvxNJWEMAWslYMPYwDHPeFn9uQI8AXBBlwm8BkkGu9hdFRTJl+/v
	 OkX1L9izkZTXVLvMCF8wy5f5yvE+xe46J6tWnkcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 040/157] drm/xe/oa: Allow oa_exponent value of 0
Date: Wed,  5 Mar 2025 18:47:56 +0100
Message-ID: <20250305174506.908945007@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 913f6ba606370..5c50ca8cd8e78 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -1766,7 +1766,7 @@ static int xe_oa_stream_init(struct xe_oa_stream *stream,
 	stream->oa_buffer.format = &stream->oa->oa_formats[param->oa_format];
 
 	stream->sample = param->sample;
-	stream->periodic = param->period_exponent > 0;
+	stream->periodic = param->period_exponent >= 0;
 	stream->period_exponent = param->period_exponent;
 	stream->no_preempt = param->no_preempt;
 	stream->wait_num_reports = param->wait_num_reports;
@@ -2058,6 +2058,7 @@ int xe_oa_stream_open_ioctl(struct drm_device *dev, u64 data, struct drm_file *f
 	}
 
 	param.xef = xef;
+	param.period_exponent = -1;
 	ret = xe_oa_user_extensions(oa, XE_OA_USER_EXTN_FROM_OPEN, data, 0, &param);
 	if (ret)
 		return ret;
@@ -2112,7 +2113,7 @@ int xe_oa_stream_open_ioctl(struct drm_device *dev, u64 data, struct drm_file *f
 		goto err_exec_q;
 	}
 
-	if (param.period_exponent > 0) {
+	if (param.period_exponent >= 0) {
 		u64 oa_period, oa_freq_hz;
 
 		/* Requesting samples from OAG buffer is a privileged operation */
-- 
2.39.5



