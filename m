Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213651;
	b=xED/V8TNdvJE1TAqRTa+JaV0o24zfk7kd5sPn6xc33rZaDpHDniiNX9aeDcw3WvTIwmr
	 jwdZwkVJBqhibsWrm69WAYRJ7/fCH64bLZOzflPYVEydLh3DZT8xrgHoWrFlTBefd1zFi
	 93/2XSLgG43q32hWlsVHv9+lotdV1S73YKGfjrGz27HI145SwjPJm71lF0g5hsBGhS9xj
	 GY63B4eW7O/60cgSrtxJbf3ov+30Zn81WNssTB+1iAgnOfSIulDG8QvB26nDiahn2d+JK
	 OO3+vbwmaQ5YuEu8uOGAF01lxUbrWkPE55w5KAVmRA9u8YUX+7I42mkE5VvJ7CliXtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3pIuyuf+OSiiio8JmFS3qK423Vgyh5p8KvCpfe2JDDI=;
	b=puo6LZZkfHjixTmA+WqK1trNH6StcbovrIdDX4bEqUKfjyqgbW6HKdhb1xuKL+pdy6ry
	 ZiWZPBlrSIePYhOT7jaL/PcDYcVEAZoFHDOKUttIGSBfI1/C4RbuDZB1LyRzNETsKKstL
	 PZpe2sVS+3bUVIBSS4KJfXlVfWRnEvuTfl3EV8ELx50QZoGUqEydlbgknnEgkspMy/bZC
	 I07u9VQQFwYU3wLyewV3vW949D8v01Ekri5wCoYE1yG4HSycywSk1VgQdVuKvHRyJ+y2w
	 ezXZ9TCFrfivy+fN8foX33zTX5TXt5BdC+G43Vj/BAKpR6CuuWSrtskFKNcJUbx+BOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kk4cv9hO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DF8606A31C;
	Wed, 28 Oct 2026 18:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kk4cv9hO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A8C1F01825;
	Wed, 28 Oct 2026 18:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213651;
	bh=3pIuyuf+OSiiio8JmFS3qK423Vgyh5p8KvCpfe2JDDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kk4cv9hOkzph9Vbt+BG//uGqvxPghLo+a9v37q+NeUywbEmzzxsDWY+Yb+s/MW0gV
	 3KpUz6sCZWP+QRrlh7D9At8kyoAmWPB+6iz5NKIbwpKtbKkCzqO8m+VSKHkVSTsb5t
	 E4IZ7Sp3pv2epSE0yarGg7KTbh+mIyM5zLlorKMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0537/1887] drm/vc4: Fix firmware reference leak in vc4_drm_bind()
Date: Wed, 28 Oct 2026 17:43:53 +0100
Message-ID: <20261028170511.568623674@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit b816da5d5df1461446a0a5f3fe2b4948a659a790 ]

The firmware reference obtained via rpi_firmware_get() is leaked when
aperture_remove_all_conflicting_devices() fails, as the error label
returns without putting it. This happens before the firmware is
consumed and put further down in the function.

Put the firmware reference before jumping to err.

Fixes: c406ad5e4a85 ("drm/vc4: Notify the firmware when DRM is in charge")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260916154015.2056797-1-vulab@iscas.ac.cn
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
[ sashal: Adapted to drm_aperture_remove_framebuffers() and its direct-return error path. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index b6384a5dfdbc1..ec5eca21df44e 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -352,8 +352,11 @@ static int vc4_drm_bind(struct device *dev)
 	}
 
 	ret = drm_aperture_remove_framebuffers(driver);
-	if (ret)
+	if (ret) {
+		if (firmware)
+			rpi_firmware_put(firmware);
 		return ret;
+	}
 
 	if (firmware) {
 		ret = rpi_firmware_property(firmware,
-- 
2.53.0



