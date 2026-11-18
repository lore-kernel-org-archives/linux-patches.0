Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021046;
	b=GiYxzgQXfsgQjyWFe++qsry2SF5AFeRQz9WOPoJV3gKml6tZMshS8pXOv5CfbKsYeCKl
	 kglTpNfVyp6E/VA1yICrStKiWUCbgs9OHPBxPfCyCyvS4kUcuoXjuGuqrexpAv9sSNFwc
	 vVO5jNQcqRDkIe5ifEguPndARUqOdKltNp7hZ8qoCxJDKUvZVX5PC0j0KqREByQKvbzVq
	 +h329LMPrL1scOuv+yvZGPQlducwnBdh/rnN5jTlZuwznPWH+ly+Zx1Ao87LlF6d13Tac
	 /tTzhe0f9NPxEs7xkHXsXCgs8GO3M34ItDFA/HLIEcf0pz3XGjzh0fcMONg5SfbXMmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EpiVe+TB2BBjGTiUM3sfqIelm+3YOXx0dZCEYv0Dpnk=;
	b=R2lbeKvvIx7Fadjh00yuHKcWQTFjZfTkrvrEKnS2+Sti79ZY/cQvMANcY041Se7Hmkgi
	 2tiFh2CQwkh+3GISa/xTzPkVcN8dA2J94RvC5LdK2Tn5S9UDhR7GSy+1Q/uMXWHeVvgvG
	 +JARazsRlcU6aun0EjI/XHSFcOYlhX0VYb6XNWYT7egA10P8ttGNHixXXTtMKRefVyFl0
	 eB+Cm13R1IppBVt6QGR46CdrvK8o+vpDEGsWBKujFClgxsMtCdwGn1VdHd17QZcWsZYex
	 OvKiqkwj/5aQ0uJrvl2Fb5FiqMa3QTHI4KcFOva/elwKQgX7IMmf6Y3HeEQVhdhM1NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w9JTKl+o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C18F606A33A;
	Wed, 18 Nov 2026 16:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w9JTKl+o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC221F000CA;
	Wed, 18 Nov 2026 16:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021046;
	bh=EpiVe+TB2BBjGTiUM3sfqIelm+3YOXx0dZCEYv0Dpnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w9JTKl+okGs+Ow/ld81iYSLcCj4N72u0M3JaMmQsZrQXm6wbsCHdoXMlIdT+TSMtj
	 cbVFKl+fXV2/Cwp2+dU8dI/Ba96GA76NToIPUjxEXxPyOGu2fi1lkxQX0rqjES/tSs
	 hldNp737a5T4y7l8gsjXHkMoCEleWwzVRUZZ4M1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2168/2651] ALSA: pcmtest: Pin the module while pattern files are open
Date: Wed, 18 Nov 2026 15:56:48 +0100
Message-ID: <20261118150403.866144070@linuxfoundation.org>
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
index b4e333b4c4381..c5b24c05b3562 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -638,6 +638,7 @@ static ssize_t pattern_read(struct file *file, char __user *u_buff, size_t len,
 }
 
 static const struct file_operations fill_pattern_fops = {
+	.owner = THIS_MODULE,
 	.read = pattern_read,
 	.write = pattern_write,
 };
-- 
2.53.0



