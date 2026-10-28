Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215442;
	b=2KAHseqBbJrArsdwoHFQ/HtCYiyFCvKawuk4odu9IVXHARqzfhuUOoEoOKGCuU7HnIal
	 W3ESrBWsRs8FcJfYbDFT/yBvT5Os7Mx/NFjz496wIpt4gwZj1bQB4xZc5w8r3FOOnxNSu
	 Nv2w3QG4b1QHPaAeeTw7XPfNjk86kBCErSTxAihjR41uECggTLWawNavEgC2ZTOT8XwE/
	 coC/GTaHUiWIydvjo/cr/aHupMAxePHJlObKwOhJ4tp1u4hkMzC8vEbL0giuOvdKgI6VT
	 BcLvZBaZ0lc4NnlUE+OCeK7rMEOXCUu0x0gJgfZ9EHJMZS8WvovYds9ssTcgAKyW+8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UaS44F3wh5Va78m/q7aeFu27Xn7ipbVwGGlvWFS3JWE=;
	b=PBbR3Rk6Qw4Gi/+khlS9tkj0n1Y+cqfJQX3xSxR7/ZlRFKF5jL5hZTeOHdttALBNJQAR
	 FpFyn+hhU3gumNsLKhud4ls9nRlyqlAJLrsImSI2NtONCLOfN3tbApLSGrL8z9F0yU/1w
	 sPUsmGa+Vnmc8DbXvXwwbgubNV1AOoNNSF4BbUSwTBlWhhKn8WyWc9rq6CLfBl48dpApg
	 kuE2CRnJJSbAzPlaTLd08ZJghnsMb+NRiDhI0GHRoA4Lm0gaH9ZIgnCLc+e3cpKdf+9tD
	 1tB9rPGHREBhNDv5w0YwkYM3cXbdNX4H+sjmfBqhP/e6OFgccyiQ5CsPaOJMjyw7XTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MesvlOWZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AB4606A31A;
	Wed, 28 Oct 2026 19:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MesvlOWZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6991F01825;
	Wed, 28 Oct 2026 19:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215442;
	bh=UaS44F3wh5Va78m/q7aeFu27Xn7ipbVwGGlvWFS3JWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MesvlOWZhQOhuVMw8r7MRrsn+pVK8Wj4Rh8cmOQMLfz0mnNlLGszn4NrvrsnKvKnq
	 pqASFX2aiwr0Ot/I12I7IOmDIzei6q1Mvy8O62RCOmzHb1GmXKYQMVWlw2qqhbb877
	 1wjtBCePj2gKXJnIY84x+Kk7p8my0gTx0/PbqVyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1211/1887] platform/x86: dell-laptop: fix missing cleanups in init error path
Date: Wed, 28 Oct 2026 17:55:07 +0100
Message-ID: <20261028170526.967367560@linuxfoundation.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 6e9cab2247e5b243ae2d907ce7c948a8a9c8d61a ]

dell_init() initializes several resources after dell_setup_rfkill(),
including the optional touchpad LED, keyboard backlight LED, battery
hook, debugfs directory and dell-laptop notifier.

If a later LED or backlight registration fails, the error path only
tears down the battery hook and rfkill resources. This leaves the
notifier, debugfs directory, keyboard backlight LED and optional
touchpad LED registered after dell_init() returns an error.

Add the missing cleanup calls before tearing down rfkill.

Fixes: 9c656b07997f ("platform/x86: dell-*: Call new led hw_changed API on kbd brightness change")
Fixes: 037accfa14b2 ("dell-laptop: Add debugfs support")
Fixes: 2d8b90be4f1c ("dell-laptop: support Synaptics/Alps touchpad led")
Fixes: 6cff8d60aa0a ("platform: x86: dell-laptop: Add support for keyboard backlight")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20260609081419.1995169-1-lihaoxiang@isrc.iscas.ac.cn
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-laptop.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/platform/x86/dell/dell-laptop.c b/drivers/platform/x86/dell/dell-laptop.c
index 14772ba16f75f..5288f080dd144 100644
--- a/drivers/platform/x86/dell/dell-laptop.c
+++ b/drivers/platform/x86/dell/dell-laptop.c
@@ -2264,6 +2264,11 @@ static int __init dell_init(void)
 	if (micmute_led_registered)
 		led_classdev_unregister(&micmute_led_cdev);
 fail_led:
+	dell_laptop_unregister_notifier(&dell_laptop_notifier);
+	debugfs_remove_recursive(dell_laptop_dir);
+	kbd_led_exit();
+	if (quirks && quirks->touchpad_led)
+		touchpad_led_exit();
 	dell_cleanup_rfkill();
 fail_rfkill:
 	platform_device_del(platform_device);
-- 
2.53.0



