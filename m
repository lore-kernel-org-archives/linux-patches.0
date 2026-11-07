Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060782;
	b=4lZZ2Nkd3EV4kYX+McWKxc67CfoUGeGrj4sInXJ6su3XPHf96BpWu5TeM6W1HyManqs3
	 OOEhSsuPswF2MIGXdh3bATNaIqdZRFKx9wsjE+Gbt3C/kn9xXtFJKADtFjxy1QhngcVIK
	 wyoBHbrS9E6nbjCxE28PRs+Zr6twd+sEJct868UKytBRYX0Ls5oXd1nweydXIBV3uxvCS
	 6KkXSAoalCKWar57GvqVNdRBRyGyKn6wkp/ENGf1lZAVODDlEiUUb0OFabsns7nP2aHut
	 GvPs0ZzHDvamvtXfp8+L2Lh3QVBdFl/EAvqO+8ry3hmlcheRSmYx4/vcGq8bgTlEtOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+729N+ozAoK4ow1ObAQ/xwzf1+wzj24Sdxv5tvvfanA=;
	b=stOqcWvJvfD0H/oJHTFidDWk0Zcy38ZtaL7i+v46HJe9ywMFl5GanAJFbCBuemr8R6fP
	 qu3USywIudSdTP4MJVQOd48sDogBtulmmtRqHFDqZLIa+S9lhGl0/R/hAj9upV7Ne8etP
	 8j0VfUcBgZUVJ0WtxgcBRGj5xRdQsvF8SPQkjwbA1cxhg4CpEI4P+BSxseR2nKRtFrUDu
	 vydZuMk5XOGN4cyPfHQMCMlxEJXaAtbMc8wuys0pbSVkcQJIwhKOYn9YRqQvb7FZ2H8G4
	 tdAD/C1Q7kwpl/215WD/v90mNlIptF9uZy8spCRWCDFkMCGXnnLEKV9CDcSS+D7+X1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ni7h1Qil;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64591606A326;
	Sat,  7 Nov 2026 14:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ni7h1Qil
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118E81F0089F;
	Sat,  7 Nov 2026 14:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060782;
	bh=+729N+ozAoK4ow1ObAQ/xwzf1+wzj24Sdxv5tvvfanA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ni7h1QilUeiQPUJN+NTzGCm3Wp4ndCLZOPWV9jmDJ1mp5Fo12JnMu6kkh8JeVO+9l
	 ibxKnQm1I7swnBwGpZBdHe/mxrht1zvkKzctrHQ5t0zK98gU9GsTu/TOSCRpKOVclM
	 fnBhGqSRQ6QkiFi3b2voBcK03IHQPVZ2pIyUI+ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Schocher <hs@nabladev.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0188/1536] drm/panel: simple: Add Kyocera tcg070wvlq panel
Date: Sat,  7 Nov 2026 08:36:44 -0500
Message-ID: <20261107135002.942066989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Schocher <hs@nabladev.com>

[ Upstream commit 900517da69afca6f72dacf14278aee3b65275507 ]

Commit 922fb2db0287 ("dt-bindings: display: simple: Add Kyocera
tcg070wvlq panel") added the compatible string for the Kyocera
tcg070wvlq panel to the devicetree bindings documentation
(panel-simple.yaml), but the corresponding entry was not added
to the panel-simple driver.

Add the missing compatible entry to the driver.

Signed-off-by: Heiko Schocher <hs@nabladev.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260721041935.757240-1-hs@nabladev.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index e54b8f164adb8..e46504fb6acef 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -4894,6 +4894,9 @@ static const struct of_device_id platform_of_match[] = {
 	}, {
 		.compatible = "koe,tx31d200vm0baa",
 		.data = &koe_tx31d200vm0baa,
+	}, {
+		.compatible = "kyo,tcg070wvlq",
+		.data = &lg_lb070wv8,
 	}, {
 		.compatible = "kyo,tcg121xglp",
 		.data = &kyo_tcg121xglp,
-- 
2.53.0



