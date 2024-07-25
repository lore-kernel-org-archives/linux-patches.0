Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6C519D889
	for <patches@lists.linux.dev>; Thu, 25 Jul 2024 17:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721929007; cv=none; b=Hyx2ZZYdVTdb7RgL+ovdgKlQir9y/keDWGCfyQV+QlBwTtb/QbIO/KeduJRGnnF9XkNiE1t5KcVMXZcfUqWuCpl5WHsVF2E1k16d00gVRhkCTzh0SFG7Zqq0MQ59PZAQ6e1NYMMTGKreBCrHSkaNWLxw7b/TQecli8wTXzgGGTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721929007; c=relaxed/simple;
	bh=/5Ga4OJBJ0/DH+4kzdoqLZLfBxepD/Pit5aYUKJT5VE=;
	h=MIME-Version:In-Reply-To:Message-ID:Date:Subject:From:To:Cc:
	 Content-Type; b=Esvf/QQFhJa96JZnMGkUzFiUApj3xz8Cj/OIg8G40tJ6VITDe2DBseiJxIMzfswFyFTstm661HPUa5g+RB7ZiGuRAZZ6R4AGiVJ2u4P6E//UBz19ZMrh8lYUwtEL4nM/4CoK0SYI6hR9plAsdwo+Us9s6zFAWSUoJoZOPKmwZbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WivwmGDp; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WivwmGDp"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1fd72932d74so11914025ad.1
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 10:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721929005; x=1722533805; darn=lists.linux.dev;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/5Ga4OJBJ0/DH+4kzdoqLZLfBxepD/Pit5aYUKJT5VE=;
        b=WivwmGDpUgqLavh2VnE3vgJuPAZr9ddJvMTn3AKtvE+sW8duvfMremaykwIUZtIjQw
         NX6Lwcr9+LeI1Z6kLt1k5jYij+M9YxmiLH6mfIQwih/1aHnneKllLl1kSVsBb+F2qhpZ
         LS7AIaJ0bWHJO1V5Zy5hgxC1uLN+3jMPqkUiJTl82heIq0/rkeibCbWe9fMJPNkoR3hb
         uSGcqci5I5jlcjYJfsMwaIRNt5iSjW1/bIvDVPuTiKLsQKjcl8XHBaUjUM47A5lal9Ij
         0WD8uocGMuYOveeFQrNUEkgXhVEkHctcBtU9q+Dax/XRHWVJ57fQCSWZ1ihB7XsZojRL
         lyQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721929005; x=1722533805;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/5Ga4OJBJ0/DH+4kzdoqLZLfBxepD/Pit5aYUKJT5VE=;
        b=bcxAy+C6oCOE07tK3puThO/2tgWRELJR6MS5x1RBKAOGxwzONy4vlX+webwgUghm+I
         pYmfi6TX1N9ePs+TETV/O89TTmCttt7Xc43YZqb8ExSLUgXJPBatGsx/0gvV8QheDADq
         wH965HPwsnlyFP19jq4BuTXPkKhmgKl7f7ivacvbe1g+G3BByJusMt0sxL6k+dQVeVGn
         bnCGgAQZJ97d0F012RNdw0Dk8pO+VoCpaFbnU8Ye9Ym7/X7Sv9/Tz00LO23EZpd6w7fx
         xGzduUynkkaPTeAZZlDBza8alhV+6H3rPRYplGSMN0hoA4n9dw8Vho4MXGG3ipPxaeI0
         xQ+w==
X-Forwarded-Encrypted: i=1; AJvYcCUpy650guX6gY1ARo7WocKmAOpZ5qP8h710F+K3X1FD4ipQa0awzXWLU9o0MfekRHPddeFdfc/aayUIgK+tUyzzfqoXMJ8Nig==
X-Gm-Message-State: AOJu0YzbLxGDQQlf6QPhr8kwqCz2F6YpXBvJit5ZSeQVGLh1tkZgzbQ+
	BW7hqSCYq6odbCRNHnHFjJQ5hpb+JOzraWG0c5bf5Dv4R4klo7y5s3RO08EmLEnlIbh0JQLpXfE
	sQEt/rtZw5YaRSv06on1TqZN8t5Or8Qq8WIpF1VHwBguitsqAdxqgxhx5H+glmquOL7rRNzdaAf
	aDCZg/f+cead6tCb9JX2sAskc0D/WZ
X-Google-Smtp-Source: AGHT+IGXqrg0gwoRAgQNq7VyW6fwJv1PWxpvN4vkPIz1jL/bpz0u1jV6R2seWl/pgxW6sZeKq6FeSHlowi0HSZ/N2RqpE45x2sfHuOvTBqfEdn/q2A==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a17:902:f693:b0:1fb:5a07:7977 with SMTP id
 d9443c01a7336-1fed314cb0amr2380635ad.3.1721929005370; Thu, 25 Jul 2024
 10:36:45 -0700 (PDT)
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
Message-ID: <000000000000b25eec061e15d6b5@google.com>
Date: Thu, 25 Jul 2024 17:36:45 +0000
Subject: Re: [PATCH 5.10 00/59] 5.10.223-rc1 review
From: ChromeOS Kernel Stable Merge <mdb.chromeos-kernel-auto-merge+noreply@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: chromeos-kernel-stable-merge@google.com, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hello,

This rc kernel passed ChromeOS CQ tests:
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/5739839/1?tab=checks

Thanks,

Tested-by: ChromeOS CQ Test <chromeos-kernel-stable-merge@google.com>
