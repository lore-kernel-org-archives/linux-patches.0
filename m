Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214006;
	b=ACkfJ2Dxg4gJkexS4fos9XgOIrb+GhUCc9Wibkex6hsl4oyDjkxx1yEV2v879/6q7LA5
	 0t1pYItK6VGMySU8iugq8v8m04r7v/dVuTGkpmHsk8M1ipLSUDX7w2hOq6KXS7zTjTsNo
	 bk1qeHM7heN3TFbUxTRbUthP+QcsAtOsqlM4lV5zGZNNu5bdqnKkbhGlJcxQa314i/52t
	 kU//B8Tpl8j4/jRgitJM0/0ZvjRzANCuYP9+QH4jy6cDb3lUZU/tTtQhqj1ONXI5GjWpo
	 7VgtqzVCC76xBl0/hJK5BZqJZX28k0YEmUJfcrCSy4cSEhIvjAzh3Cz0h1F7Owf8j2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wQqVgTXSXYUWTiRjW1lZEcIjOsDGYrN6t0lIvs2z9yU=;
	b=gfxSw5r2kGgQT00CbT2JThCjXK2iUFUTGONHjpu1aOGbbvsjsd3mEHM0UuBNdPdJ/Zoh
	 zU1mydYGuURhHgRYgmaV/NzdTJvPAx4PvsT5cylezxPrMzSyASCM38gR2HIxD+mhpeIux
	 vUks7dIWKNBFu0Vng+oi7kFct587OXk5z+QdZcz2Qti3VT7jAvxzvseJNVaToPeApZHpj
	 G5qxmMNGIJqJycsbccAxHDQmkMDZmBgaWzbooXu7SqHVvDqQICs1VGOVuc547JW5Y8v0j
	 KrnjUQtQjkdvPijCLhmM3qxk7mAfAkz88Qj+ZVi/+vZ3BoukWmurET7h+XaCwffhkNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8k361ic;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C16606A31C;
	Wed, 28 Oct 2026 19:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8k361ic
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875771F031E1;
	Wed, 28 Oct 2026 19:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214006;
	bh=wQqVgTXSXYUWTiRjW1lZEcIjOsDGYrN6t0lIvs2z9yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o8k361icL3bVBTyoncbGsNRBTPYTIL5/Eubdqkq90e22kzTGDumxg/lmCzMcqvS47
	 1WSV+uMVOLiah8+N8GjZHMBtkwvYSawMAj65I8UOlu6CsQsQsczIb2ojXx9YAdabKf
	 dknMgp3WYs7vyMBkCdMYjK/HhJEe2RpWP8a+W58k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0705/1887] drm: zynqmp_kms: Unplug DRM device before removal
Date: Wed, 28 Oct 2026 17:46:41 +0100
Message-ID: <20261028170515.454128744@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 2e07c88914fc5289c21820b1aa94f058feb38197 ]

Prevent userspace accesses to the DRM device from causing
use-after-frees by unplugging the device before we remove it. This
causes any further userspace accesses to result in an error without
further calls into this driver's internals.

Fixes: d76271d22694 ("drm: xlnx: DRM/KMS driver for Xilinx ZynqMP DisplayPort Subsystem")
Closes: https://lore.kernel.org/dri-devel/4d8f4c9b-2efb-4774-9a37-2f257f79b2c9@linux.dev/
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240809193600.3360015-2-sean.anderson@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xlnx/zynqmp_dpsub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xlnx/zynqmp_dpsub.c b/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
index f34d4ec1d92f3..463407d5f6600 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
@@ -253,7 +253,7 @@ static int zynqmp_dpsub_remove(struct platform_device *pdev)
 	struct zynqmp_dpsub *dpsub = platform_get_drvdata(pdev);
 	struct drm_device *drm = &dpsub->drm;
 
-	drm_dev_unregister(drm);
+	drm_dev_unplug(drm);
 	drm_atomic_helper_shutdown(drm);
 	drm_kms_helper_poll_fini(drm);
 
-- 
2.53.0



