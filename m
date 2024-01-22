Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E282F145B1E;
	Tue, 23 Jan 2024 00:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968373; cv=none; b=konnCqhFoz2yCHji5k/oA2Bjj8Fb8enOZ81TdZMOtENv5nFRNB4+OnpXEdzUacoijjjW/Q558fZaOBVDMzdse46lyDqKEULZXnjQDGmb/e4u8XHmDUZNi+0fPkAST/Ba6S6Efg4Ta49ExWrEltMcZL33A73OY4hp8X6uadAaGVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968373; c=relaxed/simple;
	bh=63oefFm9FLmuPSucR2Zau+FN03MyeyCbMQY8SxqX/MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dT2ECl2aUXMlo1GK16vc9Xh8soZNgK9+WH5yg75XCQoBQXXXaaiXS6HfP695t1ln2gAS9GHLYD3EKRI/lbCxli4G7nlEHyHpdPR5BoNZs5QBYv3//5WsYkeTxVT36LsR2L5tmIZw5mHCL6mZold26SRx63RETF3/kcYp5fk3gts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLxB+AxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLxB+AxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18718C433F1;
	Tue, 23 Jan 2024 00:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968372;
	bh=63oefFm9FLmuPSucR2Zau+FN03MyeyCbMQY8SxqX/MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLxB+AxDq/uKFVsmp9k9iRuMULi0UI46c6E7sZCTSOwIFls86t+TbZB3Uf5cVqcYZ
	 MwetSEGlMEFq5cDYfpPlolaOikArElyFyjkhwpVOrQ3RubfffUlxvX7ABqxS30q8y1
	 6e2mColksZCNexvqX1IrGUeGOlRxGG2w1YMkJ0vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/148] drm/bridge: Fix typo in post_disable() description
Date: Mon, 22 Jan 2024 15:57:24 -0800
Message-ID: <20240122235715.949550166@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index bd850747ce54..6849e88cd75b 100644
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



