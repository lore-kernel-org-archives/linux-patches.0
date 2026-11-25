Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620331;
	b=sMqyWMkJP/xB35zonHfZXHQg0xeXPtdNoHQNCi0TWDcIy4ymAOrnwr373XOOv60Cb5bH
	 22kMjDmQYJCIYBMjhHUuXvmJbkz5fbd4VgHsdNzot5jddKLYtq5Q093hVLC3Wug3DN+ZN
	 Uz0Yx4HJFSUSrGs3U2wUrK50SCQs4d92cydVqzw9Srj0wyXcFbC3l8FQHDW3vhm+bG499
	 rajbAaRuTb1HKhy1WilqFRwk1aqV/42HAhqieGpKrq/wgas8/WKEbx4MWKoAEfUpoSABX
	 KgE4O8aCW5+ocsCN6tE9UlpdzuGuRBmGAXdNS6f69S4HCTDioSRt3ZiFXgYMJ23wX7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620331;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FhoJTf9iHPngsjk/ITpRxcnUbCX8ez0IVobdDlSaK2I=;
	b=GfI2O3Zb8+ltu2PSbf1OD0OaNyVN955qGg2lUGKWi6vhlCqVw+CTCULp3SNfoksjYl57
	 ZiP5XJKPQ2ln2/erocotyjOEOT9i9zKE9fTuWpb6pdXgylqFxYsNQDU0zqH1M5Xr3WkrL
	 ZACtCEa51HuDexZc8GjUrOoL86bWx1hqaAVloOTycVUHMV8tYK05/oxFJuBsnr3WncDKc
	 Vk/lIa54huzqsaqJ2jyvyqbXqidGg1Awy5DGatvLxKN+wYBiV8yb/OtbDm+jHdr+dPGeB
	 6ugJm3g+dGncbikCMtL29wbWakxf0jERXfSAYr0mUV09PJ5yTzmD/c9QQHBHBfVNfBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F+nASFDk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28BC606A31E;
	Wed, 25 Nov 2026 15:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F+nASFDk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2651F000C6;
	Wed, 25 Nov 2026 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620331;
	bh=FhoJTf9iHPngsjk/ITpRxcnUbCX8ez0IVobdDlSaK2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+nASFDkdQRT9Q/eqqReq1FFT38TbfBBjZ9yrPt1Tnj8QrVU32xhBNCsToEa9qca3
	 0f8Vm0t9zROjqvsj31hcHdII8mxxTfFvI+f4tIEQdYk21/CH9q19i8L3vN1F7ZBBJo
	 r1cOqplGnYKHapJhNYO83HIFV62VR5fkt5h1n2BM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0880/1005] dm-integrity: dont attempt to commit journal on disabled device
Date: Wed, 25 Nov 2026 15:36:58 +0100
Message-ID: <20261125143842.317788755@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit e5e03918fbec31f0c896f4f43c2bd2aadf35d43d upstream.

If the device is disabled due to an error, we shouldn't attempt to flush
the journal. We jump straight to the label release_flush_bios, that will
call do_endio on all queued bios. do_endio will terminate the bios with
the error.

This fixes WARN_ON in the function pad_uncommitted reported by syzkaller.

Reported-by: syzbot+94dac3c75477e184f0b0@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=94dac3c75477e184f0b0
Fixes: 7eada909bfd7 ("dm: add integrity target")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2908,6 +2908,11 @@ static void integrity_commit(struct work
 
 	spin_lock_irq(&ic->endio_wait.lock);
 	flushes = bio_list_get(&ic->flush_bio_list);
+	if (unlikely(dm_integrity_failed(ic))) {
+		wake_up_locked(&ic->endio_wait);
+		spin_unlock_irq(&ic->endio_wait.lock);
+		goto release_flush_bios;
+	}
 	if (unlikely(ic->mode != 'J')) {
 		spin_unlock_irq(&ic->endio_wait.lock);
 		dm_integrity_flush_buffers(ic, true);
@@ -5429,7 +5434,6 @@ try_smaller_buffer:
 		r = create_journal(ic, &ti->error);
 		if (r)
 			goto bad;
-
 	}
 
 	if (ic->mode == 'B') {


