Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213529;
	b=Dur8OM/FOR1ihMuKVX/KTKecccQnzhbylU/ymSxFD/eCX2pfmqKjBh835JhlK63XenFr
	 fZrCI9kUmdAupG6CKRFB1CZnBsLprtERXdasCj22pxlf5muJW43TgB4Z4g9n3FCFJQcLA
	 bEOx6E4hY8ao1c0UEVgtE6SW7o2TTh9QYWfyNvg7wehutmIh8VSuivx69YQ0yJJ8yFuh9
	 JYBJO83ImNpeaqK+JV4Ugw1ybbOlL4kY5O0mtATzMSyrQmuVYPliXDtxyPPgfKwhIFd36
	 4o95WC1ClSEGf+C9f3kRALYAtqUVHbLQ0Y/y0RwC+MhIzgqnDQMNOMuxc8oqk5rKDbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MomMc5Qw5TTatymx3dhtPGqMxQxQ3Zuk1aAC8yACloE=;
	b=M7HP1iCdhO1lL+Mqa1Dyuf0Zs5HHibLNaIOZz/Ze0FUgdfX2F8ONkVmd/ygwO5r2AXVk
	 1Wj+APzApr9tscHurBgkc0Zf6JhDKqjvslMbZR2WpdjO023speszcGjTrtYmmBE2dnwSV
	 N9wd8xlGPrh9NaPqp7iRIEJTo33ot04M5emNhbCSiFde+bVs4ooE6ZcYum+b6L0SU8aLs
	 1eunh9D3Xn2s7J/1o5rElwp4pVyASVnFVtLLeR3luXjh0NUzIWWJ2JtW5MSz2AFCQ/TXC
	 T0Mz+iTlmhmOk9LAs47PV+NdU5+2MA0YgTMy5jZ8cCtwa/kjIVIX6TdHpY3dM+jafGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QCNvv74l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D42D606A31A;
	Wed, 28 Oct 2026 18:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QCNvv74l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D7C1F01828;
	Wed, 28 Oct 2026 18:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213529;
	bh=MomMc5Qw5TTatymx3dhtPGqMxQxQ3Zuk1aAC8yACloE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QCNvv74lKqGVjAloG3NdNDaOLn3cU9q7moto3ICDQ4ct1Ai7G+5vcK4QmW015EcXi
	 ZFSsCEfRrcLFIcf2TGjobrs2/2CkkwCDrf2+JJIdEbdeac7wVerBN7bziuiH9nZk9N
	 ArvmxIi1FsiVm08r51iXnXQyX4TLQ4ybubsiQ0t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ca23c8570669ead78867@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0539/1887] drm/fb-helper: defer setup when fbdev_probe() fails, not just on -EAGAIN
Date: Wed, 28 Oct 2026 17:43:55 +0100
Message-ID: <20261028170511.618462732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Moved the existing preferred_bpp assignment alongside deferred_setup because upstream’s earlier initialization is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fb_helper.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index a0abfb3f05f04..954ca9215fb88 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -1942,11 +1942,11 @@ __drm_fb_helper_initial_config_and_unlock(struct drm_fb_helper *fb_helper,
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



