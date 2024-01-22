Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691D8664C3;
	Tue, 23 Jan 2024 00:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971557; cv=none; b=etsTsrSctK+EPhZEXEkr1RVu0LHZWCubH1mOB7HbKrIZ8Emb9ddJAtGSrmNb+pYG+3oXqz9dtJPYy5TzAAgcD4j6Wf9spFS3781sw+x3M7h1MRgIWZrxu5LUB/xTEk8BI1+UVdq16jEGWYaSv+YYepC+4G4pNlK6Jn0M/U00aH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971557; c=relaxed/simple;
	bh=UbXDQztOKQYSffYz0U8IfJgBbpEbYGSMgpBGRXEQ2yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNWpRS01hdJwZBRFELFEk2DbkDH8MZAeR+SWvJHKKvnwi4sD+VTXcuSrdYWPNMyPf90+H7/OEmLsG/M7O6V1YD5Edk2WpzC9J/6a7Ymd3zDVQJnKq+SkqQ8E6ZztzBLyBy/JRN2189WgD0CX3fiRcJaNF1H5t+dRVT4ZjiJc10c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jodx5Hcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jodx5Hcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58B0C433C7;
	Tue, 23 Jan 2024 00:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971557;
	bh=UbXDQztOKQYSffYz0U8IfJgBbpEbYGSMgpBGRXEQ2yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jodx5HcwAkShikf5F3tZL6oxESnL+kBepcH3WM4Apuno5VlLgNpgkgiz6LqUZOJz3
	 /6iL2QB+G6jhtA1fsmKqtZGEo3cFgqptZ3tC426KIl0gJFeSYzfTEhx4dJGcdSDQdP
	 8xRockiHTJWqi+NoCK1fZY5s2Ii2uD9kBAVdwbgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/286] drm/bridge: Fix typo in post_disable() description
Date: Mon, 22 Jan 2024 15:57:36 -0800
Message-ID: <20240122235737.932129858@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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
index 055486e35e68..3826cf9553c0 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -186,7 +186,7 @@ struct drm_bridge_funcs {
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



