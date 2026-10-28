Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208460;
	b=PGdeLwsFX1ESRiK3q8dChmyJvP4RGBtOyun3D4ELwKD4jvV+aL7SXh9DfSm15FZZQWek
	 Vz5QPx0Wb2YPjA2SC9aRdlWrP1RIj1bNySd7qSseEE6VrSByvmKmlXYBj3HcVQJ69S5Xv
	 DOTNf/GhiCW0LIZThBUyjTiW3htpZf6/zOBlq0LgeARBMq6SK31PQAuqAKAQElesOZWWF
	 L0pMbGx27tIdBhrJyo3naG0x5Fy6bRgmO64ZSMshopdRyvkKT4Q68NChZCiB0UU0/YNwe
	 9xyvS1bG8HzfHGAPBIGPFc9DHLTvLjHUAcGvRDz4e7/KKQTUU1bwE3eHQ5LfWfek32w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4XQuQ3krMGR7B2aiSerRADWukzWQO88WiCgqdwAyLJs=;
	b=1c4F3ts3HldiIYU3QoXMSS6X/eA/JXB3pFoHLStMFa6yJuZktBpxzkQE0xFmtp3Pw7qU
	 FZWBKx8lgBD35FB7c00XwwrVgAkDzIsaSptfz1WoMQAsyOTsEWLqw2LBHjEauyEVUNJ+J
	 YcC1LaojRhjAmlkJo6XJj3l3mJY1VcK46uUGcllVfBkBcC5tZrTtolsjOYDffK7FPPaTc
	 bxm6veRj6HJhHI9Z9TKJF5a4BFkgKtOJ4f0TFRwSvSaZ9BxcAdcXHrkXXvPdx2prFZFHr
	 ZMa9+P1FBDUmbxOj+xXQ8PO0qjvJkELo1fbD+VVYzgXkjK2TUFoEvU14Wp86nXYnjkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFiVkNdM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B36B606A31A;
	Wed, 28 Oct 2026 17:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFiVkNdM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523421F01825;
	Wed, 28 Oct 2026 17:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208459;
	bh=4XQuQ3krMGR7B2aiSerRADWukzWQO88WiCgqdwAyLJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFiVkNdM1gzR8njze+hrX9dhSQsZGqBJJwIPK2xLw35vLPixn/8G2Oi2nrLBBONrk
	 PlFDkRuJHUhF97ylprMsWZRbOCHv9i95etqMIdOyek10h0m34NoOs1VEwXUrjSbJSA
	 DC5aVsgEd1XnWMzMKIOT4Fpiu+6e4moCNvhoEbIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Eckert <fe@dev.tdt.de>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/516] tools/thermal/tmon: Fix compilation warning for wrong format
Date: Wed, 28 Oct 2026 17:54:38 +0100
Message-ID: <20261028170006.498668322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Eckert <fe@dev.tdt.de>

commit 9da39ef332c417ce52732564c1c682a6e1209302 upstream.

The following warnings are shown during compilation:

tui.c: In function 'show_cooling_device':
 tui.c:216:40: warning: format '%d' expects argument of type 'int', but
argument 7 has type 'long unsigned int' [-Wformat=]
   216 |                         "%02d %12.12s%6d %6d",
       |                                      ~~^
       |                                        |
       |                                        int
       |                                      %6ld
 .....
   219 |                         ptdata.cdi[j].cur_state,
       |                         ~~~~~~~~~~~~~~~~~~~~~~~
       |                                      |
       |                                      long unsigned int
 tui.c:216:44: warning: format '%d' expects argument of type 'int', but
argument 8 has type 'long unsigned int' [-Wformat=]
   216 |                         "%02d %12.12s%6d %6d",
       |                                          ~~^
       |                                            |
       |                                            int
       |                                          %6ld
 .....
   220 |                         ptdata.cdi[j].max_state);
       |                         ~~~~~~~~~~~~~~~~~~~~~~~
       |                                      |
       |                                      long unsigned int

To fix this, the correct string format must be used for printing.

Signed-off-by: Florian Eckert <fe@dev.tdt.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20231204141335.2798194-1-fe@dev.tdt.de
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/thermal/tmon/tui.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/thermal/tmon/tui.c b/tools/thermal/tmon/tui.c
index 031b258667d8c..7f5dd2b87f15f 100644
--- a/tools/thermal/tmon/tui.c
+++ b/tools/thermal/tmon/tui.c
@@ -213,7 +213,7 @@ void show_cooling_device(void)
 		 * cooling device instances. skip unused idr.
 		 */
 		mvwprintw(cooling_device_window, j + 2, 1,
-			"%02d %12.12s%6d %6d",
+			"%02d %12.12s%6lu %6lu",
 			ptdata.cdi[j].instance,
 			ptdata.cdi[j].type,
 			ptdata.cdi[j].cur_state,
-- 
2.53.0



