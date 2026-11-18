Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032443;
	b=iiry7+Myrv5/shFZk2QJNW7nqRu1PLtZx+YGH6HNuHrCmm91bPdT87pObVhLpGwcMt29
	 RPnv7glSKZ9UFQ7IJpQKpclan4JXAwPDSEOMwld2i7TO9C6oavgTIxPdfgjQ+zzJNSQfA
	 OXe0QYBD6eukTQ7Xlo/RrjGpGyLAtEAjHyzFBvc8qFnpxm6Ix49QAWYUeJSCS4G5sWOic
	 QpwvkVn7QhOZGAY1gsJVsUa9oJmhWc9o2IvrjmROqCakqH4R/FjRb2Lx6FVSbtOB7fXHh
	 p8MnA2v1oY+Xl3tnm3AH6qfui7UwxHFqLfW6IBw9mkvhRF1PbVtBwsaa4fjSug+zlBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/tPn/gf4y3ltIamEou/rxBBWEhNJBO1IWgokaAhba2k=;
	b=sZ+o1t1hfhEbBt9diPJdoYnujebDBwpxdgCYYf9ovBsP5v1bZY4/Wvb+G5CaPe1Eu9NQ
	 tpqNXD6sfUJ77vl3vFBv+dmZk/u7cUchrW1h8HF2vzKW+r+AkDlv1aN7irjpRxFZpWd3B
	 4NAxZ2c9+UuiHGOloDnMPumKbfevH+opOx1lmUL+H3GJUvuQOIKerC4ZAdBAE+HqRDqEI
	 kqp9GZhLPcEAWujNH1HgP6hWPpbpDUbTesZoFsc1qEGrdwm7YWxdVmZGuDZ+Ct5tXXoQx
	 OKCz0rCG0KBSVv2DWI3I/k0+nQQ9rtitaQBsnJ1ZScVFBMdQiynMizU7dpgZaG4fMUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZJ4PO4Kz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4731A606A33F;
	Wed, 18 Nov 2026 20:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZJ4PO4Kz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C1E1F000C7;
	Wed, 18 Nov 2026 20:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032442;
	bh=/tPn/gf4y3ltIamEou/rxBBWEhNJBO1IWgokaAhba2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZJ4PO4KzVlyzu51aR4DqIi6OqlbsbnJTlWq+0y7NPPDqSVuKR5RY/Zm1DFkijH3pH
	 kotNYchXQzR7b/9qOnH+faNLJ3117LjGmtVbFN+QcOQJrgyFw23P0CodYcXEpDt6ZB
	 fSQuSywBuVD5DpZXOempwVWTQ6dwziF3WGS+PvvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1412/1756] ALSA: pcmtest: Pin the module while pattern files are open
Date: Wed, 18 Nov 2026 15:58:59 +0100
Message-ID: <20261118150105.416052653@linuxfoundation.org>
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
index 4a53dd84b19af..25f21255b0651 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -683,6 +683,7 @@ static ssize_t pattern_read(struct file *file, char __user *u_buff, size_t len,
 }
 
 static const struct file_operations fill_pattern_fops = {
+	.owner = THIS_MODULE,
 	.read = pattern_read,
 	.write = pattern_write,
 };
-- 
2.53.0



