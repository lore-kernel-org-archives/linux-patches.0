Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B811C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469AAC433D6;
	Wed, 23 Nov 2022 09:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196803;
	bh=tnZLFGjEAqxhqZfb8cO14Kfq/LMkQz8BVa1ZtgkQOWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEwTdoQXm9PK1EVsQVBRSr9Q+nneqd6IdUkVpeIDPvSoPy8PqBXJT7YbGaUpBG58c
	 KwdqUfUhlwz+NuiP3CNURRWYVSfGGl/tazXSkabg2d0Uois6EYm21ygxmTKD9lo936
	 ha/2sQSppLt4ZFAI/+babSUnZWv1YeqOCysaU00o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aishwarya Kothari <aishwarya.kothari@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 128/314] drm/panel: simple: set bpc field for logic technologies displays
Date: Wed, 23 Nov 2022 09:49:33 +0100
Message-Id: <20221123084631.337745683@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aishwarya Kothari <aishwarya.kothari@toradex.com>

[ Upstream commit 876153ab068b2507a19aa3ef481f5b00a2cc780f ]

In case bpc is not set for a panel it then throws a WARN(). Add bpc to
the panels logictechno_lt170410_2whc and logictechno_lt161010_2nh.

Fixes: 5728fe7fa539 ("drm/panel: simple: add display timings for logic technologies displays")
Signed-off-by: Aishwarya Kothari <aishwarya.kothari@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220831141622.39605-1-francesco.dolcini@toradex.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 1e716c23019a..eb938bfb0573 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2505,6 +2505,7 @@ static const struct display_timing logictechno_lt161010_2nh_timing = {
 static const struct panel_desc logictechno_lt161010_2nh = {
 	.timings = &logictechno_lt161010_2nh_timing,
 	.num_timings = 1,
+	.bpc = 6,
 	.size = {
 		.width = 154,
 		.height = 86,
@@ -2534,6 +2535,7 @@ static const struct display_timing logictechno_lt170410_2whc_timing = {
 static const struct panel_desc logictechno_lt170410_2whc = {
 	.timings = &logictechno_lt170410_2whc_timing,
 	.num_timings = 1,
+	.bpc = 8,
 	.size = {
 		.width = 217,
 		.height = 136,
-- 
2.35.1



