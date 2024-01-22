Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA6E6280A;
	Tue, 23 Jan 2024 00:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971150; cv=none; b=iq1cNm05drC8lMhdSWai2uW02LowUOi72PSKgyGUQqpiShnycqOYiowr6ac+Day9RPXOAmQApPRibHzk7BqsLlMUkoYcr1IZQJkdXXE72bXYODb7TtyR6ikezoaR+OO8j6MfTx/2drRhVFLH9FTX0iOxncxIQUvtEKiKlV+0m60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971150; c=relaxed/simple;
	bh=E/nZ7JmzcMPElpGJkbg+2oq0V8h2igmN8w0OZDSdyYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPHfXP851OG88lViHEX5mTKfK+rKy0uAC0a6imSkkz33/ggBCllM2rcwLqGEaPbnvTGT41exPg7HIQSGbm3HVOgk8elJ1kfJGY2F/UYKZ93nOCxCDm3RXBkBou7P3rvJ1hGpQJ4uHBJE6orhFmJu8nbQQEjCKJ9dKdofUfOFkSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/ry4Edq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/ry4Edq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03DEC433F1;
	Tue, 23 Jan 2024 00:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971150;
	bh=E/nZ7JmzcMPElpGJkbg+2oq0V8h2igmN8w0OZDSdyYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/ry4EdqMgUS09jOimY1PbQvXb64cTPd8+NIftOmaGLypfjodZDC1gxeTuxZAeFcL
	 qnQegwvkfVaOgdjP/RyD5mtPTlZuFnau/wOY9/+KLTDSnCvLWqRQDWwjiuXUhiq/fQ
	 kjivMiHy1kpG7ArDpJtQPALc8Lbh0DWszHfJqrkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/417] drm/bridge: Fix typo in post_disable() description
Date: Mon, 22 Jan 2024 15:55:38 -0800
Message-ID: <20240122235757.752118299@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 288b039db225676e0c520c981a1b5a2562d893a3 ]

s/singals/signals/

Fixes: 199e4e967af4 ("drm: Extract drm_bridge.h")
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231124094253.658064-1-dario.binacchi@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_bridge.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
index 6b656ea23b96..a76f4103d48b 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -191,7 +191,7 @@ struct drm_bridge_funcs {
 	 * or &drm_encoder_helper_funcs.dpms hook.
 	 *
 	 * The bridge must assume that the display pipe (i.e. clocks and timing
-	 * singals) feeding it is no longer running when this callback is
+	 * signals) feeding it is no longer running when this callback is
 	 * called.
 	 *
 	 * The @post_disable callback is optional.
-- 
2.43.0



