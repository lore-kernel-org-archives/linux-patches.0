Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211635;
	b=iQnxOOlxcyzDKZjkHIcTf7H96wD39vmDPHTk7bo1eHKnnPllljvA527hDpPBbi/3mxGl
	 Tn2AS81XqSMPL594jbU6uyXKfRgFZuTSP85pOZD9pijKjyWMtWj5YUcdCQ2/bdodiHeRs
	 hkeOzTbUpB6VfXWJEP5zfBahhb9RGZ1g6XdgPIqlHmeccFM4lOgzQ0/onSWlOU79RKwC7
	 uA5LVYxcNqkm5TbwhNjoh2fEzlADFGD+pt7W9bVG1tozcng0vFHBC1xUCl0g50Hvg1aNb
	 dy5qiBbHX6Cl5fmLEK7Mn62CVV33wt3KQO7urLoTt12x8RlmKJ3U0JRCtpRsaDzmARA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=25+e5toY0eOuZH6vDsyE3sR0LJGpnBaxIxWp9QnKIu8=;
	b=dzut56fJZillFnUuBBawkJ9/17qpLZO8OHWBjG1+K3L6mSm8rR8f3RgvmEYT3TWjmMCA
	 EQanko+v2cTCFiE6kyNK0n80uC4yRfL0bMs3whqTkCn+J6InJZA0iOOsFIEqMBOl6aEZf
	 JP6zwtyOFM5iN0dZjQkBN+mrpZeKfKvVbL9HXdvYijs2fNwDXteEkf/6h5uEU9FOllovE
	 6p4hZf/TH1KZXpoUGMfMgD36lfY0Mbysl9d0iJGuBngwsi1VN13JXqhXuZhNDY/xjwZbl
	 usc+63AxyPhQxJYpLNdFJ/n5fDwUlIdMKZDFR+FhsTc1z3oiccv4PvWRhNbDKvw/fTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EkWwzqox;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7841B606A325;
	Wed, 28 Oct 2026 18:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EkWwzqox
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0AA1F031E2;
	Wed, 28 Oct 2026 18:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211635;
	bh=25+e5toY0eOuZH6vDsyE3sR0LJGpnBaxIxWp9QnKIu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EkWwzqoxQxy5wRYCzSDT9iTK3yQU8JW1DoK2IvDQuxO6vfx7Y6Qyx12sF3GTfynMd
	 gMb+TgQe0u/7gfCsBi1zuAvBKYlC7z7iuF4wpwhz3CpWphHQg8y4ZJuQvR9yu3jmP9
	 /QG5TJjejR1K6V/lKoPJyoR83ZJaZ4RZp8iBfv2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ca23c8570669ead78867@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 446/571] drm/fb-helper: defer setup when fbdev_probe() fails, not just on -EAGAIN
Date: Wed, 28 Oct 2026 17:59:53 +0100
Message-ID: <20261028170018.609318282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit 755c94d178b7e972bb766199d34e4ba4f63a89eb ]

__drm_fb_helper_initial_config_and_unlock() calls
drm_client_modeset_probe() first, which already fills in each
mode_set->mode/num_connectors for every connected output, and only
afterwards calls drm_fb_helper_single_fb_probe() to create
fb_helper->fb and wire it into those mode_sets via
drm_setup_crtcs_fb().

If drm_fb_helper_single_fb_probe() fails with anything other than
-EAGAIN (e.g. dev->driver->fbdev_probe() itself fails), the function
bails out before drm_setup_crtcs_fb() runs and before setting
fb_helper->deferred_setup. The client is left with mode_sets that
have a mode and connectors but mode_set->fb == NULL, and nothing
marks this fb_helper as needing a retry.

__drm_fb_helper_restore_fbdev_mode_unlocked() only skips committing
when fb_helper->deferred_setup is set, so a later .restore() call
(drm_lastclose() on process exit, in this report) commits the stale
mode_set through drm_client_modeset_commit() ->
drm_client_modeset_commit_atomic() -> __drm_atomic_helper_set_config(),
which hits WARN_ON(!set->fb).

Mark fb_helper->deferred_setup on any drm_fb_helper_single_fb_probe()
failure, not just -EAGAIN, so restore keeps skipping the commit until
a later hotplug event successfully re-probes and re-populates
mode_set->fb. The real error code is still returned to the caller
unchanged.

Reported-by: syzbot+ca23c8570669ead78867@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ca23c8570669ead78867
Fixes: ca91a2758fce ("drm/fb-helper: Support deferred setup")
Cc: stable@vger.kernel.org
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260927075434.72658-1-ngocthang2710.1999@gmail.com
Link: https://patch.msgid.link/20260917154743.1621-1-shechenglong@xfusion.com
[ sashal: Preserved the existing bpp_sel-based preferred_bpp assignment in the deferred-setup error path. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fb_helper.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index bc265aa0f692b..acd90c22ea1fd 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1841,11 +1841,11 @@ __drm_fb_helper_initial_config_and_unlock(struct drm_fb_helper *fb_helper,
 	drm_client_modeset_probe(&fb_helper->client, width, height);
 	ret = drm_fb_helper_single_fb_probe(fb_helper, bpp_sel);
 	if (ret < 0) {
-		if (ret == -EAGAIN) {
-			fb_helper->preferred_bpp = bpp_sel;
-			fb_helper->deferred_setup = true;
+		fb_helper->preferred_bpp = bpp_sel;
+		/* modesets are probed but fb_helper->fb isn't; defer restore too */
+		fb_helper->deferred_setup = true;
+		if (ret == -EAGAIN)
 			ret = 0;
-		}
 		mutex_unlock(&fb_helper->lock);
 
 		return ret;
-- 
2.53.0



