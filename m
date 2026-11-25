Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620260;
	b=RJjBV4zy0AJSBWqzIrwbU56223qQCXwoUfsFS9SXH42lMoXzV/e+ykaUuHA3ULSPTTiN
	 haOOcgaQr8Nl/xEY10qrhvzWQUjo6kBy9QO2Vlu/ipJL3ypjXkxfbfvFaksBE+Gw5M0QZ
	 8QPDXEaK77D4Cgg9tXf+k/1VRnpNeBjQyVMdaHpnO3lMeZhGhbPhrNwaVPzHlqzmThNL7
	 NJEsSi2u/zA270LvN/aYV4umpfjjmGTdVHUI8RyWOFfgeQUtJliPahOTVnphsacyxgpbY
	 NixArAljoiZOoO/yySnexaeStoPDAI7n4jN8jDJvpUp7iREu9BmPV7LTE4WcwAR7i7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3xtn19WLmJAiK8GuxIhdGGQw4BG/JH7Vry9wrkSIxF8=;
	b=km2DkUfMSXL3CEoJhGUre+xIZuGZeIfgK/GcNloOljAudvBXbqloos1xvB/EGDqJpQzB
	 HgLShc3h3o7TPDmUmVF1rbqBti8WddqlHuW6ZXH34/A+P5tDivTd1jDtj0dndbPSMkqCX
	 A1SSxOL5ZZezeaErfZEH42emzVKOzCYFs23rwXxg512NXeFF32ioFIbxqZ6YXjyVSR2Mp
	 Z5uMp6h0j5ohrXh2ps5PEmggBpZlxcaBcd3GQ1QzHpADgzzb4DmKtkyu52DqZ1sXKLrne
	 1PqfFRciRXBWqftvAHnvpOk/9A6Wyy3hOVt8PVnTd7xoN+ythZ5MCnuQk2+4iZ+9vYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jm461UMT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757AF606A31E;
	Wed, 25 Nov 2026 15:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jm461UMT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED861F000CA;
	Wed, 25 Nov 2026 15:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620260;
	bh=3xtn19WLmJAiK8GuxIhdGGQw4BG/JH7Vry9wrkSIxF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jm461UMTWbN6bo5cuOxZWTu+4oGNP1hGqi9k4TwHa5aWQvXBFPidX7Iy4UvsNTDJf
	 JlDTj9JbmAmB4XdSMXXFoFKhblMZzraZG44wWM28oRwXvb9JX2EHyU2rlRJC3Ng3Ko
	 VOrj4PLgF8htJihWxFwbinwxN7uTXikOJLmXcMTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4b232570d625662eaab4@syzkaller.appspotmail.com,
	Zhao Feng <zhaofeng2@cmss.chinamobile.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0860/1005] dm crypt: fix use of uninitialized percpu_counter in ctr error path
Date: Wed, 25 Nov 2026 15:36:38 +0100
Message-ID: <20261125143841.855829548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Zhao Feng <zhaofeng2@cmss.chinamobile.com>

commit 8ba1ade3e6b595b9091040feaa3341d7e45ba95d upstream.

If percpu_counter_init() fails in crypt_ctr() (e.g. when the
underlying percpu allocation fails under memory pressure or fault
injection), the error path jumps to "bad", which calls
crypt_dtr().  crypt_dtr() then evaluates
WARN_ON(percpu_counter_sum(&cc->n_allocated_pages) != 0) and calls
percpu_counter_destroy() on a counter that was never initialized,
because __percpu_counter_init_many() returns -ENOMEM before
calling raw_spin_lock_init() on fbc->lock.

With lockdep enabled this triggers "INFO: trying to register
non-static key" in __percpu_counter_sum(), as reported by syzbot.
The console additionally shows "crypt: Unknown error (-ENOMEM)"
because this failure path sets no ti->error.

Move percpu_counter_init() to right after the allocation of cc,
before ti->private is set and before any "goto bad" can happen.
On failure, set ti->error and free cc directly, so that
crypt_dtr() is only ever called with an initialized counter.

Reported-by: syzbot+4b232570d625662eaab4@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=4b232570d625662eaab4
Fixes: 5059353df86e ("dm crypt: limit the number of allocated pages")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Feng <zhaofeng2@cmss.chinamobile.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3208,6 +3208,14 @@ static int crypt_ctr(struct dm_target *t
 		ti->error = "Cannot allocate encryption context";
 		return -ENOMEM;
 	}
+
+	ret = percpu_counter_init(&cc->n_allocated_pages, 0, GFP_KERNEL);
+	if (ret < 0) {
+		ti->error = "Cannot initialize page counter";
+		kfree_sensitive(cc);
+		return ret;
+	}
+
 	cc->key_size = key_size;
 	cc->sector_size = (1 << SECTOR_SHIFT);
 	cc->sector_shift = 0;
@@ -3219,10 +3227,6 @@ static int crypt_ctr(struct dm_target *t
 	crypt_calculate_pages_per_client();
 	spin_unlock(&dm_crypt_clients_lock);
 
-	ret = percpu_counter_init(&cc->n_allocated_pages, 0, GFP_KERNEL);
-	if (ret < 0)
-		goto bad;
-
 	/* Optional parameters need to be read before cipher constructor */
 	if (argc > 5) {
 		ret = crypt_ctr_optional(ti, argc - 5, &argv[5]);


