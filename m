Received: from mail-ej2-f3.google.com (mail-ej2-f3.google.com [74.125.228.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F56386450
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 07:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783062853; cv=none; b=E7CKx5eawZmAoxM/u9jZOWqf2gFrcFQH0YYtCWuLA9y8pud+gy2tYFVIvIygsj/iiNYHKRovtNLc+k8bNfJOn+urrCpLxJnmLG4voZFTfzJ/52HAblVIPX53+t66oK1BFY4q1P61leuskmnxfx6UYJ0UJfLNfHgkU5C0TYIan7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783062853; c=relaxed/simple;
	bh=YeT+efPB8SN0Ble6knLseD936dKAeHF4GuXCsQVS6MM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gSc+HuKAV2vZHHuHEE0rtuAShIn6DgfhmFwGb3filBAB7Do2SK2SgPqMUo/e38RTwoYgCz6jCjw8SShXYYchr1x1sOHVTnXbGK3984/P6GFGjyT1cl1wxeXB9CBaQNQwXyLq7MgwS0vrq230KMJHHMNcQamUuiQoWK25e/sXjnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IITMPGyp; arc=none smtp.client-ip=74.125.228.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IITMPGyp"
Received: by mail-ej2-f3.google.com with SMTP id a640c23a62f3a-c12986ea776so7249466b.0
        for <patches@lists.linux.dev>; Fri, 03 Jul 2026 00:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783062850; x=1783667650; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e43GFmd64lmRLV/cd5SLNbiPWjf6jygsiKOe7E5GoMo=;
        b=IITMPGypqhGwdc7Gj553EbEhZ/aDO3NAzk4PkogLThCGnFYTWBpgVCl3vuJfU6QCe7
         AIlmFfeBq791wWdrsDXsCXv3s1cayZll0W27LeYf2B/bwjQmVbPAjygPNVpFVycGp3YT
         aBDa3kHMlJ9AhFbBlc4QT/39sdg6TJG/Ocoyz97AjIK8as2eSrOGKMK2irQ81T0hDXgN
         s25OcqWgDhzlQE39kbt9N3BAVBr4VV84kcklvGhokRBrfH1i6emtHaYhYw2rUp7N8Bum
         7Vg7fw5KTRRErFlVVleJLkpFGQ3MTVP07h0Cr2U/HTeYbpQOXwctCexelhoJSjXNQfms
         Srmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783062850; x=1783667650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e43GFmd64lmRLV/cd5SLNbiPWjf6jygsiKOe7E5GoMo=;
        b=Y6+twdttdCeKTaQx0Z80V1KYatyIrUkoD9ZPQCBSN9PaEnU7oIfhgs4pi/pvKa97Js
         st/FMDT2uhLnSNuCDnVJYaciAU3xd20d6LnC8yToSAjJ9OxouTN5aiqyNZyFtQiLY4gF
         DWgv2iTlLrJ9LffhWf9KAoA2NYzP+li4uhx3FIj9Wp9mSZ7v9e/Rj371dRAlzimjFo4d
         Sshhuxsi977rnod1Vw80AIioG4oHEFlQI50x3sC0qo+MwT/P+kGvTsKFJghvlJIz/Les
         ssQ7TdSwieRWB5g+0ehPgPkKn+UUzZNsrv79x/UTvkqBvfnHZawMfH2UPyoPLchD/fEs
         ezmQ==
X-Forwarded-Encrypted: i=1; AHgh+RoKME3pSkrQJfq873Nzi4eGNCwUxoMuD+M6P2J0dEhwE0+LyoOAGyKaGlxuK1vbHNvwE3PuwVx+@lists.linux.dev
X-Gm-Message-State: AOJu0YwN05mffFD97RlPYyf3+gKpS0qhQIXhbBUb0IcdsHLNEBRzyV7B
	0g9MnYAbidJef/kphVUmj3Sk+rYYLCm4x26PenoxY8DOXuWvGar9oTUV179j+Jycfi0=
X-Gm-Gg: AfdE7ck5gUHDm4v3sFbxUGepK0Kg4RgpV6U9aa2nbLaxUTZ/AUhs6Ft6R+LuoFme7Fq
	8SilIXbLgk4C3r+wWmpE1w9OaNk6Lhg/MuDqGXhmktaQ4RzG2XNIr6VAXYMp4ABcodqgnkleX5a
	q8w1fYJl8LvC8eDmPWLxAg2Pf7qwj/cgbJvL7xHhg3BB0KeyPV8gfzsF1Jt4SeCscEMJLvaJe60
	dtKGaRpMmFQTwwb6eteB6F1TgTzoBbIwI1a3VmWV/fdivJHbIUW+HdcJyRm2AH2YhhzOy5eD8Ma
	LlIhT38yMPuzOdQmw9Wkmti0m5svCRZCFQsFHoOYCcedg7bi7Ttu4KfXBD+Kk1PwY5Lh5hebA9x
	XmdVV9RoZH1YJxCAViyCTUvT42pcQGjtVLFY6cpKzz2npVQAymokmcRg3SMzGo2JhTkdbkzUojv
	hbWdCohqr+XHmws8fqHlyft5xXq447CfIK
X-Received: by 2002:a17:907:c244:b0:c12:4a17:ef04 with SMTP id a640c23a62f3a-c12aa13d082mr470072866b.33.1783062849984;
        Fri, 03 Jul 2026 00:14:09 -0700 (PDT)
Received: from u94a (27-53-162-24.adsl.fetnet.net. [27.53.162.24])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a3103ad433sm3724083eaf.12.2026.07.03.00.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 00:14:08 -0700 (PDT)
Date: Fri, 3 Jul 2026 15:13:54 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/175] 6.6.144-rc1 review
Message-ID: <akdhD_Z29wdMWxG3@u94a>
References: <20260702155115.766838875@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>

On Thu, Jul 02, 2026 at 06:18:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.144 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps, test_verifier
in BPF selftests all passes[1] on both x86_64 and aarch64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/kernel-patches/linux-stable/actions/runs/28642644980 

[...]
