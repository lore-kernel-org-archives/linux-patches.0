Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1193BB13D
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 04:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617624; cv=none; b=hl6suf7yQ88bE8c2SWcQEL2FgblVYmCj8X/sWAaU4Mg2Piy5n/k2NWRI/q/wM5qcz9nKfrTCp4CAlrZFWU6ecnJNCLwrIQN3m2DRHbDS+ZFRcotoUSsEC98GQF78CT+tgBz+Pb7H1Oyq82iDB0Cm6gO+T4nmLXQyGaPOfmVOdHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617624; c=relaxed/simple;
	bh=NndGd9GOf0I6NO8Ce3nP+s13O09BbawYzE6kgfvxPZY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wzj70/czaXfff7TLzoiht/QyXLl8WU9QHsDHEN0MQQTQgAPzDgIpI1KwepjWKqlDlMX3bB5SuW8M6nKRsF6GkRCqavr+7xI7klAUwXRCwlOAR8anab16SDS6YTGTA1MuSuvQqjgcqSBldRZgl00zWBRYFeW/9g4ElrogNzlWudw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p4RzfA0l; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p4RzfA0l"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e721b5503so3341325e9.0
        for <patches@lists.linux.dev>; Wed, 16 Sep 2026 21:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789617617; x=1790222417; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TH7pqPWttSJGp/Lqeiet7/X4Ui7u8p69YinbdJusLhk=;
        b=p4RzfA0l2CDhnQKbSJaCT0cZ+OpikAiSJGbcHiJBS1T6t3lcqFLp2C0AuKFyK+yHzx
         vDbMQQ6e19C4Rn3K0z3mX/IShCuRYs/nylEK7dB0MFynsW4BmqihOs9ggAaDn+Z6w0Ly
         tc9DGL/Gj94PN8dk276zQJCqJh64y9sYlRoEGOsyjes6U+7kkc281ArrZAgpwHT0K3Mg
         j+NCUvQyQIgT4mL78XlKJR83HJmy9KPEBHpUOwlSJr9oe/zBc3Zg5qMfLwg99Hv9lt+n
         8zOjZpsRfrWp3NearZmCE/8dmhVx+i+IIlNAAhD4LzhV2h6mtKIRi+K3iTawq14bH3BY
         qD1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617617; x=1790222417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TH7pqPWttSJGp/Lqeiet7/X4Ui7u8p69YinbdJusLhk=;
        b=JQeMWqkVx3CKttGBmepMoHoNMQlOOeYdyruareLzQmeyaue4AiVg+B3zgQZFdXDWvZ
         AiLXzPkTWWLmgWqNhSSMUboU+AjmBAwSfMaF3tIefIu99tZIKxREij9xvGphu2Vp8z7h
         a4qSXgJbxcsMNkaAp+VQ+EfspUbRnE+hwEOkRkyIQa982AV72pTR5PFaX+m1qv1nXRDN
         FhZui85uXNZ3vYbl0RAo6uZNVrfYny7DRQQbr9fJQ7Ep7KqdTvLZskL3qTbslyrRZpkS
         ZZmcjr1oTlP/j9waTGgix5ofctvk7R2532RHvM/G3tGkctxuPFhBDZ58OuAO0KC05TCq
         bYTQ==
X-Forwarded-Encrypted: i=1; AKwUvBzK5MU9uCaw4ld5i1ayZS2SBocierpcZQz+8V2rNQqV+w0n7YYfxswrGmdwQMK/72+dCnCmQttS@lists.linux.dev
X-Gm-Message-State: AFuF++kZl4x7vU10W9HtlsVygCVoebo/94+wybGj0H/TV5kSWyqfxAw7
	8iH+7p1bICBR3gSctws0Wc2WYfI1xONQAniRKnNvnSoU3M00zv2Y9rsQ
X-Gm-Gg: AYBFou2HJ/mNg6mHxbTfS6KdOTD7IuXtwI+3lsK2xNZVioAHLnNGwaUdSaQ7kjHMNQd
	meFs1tfYsHbzPWAKuu/SI2owzh8m/cztogpufLG66nxDaF7WnM00KtlZC2Fv4OgBvQV46+8MLS2
	kKr2EJpFOEH6NKbUF70M7SrGfWHjYAFhpyMbPj8/JJcsUyRRfUlodEUsFiThAxcZ0NCzfeWfuGE
	qM8KPdNHJDzPqWMu/IT5TDLHKXMbkcWK8EpOgYsqVDzHMfIm/QMWk7+ZsbGpTbXrs8f9xHsbXi9
	XXDgPX5GZLe8hnNJff6WPbGQUtL/jHXAg2zsSwyOtQ/eilgRIC/V4qNwDLuDhz6gm5aX0U3R7jX
	ujt4K9cjgEwF/lpvckWzc/3ITjYejShL34Y6ZiYbK8iuTe5p4f7WL3pSdm5BlRF8u9YynCQoVUJ
	z1uXHo+x76sJPI/isiuxTs36id8fYsgsk+RDOy7+nKSLWKqBHXLiuoJCrxXDVUX7A5Uq2GchCck
	C+3lyO5htdIzKJWyL/pYCtZPmRKEXv/RvlUxhJcZ75x2O6CLi63ljaxRjiFD6W369symcERUDjQ
	a1aJN2vfOkOTriC6fwhlk/jbW0/cwVbhyvzqCG99cWFhiXP3npQTvX7iDxxBkfa7CXJ3FYtocAp
	w
X-Received: by 2002:a05:600c:83c8:b0:49d:28c4:b304 with SMTP id 5b1f17b1804b1-49eb7341406mr52441125e9.29.1789617616894;
        Wed, 16 Sep 2026 21:00:16 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-9dc6-c001-54ee-4741-4927-0a28.310.pool.telefonica.de. [2a02:3100:9dc6:c001:54ee:4741:4927:a28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbfd935cfsm6880015e9.0.2026.09.16.21.00.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 16 Sep 2026 21:00:16 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: stable@vger.kernel.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	luiz.dentz@gmail.com,
	luiz.von.dentz@intel.com,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	eadavis@qq.com,
	davem@davemloft.net,
	kuba@kernel.org,
	linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	pav@iki.fi,
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com
Subject: [PATCH 5.15.y 2/2] bluetooth/l2cap: sync sock recv cb and release
Date: Thu, 17 Sep 2026 06:00:04 +0200
Message-Id: <20260917040004.21041-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260917040004.21041-1-kmehltretter@gmail.com>
References: <20260912065526.833703348@linuxfoundation.org> <20260912065546.976652519@linuxfoundation.org> <20260913202907.3100-1-kmehltretter@gmail.com>
 <20260917040004.21041-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 89e856e124f9ae548572c56b1b70c2255705f8fe ]

The problem occurs between the system call to close the sock and hci_rx_work,
where the former releases the sock and the latter accesses it without lock protection.

           CPU0                       CPU1
           ----                       ----
           sock_close                 hci_rx_work
	   l2cap_sock_release         hci_acldata_packet
	   l2cap_sock_kill            l2cap_recv_frame
	   sk_free                    l2cap_conless_channel
	                              l2cap_sock_recv_cb

If hci_rx_work processes the data that needs to be received before the sock is
closed, then everything is normal; Otherwise, the work thread may access the
released sock when receiving data.

Add a chan mutex in the rx callback of the sock to achieve synchronization between
the sock release and recv cb.

Sock is dead, so set chan data to NULL, avoid others use invalid sock pointer.

Reported-and-tested-by: syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ Karl Mehltretter: applied in the form this commit has after
  f1a8f402f13f ("Bluetooth: L2CAP: Fix deadlock"), that is the
  chan->data clearing in l2cap_sock_kill() and the guard in
  l2cap_sock_recv_cb(), without the channel locking in the callback.
  That locking is what caused the recursive chan->lock deadlock.
  f1a8f402f13f removes it and moves the lock to l2cap_conless_channel(),
  which the previous patch does here. l2cap_data_channel() already
  obtains the channel locked from l2cap_get_chan_by_scid(). ]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 0b51c3e0f469..bef6a948d7d5 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1237,6 +1237,10 @@ static void l2cap_sock_kill(struct sock *sk)
 
 	BT_DBG("sk %p state %s", sk, state_to_string(sk->sk_state));
 
+	/* Sock is dead, so set chan data to NULL, avoid other task use invalid
+	 * sock pointer.
+	 */
+	l2cap_pi(sk)->chan->data = NULL;
 	/* Kill poor orphan */
 
 	l2cap_chan_put(l2cap_pi(sk)->chan);
@@ -1519,9 +1523,13 @@ static struct l2cap_chan *l2cap_sock_new_connection_cb(struct l2cap_chan *chan)
 
 static int l2cap_sock_recv_cb(struct l2cap_chan *chan, struct sk_buff *skb)
 {
-	struct sock *sk = chan->data;
+	struct sock *sk;
 	int err;
 
+	sk = chan->data;
+	if (!sk)
+		return -ENXIO;
+
 	lock_sock(sk);
 
 	if (l2cap_pi(sk)->rx_busy_skb) {
-- 
2.51.0
