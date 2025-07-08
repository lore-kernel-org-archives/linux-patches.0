Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E2E2E427E;
	Tue,  8 Jul 2025 16:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992495; cv=none; b=Vu+zQYvgjPIs3G12U3KhualzG84RsFSNiKiTV2AGWuK/8i1uVGIkKqRO96ZXEdGCy/Di/JQYUAwugHbcdmGJH0x5p3DZvRS9vbExPC1hOxBX6WCSEnQqitl4TY/33ItgDU6TBerFC+5ZwyiYSexXksVQMiOWKJcsHWpjLe0OeQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992495; c=relaxed/simple;
	bh=sWEWJmuDss8a0DwqZFnqtEZ82cNZZCNVjM1NAzL3nTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXRr+SIcI0Q/2HsY+4l9ZYfDvi+fjFJ0vCpUWdsC/SvIHQfzcipmh0NEJv5mW/orOGigt/2zYHpjW3z3y1JHv7tU7U6mu3gXGKybbtAxskrky0nAmiMFdMkMmy3dimG74wQw1U7ghEy4K68ckg5ZJw5Iv46GTzyNSlWgxZNabz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tY22MjqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tY22MjqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDDFC4CEF0;
	Tue,  8 Jul 2025 16:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992495;
	bh=sWEWJmuDss8a0DwqZFnqtEZ82cNZZCNVjM1NAzL3nTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tY22MjqNNgIO4LLwB/arEy8JDEfT4psF36zo/cWAl7q6kAlvlZIHu42zqnwlrAe8n
	 mOvW3kjPIDIbZOVRpFWjZcVcllQ7q1HjLzvriyTln1rMw8Uv5DjYa9M0WMKUJO98EZ
	 Kbx4kJ8AWGkNA/A3xzPl/wej/4qKAOvbuy5/WJXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/132] drm/simpledrm: Do not upcast in release helpers
Date: Tue,  8 Jul 2025 18:23:11 +0200
Message-ID: <20250708162232.975489001@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit d231cde7c84359fb18fb268cf6cff03b5bce48ff ]

The res pointer passed to simpledrm_device_release_clocks() and
simpledrm_device_release_regulators() points to an instance of
struct simpledrm_device. No need to upcast from struct drm_device.
The upcast is harmless, as DRM device is the first field in struct
simpledrm_device.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 11e8f5fd223b ("drm: Add simpledrm driver")
Cc: <stable@vger.kernel.org> # v5.14+
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20250407134753.985925-2-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/simpledrm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tiny/simpledrm.c b/drivers/gpu/drm/tiny/simpledrm.c
index 8ea120eb8674b..30676b1073034 100644
--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -276,7 +276,7 @@ static struct simpledrm_device *simpledrm_device_of_dev(struct drm_device *dev)
 
 static void simpledrm_device_release_clocks(void *res)
 {
-	struct simpledrm_device *sdev = simpledrm_device_of_dev(res);
+	struct simpledrm_device *sdev = res;
 	unsigned int i;
 
 	for (i = 0; i < sdev->clk_count; ++i) {
@@ -374,7 +374,7 @@ static int simpledrm_device_init_clocks(struct simpledrm_device *sdev)
 
 static void simpledrm_device_release_regulators(void *res)
 {
-	struct simpledrm_device *sdev = simpledrm_device_of_dev(res);
+	struct simpledrm_device *sdev = res;
 	unsigned int i;
 
 	for (i = 0; i < sdev->regulator_count; ++i) {
-- 
2.39.5



