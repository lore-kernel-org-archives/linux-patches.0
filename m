Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6006335064
	for <patches@lists.linux.dev>; Tue,  5 May 2026 10:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777975507; cv=pass; b=Yf6WuxzZ1dCPOd3OHRu/G7EP38TvgGeycPHxPIA15dqX1lP7YRRAklUsdhKQonn0kCYMdxXdxwkMBmhzX6qacUgZoU5JU1nU4Y6vfL/Rfxjw5DVPDAul35KvITypDAubyS6w4Couk3+PSspl9Io9V2HObIQIveJZJmUUY57qcTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777975507; c=relaxed/simple;
	bh=XexUs3O5JcQ4u9Xdflg7ex0VD9OVSFnQ+ng7seBz/HM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k+Txzyd+urFp3qcmj5XqEMyApJ6DAQBoVZYh3bIAzYUxE+lR7WTFtr9sEbsJHsgsXA3AtqoGnIGFiHE8VUBq/uGZcGym+fltACWrbb4qtOKmlngqAzwSMlcX5fqLVOQgW4QFflFd4+D9qAfgQavz0+TGJ9VwVEe6sn6jWV3CKg8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ss0qLo00; arc=pass smtp.client-ip=74.125.82.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ss0qLo00"
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2bdd40d3c61so6391963eec.1
        for <patches@lists.linux.dev>; Tue, 05 May 2026 03:05:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777975504; cv=none;
        d=google.com; s=arc-20240605;
        b=ZHxkWXiAX+a+g2/y7Ko3AG8wTWeGlBzwGwZQDTe6NnNsALa0JIVtRNQe+ZOsFs9ZXF
         PNngt83mILouZLZZ7/+P4cpO0U0PMrugqp79hZy8ircvq6WuJOl7QiWpZQOSfZokUJpd
         w0o4TVGGPdIyQJe5y1Tl8xLSmlyZ2uOXVRnLC8Pf3y4rV7G61X9Yu85DGmKL64MpubMK
         UzcmIJN26e5U2vF45QJDpZbwSSLzH/b017Njsx7rWHMjlVMvx7rtZBGhjYnOq0R4nn0B
         IXz7+qvVzm2h+zUjnsLE7SvX+/TBv4wuOH9OGHvh6NwAWRzX75JlxpbbI56U6eLMFJxK
         xYRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=89ZQvEnB/Na6jCKTloQvTLWsQnIxqnHe04nVB2+E7Rk=;
        fh=rjfnaLjVdN61oaAMo3oVM/egya9OO7wpiRX9dYC1Uj8=;
        b=I3CGmT1HBxVvVDj5qznaVfZ88/GGr6xnnM6X2M/NAcbG31gIQYT4PNmXYaGAu1fOmQ
         mtr+QsE/uLKXxpMBRrZzp6zwAL5Lj0towYCcgipb6UpKTjj3AOU30d4UhsjeKmf9XCe7
         5Pb0uPdMuGN4psbNfDgG/jZ0x1qTp+KbKzWxgnLpV+z6xLfYLpTVI3D39QrhhWN8lola
         yy5xA/kCYW/SGqxnNtRf+VRJi+KRN/c63J/GxlgQIimUCaWOwEJHafttnqXtj9yFmjYE
         T5QqW4OByGM6s6ywfiPRrQUKOMImtVLjHPTPsEDQpdnkwi+0TJY4jCrHrf5Wvs1HYFWr
         /pTQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777975504; x=1778580304; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=89ZQvEnB/Na6jCKTloQvTLWsQnIxqnHe04nVB2+E7Rk=;
        b=Ss0qLo00nVeq+fRkH/wv0Fh6M+MkOXrxtLgkhr810PETHccWSrmFRgCxMKPfNgwdzX
         HHHnbd1CMtOsbISRxBQbMi8j+SQeHRQsV1Apz+EfWkDbDufNcljk6VBS6E+0CDElSoTx
         xnKAb2CB7HPrBMMoHbSxRAESeG99app9lwiH7r/6082nexewrUrF7xiWJS1ERW9UUTS3
         AMjBSSflNgrSQEqFELpMVtj/6o/ZcCbDICSPW/4tmH+z+e5WX6XE8MXetVumCXG17MuE
         z1rYiRLV/M0m9WkjPyEJNMA5He1HK5eTyULFPKCB/BtdY/e7wyKfmPvv29eLPwGx1bNR
         5bUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777975504; x=1778580304;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=89ZQvEnB/Na6jCKTloQvTLWsQnIxqnHe04nVB2+E7Rk=;
        b=WXhqIflB2PeebyBlrsViCqhi4jAUM6iT0FnBPB0MOB/QFWGfSkBXguZzPpGTJg1QqR
         zXDXSFeOPl4UFhW7IjaP6otTCzHCge2XRv8JR9L1wZa6nWompmzvpi2dbJQ4ShYijiTG
         kDmv+a6trgF0060IbIXXD8xBXYmEvqo88FWFCuj+b71DTT3ftye2cFNn37I9yb97DJBA
         RjgdrdFLHmt+Dtrfc6yTHQrjhjfLfAVfh3fwp9ruKwiK9WbWUF8Rza8+7rNylLNm3wCu
         XSx1gONGVC59+tMeIo41vEQETt/U3//GWMpgJzeg995wPIwB/d8AY6LvC44ovUGy04U8
         BXWg==
X-Forwarded-Encrypted: i=1; AFNElJ+HGdd+yqLZHdWQjFlMJkYshAnhAND4SuGORaEZtUppmLR9NWAnEEWKupdt4jdvj7NzhJwolhSe@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/WtT+J4c6DV1jP+W2+J1SaGbwEn7bMbf6tt/MVF/eGoL4l+ww
	bzfKRg7Uc/R40opROrjOzosj8bINve5Cp0OrV8k1CULNJ4z72DSA4IvfO19Ojm7KKoVFsDW4KXg
	Z+y6Sw5o7DpAewBpRodNFxn9qJ3pxXjU=
X-Gm-Gg: AeBDieuuJ8E8FyCQ4XgyhN8PYMyNnWmXFC6WXPc5opI6OgGUKX/cV8hKcGgIxq73k+M
	rlq6SEQYPeA9MR4PJFk1msA/a/2Nn30FtRobvzbmBr07q7v/gjnACdER8rShWJvw1mLpZ9XD6zC
	e7W28cuHTJ4HINshcV0AfyThB74upWVn92rQkZDxTrxMNYMZWqlxC0ISBksP79As/iSePSNn345
	pI+PmhFABwa2AZxnf/gDTsxgbpO5mK/ZUiew+ipXUh3Pxvd/EeuXSzmheUlgKbJZ7Tp3jNY3jxK
	HDR4uQqh5LOc4Q6oJRxUIcR0flUnYQxhdPW+EKqYUxmXUBygapU2TZW+FXQ9GOO9c0kcwo6RcZE
	ZhmCSjiA8x/cXrVbwC0KvAglmCSloQ1HzRVPITBDVWTxa2fzfNyo/XpqiZ/aQL0OjfMScO9HAVz
	PFTTSLMEjKRVZWX/hGSM64y1rRc/fHT+vfdWYhDYDYKL1hqq98
X-Received: by 2002:a05:7300:5722:b0:2ed:e14:7f5b with SMTP id
 5a478bee46e88-2f40a18f7a9mr1151611eec.31.1777975503761; Tue, 05 May 2026
 03:05:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260504135142.814938198@linuxfoundation.org> <20260505095136.246649-1-ojeda@kernel.org>
In-Reply-To: <20260505095136.246649-1-ojeda@kernel.org>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Tue, 5 May 2026 12:04:50 +0200
X-Gm-Features: AVHnY4JT-cjkqUsEG3M4nzqCxjgyAeD4QIKJnnEsRIfTNKrdc0pPZlp4BBbDtvM
Message-ID: <CADo9pHgoHWTP80u=bt0mNB4fsYcOELs00ToG0LsZddGiWAb_6Q@mail.gmail.com>
Subject: Re: [PATCH 7.0 000/307] 7.0.4-rc1 review
To: Miguel Ojeda <ojeda@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Luna Jernberg <droidbittin@gmail.com>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org, 
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com, 
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org, linux@roeck-us.net, 
	lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev, 
	pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com, 
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

Den tis 5 maj 2026 kl 11:54 skrev Miguel Ojeda <ojeda@kernel.org>:
>
> On Mon, 04 May 2026 15:48:05 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 7.0.4 release.
> > There are 307 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 06 May 2026 13:50:49 +0000.
> > Anything received after that time might be too late.
>
> Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
> for loongarch64:
>
> Tested-by: Miguel Ojeda <ojeda@kernel.org>
>
> Thanks!
>
> Cheers,
> Miguel
>
