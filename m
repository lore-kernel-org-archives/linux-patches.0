Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3E31F8BC9
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 15:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739979840; cv=none; b=DidU+Oz9Lb0NLnL3SgZA4wqT++PGy3AHtKswwNYAD3YVgc8XF2cMhE9mlxBcFEn0YaDRNgtfLQzUuA0f7chLUh+iRbdfzv8xhg4gnExYuUnPd2SrDMUyjhiXH6VN6vQ1SEdONlFZjLH3Ej6qeGOwdd7QyPNaWVCmdo97+H+1r1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739979840; c=relaxed/simple;
	bh=YNmYlTClH6f57hMX0irzBAGNNqToOG6S23UwEJ2SIOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fmb/KGyEsxB0TT2a3tDM3cXCyomjCarv4dA9dzl0FuHY1afKCLUJLje6GIMDYlY5kz4YT5W7OwX4Y0bOny9mwLfoXstMVYCTLIB9jwLmXYPyBDgNbHyDRQ4LIcuHU6NA3k6rZB5NpCJ7ugK39y1H+calh9Jrjk4LPjTGUGYfkwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TUadXWKP; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TUadXWKP"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-abbdc4a0b5aso125848366b.0
        for <patches@lists.linux.dev>; Wed, 19 Feb 2025 07:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739979837; x=1740584637; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ztTcSqiM5jchwSh7zNDJUJXvpA9bZcVb5dRh9uYh8nc=;
        b=TUadXWKPQpM4iSDQLZVDnJhaiOq41EYMVw82mDePxzNDXmDLyPygfc2Kk8QOcsKIHC
         jtCfjj9DuXBQvDTIqw2igP46x7t83hIXAcSpCQ5p09UBnqVilEvEy9aEyiNBnJW71pMg
         3OrzTlZ2d6bI473xoqGk78iSVFPsn6NB/nYOH6a+bCfhPGlW7hdT7sZQ7NRca123boKA
         2OtdVi5aBtnJwGr/C+2cw5uy7s4/CPgyfM77saERy2x+c1HmANBSwMsWje1l/S/wRy2w
         9b6M8ywFOSFV9j0FFd30ByARJxs/XHbbbo2DhQG8lGrsAoT2/u90FWEL4hLqc4Tcycyr
         eiQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739979837; x=1740584637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ztTcSqiM5jchwSh7zNDJUJXvpA9bZcVb5dRh9uYh8nc=;
        b=ZoUmC9SPoMr9xAkg7zR0LxDBH7MFYWohZw6/qCNc55csX5+VbBy9mrHcKPhV5HbPw9
         zvY5WDefbwQaBv3C+UwAkEPfXoFv6Cb62QE+nmteUvaK4NJ0XI9oOdWW1srqtiCZ32QZ
         8rcL2sEiEbzXkm0IyjTbVJEsNp93q3j7Y8a8DQmR4Fpb5vVZSphMN0J4tHIOw8lGEm7e
         +cD9IvV/WsDYD9H7y3L+vJZLK1e71o6F0O5IrrnIyVBp0beQWFgyHr+QopymyB7y54My
         ckEU6tBW3Swi6pqfWxZzms68ewkzNHVXedsXfyKfFappeyrTZeez9w9vw5B4XhHK1ypB
         svxg==
X-Forwarded-Encrypted: i=1; AJvYcCX1u14bQvel1U8NGGstXQKw+PS19NyHQVe6dJ/1gpmKLoBUtJDPGATtN7j7UupLAdTsZeAE9NHZ@lists.linux.dev
X-Gm-Message-State: AOJu0YwjY8/1RYie+G9Fr0Swa8IZnWJEdtCv4iw9f0Bhc0uq5qKvBbYx
	e2U/E0j6aL1G2M4ywtVSJebeYkh5h8gn4amoVfGC7UHXOL2YUtza8ZHqB9sx+Hk=
X-Gm-Gg: ASbGncsxB8c5XBy83My1Z9EhTfclzn3FPZ5+tNb5SXz/0Rf+doRyZWf/Qy9Ep+EYjnr
	GGQ5RCPYpUO31DszifemB0PHcEi0PemoEYWPmJuqQ6DYVMno+41kxJE7sWszf+AzNoUHkw84DML
	1lUA9WdUn2E4AaEJZVe+fnY11XwKPn0Xp1h2RaqsMm0XRVssG8F6R6BeE6IcLArpY8kkg0ZvLk5
	QuE84khN9u3QMWMWDUHVCmlx9mWD4NKzqF8YlbdVUU/eGJS2TJltNTNWLu/hY4Eum2+YcOrKHVp
	r1BY31Ca6dFaahRnE1c5
X-Google-Smtp-Source: AGHT+IEuAZ/31Yw+onuB6dX7P6MBrwUPKEqWPMc6/GLwGLwgBLIZWvMyIkebqkSIVitXPRtyLX0fJg==
X-Received: by 2002:a17:907:d307:b0:abb:aa8f:c9cd with SMTP id a640c23a62f3a-abbcc7f2ab3mr419789166b.28.1739979836924;
        Wed, 19 Feb 2025 07:43:56 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-abbaa56026fsm491684066b.113.2025.02.19.07.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 07:43:56 -0800 (PST)
Date: Wed, 19 Feb 2025 18:43:52 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, willy@infradead.org,
	Pankaj Raghav <p.raghav@samsung.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 6.6 000/389] 6.6.76-rc2 review
Message-ID: <b44dc8f6-7abf-4168-b96d-54f1562008e6@stanley.mountain>
References: <20250206155234.095034647@linuxfoundation.org>
 <CA+G9fYvKzV=jo9AmKH2tJeLr0W8xyjxuVO-P+ZEBdou6C=mKUw@mail.gmail.com>
 <CA+G9fYtqBxt+JwSLCcVBchh94GVRhbo9rTP26ceJ=sf4MDo61Q@mail.gmail.com>
 <Z7Xj-zIe-Sa1syG7@arm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7Xj-zIe-Sa1syG7@arm.com>

Hi Catalin and Yang Shi,

What's happening is that we backport the latest kselftests and run
them on the old kernels.  This is a supported thing so kselftests
are supposed to be able to handle that.

So we need to modify the testing/selftests/arm64/mte/check_hugetlb_options.c
to check if the feature is present and disable the test for older
kernels.

This is not an issue with the stable kernel it's an issue with the
new selftest.

regards,
dan carpenter

