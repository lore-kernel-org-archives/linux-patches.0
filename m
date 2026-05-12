Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B997D394E96
	for <patches@lists.linux.dev>; Tue, 12 May 2026 15:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778600877; cv=none; b=kBQuaGWBwUVsjOe8h/j6AvHOfQkFqTPmAsDSE0ZWJgpGKeF3aNjSFYF4PYo+Rb2N6/CbRXi27mSZrMtIBqaPxyYxSMNVRp9i1OpxDxV4xDiq9Oiva7xt+iH+zczDGXYSDc6L1/dLPflSczaRu7VQW5nebVJbwYGupXtTyijfLZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778600877; c=relaxed/simple;
	bh=+fFU7jIK5BFPkMYtAIwxntL9yQQw08VG6EF5OZCivYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DpDLCajvOK8gWiCTKANfeX7h2je7+5LZKh1euBMvAEX9UnpFrCFMWbm8Y3qgWAnJmFUbqrggdf9tM0PtGDc138o4aUxI/qa7oiCbiThQs2xcKbG2moJwBPkYlCEvNkHkBzYAIL2tE8wzjk353QF/hgJJRV09D1pdhohG3LrEz6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=FlbKwn8+; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="FlbKwn8+"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-47cba53479aso3526095b6e.0
        for <patches@lists.linux.dev>; Tue, 12 May 2026 08:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778600875; x=1779205675; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HdFF4dCw+6mO/bxdzEz9RKka+BXsp2V02/j635sy9XI=;
        b=FlbKwn8+exK/0Hl02JG2PVRw5RCW2Gi3Eq2ymq9gR3rejIxcC9pW82BKcolt/dyf6g
         N07iuZJPdXzQNhjKvjAgjcN4Klk63ciGIQkWMWXUY3ap9G8fM4DWbAEg00jBxfUdx/P9
         2tB15xavvaxTyJWRd44zL67ZmEUSTFWa0yvBMHFQcss0ZS78aEMyuYJOMngINYMOhkHe
         G6547jBNj0JihbP0HUCFfrywRoJpBmv/2QaGJcuYPyPy21a6KqnNnMDFGsvg2eolhA1+
         +a/iiFabCO4dPMx1DMsrMh9gXTDuNNGuihA0CM7tMkjSlINkNZeUAiqNBoV5dURlRyBl
         r+hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778600875; x=1779205675;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HdFF4dCw+6mO/bxdzEz9RKka+BXsp2V02/j635sy9XI=;
        b=WesyNmgfgarvLQeKeLCZo9/fl+5A1mjWg1cbVUX6C8Y0s5rIjK01/rwyt0vNEBRNRx
         F3UGahj6Wuzbj9A0GoDMuwZtuuRRuD7ZZvi+1R7wOcGbJjJz+oiSW9ZBv9jv1y5AUUkt
         HCd1tbMtMGj/oFw6YUrow//WZQELWgB38Mxtnq5yrAD5Hva4svT0prFwSOc/F2keUCcb
         i2apWPs5WGNmeM8GLF6iesJRnn5DRY3so3gmZcysSU7brbcpU+IjqlW8Uz19WDR4xVOp
         NLJbiD8DG7u3nPAvZ3WJdu/hXhx9QAD5Oqo/r2WJPwI0MXjlBQ9/2GL+oYPI+uGHyts7
         A6wQ==
X-Forwarded-Encrypted: i=1; AFNElJ/NEWbitM4At8afp6O6y8nie8C9ljneDSa8+y8mfDFUwC/LUJwtqPwHGeVWLovJ6psApHkyyHjq@lists.linux.dev
X-Gm-Message-State: AOJu0YyjgJrWL+R8NaTuwA1cLqHxwh01Ojy7AWh+Eg+X9RmlwISPv9e8
	ZEbERAZbtHHbvRRm9QZVhecvufwCNCY/EQ4KZSO7iI3noa4/j2v2xYzVE2d0kUcPw1g=
X-Gm-Gg: Acq92OEy84KSsWJL+PnH9XUklZEYpoCFimOoVX2Yev9pLitp1KIg6KxepanUcKV6r2y
	ptbqnr0GQbXqsP0s2n92b42vu54r37Wzqf5IcDd5wZRC9ITqAmFFdukajd5oGtp+dFA+KldBtcV
	o5I1UYyYW31vN9M42SaVH69arbTcBnCcyntSV5Wktj1tHqSZWYgiIZXMhUw3jPrQMCS2GnE2SQq
	lDW93gHLEpNiJDf/AG+fOkpMiBx5SGEHCEkqjCj5H/3hsNqeCA74iWwkuMe2VldAXrqlQ8sjwUY
	wZ3wYfvC+q8SYmvo7ZLP14EylYcAqXYF9ytWmrRQJozAPYUSgFzHd1MZCI2fBVF4e+eWqXtDR8D
	YFowvJtsHtYfOPVO8A3fa7ifIsIRetZGyNPVFw5JdsCerVCugtf4OmqFtvAtlo9zCIYaSUGN4eN
	tLncIVVZ+/mnoSqUPVmUCRXxhBusXESf0dNCOE2Qd0U5L+lnl/Fv1yfnv+Q5mXlv3L9HU61L1yR
	IcXNZEsq091tKyF+BI=
X-Received: by 2002:a05:6808:c298:b0:469:fc59:b128 with SMTP id 5614622812f47-4829731fd75mr2139910b6e.25.1778600874805;
        Tue, 12 May 2026 08:47:54 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c76986f9dsm22873454b6e.16.2026.05.12.08.47.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2026 08:47:53 -0700 (PDT)
Message-ID: <e12d01e9-8934-4150-bcb3-09ba147fc842@kernel.dk>
Date: Tue, 12 May 2026 09:47:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time namespace
 for IORING_ENTER_ABS_TIMER
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Maoyi Xie <maoyixie.tju@gmail.com>,
 Pavel Begunkov <asml.silence@gmail.com>, Maoyi Xie <maoyi.xie@ntu.edu.sg>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260511221931.2370053-1-sashal@kernel.org>
 <20260511221931.2370053-13-sashal@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260511221931.2370053-13-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/11/26 4:19 PM, Sasha Levin wrote:
> From: Maoyi Xie <maoyixie.tju@gmail.com>
> 
> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]

If you auto-pick this one, please also do the other one in the
series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense
to do just one of them.

-- 
Jens Axboe

