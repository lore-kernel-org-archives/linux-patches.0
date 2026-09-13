Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8FC33BBAF
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 20:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789331359; cv=none; b=S5vEXWmhaIwhiWaH4KiuMvjoYuchEwP9ACfcaLEH2DMXMeXMNWiyH7zQ0K4AvGDatxGSp+Tn9GxiKmije4/dPbjE2BUHcznJR+OVzlbIYm5tUl0oewUUyuBQkTHn2zPrgPh2W3BKwnSfdoxTMbvulq3NeiwycpFoJpELABzLMus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789331359; c=relaxed/simple;
	bh=zzJJc0BvZyAD8faAxTr2KVe8l09VN4/GOFqySLP4k2k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oxEigzupFjARwYzORxgH1eZe6kZy15VIyKinfK0fH6g2MVADrwJha5saqLIDJxnu5UALlcijjNG/W9H+6Em95UXsSa8a0KIris2wxxnIwEMMYdZWljyDAXr6hDZ7h+r2MPVhQPWZqr3ldT6/vmTN10ohPPwkIfVZAFaDMvZUyEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=djbXM+TR; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="djbXM+TR"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e2406so5290705e9.1
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 13:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789331356; x=1789936156; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zzJJc0BvZyAD8faAxTr2KVe8l09VN4/GOFqySLP4k2k=;
        b=djbXM+TRgKjboEIRhBEk9gJ3IiOI5R9tEsrSgbPWc10aZK4E43aHXTmTliNWQJ2c9l
         CnH2stIovO8DYX+t0NrENA2xkz8I+zuTnWorErJmhrpYLqId/nUBXNjgrrtIvxU7IjhR
         0DNZZL34exE6zyoh6jrwTDhlRV0DLoGGxRrw6oF5OZG1EVacSFaCXDtTYVF4j57Hx0Mn
         52CT2kg8EWaae1PZ+TgvWgasWUkVbvEyTvtyl1KnKRCl1/IDfZktYecN8Zwqq4ihUij7
         abU4h7jLwXpcebM/4SNWlpT8oWWWBcqH2iSHUxz17JjgKIe1UK/72RKRcOxiIbBsJxEw
         8vbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789331356; x=1789936156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zzJJc0BvZyAD8faAxTr2KVe8l09VN4/GOFqySLP4k2k=;
        b=ZBTJ+yq6RN5aczVspfDpA3La9XKctr3aXQvT+/77uqVxs7tIvZ+LX08yPDH7U685va
         moIvFNLoW+4eHtfbT1mPOww6A0RFha3+IwVmpdxQ7NIla711JWJrrgaMWou8ock29gFo
         r51NSPJtO9F9OYzxYo4QiAoaAh0iVRzh9ywoC06euNIljbG+QjryTUglzFpgNrqn/G/g
         oYczctXRzbrEd7gGzOsrWTszE3rKbKM5Qho5eZrjnsqttmhFsON3yMYV9b7rJ2/+G+BN
         IRoMjzRHFxV+im6SbDJVX88X5IcCw2rVQw4LTAVfe5vSjAJCfj52pr0Vlzl0A6qNl/IC
         E9ig==
X-Forwarded-Encrypted: i=1; AKwUvBxj3il2rTkDncLlGhRt4pZ4ITZ7GHj1r/B9hofazMupA0FGpTmVcNNiUzXMADPQeI5uDNGelSzc@lists.linux.dev
X-Gm-Message-State: AFuF++nAMkw/5DDbZDEj6zmgQrFwgnuYvOf1MPiS7Www+pkA0gkkQ0gh
	3ggCuzWxx1ATUvzGnTYU0z9k2u/tBqCcyAQXxIF/xOmq+o+hjssg8ooN
X-Gm-Gg: AYBFou1KBw0Pq2v4CmGfotnA6jlVKNPp8d1dvzqt1NDik3PEIz1fpHTcXTWynbD5dsC
	1AhvzlVCtJ78d68//uK6s415hTAhr2KbzUeFDgRvoHwEBNm7BI8HKhUt6YMVsAYMBPqr7ZeDyxH
	hxCsGiYtRZ/brs1hANZS6qkeRGe1TAW9JJM1XPMSgqVhhxkpDb4XPYG1fjZpist/gkqdNWcWZrC
	vAYrd1U4xz07GFaYGmGStF9HTnq7Tf1ErvkOAXgCVL6yY/9Nsmjjrz69Q2WkR/xNifXsiNdQXf0
	cbdsrAN+okNYikXtduZ8Aj8pxGcmnC/GZIDubtizaRIUjn6AZ2JCXsLSsdY8VSLfowIQf9GMu4H
	m3i/kyWRyKd30g17/StDBGMQ2ht5+XhujTsAt3q/1L5Ss1jVr9uTyw5V2OyH/8QuCrAeIedsyDY
	XauxX3ZnEyiZQqsvcK5esHYjOTRWKW5NfRk479yaU+K9iiGuybPUC8wUBjsHR8MezLFfQemcLy2
	uaQ/lPGmlyagAAZkMUDINfSHF/ecIG+i3lfYCv56YAsGezXGJ+1BWZ12fUFoQxZJcOmvHN6JD3J
	Tqiudxztpz77w58ylen7a+c178ofWc79zAkD2fSsFFhXWy1mmrpKAhwb7Dn7ShWZbbKPbGKpmcu
	z6rjruLhqFQk=
X-Received: by 2002:a05:600c:1989:b0:49e:71cf:7088 with SMTP id 5b1f17b1804b1-49e76036362mr36886325e9.7.1789331356085;
        Sun, 13 Sep 2026 13:29:16 -0700 (PDT)
Received: from MBP-von-Karl.localdomain (dynamic-2a02-3100-a0e6-2301-7846-2cfb-35f5-6359.310.pool.telefonica.de. [2a02:3100:a0e6:2301:7846:2cfb:35f5:6359])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e6aac22bbsm124123255e9.0.2026.09.13.13.29.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 13:29:15 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.15 879/935] bluetooth/l2cap: sync sock recv cb and release
Date: Sun, 13 Sep 2026 22:29:07 +0200
Message-Id: <20260913202907.3100-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260912065546.976652519@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org> <20260912065546.976652519@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please hold this patch unless the applicable L2CAP hunks from upstream
commit f1a8f402f13f ("Bluetooth: L2CAP: Fix deadlock") can also be
included.

The connected receive path already holds chan->lock when it calls
l2cap_sock_recv_cb(), so the lock added here recursively acquires the same
mutex and blocks hci_rx_work.

I reproduced this on the exact 5.15.221-rc1 tip
0dce236725a538e8ddc0601eb0fb0bc43fc2c87b in QEMU with two linked virtual
BR/EDR controllers. One normal 64-byte basic-mode L2CAP SDU triggered
lockdep's recursive-lock deadlock report, left the hci0 receive worker
blocked in __mutex_lock(), and was not delivered to the receiver.

With the two applicable f1a8f402f13f hunks applied, the same test received
all 64 bytes, both endpoints completed, lockdep stayed silent and no worker
was blocked.

The tested adaptation removes the callback's channel hold and lock, and
adds channel locking within l2cap_conless_channel().

Thanks,
Karl
