Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027456;
	b=l9cArOxSG+ZyJcjy+lMg5mIWXy6SuQpE34lj/C8uwQy/pcFli2+EfCPH0kw6s/rpfm1C
	 N1PRcbJ2ilFSgKFSUZiS7ITWyLf0p4NRdnL3kx0AxnbCf3N1tYVeAiCEIm/FFy+YB7jm6
	 sEL0wFlXIQbHrhpb2RpNeAp3GPTybFiFS4EcDpCd1zrBMoIW8rXHoS4DbC9uAepleOyox
	 HG1TN3+39llt1eH5rvUEv13T5kntajiPikvitLSKyJsn096L4LndgE51D6oxSM3gHAgZX
	 AiNbBwSaOujh/YafbQb7WnOdXFRn2ReHOkxEPdQbua0+GZatQcGemyzZJDpkf5j0N4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5IwnEmxYi5xxMEbIIuQMgniATd8etYc1NckeOKpvI2w=;
	b=NlQ9/r/I2ollkYcrZEaEI5sKFKaEbaki5EXYpTy+6+GwFh8Gsqq0ebi1BadyXh7huQao
	 G+rVpUa9wqUf8wcCoIOjmLB++M3qOTKOA5mWu4rzBJV82f0wxybC81/AyUB+jTNo4zxSi
	 XMPITgl2tEY2ncaRzeITwPQp33ViEcZp/6uFKB/xbG0WgfYlPuAFQHI0IX/Wjj9UQQsww
	 zZdbufFXei1V7/zsiMgDcRvc0WXT2fSQp0HvT7BdMh3N2KHO7rU3/jSQNXf4m59WaS8Xk
	 TBIg7kPf0GfSbTeAnTWDrKdIGfg5K09rGT0usVNuJD3f3YR1AjF4eForsyKRdB0n0YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r0LIcdxx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB3560A2616;
	Wed, 18 Nov 2026 18:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r0LIcdxx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7901F000C5;
	Wed, 18 Nov 2026 18:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027456;
	bh=5IwnEmxYi5xxMEbIIuQMgniATd8etYc1NckeOKpvI2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r0LIcdxxbsCmqf984z+vQVN9tjynhm6//fl7f8CHt/XGWIo/PCv1U0ia9m8nC8rBa
	 qdwxt77xaBd5UV5GpY5lVGxUyKFDuyBU5toHyEta/FFlCU18KeThAsHNcGCczw0ITP
	 ew2xouPQwJir64bkz/Wvh+dD9ouwvKYAbCZiuUh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1779/2151] ALSA: jack: Pin the module while debugfs files are open
Date: Wed, 18 Nov 2026 15:58:34 +0100
Message-ID: <20261118150226.631280345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9f1f61892d940..ddee40de720e8 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -309,6 +309,7 @@ static ssize_t jack_type_read(struct file *file,
 }
 
 static const struct file_operations jack_type_fops = {
+	.owner	=	THIS_MODULE,
 	.open	=	simple_open,
 	.read	=	jack_type_read,
 	.llseek	=	default_llseek,
@@ -316,6 +317,7 @@ static const struct file_operations jack_type_fops = {
 #endif
 
 static const struct file_operations sw_inject_enable_fops = {
+	.owner	=	THIS_MODULE,
 	.open	=	simple_open,
 	.read	=	sw_inject_enable_read,
 	.write	=	sw_inject_enable_write,
@@ -323,24 +325,28 @@ static const struct file_operations sw_inject_enable_fops = {
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



