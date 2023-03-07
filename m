Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED5EBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E757FC4339B;
	Tue,  7 Mar 2023 17:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209796;
	bh=ZT3QbQgbpXkXnak01gpPhoP+vcBfgriVrJHuHi4dsKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbLEtS2yCjDkubwA6SMFFwJtB9ru9cr6fLBFAxt5Tr8dgowAjCrwVjE2aJmQ+eCco
	 YIdYkuJaZ30NuHQS/WBG5O4jxSTkjAMOkZB7V/Vat/iePAz+X/RglQC2WmA78abevH
	 X2B8J865GxHZUqP16S+FdUiX6ed4qE4DBvocweaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	coverity-bot <keescook+coverity-bot@chromium.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Maxime Ripard <maxime@cerno.tech>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0335/1001] drm/modes: Use strscpy() to copy command-line mode name
Date: Tue,  7 Mar 2023 17:51:47 +0100
Message-Id: <20230307170036.022001470@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 0f9aa074c92dd9274b811c1c3fa93736814a4b0d ]

The mode name in struct drm_cmdline_mode can hold 32 characters at most,
which can easily get overrun. Switch to strscpy() to prevent such a
thing.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527354 ("Security best practices violations")
Fixes: a7ab155397dd ("drm/modes: Switch to named mode descriptors")
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/20221128081938.742410-2-maxime@cerno.tech
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_modes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index 3c8034a8c27bd..951afe8279da8 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -1809,7 +1809,7 @@ static int drm_mode_parse_cmdline_named_mode(const char *name,
 		if (ret != name_end)
 			continue;
 
-		strcpy(cmdline_mode->name, mode->name);
+		strscpy(cmdline_mode->name, mode->name, sizeof(cmdline_mode->name));
 		cmdline_mode->pixel_clock = mode->pixel_clock_khz;
 		cmdline_mode->xres = mode->xres;
 		cmdline_mode->yres = mode->yres;
-- 
2.39.2



