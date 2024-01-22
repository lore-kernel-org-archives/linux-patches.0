Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB2F5BAD4;
	Tue, 23 Jan 2024 01:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974347; cv=none; b=nFO7eWS22pR5WUXUFa5v1iWTGO0sqJfB6nVTEuAQ5pH+YROHPIuGEcrMTG+4SoBpofp+OAfFl74EM9jN69+SZGlyKklVJEruZDg3BavRRIBphHrPuSeBBOHUBsimjqAya2Q9SK6VhNBoYCPlze77QIwMjBbsidjVif6eIK303w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974347; c=relaxed/simple;
	bh=GYx27Q2NYzhAAorbE1NMGBHWs8ISlh8JFduknWjHETY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cCISAvpISv7mfHzbNW6mdVojXNZ2wAwdJk4fmjYvyjr4nVa/qG3qWMDUqHuB0JeUjBrjGAgYZwwWEXysdA6sK+5TfZfbZPBihhgHL0CDvWJSg540E1lSfWDg4bIwFcaPpek2Bdk64XBKPDmk6NW+9tzRU+3tdpyx0UW3JrpWLe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyveFkao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyveFkao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF18C433F1;
	Tue, 23 Jan 2024 01:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974347;
	bh=GYx27Q2NYzhAAorbE1NMGBHWs8ISlh8JFduknWjHETY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyveFkaoy44whm4l4hvV5BltAu/XcXZul8bSXXThiBciaIFmGGxl8YSn4lwr+G6QJ
	 OvQ6fLm5VwrCRwllcK+dOwWyXcuiKjQQXeGB6JX4jxAcqi8/2R71XQhg5qskIR/JtE
	 9+c0RRT9sSK9XLfuPfb+9m4qFkCa4F/mwQwYgcow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 185/374] drm/bridge: Fix typo in post_disable() description
Date: Mon, 22 Jan 2024 15:57:21 -0800
Message-ID: <20240122235751.063135782@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c84783cd5abd..3188b7a1d2c7 100644
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



