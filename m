Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021057;
	b=2+ycAr8PiyDDp5671Ayv2bC4fiORTh5UqInhJeq5X2TE3crUYWCEQGS/dPigwE0W8suG
	 NVD6HfwTXc4+HlqoN2201He32VdNdHmQSAf8CDRHSFXFo60oyr20GBNQ8CZgVuKA2Zd5N
	 0UPmqqAS1qJsGHz0sNHXpBN39xhYN99i8916iVOddLtau+05KETY0LYNEJt/VNgEE/WHU
	 tyF5xGDlM68PpDYSsxzEdOyugI44xI8qrmR+F9PLstpFq4PJXt2nZbLeJyIQuYN6FiQEz
	 trMXeVWzklVDxzzDPswJ/VWocWpq1hdTudDw3mzNeNNBoJV2ymRgxR58zGgXHN9EqQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IcZVSdPP6g2CFAsxcPeS4psdeeEaRdmB+kCX3sZWTFw=;
	b=sVXMYQ6ViH7Yf5L/FYLyK3M2LkjL3PLypMrig+kMM0cEnDphxVBYCljWnJ/HrUqI4kfe
	 VXQCyMiM1fghXuLwpS0dFtToMQiABvgMC/U0fJi6YxoLGsFPcGWKRacf2N0Nv4RoAEyD5
	 Nw4zlDJ3Z1qER4xssn7o1dwXqwuk5FiYExx1FIYy9YMT5N3IB4ITRzUiztFAlY/dJzKUZ
	 K0dyhkDHN3ZlIX9fVmDR5TIWyo88Q2QRcpAr1q5pLR28Sf5FTVszHvW1Jvbe3L26XXJle
	 yTbbMHujlT1lKQRmVaoK4+z4OYIKO4FfloFeWKMA0I/Nxb0003whQ8QIBeRWKO9vKwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mbvKRe0P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4F0606A31C;
	Wed, 18 Nov 2026 16:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mbvKRe0P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCB61F000C5;
	Wed, 18 Nov 2026 16:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021057;
	bh=IcZVSdPP6g2CFAsxcPeS4psdeeEaRdmB+kCX3sZWTFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mbvKRe0PS4r2pnC7YFrc5Yv0AaqpPwBFrsA8vI4+Ph0kAOuI839xTZ01q9i5E3aBk
	 Ol2cF9ZwDZvH0O0t+j7w6MGT0f//D9l6p22ea5rSjO1KVBOAFitivaVev/9Gxe42S7
	 Q0o4CBil659Rqly2kpDIoUTo2jFdOgbkBFKoPx4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2171/2651] ALSA: jack: Pin the module while debugfs files are open
Date: Wed, 18 Nov 2026 15:56:51 +0100
Message-ID: <20261118150403.967243437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 8b479b265301e97bfbec0ef25de1c1f7eb4d2f74 ]

With CONFIG_SND=m and CONFIG_SND_JACK_INJECTION_DEBUG enabled, an in-tree
HDA jack creates these debugfs files through snd_jack_new() and
snd_jack_add_debugfs(). Their file_operations live in snd, but none sets
.owner. full_proxy_open_regular() therefore takes no snd module reference
when it calls fops_get(real_fops).

A debugfs descriptor can outlive removal of its HDA card. Once the card
and dependent modules, including the OSS emulation modules, have been
removed, snd can be unloaded while that descriptor is still open:

  Descriptor holder                   Card/module teardown
  -----------------                   --------------------
  open jack debugfs file
    full_proxy_open_regular()
      fops_get(real_fops)
        owner == NULL: no snd pin
  keep descriptor open
                                      remove HDA card
                                        snd_card_disconnect()
                                          snd_jack_dev_disconnect()
                                          remove debugfs nodes
                                        snd_jack_dev_free()
                                      unload dependent modules
                                      rmmod snd
                                        alsa_sound_exit()
                                        free_module(): unmap snd
  close descriptor
    full_proxy_release()
      read real_fops->release
      fops_put(real_fops)
        read real_fops->owner

debugfs_remove() drains active operations, but does not wait for idle
open descriptors. Release deliberately bypasses removal protection and
reads the real table even when no release callback is installed. The
last close can therefore access unloaded snd storage.

Set .owner to THIS_MODULE in all six tables. The existing proxy
fops_get()/fops_put() pair then keeps snd loaded through the final table
access on close.

Fixes: 2d670ea2bd53 ("ALSA: jack: implement software jack injection via debugfs")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/pm-pmb-431ddb947e1a13b95d3a-v3-02d37dd7b4eb4774e100@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/jack.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/core/jack.c b/sound/core/jack.c
index d9132b885ea3c..b14db9fe864fd 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -306,6 +306,7 @@ static ssize_t jack_type_read(struct file *file,
 }
 
 static const struct file_operations jack_type_fops = {
+	.owner	=	THIS_MODULE,
 	.open	=	simple_open,
 	.read	=	jack_type_read,
 	.llseek	=	default_llseek,
@@ -313,6 +314,7 @@ static const struct file_operations jack_type_fops = {
 #endif
 
 static const struct file_operations sw_inject_enable_fops = {
+	.owner	=	THIS_MODULE,
 	.open	=	simple_open,
 	.read	=	sw_inject_enable_read,
 	.write	=	sw_inject_enable_write,
@@ -320,24 +322,28 @@ static const struct file_operations sw_inject_enable_fops = {
 };
 
 static const struct file_operations jackin_inject_fops = {
+	.owner	=	THIS_MODULE,
 	.open	=	simple_open,
 	.write	=	jackin_inject_write,
 	.llseek	=	default_llseek,
 };
 
 static const struct file_operations jack_kctl_id_fops = {
+	.owner	=	THIS_MODULE,
 	.open	=	simple_open,
 	.read	=	jack_kctl_id_read,
 	.llseek	=	default_llseek,
 };
 
 static const struct file_operations jack_kctl_mask_bits_fops = {
+	.owner	=	THIS_MODULE,
 	.open	=	simple_open,
 	.read	=	jack_kctl_mask_bits_read,
 	.llseek	=	default_llseek,
 };
 
 static const struct file_operations jack_kctl_status_fops = {
+	.owner	=	THIS_MODULE,
 	.open	=	simple_open,
 	.read	=	jack_kctl_status_read,
 	.llseek	=	default_llseek,
-- 
2.53.0



