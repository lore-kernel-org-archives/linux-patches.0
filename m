Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96F6372;
	Tue, 23 Jan 2024 00:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969462; cv=none; b=gJC6mQkh5uoXwL41xNwiIonqzl+UUIj/EsguVOzMkHptGSH0h0s/ap8G5mnW8uXF7znxQdqSd8aqdqgmYJEgL7n+wGEDDtC8jcKVUdtT4ptcu0kG0I3bXgKenhEnZgCOmmEpz8+xKB2I/Fb4eClm6XR2xEE7edveGbyiSTmlOUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969462; c=relaxed/simple;
	bh=DBfMJ1V0Hyb+Sqp76RYH+G9sxsTNFe5dLiIz55qus3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LqEYSNuAisGGOTJ+PV5087ISqGQKGqyQ5GRWsgs0v/4b9YrQCXOu03Qz5Z0iE4gYjTe96aXcBPoxEKev4TKDbzFCmbaXhV2D7ANERuv4eHIUZvwxkXgMqibUGMHVVhR9fx4/pUJDgejkk8JvOM3xo9TQE3GsDn+z4FwRSLg+84E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGvBL1e3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGvBL1e3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6001AC433F1;
	Tue, 23 Jan 2024 00:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969462;
	bh=DBfMJ1V0Hyb+Sqp76RYH+G9sxsTNFe5dLiIz55qus3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGvBL1e3gTFb9XXm+eeYVolVL1Vls078GpcRQX0y9CIYRAOymEbFFVrky2ZPJeGP3
	 sauC3QHC66fggRBfoYv8T6J1OlzaX6dKvnAA2jcxyJ/mdeZ5q3w4c5HSHre4vXdEMl
	 L5kXLTrd1mlQ4SRc/iHGC8uS9jN9XI2Ymc12gbHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 261/641] drm/bridge: Fix typo in post_disable() description
Date: Mon, 22 Jan 2024 15:52:45 -0800
Message-ID: <20240122235826.101660102@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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
index cfb7dcdb66c4..9ef461aa9b9e 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -194,7 +194,7 @@ struct drm_bridge_funcs {
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



