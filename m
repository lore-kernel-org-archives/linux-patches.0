Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C433B775A
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 04:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617616; cv=none; b=UV3WKomM7EdtE7SxAwlNT30QtM552bfS+hr4auTxsmTSAFHTynXk7peNz56QbZDcntTJ6tW3NXRl8Z9XlkgpO1QXI8MdAJCGrdvPujaB6PLnMZ4wH1qM7ZDwXQScxUdNelRv8N/IsK2qvGFZhL2xI8r+9WLXUk3fjTGmOpdzoi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617616; c=relaxed/simple;
	bh=J/bZaVCssFw0vW7xv0YPZK10RdXKVFgMBVYfQvPz70I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TGge5V3MxIxWSFn6dwTr39UDrPLoYX7iSRdz5XGbDYPQZ36Ao1UUha7p7KG3i2RK/9V0kJMGrxOVhDaYOTNrOuePUi8naGuxwaMdHagDUOYl+sP6mPJaYI2MsLAfDq1ph0x8NPX2BcUHkGDk6pvVAwx8OZX9epF/eDEQbbogqL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=peql7Zy7; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="peql7Zy7"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b965f447cso2815995e9.3
        for <patches@lists.linux.dev>; Wed, 16 Sep 2026 21:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789617613; x=1790222413; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hq+RhWH5t3rOMXgtP2JnH29EHWf8ckfy/YyUirWvEQo=;
        b=peql7Zy7lvegPJL3PT9thYOO1+fboWz15r5stLLvjE/Mc+wGcMjqEaojPye1lx3Y+w
         /UOISf6QR7HYkrkAF+3SGImzKqnZ7qsLvrYqclPQ5cFsHqEgIFQosCB1QzbfFp+sLIRd
         0t4V68KYf3yAl5m0X725YAPnqXwVjmCtowNPTkyp0QSGjYZjq1yO1KyPyMBpAcu9oTjq
         M4r2rOHjA/zaysX26a3JBD08O9AA/IT1XHYfccrrn5xIUgyshSYghU02ZaxoEl0eVFpK
         kHCLWwrNCa7Jahj917f/rY6XpRTqffgqWZ0FaXY67d84w/Riohtqhrn14jvB+Qg0vitk
         oPRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617613; x=1790222413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Hq+RhWH5t3rOMXgtP2JnH29EHWf8ckfy/YyUirWvEQo=;
        b=KvOC1YYmCgRopk3hmSBZoK8MngxAo/fE5swUnKh+UVHcrulzyyyDf7tFRJAp4DffYV
         XQTrAnUhuRmhTPorrmcWxsQ8GlXcxH722xEL5s1MchtBwAmuM3uyjpAS2hD+jPB9uulw
         0XYN2JZ9YkfX1EqRjQeJTBZLuSvyDg+b7cuSJYB+WGHT9J3dq/ZIJsPtLVE+Xtuf2yYZ
         vSJ7CxiXaH5D4UUtg/lJb25C9Mnq/HTxOo8xBdQLB2MuevemPTTMcagdi+j4IAxU0Eos
         +guTLynMP6/n/IJ1lKfmou3N71cngHn7Pen9vRCDOjZOhOVYoqaa4OFpF27FaNusWBU3
         hegg==
X-Forwarded-Encrypted: i=1; AKwUvBy3JtvyXL2JPtSBAPxQHYHHK237zwDoyqz0zYMFVhXesHcI7WxTZmFYGqPnmldDtauDt0d7O9e1@lists.linux.dev
X-Gm-Message-State: AFuF++kAZR1DDBYlqBuzwVLp/6PMmCXB8EX5OyzT+QGBcbPMsU0SHe92
	dA0W/IVBcXY5Y2uVC1KRtQXm7UgAiQX8V+1vXs0fbRkhxJxFrARm5iUt
X-Gm-Gg: AYBFou3z5CBIX21HZ149gULxlF4kLhNqyAPJshPa2MSVdrgnC26BmYu2QW8bzDUQA1s
	Q87VKLcQlf/PSRopv74hO9Qwy9UYH8irHZA5sXcFoNeX6RKpc/oiibS0sP32qZgXqv4k8w3NH46
	4VHmpKEqlc7raCIiEUwiFevIwvpJz5q0XbtaTrY6vWDo+pBiY9szRnFFO3kweKpsXNzkWCfl1yq
	IVuR+5auF+zJEPWEh3ouOVtqPNzljgVgnVF5As82smFs6F+1/2jstM/pAaPLKvS1QmMSq6gZdwv
	g+Ui1m/zmlpQja3QfHqO3tX5Jz6xLovaJhFOb8PkGZMHXzKeMGRbtam/mPy1JJ2SBwaJiKLDfxj
	TxDUfl6RMzIs80xljr9IMGUpOfAGU2IqlIKWmAqIq4LNIvnN6Hi0CX92ym+qQ2cyOdPEU24ah9m
	SuLLpyvF2hY/AtxU2xBtqUdmEG2QQNQfriIiUI17Yr3L9c7OrRvhFGrDDSc4YTXDTzCy4qX1GiD
	Io1WZVcAhlhtSiWNyI13CgHRcQROr6e7sXBXa4A7tYXUs9JpR1zTchHpyoNmIqdipfkL1tef2Do
	wJNep0pGLqGIEZlw69rGQrB1ID9ZizUx338P+F7tyGJwv+AOMwJVXVQ+TyfLThYvyCg7018/T1J
	E
X-Received: by 2002:a05:600c:4e48:b0:49c:fa20:cc00 with SMTP id 5b1f17b1804b1-49eb732d38emr61576605e9.23.1789617612631;
        Wed, 16 Sep 2026 21:00:12 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-9dc6-c001-54ee-4741-4927-0a28.310.pool.telefonica.de. [2a02:3100:9dc6:c001:54ee:4741:4927:a28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbfd935cfsm6880015e9.0.2026.09.16.21.00.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 16 Sep 2026 21:00:12 -0700 (PDT)
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
	pav@iki.fi,
	davem@davemloft.net,
	kuba@kernel.org,
	linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com
Subject: [PATCH 5.15.y 0/2] Bluetooth: L2CAP: fix connectionless receive path
Date: Thu, 17 Sep 2026 06:00:02 +0200
Message-Id: <20260917040004.21041-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260913202907.3100-1-kmehltretter@gmail.com>
References: <20260912065526.833703348@linuxfoundation.org> <20260912065546.976652519@linuxfoundation.org> <20260913202907.3100-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15.y has two problems on the L2CAP connectionless receive path. The first
comes from a backport that landed without its prerequisite, the second from
a fix that never landed at all. Upstream contains both fixes.

1) c531e63871c0 ("Bluetooth: l2cap: always unlock channel in
   l2cap_conless_channel()") was backported as 5caf0ffaf915 without
   f1a8f402f13f ("Bluetooth: L2CAP: Fix deadlock"), which is what adds the
   matching lock. l2cap_conless_channel() therefore calls
   l2cap_chan_unlock() on a mutex it never acquired, and
   l2cap_sock_recv_cb() runs with no chan->lock at all on that path.
   Patch 1 applies the l2cap_core.c hunks of f1a8f402f13f, which supply
   the lock.

2) 89e856e124f9 ("bluetooth/l2cap: sync sock recv cb and release") never
   landed here, so l2cap_sock_recv_cb() has no NULL check on chan->data,
   while l2cap_sock_destruct() still sets it to NULL. Closing a receiving
   socket while L2CAP data is inbound gives lock_sock(NULL). Patch 2
   restores that guard in the form the commit has after f1a8f402f13f, that
   is without the channel locking that caused the recursive chan->lock
   deadlock.

89e856e124f9 is the fix for CVE-2024-41062. It went to 6.1.101, 6.6.42,
6.9.11 and 6.10 in July 2024 and to 5.10.270 this month. 5.15.y has never
carried it.

On why patch 1 is only part of f1a8f402f13f: as posted, that patch touched
only net/bluetooth/l2cap_core.c and net/bluetooth/l2cap_sock.c.

  https://lore.kernel.org/linux-bluetooth/20240624134637.3790278-1-luiz.dentz@gmail.com/

The hci_core.c, hci_sync.c and hci_sync.h changes in the merged commit come
from a separate patch that was squashed into it while the pull request was
prepared. The author noted this when the AUTOSEL backport came up in 2024
and said that for stable it would be better to unmerge them:

  https://lore.kernel.org/linux-bluetooth/CABBYNZLzf2x6cScmjGv2Rxk-i3F9=QKVWosrSEBgmHBdHqOWtg@mail.gmail.com/

Of the two posted files, only the l2cap_core.c side applies here, because
l2cap_sock_recv_cb() in 5.15.y has no channel locking to remove.

Tested in QEMU with two virtual BR/EDR controllers, PROVE_LOCKING,
DEBUG_MUTEXES and KASAN. Three runs of each variant:

  v5.15.221 as released   bad unlock balance, and a fatal NULL dereference
                          in l2cap_sock_recv_cb() from hci_rx_work, 3/3
  + patch 1               unbalanced unlock gone, NULL deref remains 3/3
  + patch 1 and 2         clean 3/3 over 300 socket close cycles

  BUG: kernel NULL pointer dereference, address: 000000000000008c
  Workqueue: hci0 hci_rx_work
    lock_sock_nested
    l2cap_sock_recv_cb+0x36/0xf0
    l2cap_recv_frame

BlueZ l2cap-tester, rfcomm-tester, smp-tester, bnep-tester, sco-tester and
hci-tester give identical results before and after.

Also on a Raspberry Pi 400 with a second board as the L2CAP peer, each test
from its own boot so lockdep was armed for each. The released kernel
reproduced the connectionless lockdep warning, and both it and the
patch-1-only kernel died under teardown stress. With both patches, 300
receiver close cycles against 25,877 peer datagram floods completed with no
warning and debug_locks still 1. Connected L2CAP and A2DP playback showed
no regression on any of the three. The hardware crashes left no readable
trace, so the attributed NULL dereference above is from QEMU.

The 5.10.y fix has a different shape and was sent separately as
20260916193454.9996-1-kmehltretter@gmail.com. That tree still has
89e856e124f9, so both L2CAP hunks of f1a8f402f13f apply there unchanged and
one patch covers it.

base-commit: 0248c33e835ecbec3a591f93fdaae53f7b90a4d6
