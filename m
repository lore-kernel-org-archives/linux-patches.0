Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4173437455
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 06:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790233145; cv=none; b=llDOPcCsW9bMIePOhyfufCosUnnXlL6K5Zzwzft5Si/z5uyiX5tjtPlRuBS9PcoMO5Cf/4ho8GiqoGPJlMJnStkvPC5MFHwMh29o4a1400W13cSQyaQTvclJlFhzHJ+bNU+1Io+ZNh/v33Ug6cx+tN+g8JOkgFZZv5G0FFCqsUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790233145; c=relaxed/simple;
	bh=0udDt59MpBhkl1PfoDwulOFVVwnC/G5KphRMorcHheU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E2687s9bzfJBAuccwvIjT4FbDkiozeFuOT1F1R88imhhpK9GVRnwAsAgiye6ANd64xtBUK8dJbZZJ1s8z0H8Q0PyBToTAQYdw/tPioU5rGO/kAci+yHxikPOxrWRDOcul24uM3hbuAeyu8xCvjfnblaDqcPnC64Hwi4S+bEvfgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pLzrHNeD; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pLzrHNeD"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843f22dc83so1294809f8f.1
        for <patches@lists.linux.dev>; Wed, 23 Sep 2026 23:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790233127; x=1790837927; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0udDt59MpBhkl1PfoDwulOFVVwnC/G5KphRMorcHheU=;
        b=pLzrHNeD3MS6vUQ8eLS0lItmraN/6W4vSIFgaNIse4vTgCWldNoBSnlEk2XPswrkTk
         b/pMZBPZLvfScibW4mobTRJV47xPnti8aQmO9FCkfHA1DqOHnheZrBG3hwj8g/85yJ6e
         MvoLX+GE5Bg/b92CFxmDu7YBFj/7bx+46ajsvwup2ghPPgAigyLmoILXA6vaIVkrADGh
         QByylP5LdVb0IOIJxryQqm/PDtxaj6vvYEbJjXAEIzFN1BddMJzU1mZ0w4VpD465E0T4
         WouMwM22tEC2wbtCuPFExJHEIieEjqvOjUhj+sY5U8JYCJkmSrrD+KwPydGOOGL+3BR0
         5S+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790233127; x=1790837927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0udDt59MpBhkl1PfoDwulOFVVwnC/G5KphRMorcHheU=;
        b=TVvzffJwKuZP9AL/x5VjNU7eUNrmYCYyR1RED+FhgF4cFINZEwz/YO81sBZQPZSZkQ
         5p3UV/MZvCQKsnx1fhF/9c6ay8zl4xBtUhRZZ+xRtY324DyqrVwpj/33B0Gzvb5CI0tQ
         7PXyvPlktJmiEYPcl+4GgJDBN1A7q84z4OiTnjTmpn7EXZ+QGopARj2D+eGowZi6L/jx
         k1M8ozHK++5qXuE3bNCIZAgnUhM+NTUEzp+e3XRJQ2IYzDZxQJfpZY7bkBuR0ReuD/Zy
         hVFqvqkLywubt1Lq53jpAuAdruXehPckXx4mvOjnKVgnnxfjGkTwyoXXmC3OsmzNUDXO
         wzKw==
X-Forwarded-Encrypted: i=1; AKwUvBwo5ItS84rSo58mcoU/5Ao6ND4WsZSqUAf0A3rG8yd65kUUnGRYzgNMR5MFHWTq356dCQFEM6HK@lists.linux.dev
X-Gm-Message-State: AFuF++nIwjMFcEmmlW+PmlbEA7tkydK+YYHDENXq/WWJuKSg4KDpQMJp
	LW9k3emgY9LuMpVwnKYKhsL2rcMRoCUlWlyY/YQ8ZtOOeGXzrKLMClZq
X-Gm-Gg: AYBFou2GhosjeNj4MCy1ccXDamQwKcWiitVNNST8HFj8jQh3F4Ur5j9JLPH7WT0mz3c
	Sn8x7eHRKrrNdeKO9RPa5RdOLlrnfKonF0GO1b7nVPVXW2yS6RUnOhGGjxC62d8r45EkEOrxjCN
	XA4Fo5zywxGlnA4Gr2N0pAsLuzXZ/p8fZWbu3dOR0tusDJQClPrVn2zlzNparjxQx06w7XvpSKj
	uIJdSeKIob3jc6+J8uBdrCAruQFekmaYSfii9kuYcNkQQQvgBnprDqo4yw5Hi36uVpS+k5mYSxX
	JltU3hV9w4VgoTDpxqdJ8LqONU8MOwc2YNSDlak3X3pKWm35NiMi31jmeL+zOgpVLgRswtvhLPB
	1pz5RUJywOqeIvqz8+oNKPzZPQNS+pgabt31ozZE7ZvhiddV9d23GQfiwOsSMszjzNfSKcjtvK2
	I3lNlcWaJn26vDKJC+1ZAdt1LLdNGk9rVXElCAroPZbKvHMfxBKfuBm3mthpNzYDLNCFD8GzkuV
	FG0TLmGUjtl2fm4pD1C419qLng9IkWffFhCB9ikaY5cArAVWRK36WUnqPfRrQ/3uBWfDd811XEc
	0Zfnj59MVZLCpqL/YSwtbDtXnony8N1V97uOIfAYGxd9o2DOYecy5oi4mnUH70LQLbYXHCo3ze8
	hGgFiLIHjo8uH
X-Received: by 2002:a05:6000:703:b0:486:fb08:2353 with SMTP id ffacd0b85a97d-48872abc9e4mr1788836f8f.31.1790233126966;
        Wed, 23 Sep 2026 23:58:46 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-adbf-6901-6c54-85ea-c6d5-a48d.310.pool.telefonica.de. [2a02:3100:adbf:6901:6c54:85ea:c6d5:a48d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48868889376sm9893819f8f.33.2026.09.23.23.58.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 23 Sep 2026 23:58:46 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Justin Chen <justin.chen@broadcom.com>,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 129/398] net: bcmgenet: convert RX path to page_pool
Date: Thu, 24 Sep 2026 08:58:39 +0200
Message-Id: <20260924065839.56793-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260923140646.783275824@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org> <20260923140646.783275824@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I have a small objection to taking patch 129 into 6.18.y only as a
dependency for patch 130.

My LLM agent helped me running these tests.

On a 64 KiB arm64 kernel in a custom QEMU Pi 400 model with functional
GENET v5 DMA, patch 129 increased the socket receive-memory charge per
512-byte UDP datagram from 2,752 to 65,792 bytes.

With the same 512 KiB socket receive-buffer limit, this reduced the number
of queued datagrams from 190 to 7 and increased socket receive-buffer drops
from 810 to 993 per 1,000 datagrams. I obtained the same result in five
bursts.

The page-pool conversion otherwise worked in this test, and physical Pi 400
testing with 4 KiB pages found no correctness failure. However, patch 130
was also verified on the Pi 400 to work without patch 129 after a small
contextual adaptation.

I would appreciate the BCMGENET maintainers' view on whether this page-pool
conversion is appropriate for 6.18.y.

Please consider omitting patch 129 from 6.18.y and applying that adapted
version of patch 130 directly.

Full test details and logs are available if useful.

Thanks,
Karl
