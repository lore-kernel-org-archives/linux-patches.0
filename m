Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D635534C15E
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 20:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761684276; cv=none; b=JxsUXotuV26Xh4EI/oT/bMWifyYiGA95ORzZrs0zX0m+aDaIHlQ8Kz6uf1fol3IGQu81zc90tTJ2egS0EmtKTPU3486jjPVed6UlQ1kNQ6qnqgZV37z5syG0T30ECK9sOFAa51a5i1R4atsOVX8fa/ZnW0I1IezG/bS0Z/j/DRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761684276; c=relaxed/simple;
	bh=Fied3dl/UANQJerWoF/cFDOGnWnacpaFnRaDcDM3sh4=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=pIpfACkayjjIrJVVyBA8FMRAqpCWYb3oFKPbxpPB2moiGubqJFk0e/x4TmGM+opvUSC61fh6KHnNEAgiaAUpQzOBebUhZck57a+dyF6hRGpUOEsKmnnBcamNjzwk2J0YMdoXWKMK2ahClruBdluGeTq9XJwPuMc1ciX4R7TP+RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=G5b5rCpY; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="G5b5rCpY"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-475dc6029b6so36681845e9.0
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 13:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1761684273; x=1762289073; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:subject:references:cc:to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Fied3dl/UANQJerWoF/cFDOGnWnacpaFnRaDcDM3sh4=;
        b=G5b5rCpYH+ZbyehSwkS28C6OOyLXw5SbIK2yvJWbdoO4ssiu7dS/PkrOu5M/8zDwIi
         Ika1HcLrwaMgK1b3I/x9blLBG3zyuZb0jx/C5on5hqU9Q6AQtAeuRyGdi9YhvhlMHGZb
         nKKQ3JaDFZgHPOrnuwfq8cUTo+r0M2x/yz6V8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761684273; x=1762289073;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:subject:references:cc:to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fied3dl/UANQJerWoF/cFDOGnWnacpaFnRaDcDM3sh4=;
        b=ikPww+2iv1LPALjLfL+t6NbpZNsuM7pl3hRxN6SMYqn2dSffrJvImbya0xXLHU0O2c
         EORM2dw4NthsklN/36Xun48BBQglIu+dq9J/fJhozFABLkXbrKDWmAGPT+q9knM6CDAx
         zNCbdF1Lf8SSn9iJ0WNw9CZ272aXoFjI6qPz//tqH7J3hz3Hni85nrQ/CuEB+x9eD8W/
         EZMYGDfr5vmkFWfxUlfBGonEhsCa53q73GgMSuPtzCGqQ+/e/dj93AVSj+LKnvnXWRLx
         sc5YopSgln3+ogk5HQVtTkZ16JpOHdakcTt+eQzc+KbafKF54Kw4XoMtnA0siJnXuqUC
         MpdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXp5cvMAi8Wa7Ude74WmTM5tC4PmeFvO0qnSEFaeGnAMWK6Tt9nKGP+pMBPNEIkBgXo8rYJj+Hx@lists.linux.dev
X-Gm-Message-State: AOJu0YxjZE+xQBVlsdqyflyrlw18hnRCDvW3o4I3RWIZ1SFDBN4zNZ5d
	F/bXbEo7X0AN8hmsg9lEuxPbgsX6e/IUMwdxQtdX1qYpnyGd7qz0HYFqTZxWjBjmVUo=
X-Gm-Gg: ASbGncsP0Ds78X23f3O24qTnnEacRbEAGHdJPfut4l0S+yaxyk5UFxyi0feYpXWul4I
	pbMrSBGc4IK6pv/ZY4XKd5xqwT4CVZ0pk/A/7WLV3+CMmXEPCK9zDtF0NnNbqeDsJpViRLhINYL
	CDhvzZD9e0kYNcZVtJXEcwyN8hcv5z9qsZIOWqkCLmRJ3e0DCevIu92E/iXvxe9bwSwNHTuxKpz
	gtMFUbNt8OGoWN6437CJdlOmS+HcAdWKb9ZARfs1G8FbPUmguLbVxcK9vgjK4mosUtNUCfIsNAK
	AViTzhqlMJUPpRTE/Q5inGfKeMGcS7Xvay2mQHRNj+Sfe5SFbLSDnqIAqQNdZR/jGNl6cYFji7F
	yXwkZHlZd4iNfDGS6JbWQSVXmbT9Peeti8YOZhnkTxcs9Q561w84E7kb7hGnsv06klPFkMCqXf5
	uyXOVyFOxKlsu4lBAFkd39Iz+b3mGidSuYz0oF7LCDEQ==
X-Google-Smtp-Source: AGHT+IFYxA9IdAZRK9TXtqt+3/HXyNbBqUK9nyIZUDmu+18dLsdb8MnEA9PGzDSYdEQoZJOKzbjQYw==
X-Received: by 2002:a5d:5f51:0:b0:429:8c4e:b0c8 with SMTP id ffacd0b85a97d-429aef8a7b7mr403057f8f.27.1761684273028;
        Tue, 28 Oct 2025 13:44:33 -0700 (PDT)
Received: from [192.168.1.32] (host-78-149-11-196.as13285.net. [78.149.11.196])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952b7b22sm21934277f8f.9.2025.10.28.13.44.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 13:44:32 -0700 (PDT)
Message-ID: <19c03c72-9fe3-4712-872e-324e65030dc0@citrix.com>
Date: Tue, 28 Oct 2025 20:44:31 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: dave.hansen@intel.com
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 tony.luck@intel.com, x86@kernel.org
References: <704189df-908d-469a-b719-4d18ce0bcdf2@intel.com>
Subject: Re: [PATCH] x86/cpu: Add/fix core comments for {Panther,Nova} Lake
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <704189df-908d-469a-b719-4d18ce0bcdf2@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> Is it even worth keeping the core names in there? This is an example
> where they're causing churn. If nobody cares, maybe we should just
> zap them, or at least stop putting them in there for new CPUs.

Personally speaking, I find it very useful to have the cross reference
all in one place.

This file is the most concise source of information I'm aware of.

~Andrew
