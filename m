Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027548;
	b=DJo5G2WsKwPukLSXQkg1wOtyP9On5LKlRTUHCweLSIie0NShq4IQXsEkr9SXcWheIE2N
	 ySLBR09+fg+XRLxRFqnCzzVETwMcN9JKUNGyPSwxn16GKoDVak3CzwRJG0uujqrPp6F3W
	 jR3WTfzYuHHHk6P47/Di36ScKz7FKhRRIITuVRJLesOdU6MKxbvSwu3xAAkjMQKRCYzW/
	 0G18L3IG6HpD3jn2ZjcTEcSw7wkUkctxT+tKaE2oCAnXqHRvG7e60tWwxGys/iDoxGcrU
	 I3lm31Dxdlpw2ld5tZyDSpPnluzHleM5kBHZpkSl2SHW2ZmVWNxN6+QtnYY3Ax+0z8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ut1W5imKq9NsfM0B4phSRJFB61cYMWgtH3JnNF+FemU=;
	b=GnGR4Uj77XVfAb03jxC3CGufb3SdFQo6FagNXq68wkmL/BKiVJVlHZ7N7rfNzg0acQs8
	 UCiQ4j1bveS3LHU14VfYIGJmdSa6il0rLRJ+4HQcDgvJnPczG4ox2TRMtJt24i+g7Z65Y
	 b2VALvJKlNwCATROgIricMR9gcIwHGT/o/a3zrKbSOcid97li2FutzLcNaOMd1blPHstU
	 a+TMEoTa6RwrXJdNuRx0SPO1DuGGT84ZxYnMds4BvOUvKugd34sktQQb5HBaHCUcRGCss
	 rPc5iOsOAgFue0888Bmr351bkAOGgR6kiJ7xbS9VES9TNTmm7gQ9l6OIbj2lHcHXR2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SLwzXieS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320CE60A2609;
	Wed, 18 Nov 2026 18:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SLwzXieS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794951F000C6;
	Wed, 18 Nov 2026 18:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027548;
	bh=Ut1W5imKq9NsfM0B4phSRJFB61cYMWgtH3JnNF+FemU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SLwzXieS04p0dh73XUNJbHqGkIFg8JZh5fvgQ5nS1fXpdVhjdSWyysXjGZVcV1B6P
	 vuClc43tICCGTaL33QBSEPD/iIxpiJ3uGfg2Crqn54kvW4TblVJIsgGWSOzpmeH/A0
	 KNUKaPUiMKR99Jkin7iLn8QD1SZlRLN+TjS4yTZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1777/2151] ALSA: pcmtest: Pin the module while pattern files are open
Date: Wed, 18 Nov 2026 15:58:32 +0100
Message-ID: <20261118150226.558879235@linuxfoundation.org>
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
index 29fe119630153..651a79c3f5786 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -684,6 +684,7 @@ static ssize_t pattern_read(struct file *file, char __user *u_buff, size_t len,
 }
 
 static const struct file_operations fill_pattern_fops = {
+	.owner = THIS_MODULE,
 	.read = pattern_read,
 	.write = pattern_write,
 };
-- 
2.53.0



