Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12613630AC
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 19:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789327354; cv=none; b=jLxaGU1DBtivOb04mnWH1BoWEUXwfb0Dsfj/fxFuR5SsslAA6b7PuBdYPBW74oj+J7ggMaAnmD43NADw7doqccywJuD4DBRukQ+BX1/MTHsqa1Gm2Jhlgm5NJok+gmsqyTtQIEf1KasdKgbmCMFrN1+nDzUo7c1oUmM1JlDL420=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789327354; c=relaxed/simple;
	bh=qQilx/XJAAeSEVVpMCFNrvnuxibowI9VFpjoi7rJZoQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bvf+O4+o7tI4jO8DlvL19DcE0Mcl9MzM4KLYEGt3gBMgsAbOsp1ww9oaq6Aws/odHoc9R4cstZPAYUm6C04hrZxD2iLANxwgjMwy1Lfe9NSf0GpdPN4UXsRymrJ1Q1qoxM3lp/0l9tV7t1UPmgBjJ05MUm2b2RWszvXVcK8RJEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XU5J9ctP; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XU5J9ctP"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-485850cbac3so1292548f8f.3
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 12:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789327351; x=1789932151; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qQilx/XJAAeSEVVpMCFNrvnuxibowI9VFpjoi7rJZoQ=;
        b=XU5J9ctPt1LUahJY/J/kHhw8H2lPRw93VU9G3hMU1w32leiKoPG5wqUaO+kPhw+wzV
         2J2P19OvJvLsr5l9QuIDXz02GwfgypAB1fLBraHh+zll4STSxehEg/aXz35ntPTj7JlX
         zGnvFjMEEeiWo2s/5HxRvew2f6S87+Vh2TrPvrB89RoM1wV5woIwaijj0JL+kdU6DFeI
         ezr2WuLUwyBks0kxxVg25o4p2r/bajimGKNpO9ysTS7RuPv50VKLBDUZnmxCUQGs2NuU
         Vljm7EcJ3tjmJSxnoftAwT/iVpAMRVuYYyq2LSlrZJP3S1FHFWKx4VeEPzqtnq1C1Jjo
         pB7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789327351; x=1789932151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qQilx/XJAAeSEVVpMCFNrvnuxibowI9VFpjoi7rJZoQ=;
        b=szIiOXIR3gFKH580D6tUxaqsTEnnLo2LhQ/A45YTsU3fgUZ9v3oj5Cd40u18jbFSHW
         SRVtOinnG13pGyURWkV3VY1uyBjofsY38TKgGglxrQ/Upxl+OMnLJUii/Tta84hEVhSw
         5X4n5c+owspoV6SHEFwc5zx/8XLeGWMgv5T+xRJqhsLff83gxXzM33zO9vSKkEtoL2Yv
         IwTqgvB4eNAs2yFc2Dw8vTgmj2nFTtQSnjhGzvjFP7MQvs+eM95gipHefDUZyjqA6dc4
         HvBjfhhtSz2lAJilumYWjkHb7NdRwdzXClHlyw7JvNFfnlD1GjEv0TgaqKwTl4tJcyf6
         LtpQ==
X-Forwarded-Encrypted: i=1; AKwUvBx2ugOV+dKIxafsy1jTQc7///1MMG8IP29R0NuwnyCYzpBhKnYNkNE/e70FcgUOSLeM4WqQQOQJ@lists.linux.dev
X-Gm-Message-State: AFuF++l+yXIfxXcMGPgEsyDaGdCxu2YrLl4JQ5/GS7o4gupHhkQfV2U2
	X8x9iXCWDSajb51JMQ2XyL7zXEDkWPXDVDV+cOgAqcs6+718z/h2liqEkGBCijy/
X-Gm-Gg: AYBFou1T28+nTt9Ek5piWUTXa+WxqIR9xic6OD6aii16nQypES2CxufpnaCMeieoFrB
	tVXWAUqiIvtWncN2BDqZuIlbro2gGHc4au+2aP0vlEqTZ8uGpKBXq2/jH8s/neChSyuT80IQ8dy
	aQm3heigCnPngYg87Q8eoQypu8V6bf9QHGPn7rdKoopEnBYlkbVmSYYv3u2dzFev+iPU5V0Lu89
	tAjo5DFg4gb1kGn+HzumJF1VfvY4nkKRdHTL76pqhozG4DcM+/2cE31fHVJqyk/SmjMwIE1mnq9
	CQgaMRk6sVh223q1DUQzf6k8RauNWMPmAv3w5xkEMh4t7aCDPLfiuIVRv2v0sjBYZxXAax5/ctv
	ghk7vflARGUZvXGKlan9JcmUk8+w60FxL4BCUTXiOVlHv/RYb99rzM+APYZRb3LIMwoRMRDkMw3
	zYLH0US7kRjjWJjhjMPPHQIt2kiNaf2ODzbrI/kmF0HvgnYlcA/dDDd1hqgmDS+utQ6Hsm1Foqx
	TFgDY+Ezu3SYNOsIQcK7dxkVYN0863zOmF+Lffco/OlIjmS0flgG6dVwvAociuL1qE/sy65ArQ9
	pZ2+RcA5RH2uCJNJRCkadpNoh9VXnDB6qxBVTUasxd59XgD5F+fhwlhf4Wvwjhj9otQnRrEejeD
	kMQ==
X-Received: by 2002:a05:6000:25fc:b0:486:fc00:b0db with SMTP id ffacd0b85a97d-486fc00b1f8mr4127609f8f.30.1789327350656;
        Sun, 13 Sep 2026 12:22:30 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0e6-2301-7846-2cfb-35f5-6359.310.pool.telefonica.de. [2a02:3100:a0e6:2301:7846:2cfb:35f5:6359])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb359f38sm19681970f8f.30.2026.09.13.12.22.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 12:22:30 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 0787/1424] bpf: Sync tail_call_reachable with callee state on entry
Date: Sun, 13 Sep 2026 21:22:24 +0200
Message-Id: <20260913192224.2361-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260912065624.923073650@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org> <20260912065624.923073650@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please hold this patch unless a 6.6 backport of upstream commit
54c27ea6dadb ("bpf: Fix tail_call_reachable leak") can also be included.

This patch resets tail_call_reachable on callee entry, but 6.6 lacks the
parent-state restoration it relies on. Returning from a clean callee can
leave the root program falsely unmarked and make the x86 JIT omit required
tail-call counter handling.

I reproduced this on 6.6.157-rc1 in QEMU: Linux permits 33 successful tail
calls, so the test must stop after 34 program entries including the initial
invocation. The unmodified rc1 reached 35, bypassing the limit.

With the applicable 54c27ea6dadb hunk applied, the same test stopped at the
expected 34 entries.

Thanks,
Karl
