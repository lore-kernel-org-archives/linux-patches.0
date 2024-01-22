Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E864612BF3D;
	Tue, 23 Jan 2024 00:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968938; cv=none; b=DuLsC1xiIcyLK6mgdCj57LzjHbDIL/VOCWFgvV7CVlJ8DfLnrNink7u5BkxGL1eb++nWPa1cpLQEuegs7TMCDM3FYexfQIh911kivOw0JzovOtEUAx065po9PJiiy2uAHYy1t1CrZwk1na4KHWJqZnuT8pyfUvHnDfuizH73X3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968938; c=relaxed/simple;
	bh=Vq3DUU2hKbkry7x0NpEAzVjx4yJKtuN2maLSYeHSqpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upWuQcrf3q+Ep+734rOPilJA2lxbAxr4RiaGcK1IEUdHToEapk6uyZVzW4YaZWhGIwTM0eE33zeHBwDOFusC8IgGC2qByk+R35gHE9/cRTYFIW9THej8cf7FqKFmRAg+nV3gya3APKoW8LVE4eeAt3rxMCQZRP5J/Qb3HzgDpfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9j861cz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9j861cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE176C43394;
	Tue, 23 Jan 2024 00:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968937;
	bh=Vq3DUU2hKbkry7x0NpEAzVjx4yJKtuN2maLSYeHSqpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9j861czmI3wA+lIl/mDnrYU4bsNCkkeRNfNpcF1dwBQHJQPeYK5OgKek6EWNIkJp
	 +n8/kU2kuoVG0my140A15f471MZ4CLNxdg83+lkNtDY5P/CXEXTmGqf/5scJxNCHqJ
	 5NNDSnzthDxp2Ial6uYfi4udjQzBM/K/u/88SoM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/194] drm/bridge: Fix typo in post_disable() description
Date: Mon, 22 Jan 2024 15:57:21 -0800
Message-ID: <20240122235723.991627392@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9f7192366cfb..64172de5029d 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -162,7 +162,7 @@ struct drm_bridge_funcs {
 	 * or &drm_encoder_helper_funcs.dpms hook.
 	 *
 	 * The bridge must assume that the display pipe (i.e. clocks and timing
-	 * singals) feeding it is no longer running when this callback is
+	 * signals) feeding it is no longer running when this callback is
 	 * called.
 	 *
 	 * The post_disable callback is optional.
-- 
2.43.0



