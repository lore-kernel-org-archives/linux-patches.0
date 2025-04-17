Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4C41C3F30
	for <patches@lists.linux.dev>; Thu, 17 Apr 2025 04:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744864874; cv=none; b=CHlg2NvTvSkHVpJwQaE2JUMCuKnm5aPxJdrJBJ/1ZLbLA4jMbSg8d+h/58zkvLyX+OKo/fMsMebMYCB6rduDagTcxVmCesFAtX99napIRyBTgqQhh+z9AWgCgyQEl8cFM0aW5SPcM9QFakdUS4c8xYIY+tFtzCvaB69qUbfrtjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744864874; c=relaxed/simple;
	bh=SPeJW8O/RdyKgGzZdcpOtGY1BN9HvfKy7ydyqtr/PlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RRcbV8UBclPGDr+toIeq3O7WjrBpt1AruaYH97dcRM3AncK0Kt4r3roaRwvbCD9Z237mL8PntXm7nDXTfQh7pxl5usG4NIRr2Sr1Pa+t3SetZiJpNz/rcIFSKP9GHX+h/FmSfxbFarXZUPvji2Zv/SS8oV3ZaFrj+CoxCyj3KQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Dnvo4xjM; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Dnvo4xjM"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-ae727e87c26so235119a12.0
        for <patches@lists.linux.dev>; Wed, 16 Apr 2025 21:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744864872; x=1745469672; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=StTtcZEL8yuxE8J2mkGpzTNue0dDQ/MJGGswTzHY9b8=;
        b=Dnvo4xjMsiYJJCgrJIwoTAPvu7PE2EgUWGlmeQ1MbSg18YwT8C+EVtN5H6dkEJ2lJu
         dPWUr6fO2XPryXFLWQKCWhvBQx4GMO2rqLYyGtbBckvhwW0RtLVz3DkuwQJDSko7R5QY
         NG2MEoZCpHg3ptKFUclMujOv+FeLsbFw1qsjBI8YAZ51UGD8JkiHN3kv56egdTcO9B67
         YAYc48+1HWTknKXNbwDiafkxhDAATGHG2I/zyI6Kfn4E8GeghXsdWeiKztSgzOjcDMLk
         3kHYU/EENOEeBefOYSFlccr6j2B2f7/ZA9JoLF6V+FyC6h2Ap/Nm5mINRZrqEECeCam9
         9ilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744864872; x=1745469672;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=StTtcZEL8yuxE8J2mkGpzTNue0dDQ/MJGGswTzHY9b8=;
        b=WbYyX6qwgVFBxBYisH5HSBi4YqSlP+JGiumHG3yDy5hpK9TEKfrrmOti1FxSrP5hXK
         nvkialK1ZDfqSl/F1hj/wtdZZcRmAw85TVa4VzhsaNOaXrLc91D7JMxpRu4tUMJBAuO3
         nmW1pGnieKqRKeoiwu7pFOej0e9J5y6cALWrWxeoFf1SmIYdJVJsOVr0zzLMizyR+omX
         6VW1nQq6ml2TgfQRixJA8kUz4IPZNIgZZQIkaBk3JlZXTuCdhACdPDEfRRDVazFB8Ctp
         bRlHyYkSejsSm0rZUuo3vnESH4/Z/ULDhxO+Ife31MpEhILip/H2pbjoGKe37HmChGMB
         VyfA==
X-Forwarded-Encrypted: i=1; AJvYcCUwo82T8i4YxPNukXJEJPc2punf4e6tFNqgYwaqCbbbzfWQ/jIqsQDV+eyW7DpUv0CepAGxky8o@lists.linux.dev
X-Gm-Message-State: AOJu0YwKxM+MBqh8jVjQJbA0vWCiC5VkQ67ol52aSKT8DubB6grzcoXn
	AIbnZG42fkG5yB+0tvcWE18tMYZngCU2k7G+lGlhKomDCBSmx0sh55rU3dma28M=
X-Gm-Gg: ASbGncsADVBHuF1iHTa01LVv8VTUSkNlbAGAwJgDwH36pK/UoJuToUZoMg1GTLDpdAs
	wDMc2Oaah3SD8fCi1Cfrmp1ynJT+EIES9GhqE5NHSp2jQci04Uxr3t3DNAdFcSPwQ/WyeukN36a
	/RziEa1FWvemSuPaWj46/Xu8yHs/D11P6eNltxqXQJTf9s3+QoqtzfZicFJmLB0s+fqvq+QCqTo
	tLxnMsFHx8rIFDi/cgCWacGX+FkK4+7a9hgduNCqxRDttTn5iwlQjmt9QuNfsO1z+7it+hOCqqb
	VbPZTlxMo6oeON0YzL/31pdsQdDpWv0I2rt+9DSm6w==
X-Google-Smtp-Source: AGHT+IHSwNZXRlBErUquc9s/KXGJ/tJ0ZSJY//U3+xrEDFrzroEcRYfbd88YerCo8sKgIpeIi1M9yQ==
X-Received: by 2002:a17:90b:5864:b0:2fe:b470:dde4 with SMTP id 98e67ed59e1d1-30863f198c7mr8175815a91.12.1744864872142;
        Wed, 16 Apr 2025 21:41:12 -0700 (PDT)
Received: from localhost ([122.172.83.32])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-308613cb765sm2573852a91.43.2025.04.16.21.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 21:41:11 -0700 (PDT)
Date: Thu, 17 Apr 2025 10:11:09 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] docs: rust: explain that `///` vs. `//` applies to
 private items too
Message-ID: <20250417044109.3enslespfaifjw7o@vireshk-i7>
References: <20250416112454.2503872-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416112454.2503872-1-ojeda@kernel.org>

On 16-04-25, 13:24, Miguel Ojeda wrote:
> Sometimes kernel developers use `//` for documenting private items,
> since those do not get rendered at the moment.
> 
> That is reasonable, but the intention behind `///` (and `//!`) vs. `//`
> is to convey the distinction between documentation and other kinds of
> comments, such as implementation details or TODOs.
> 
> It also increases consistency with the public items and thus e.g. allows
> to change visibility of an item with less changed involved.

                                            changes ?

> It is not just useful for human readers, but also tooling. For instance,
> we may want to eventually generate documentation for private items
> (perhaps as a toggle in the HTML UI). On top of that, `rustdoc` lints
> as usual for those, too, so we may want to do it even if we do not use
> the result.
> 
> Thus document this explicitly.

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
viresh
