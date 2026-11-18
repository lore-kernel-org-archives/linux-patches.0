Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042096;
	b=OS62xXRphnw9TxhP9uN+eUtygcaqORi9NGOO/3Bgg6VdgO5fyGT8L8TdW7N67ZXFNeKk
	 j9iqqW7q8ohO1jLO0+mYQyNQ9EstG9m+SxBX0i90MzvOtmJHoO9Z95s4BEk3sBWr3IW9B
	 QeUYHpB9S7nlJUdQLvxW+R+lr+AGZWJbZg64n5i8NMpBaQitLNK+hf6KWfuapTuVTuMze
	 XxQwPtdC8Jigf3Vl975vlFfiGqVGz/MUTuiVVXgQuGNZFns9VrNQWCaoHLBPFst8qNVFn
	 EOwl/HdG9K0KS4NVKFIrTQ6Eas+AH4hKlh0t4tzMHBNWeqQLa/p6Og9ZNKmrs7m/Gsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pwgR+bPa49jvpjwD2HnKQzWymAi0BGllqvrc4vpBGDY=;
	b=EwoIfehc5sDdy7f5XBLpwKe33SMu+pVcHRG1Kh0PHacQY1do2pA4CYkRtQOnvlAMTvOL
	 IS3AKWsusRtE/ulgXQktRGbK70r5QyNbSzJBZqPgm+I6xu0YKr7Jzs83i+/cDI7ipDAwu
	 WRkbsjCLRxQFL+WZbn4G9tlCjVgoObt2dzWoyMQYTR/x5N4OQt9w2d+qwP+5WZsqfpajl
	 Rkgw95bT4nEhOBtUowrfhvvbWQtv7gi7oJIY4UKthxCZM2FxQLUjKPazerGgjKwQ/Wujc
	 QQwHtqI0emeXP9fp0w3nBbCOhT3In80H+SYDkGMKHo0RoFV7/hxAtYdk6qwVmemdtyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b6J6VPDk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590A8606A31C;
	Wed, 18 Nov 2026 22:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b6J6VPDk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95781F000C4;
	Wed, 18 Nov 2026 22:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042096;
	bh=pwgR+bPa49jvpjwD2HnKQzWymAi0BGllqvrc4vpBGDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b6J6VPDkt+fTKe6ytBxFm8fBeVPWnTzkrpqxZW7wM56QuHh/Nhx3aNe6g1ujzZG7F
	 BN7wyIcr2Qk/vjXD3YdzNjxib+q5D9NRQnljwdNKgH05gTEcezdOkmZNNWJ/pzRqUx
	 iqjdUB8C9XkuVcgdBpqjM8iY76x5Ce1tiPZrEdTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3048/3318] ALSA: pcmtest: Pin the module while pattern files are open
Date: Wed, 18 Nov 2026 16:01:10 +0100
Message-ID: <20261118150451.594499732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 069003afab42b5a9394faa6985a3d76bd4700e72 ]

The fill_pattern_fops table must remain alive until the final release
of each pattern debugfs file. It has no .owner, so the fops_get() call
in full_proxy_open_regular() does not take a PCMTest module reference.

With snd-pcmtest loaded as a module, a user with permission to open a
fill_patternN file and unload the module can retain the descriptor
across normal unload, provided no PCM file or other module reference
prevents it. The following ordering is possible:

  Pattern file user                   Module unload
  -----------------                   -------------
  open(fill_patternN)
    full_proxy_open_regular()
      fops_get(fill_pattern_fops)
        owner == NULL: no module pin
  keep the descriptor open
                                      mod_exit()
                                        clear_debug_files()
                                          debugfs_remove_recursive()
                                          drain active operations
                                      return from mod_exit()
                                      free_module()
                                        free the module image
  close(fd)
    full_proxy_release()
      read real_fops->release -> UAF
      fops_put(real_fops)
        read real_fops->owner
      access freed module memory

Even though the table has no release callback, reading those fields
is a use-after-free and can fault. The retained dentry keeps the
proxy's bookkeeping alive, but does not retain the module storage.

Set .owner to THIS_MODULE so the existing fops_get()/fops_put() pair
pins PCMTest until final release has finished accessing the table.
Normal module unload is then blocked while any pattern file is open.

Fixes: 315a3d57c64c ("ALSA: Implement the new Virtual PCM Test Driver")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Assisted-by: LLM
Link: https://patch.msgid.link/pm-pmb-1ce354e709dbab28e563-v2-6b2ea0aa16ec39442f6d@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/pcmtest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/drivers/pcmtest.c b/sound/drivers/pcmtest.c
index 0de45d6e3a777..c9a32e45603b2 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -682,6 +682,7 @@ static ssize_t pattern_read(struct file *file, char __user *u_buff, size_t len,
 }
 
 static const struct file_operations fill_pattern_fops = {
+	.owner = THIS_MODULE,
 	.read = pattern_read,
 	.write = pattern_write,
 };
-- 
2.53.0



