Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B9D3B19DB;
	Mon, 23 Mar 2026 14:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274565; cv=none; b=SLRn+4GRqimgViz71gGvCB8kNIGeWydZeYBO7PB9TomtGi1/MZDIcscsf0eedkAWQD3ctnG0TcGpGq2++uVWbxXKDmbPSJ1fZZdNhKsNWgwfR3jNSoyc3D2q0m7iWqBlaP3U4ajdJi2IhkRrHCwuY4LZF1PHEVzCaKw87bqO+hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274565; c=relaxed/simple;
	bh=D5ngVfY5jwPC5BuZMz92mGz4DluZljGMbwOM4+kd1wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dc8WcgADKfrJPAXlsrtstjDyruoMbduO+uSUE3C/wB4/XI6fCbINB6tGnjjddg/MirJWoYPZgKkYlP6O90n0n5lmFZI8YtY4OeKniVjBDGOOclD3ZmB7Dp7pyAJZZwdszow0h2wzIcGPvGuWCUCNuL9NlvlmIZSlljTrRN4800w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJDyIbGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJDyIbGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9937C2BCB1;
	Mon, 23 Mar 2026 14:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274565;
	bh=D5ngVfY5jwPC5BuZMz92mGz4DluZljGMbwOM4+kd1wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJDyIbGDtd0AC8V9vgZW544o5zHlPZL3nzy+ga6trn4/XO/8/x227ozX3VjGbhbVE
	 Tbdhg1gyIQaQ5F8MOJ99acEL7zhZw12rtkJf6WLKYzaUT1hcLEYCuoSGMKb75FC6Cj
	 OALaw/zbgswZhYyXYX59RWPIsETYCa0Sk6OjXl6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Baoquan He <bhe@redhat.com>,
	Coiby Xu <coxu@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 008/212] crash_dump: dont log dm-crypt key bytes in read_key_from_user_keying
Date: Mon, 23 Mar 2026 14:43:49 +0100
Message-ID: <20260323134504.033549175@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 36f46b0e36892eba08978eef7502ff3c94ddba77 upstream.

When debug logging is enabled, read_key_from_user_keying() logs the first
8 bytes of the key payload and partially exposes the dm-crypt key.  Stop
logging any key bytes.

Link: https://lkml.kernel.org/r/20260227230008.858641-2-thorsten.blum@linux.dev
Fixes: 479e58549b0f ("crash_dump: store dm crypt keys in kdump reserved memory")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/crash_dump_dm_crypt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/crash_dump_dm_crypt.c b/kernel/crash_dump_dm_crypt.c
index 1f4067fbdb94..a20d4097744a 100644
--- a/kernel/crash_dump_dm_crypt.c
+++ b/kernel/crash_dump_dm_crypt.c
@@ -168,8 +168,8 @@ static int read_key_from_user_keying(struct dm_crypt_key *dm_key)
 
 	memcpy(dm_key->data, ukp->data, ukp->datalen);
 	dm_key->key_size = ukp->datalen;
-	kexec_dprintk("Get dm crypt key (size=%u) %s: %8ph\n", dm_key->key_size,
-		      dm_key->key_desc, dm_key->data);
+	kexec_dprintk("Get dm crypt key (size=%u) %s\n", dm_key->key_size,
+		      dm_key->key_desc);
 
 out:
 	up_read(&key->sem);
-- 
2.53.0



