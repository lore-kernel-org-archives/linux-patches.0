Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032602;
	b=QIAEhzrE2spc+D/btGnpvX1rF2Q3nkYmtLeuoH4ioDRN91yOtB/dwzcx029+fMbbO3mn
	 HPro7x0PIJbveSh8Th8tneCwNETJJK0GZja2nsDcWjvPwBSrG1W7XlE8uy7wv84Tvm4xH
	 Yh0qjo68eSKn5LuH0zgrZ7P7W9FJyL0wDv2ECuoYDpjlP9Ke0+QfPLaT7wDjCU5P/xBrV
	 Fmxx9y0a703EDO7OB4k1Z3Pat0Gd7oUJdB688f4uZmjrg6eCq8fZh11ouohKWlznRPHb3
	 ZdnaLopPnXrkeH9mUfwMSLpLayvZN3wtBv7mAYJ1W2fdxF3NQBRketWvhbeX8IYsk3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NJslvF3VekH3T2vggYNmvNKTd5kdTxfT5n+NfX2u7mQ=;
	b=eq6tJzGbErhG/eV/oDUAN3L3ZuGrcAKyLn+VvOLoc0cA2YKMXBfiX3jyP+uLGejJffK/
	 3cqPsbYogv9aE3zMVhC50b/utQmbDueRoWeV+Czp8q3NZHpK2d7vXPLZNGZ+gBQYBg7ZM
	 uVBxeERzMOByYnudcxAUKA9iz2xc20wv6Ggrxdm2a6ZIl+gFwL4ex2Cr3nX4bSW+nE8Yd
	 efl3WfYjixu3ZgTuAjvproCkgsG0bw0DXy05AmoXERjZQSYQP6CBzH/4ns6bFiu+H9lwc
	 f4Tw9DfzKTBpqLG88vjKnjFZkMELR7KeCQdO/kUi2FZgkCTQKatIYdQ0f8SOEtXFd9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A0ZWTXZw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0230160A260F;
	Wed, 18 Nov 2026 20:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A0ZWTXZw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BE31F000C5;
	Wed, 18 Nov 2026 20:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032601;
	bh=NJslvF3VekH3T2vggYNmvNKTd5kdTxfT5n+NfX2u7mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A0ZWTXZwyr5tJb4YXW3istlfNxQeU0MClMT3cO66pKbd2Gme+1ZPpwkvTnv+0UiwR
	 j5b4q7W1KONTxlAWFgU8k12ygnAWU8/zM5qekxVSVQk2G+k0UDtCO4NTt3R/VFufNy
	 wxCwriiqWGCbYFCBtgl+2qJ7LF3Eic1f/nF+C0g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1414/1756] ALSA: jack: Pin the module while debugfs files are open
Date: Wed, 18 Nov 2026 15:59:01 +0100
Message-ID: <20261118150105.488321565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b6f5dcbae8b0e..8e42a009cb24e 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -307,6 +307,7 @@ static ssize_t jack_type_read(struct file *file,
 }
 
 static const struct file_operations jack_type_fops = {
+	.owner	=	THIS_MODULE,
 	.open	=	simple_open,
 	.read	=	jack_type_read,
 	.llseek	=	default_llseek,
@@ -314,6 +315,7 @@ static const struct file_operations jack_type_fops = {
 #endif
 
 static const struct file_operations sw_inject_enable_fops = {
+	.owner	=	THIS_MODULE,
 	.open	=	simple_open,
 	.read	=	sw_inject_enable_read,
 	.write	=	sw_inject_enable_write,
@@ -321,24 +323,28 @@ static const struct file_operations sw_inject_enable_fops = {
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



