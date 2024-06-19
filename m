Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED4D82495;
	Wed, 19 Jun 2024 13:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803099; cv=none; b=pvpg53O8iNUsU4lDlw6FXGABt8TGmdSW8fU2IEPJNErioFbM4e6iOMKXE6xTWQ2kT2ydIIcDYbOnkVu5r1UvgOXYiR1Q2rSOwz3ysJ90d3TgBOnXYhI//Q8J87qI7sLZbuRfZuumZFFCPBKA2yxqxfUhc2RhxGugazLzX9nOyWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803099; c=relaxed/simple;
	bh=DknbqQajwAqhN1VZjYDD90PN6HhkgVBB3QjoB4PBpBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRvX72G99Lob5H92z57KgRX1srP2eMhoJlDz9jGES5y/IjAS84yuqIoArx4TlsrSQS0+BwgZTveCmtklI1sdT22paQ51YMQndUy7QrvY3+0zwwJeFpmmTktv4eaVhxGcFleoWhiBgViqLKGwFzmrv3mAxYPAQOh1C1NjtjxI7ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlY5BmQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlY5BmQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5572C32786;
	Wed, 19 Jun 2024 13:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803099;
	bh=DknbqQajwAqhN1VZjYDD90PN6HhkgVBB3QjoB4PBpBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlY5BmQpVsMLDq4OQlhwiv/e8R8a2npJOAgL4P5CDzD/iZm2rB2qL6LCS7FSux70q
	 UnFYNyHcsZ5g+kBadYvOOOeNysN/qVRAumUh7CH4/jcAdR1L37uJdX+YSSkIEFfyWG
	 4vVQFj66/gQre9Uts3qOCflFJu2dRb/Vdk40yjpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amjad Ouled-Ameur <amjad.ouled-ameur@arm.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 153/281] drm/komeda: check for error-valued pointer
Date: Wed, 19 Jun 2024 14:55:12 +0200
Message-ID: <20240619125615.727031100@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amjad Ouled-Ameur <amjad.ouled-ameur@arm.com>

[ Upstream commit b880018edd3a577e50366338194dee9b899947e0 ]

komeda_pipeline_get_state() may return an error-valued pointer, thus
check the pointer for negative or null value before dereferencing.

Fixes: 502932a03fce ("drm/komeda: Add the initial scaler support for CORE")
Signed-off-by: Amjad Ouled-Ameur <amjad.ouled-ameur@arm.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240610102056.40406-1-amjad.ouled-ameur@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c b/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
index f3e744172673c..f4e76b46ca327 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
@@ -259,7 +259,7 @@ komeda_component_get_avail_scaler(struct komeda_component *c,
 	u32 avail_scalers;
 
 	pipe_st = komeda_pipeline_get_state(c->pipeline, state);
-	if (!pipe_st)
+	if (IS_ERR_OR_NULL(pipe_st))
 		return NULL;
 
 	avail_scalers = (pipe_st->active_comps & KOMEDA_PIPELINE_SCALERS) ^
-- 
2.43.0



