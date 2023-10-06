Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FD45CB5
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 07:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v5M1tU6q"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-27760c31056so1248404a91.1
        for <patches@lists.linux.dev>; Fri, 06 Oct 2023 00:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696576795; x=1697181595; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QLbD36lfGshKBD/IHq1uy+catxZoLx+hDosAbEWMfB8=;
        b=v5M1tU6qtXSTOFJMcoaHJlxzFR92uACnn32sRcIE8sKerfEb3R+v69BjPrzpwOx+kh
         OztZ1dVm6qLhscJ06X5hJYmQbSDh+tePYSm8sImPyJ7GkbIQLNp0JivKbKXfGz8nIiMv
         X6q8LYOI59VG2ERr85i9yQnotWwvbYDmNEToWvQMU4dlmwyBFAv0r1aNX/QElw37FjVS
         Sjs9lgUBfffUZqPlsZAN2VMzfUMlC0mjL9yxumM9+nKN8NQZTJM1atEQFUqGGrlu4wak
         wm5kcozXFcDX7DN2NNM7h0LBsNPPlkcoTy8fYHCBtY9DgOcfjBPgG61zddGm8NJVzsC0
         /0cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696576795; x=1697181595;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QLbD36lfGshKBD/IHq1uy+catxZoLx+hDosAbEWMfB8=;
        b=xKRVtrxIp4G66A0h6ZWosaKsk4cijQ2lJqce/VaJV0cQPqPQp1eRo21hvWxoFo9kQp
         rA7PefqSLbUKPg8b2cEwapTpxhQ2stHQrnQ6sYlOXSUAWXzprqO91ZlRFyhS3G0Pb2yT
         /V2xL7Tb5BGwBwihbvzp+k5RdoXyQmEe/beFo84D8XVOwo/dVFJFd/1fXOVT2vN9apHZ
         6y6BWhIkUHNTlOpjV8VSdr92LIC0A/QuV8ob4a66RtJEsBUwWLbfDgRIcpaxyy5cGM0w
         o+0YlU0b2VHwSwgcWKYzjLKlBuPMc1AqFA0hsBU7vS1iJn3pljWsPrxgOt4xYAbqZq8a
         01zg==
X-Gm-Message-State: AOJu0Ywd3p7fOQwpediYpHnGU11QLZ9S77vdr9bPjIHD5I372aFptV5L
	fm4DhmMznwFsNFgjUBXSsx6r3Q==
X-Google-Smtp-Source: AGHT+IEnIZWIPATAMO46x1U1rXCCVIqKIMiKNxn+ZYVTiXHcvpjaRtDDpI08eGoBu+OpT0LvVnZPcQ==
X-Received: by 2002:a17:90b:4c07:b0:262:d661:2963 with SMTP id na7-20020a17090b4c0700b00262d6612963mr7011516pjb.39.1696576794865;
        Fri, 06 Oct 2023 00:19:54 -0700 (PDT)
Received: from localhost ([122.172.81.92])
        by smtp.gmail.com with ESMTPSA id 21-20020a17090a035500b002796494b98csm5132242pjf.37.2023.10.06.00.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 00:19:54 -0700 (PDT)
Date: Fri, 6 Oct 2023 12:49:52 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>, vireshk@kernel.org, nm@ti.com,
	sboyd@kernel.org, ulf.hansson@linaro.org, trix@redhat.com,
	linux-pm@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] OPP: Fix -Wunsequenced in _of_add_opp_table_v1()
Message-ID: <20231006071952.b43vbnrhax7g6vta@vireshk-i7>
References: <20231005-opp-of-wunsequenced-v1-1-778815980a8d@kernel.org>
 <CAKwvOdmhtS6LAcckceXLftKeqxthdHEEi-zr8EiOW0hRYwsjEA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKwvOdmhtS6LAcckceXLftKeqxthdHEEi-zr8EiOW0hRYwsjEA@mail.gmail.com>

On 05-10-23, 11:31, Nick Desaulniers wrote:
> On Thu, Oct 5, 2023 at 10:25 AM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > Clang warns (or errors with CONFIG_WERROR=y):
> >
> >   drivers/opp/of.c:1081:28: error: multiple unsequenced modifications to 'val' [-Werror,-Wunsequenced]
> >    1081 |                         .freq = be32_to_cpup(val++) * 1000,
> >         |                                                 ^
> >    1082 |                         .u_volt = be32_to_cpup(val++),
> >         |                                                   ~~
> >   1 error generated.
> >
> > There is no sequence point in a designated initializer. Move back to
> > separate variables for the creation of the values, so that there are
> > sequence points between each evaluation and increment of val.
> >
> > Closes: https://github.com/ClangBuiltLinux/linux/issues/1940
> > Fixes: 75bbc92c09d8 ("OPP: Add dev_pm_opp_add_dynamic() to allow more flexibility")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Thanks for the patch!
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Applied. Thanks.

-- 
viresh
