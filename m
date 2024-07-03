Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA47D176AB8;
	Wed,  3 Jul 2024 11:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004506; cv=none; b=DxghHXTysbms8k4w28CaZOZFWCaAjcDenzCCcu7zldajX03ubAp4REEyEEL8vCu+Gmd7keWkLzQgxdCGaoRN9bm0fFXIi6Of50OTAr6HlpTbJlXffu3WN+emXnlHr2/bqViwezfOWZakYvwzV5LKHkQ4wGh/kzJDMEk5asUoIns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004506; c=relaxed/simple;
	bh=IjvmeJsWkBuRrJ63xcttB3D9DKpWqI/12gkdI1qNoqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPJqr5DWeDL8VHWhjEMRM8sRPCzZxI0KZI/0JvBfsKvzRgeio94tfESvQtJ8JCBy9BqeQjlS7MwwV21afC9oWTW/PYEw8YdRhS/uOZrXt1zjqnHiDfqtYk8vumz3J4AK5AC+tDKWh36OBmRY55O+WC10TuAsajk2thXfghQZebs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7N6lMl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7N6lMl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40752C2BD10;
	Wed,  3 Jul 2024 11:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004506;
	bh=IjvmeJsWkBuRrJ63xcttB3D9DKpWqI/12gkdI1qNoqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7N6lMl7D0MS7b3l/PiZls7ORSLEQu0CaBrS7J4FX0IC6rhb2OxP/bNqo1d8scCOY
	 HWxozvSNI2rk2mG7bbVquGxoTkkaXZKkTSAHwUSzn+IO2aNAEGw81bDKj5iW0FmVBS
	 ZJ46776cTB423ZZAGJlKU6g/V+V8RxsbZK6c561E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amjad Ouled-Ameur <amjad.ouled-ameur@arm.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/290] drm/komeda: check for error-valued pointer
Date: Wed,  3 Jul 2024 12:37:26 +0200
Message-ID: <20240703102906.655628166@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1e922703e26b2..7cc891c091f84 100644
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



