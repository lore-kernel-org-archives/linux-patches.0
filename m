Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B5E73463
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 00:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780533970; cv=none; b=pvZpK0lgE/KaL3/47lh6uostiBC7ZBnf3RN1BsXBy4rE3aiAoj16xJu8FoKdiatSDCDQT7FoTYMsa+hev/6eHXcYHtPsUqe7/BIhI8bDws/iHI615Klp+62ePGEsYFsvI8BqyU0cIvPD5RuNL8sS3Fj/cfxeaClDbf3kJ8UBT+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780533970; c=relaxed/simple;
	bh=4C6y2z/XTDC26AyRBpojFCbnM2K9+BeYPffxKjyVQk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PP7cz16rVICy4J+S42k4C6Ut8kkhjxhFYYWLYPHOlx2hrWGqdcOwecTgayew5rizvUbwl4pJnlio2+TxrYiu/7YAxP3L01s0uWvc4MJkATdYrzKVhwXMjnEDeQheKf7S150ywkWGlvfM8+YTTpxBjNJFlKH66eurG8sIh0CGXao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WMtXJfrb; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WMtXJfrb"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-45eee266c6cso66784f8f.1
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 17:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780533968; x=1781138768; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hNgRjJgbYuUrLzdW/5WEzZhlyP27Ht6YujPqndZuMqc=;
        b=WMtXJfrbXtCTDNLfCjbFk26nEaYe1pa1Z5jLVUK5e7Fx5ojKuw1gC9ZWOOW75yEIUV
         UD2nRhxmGOVjm7b8HVTDia+aUVxOWoYDOkRYQymUWEyIMVCEyNQhbj0Jkx9H80EpnTcT
         o+dXovGTBeB3S9+x4mF9OpOjIsvq9ZHBc9rfApZXyVKrU1syeMp8/GbumW8tI2VIFa2z
         mb3nJwqR1/mclmsEPBaw+vF/krj/ffeliFHI7BIlWcyTZCD+/thAkmqEAIDRQe3KYA0P
         WomNWhOp3i29PcS2tlRg47sQF3fD5lhx1hC7IfpaDqfEGSVxjsmcHkUzeyYwIxQWPTPV
         MNzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780533968; x=1781138768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hNgRjJgbYuUrLzdW/5WEzZhlyP27Ht6YujPqndZuMqc=;
        b=oehD3V72nJ7lfvuXko8pKn9mhkkJsyC30vOcGpdwRs7CWimr9y6sSnB4nTvC4oiWl8
         OXX6Fh+7ZA1YqQ3YhEgVbdq93yBuDNfk2xRLD9zzS6Kuft37Tmwrn4lBERzJlhPHDbG7
         VNvrz8tePAbow+RAqc9Y0gJjFhtsl22vd0b471tZwhO4Xd68Gx5JrN1sHNESE9eby/fv
         MM39Q9Gc4B7j0SvQ+vb/XWxi3noN8swUq2unCrZwk1BhCP0IUzxy1WfJaGeUzY9Aq+Hn
         eT+RPkI17NmN88b4B5Qhz0/NdqyXBaiDj1moTeO7rkDTeK0pU1pZCeBzwI0kfm+iIlu/
         SI8g==
X-Forwarded-Encrypted: i=1; AFNElJ8e7OUSOnVsSgHjqpZKUJvSuQCr4jdNiE54qkLInx+BMMu+NApDIpauZXTXj89CVOtxCrYNh+vZ@lists.linux.dev
X-Gm-Message-State: AOJu0YwWh1BNS23npBGNmseIk10/bbJt3BciizEldPNXBSb7j4lVm5WK
	7m3fSlkvAfwb+SpifgPOHLDCyPyFa6Lo4qDTPX4xPPbpMxlxe7km7Bdl
X-Gm-Gg: Acq92OE2ar5HY2UrpLT6BZaBqzARPReFP0B4DpbSheZuXVR2pfzTK6xjE+g7NJb8b/W
	DUgQNiVCG8x+UZuh6+Yvn/gSylz48/YLu5Ou6RP8jyXnijJ3oZ9QHWV+hOZaNoirlX/wxplZeTf
	2tn+9PtxPS8329kVhKyX3A7TshZELBLY4Xf9caJz+vPADIwb3Kb5WT8CsbPD2gVIwSyZ95RmG+3
	6Hfc/jEahDnix+nljJrhgA9ZzikZ/UZRQkf1iX6aNA20cMtGrEKd6hP3TFwEfw0h3Og1qN7LaRA
	GqynhwDlHSFk4gwtXjXwMlnbOajdJrxT4B5xoibSeSGub+T6TwIuyAHcK8NOB4uQzkx6JiUSfx3
	7mUKwhHlVV3G84GJuaZ1VK//GwZX9AcATie2Nv3rsVA3pbPSSZmJHhsxhu4O5BvTQrEmvJFjHol
	loYLRhC5DvHlubr5wxGoAEn2t5pgAudoFVoUulACPu
X-Received: by 2002:a5d:55cb:0:b0:43d:dd:8ca4 with SMTP id ffacd0b85a97d-460218f1283mr6820154f8f.14.1780533967626;
        Wed, 03 Jun 2026 17:46:07 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f2dcde3sm13029996f8f.1.2026.06.03.17.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 17:46:05 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: safinaskar@gmail.com
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Thu,  4 Jun 2026 03:45:59 +0300
Message-ID: <20260604004559.1112474-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531010107.1953702-1-safinaskar@gmail.com>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Askar Safin <safinaskar@gmail.com>:
> For all these reasons I propose to make vmsplice a simple wrapper for
> preadv2/pwritev2.

This patchset is already in next, but I still kindly ask people to
carefully review it. I'm still a new contributor, and I can make mistakes.

For example, in vmsplice I do "CLASS(fd, f)(fd)" and then I pass
"fd" (i. e. integer) to "do_writev/do_readv". I don't know whether
this is okay to do so.

-- 
Askar Safin
