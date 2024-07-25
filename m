Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C384F12B72
	for <patches@lists.linux.dev>; Thu, 25 Jul 2024 17:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721929027; cv=none; b=lSerteDFBPlm2hztrl2XjNlVxlbm2nJE0AdxKpsyFWW094m7xWy34fvwrjElKwhAAmGgJhE94lygCe+f3LWYHuPR2orSkKXymKO9QyIc7V2Ziw9sTHR8N8FeK6EAFbCSZs02LkaXsAdLGAkmdIk78D9hX+fhrcY6jlqzatdVass=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721929027; c=relaxed/simple;
	bh=yUSqsewQgRG+ZhARcOzlOJ2nTiGo1uWU4BJmS3pLRBo=;
	h=MIME-Version:In-Reply-To:Message-ID:Date:Subject:From:To:Cc:
	 Content-Type; b=Ta2R8Giwig+As6HZETJ9SQtG9X6oNdPOVAF6P9RS1G3RvdXDCYrGUuK5g8mWc8HyoQURT+G71GtNuZQv+v9CNJ/Jkpc8608q9wFErhMpu8RTd25WpE8PxE5tBpxmK0DaG/5dgyb/71a1f57EaZyM0+7yDALoq707qNlKr+hjeb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sD6Gbd4K; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sD6Gbd4K"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-6fd42bf4316so83966a12.2
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 10:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721929025; x=1722533825; darn=lists.linux.dev;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yUSqsewQgRG+ZhARcOzlOJ2nTiGo1uWU4BJmS3pLRBo=;
        b=sD6Gbd4KbW3uQx5fMyi3FfXGkBB+cEcGAnzn3gWLku6GY4gSvTslD/hcnyV28LsSgy
         UWOvVqLpQxpIk/51WNdBXwp/ZlA3cXm4x9xJuOrMfGOvZjqSdYpuRTks2gm10B/5LXrI
         geCUP0Nijk5TgOdJQhFcpztxhoFLyCycqjeChiSreMwsq57whb1nrZZ4MWjWeqBmQcwI
         1wxdRsK5dhUhqufUYVkvaRZ98HgUtEi7FLbX+dczGqWuoQfFS6IP8CoN/rcPioDQeAJd
         ZrUVPVxfuYxkfaUFpBZtebx/ZkLXvj+mambumN2vKduE7yX5f+8xDZ5PUraOi9MN/MLP
         zGHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721929025; x=1722533825;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yUSqsewQgRG+ZhARcOzlOJ2nTiGo1uWU4BJmS3pLRBo=;
        b=jRjnhhsOjpa29oVM+I+fk7AxF1lLLX2DY3VQdef9jlbkFntpHpOZyMuIalUrccZiuI
         CAU3X7YjGdbmXv9bm5HsWb9pScJxVkYq5vYap5o0iyXzzeaTaZKzACxIF2Mcp67NxueM
         tfK28Ogb4GaxaDDXvhLvbtAGm72Jj+apBA/zOgB1WnZvV7IYHV549cSkZOb06+K8Q7Dm
         NjcruM9zV04iqYxW9pzcAU+k4y+M1CWTdkuZyM0eJ8Rb3Uqw5n+yYQR//IrZe8IYrYRN
         Ue98am7n+9daOH9c5GYiDOE0cmALh23pi/k35lI3huI/nut28lHxF9NLGsaB1Rm0cSXP
         cAYw==
X-Forwarded-Encrypted: i=1; AJvYcCVMtRrNpR2uChd08GzVNUwMBVFYiz2VMTPNywTvNVjoWKqILMMS7dmmy4t+45k5jhB+Rx4fH0+FYlApEfsDXurNoJUF6+OswA==
X-Gm-Message-State: AOJu0Yw8AmXEbUT3r4lX8eR+06Z8tH3WMn+eTYoOUxoWsQ37sWp7NBFK
	0EyLuUbObFNoZb0KYFzQ2Zmvr9p13G10xaRt6Y5oRdvA14ladet59fo4mm2RRy7y9YeRVpkJBjU
	4VjEwZ7jmnAVYbRQarEihE5AQnYqlEXkusE62AKcuG5ZUjogBCu+iWEUm3eMM9Q6E8js3Jr/0fo
	rqnB6Di3wbaNZhDq/4ZnvtCQFImv8V
X-Google-Smtp-Source: AGHT+IGgOgqcOs5hP8QsLKObBY4ZeSyafDicC5SD03zZ+WMOZp42J9ofmxXVA1rYRWAg2bSDj9SQG0bdONEz2lGIwhVaAWsQahF0jjdDUNthD2tGGg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a17:902:e74a:b0:1fe:d72d:13bc with SMTP id
 d9443c01a7336-1fed72d23a8mr1751175ad.5.1721929025006; Thu, 25 Jul 2024
 10:37:05 -0700 (PDT)
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
Message-ID: <000000000000dd9096061e15d78a@google.com>
Date: Thu, 25 Jul 2024 17:37:05 +0000
Subject: Re: [PATCH 5.15 00/87] 5.15.164-rc1 review
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
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/5739840/1?tab=checks

Thanks,

Tested-by: ChromeOS CQ Test <chromeos-kernel-stable-merge@google.com>
