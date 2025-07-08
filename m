Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB2E264F9C;
	Tue,  8 Jul 2025 16:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993047; cv=none; b=hRotzRUr0ezVkYf83xQQcbWZaTDoCqrzxTu9TVXzFq9zY37u0fUqqi5KQLQU2rBD8Zq48thgg/Z6M1ca8MffWCClHo/5nq7Iy8sHeYSbSTRS/31L7rrqP1UnpRymxpYLORpjIdh04GUEmijHNi2jnW4c+BxpipvzNCx/YZ4JxzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993047; c=relaxed/simple;
	bh=k6xzMWUEu6JVsawzxdvUfdUu7dBOdRF9eU/wQGRCUTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHBVw/y1LWT56y3zoETHEz5ONJiWs2/30udXW2lDOh2+mS+/z4YjJo1tCJ81KyHHom7tWQlgVwNy/Z8jRvoVirWEcTskJZqBUBYcl0yqHwLM7IUNKEBhJxUSU91xsB7a0Jo1k1UlXA4gpGwH2ejnywzCpkawoA+hq7fcjEaZkGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W50VEXWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W50VEXWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CF8C4CEED;
	Tue,  8 Jul 2025 16:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993047;
	bh=k6xzMWUEu6JVsawzxdvUfdUu7dBOdRF9eU/wQGRCUTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W50VEXWd7oJ5WpXbbZjTEVhWgTHMLMTjMk1CjiSA+xcsmaG/Le5ljrdMBAnOHuS0K
	 It+Xn5JMlbeoqdZIGhGcf7ngwXyBlw59Hh9SApvN91CP0I7UdyvAZdhuu+O6QTTY8N
	 cdZmaXCbg06ZCeX+6gRiQ/7VNamThUj46m8R4yTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/232] drm/simpledrm: Do not upcast in release helpers
Date: Tue,  8 Jul 2025 18:22:38 +0200
Message-ID: <20250708162245.676695968@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d19e102894282..07abaf27315f7 100644
--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -284,7 +284,7 @@ static struct simpledrm_device *simpledrm_device_of_dev(struct drm_device *dev)
 
 static void simpledrm_device_release_clocks(void *res)
 {
-	struct simpledrm_device *sdev = simpledrm_device_of_dev(res);
+	struct simpledrm_device *sdev = res;
 	unsigned int i;
 
 	for (i = 0; i < sdev->clk_count; ++i) {
@@ -382,7 +382,7 @@ static int simpledrm_device_init_clocks(struct simpledrm_device *sdev)
 
 static void simpledrm_device_release_regulators(void *res)
 {
-	struct simpledrm_device *sdev = simpledrm_device_of_dev(res);
+	struct simpledrm_device *sdev = res;
 	unsigned int i;
 
 	for (i = 0; i < sdev->regulator_count; ++i) {
-- 
2.39.5



