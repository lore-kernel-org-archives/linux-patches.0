Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EF81B6D08
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 20:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789331640; cv=none; b=RN58P3WBB1qZxRoSUtXhsPSAOAABiCDvL3zZZsKOiyMfKOPhh61k0I4hSTAq5wTUJWisaPpMcnmjxZrivqcjX3JvakZEzZaMVmHX2FqvphYnT6nbmgqnvQ/Qd0n9T7fWhOY5csSYJ6xMPScwJcv0KSwfitMqy6nVEv92DkFYIEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789331640; c=relaxed/simple;
	bh=ZImNFxIOMPZzklYZUNsRSmel6jjVlfotzjbWSm0W0co=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kaa8wTvTVStQPHvPnFBvnj66eVvtB/RPPZ0HMof32Re4WLlpp8Prz5A5tWUCpuRRr+34CA+utG26zEc8RelUw4EVjucX2rJUeUFJl3k/JtCZnV9+YOn6AX4Zpk5QRJm5ybFf/l6er8jvyAJ7VW/jXZlyadwXaelBmQKJGMOWTs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CnqPAAZK; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CnqPAAZK"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-486fa798933so741769f8f.0
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 13:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789331637; x=1789936437; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZImNFxIOMPZzklYZUNsRSmel6jjVlfotzjbWSm0W0co=;
        b=CnqPAAZKgIGY5ZBPZRdbWoFaEMcAYfwxD++J3Pfkem6PFvm69gQXuSLKjdzi8aw7IA
         1h6Y4fcJjafmNSmSoJn10hoa8+LupvXql7ZsY8y5FeDFA8yoiTIWv72zBbfC/bNlAPfe
         w7Khav6iNBA9UUy2kCgxlDUm8EstDPbGV5wXgsX5ZkgF6CB9HONdxHVhVFgtIKPHu0o7
         YWuvHpQEtxC5ZSu5hsUx6h47YDyHvMTi6IvSnc8fuQvaQW+tr8tC3T/2HveYGvHalsK2
         90K0iG/kvgDNhZ83vTS51xbIH4fzkJaqoJbxHmMQoPEFcZ9Tb1xwDRS2FnhjvMOwmLH5
         +zBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789331637; x=1789936437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZImNFxIOMPZzklYZUNsRSmel6jjVlfotzjbWSm0W0co=;
        b=Ee6EzO3P4rDeEkWvpIRYh+jxcvN9LHTFSSW5IRhXyDcq2hQD6PnSlzN6yU8YIooAf6
         vd3TQRTCZYSQ1sBSKF3Uk+ClgfKhuC9JrgRsQzFSDxFBlRgeuHqt/kIer0KcxK17dagu
         dvS+FIuvEwQOJH1W7PUDZg4G5eAz2Sg92NIt5r02kKGT2xqekpCcQrZHM4toM4Ex8vWF
         +tNLeiEy+LfN8lY1QgiTU9DGnunrD92FzpycNJio/RlA3RaWiWLY/avmFxfKPVjrMEvb
         pz9TOsEdl4aXpMJz2eeoNnT/f1+y5QCXKQL3tVeTtHbxgMljJ61Jym2DpIKIdf2mIPFh
         cKSw==
X-Forwarded-Encrypted: i=1; AKwUvBwjNIde040qInKh9Hzh/OtGWHQ4h5kyAbmUGGYM5rngNAnXenW/g/QCh7oKLy5sDIOzgJXd3hlJ@lists.linux.dev
X-Gm-Message-State: AFuF++mx/ESEmOIBH6P1XBE7VkYE3rbbuqX70bO6mtMAVyzh62+v99EL
	uWfKKd2QcvwFtlX/weO3p9LiucAFadcypIkBfwzVSXWH0iD/rxXLLhx0
X-Gm-Gg: AYBFou3Ge0T3jlKE8weqFF5fwNIx4SuogBByyQEQho8935dPqFGc8okNTTCzrX2TO/w
	Or4PHGlsDPiTof979hN4seRx2ymSuQSN1ur+9BNFTMGCFKgoRexBD3ytUkjNpqIw8Y2xM0uyCd0
	4sGiwgo4GctlkaLqL5VcBFx8or3fbOYRgvmnAtYz/SHf+JJ9y1Z/JMUbJniH6p7Ie/eIcO6BE4z
	EQPAN+iz8oFFT7h9TFM32c4YHHk+WljMxeTiUcGpKQndQVel8k5bkhPQwu0zG/5ZtSF4vLKAp1o
	KYu9+tSqlsJgV53YQgzAz/4yiVBI9xv1OeIj4EM5IaFFyi+nqwFloEC0iP39qqpsK4Szhs4jBgB
	cnpJT2ueXlQzly+pBbPDY4bIidFD4uu9UYCOPetH9xNMnZiuJmxMlvOqGCP/d/xFpLvDcN8FaYN
	V4/vm+DMYvW1NRC8E9+PaAjNZTXyTOpSBbEjdWdZzvilfpg/6PEFvAd1hmaj68OiuIj1X7BNqIn
	8wdItlIMRItYQp0+AkP/gPBEDuBGZiW/yT8zkeO/GIMq2CHz+KctTJ4xK0jnYkoVgSYzJtf0v0g
	0BXlIFy1BO4UofJCy4ri8CInYLxuEmLx+d73RbFYdCxLzhWC1Q1t+m8YWTbKlcx42VLxzzBws0H
	95Umdd8V7R6di
X-Received: by 2002:a05:6000:2211:b0:486:fa3b:7830 with SMTP id ffacd0b85a97d-486fa3b7866mr6070871f8f.15.1789331637349;
        Sun, 13 Sep 2026 13:33:57 -0700 (PDT)
Received: from MBP-von-Karl.localdomain (dynamic-2a02-3100-a0e6-2301-7846-2cfb-35f5-6359.310.pool.telefonica.de. [2a02:3100:a0e6:2301:7846:2cfb:35f5:6359])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb34e74esm21719486f8f.25.2026.09.13.13.33.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 13:33:56 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10 749/798] bluetooth/l2cap: sync sock recv cb and release
Date: Sun, 13 Sep 2026 22:33:53 +0200
Message-Id: <20260913203353.3295-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260912065534.238252948@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org> <20260912065534.238252948@linuxfoundation.org>
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

I reproduced this on the exact 5.10.270-rc1 tip
f69aa74a82509ee94a2aac2822b4189496f267a8 in QEMU with two linked virtual
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
