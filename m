Received: from mail-ed2-f0.google.com (mail-ed2-f0.google.com [74.125.228.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14ECD3E556B
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 08:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784795840; cv=none; b=sNjmh4wlvvYFYmSAl/OOqeemBoPcb/gXoJaallt24j8p0YqcH3VWKLDvKVYS7vTMmnW8sDLgNZ6bnUn7TU2JvO4zQk7/r9LLkD27r2VqmpjVFsukzLiDEUIHRiv6nDahXW4a9L1Avh9+reea0IWb+cSXNUxv2ZF9wO8QEXicAeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784795840; c=relaxed/simple;
	bh=rYCq3Rux7nq1YFxRc0XFo1MDW/UFjDG68g2Y9h0HDcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JJLlTuhG4i90tAIK1DsNxakbPOdVv5tWfyBd2A3LUkK8qdUZgE1LQKAVNXID2V3jOIUQ0foe8f2nCfkTHiUwXhekXiqfzyYG9R1XdgW06eSTfV8DxMsPRTZPUnKQZNMiKzMB3lJaH2v+Flku/FU3cXYYUnFxJbE4am7OpDpxIeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GbWH+8zz; arc=none smtp.client-ip=74.125.228.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GbWH+8zz"
Received: by mail-ed2-f0.google.com with SMTP id 4fb4d7f45d1cf-69846db5d38so272184a12.1
        for <patches@lists.linux.dev>; Thu, 23 Jul 2026 01:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784795836; x=1785400636; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MoMNc/FFoprTITsRfG0L5TdIxxhYdIk+KGTLx1gAHdQ=;
        b=GbWH+8zzWcsNx0kH6tlUE/TeW0GikUlUjWZ4bLR//TsxCmhjkZJDlqCkGvFNhFMoHe
         AYfIdHvJMa+BFwp8XnUNsOsFPLWW6UvDS+nn6XxWv1voqDsqyzHuhAZ1G7l47uTE8/Bh
         ZN6ZAbKBtJpzGyMF5a/QvVTTntuvkthOriVCrEYzN9qyoaO0aGjL6wEJIrltw4GeqMx9
         AHeyoB+rtuLtO9H+i6QW6E7r+PvZdlAEVXc3tXLqxOb66718aYKKN5Q346YPAXaDL+t5
         0DS1wK2zbEUqMrZzlHmhdkpxl6yvk4GZWoLOEGNHHToAwhYA24NNWzmulPp33RHeRBAL
         npUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784795836; x=1785400636;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MoMNc/FFoprTITsRfG0L5TdIxxhYdIk+KGTLx1gAHdQ=;
        b=INMeS+xeJj9FahUajhyBTMLNokU0uagdPcklaUiQGJq4FSyMjud58f0WEwZXr766pG
         u+WjIrbfrSVlMhQ3peJXN3xMyviWY0LmCHXeT/f6DelGabyoD9DUaw+DL234B1iQzToW
         bju6id7eIZ4kBKhQ5owywdbcOf6/oDNmJJVgtHz8V5xaHeMZqJcpMe2Wtq+YuztWuBeG
         hHdAzILHSen5tgNeCwcmTDvuTzaIt/x86abwETaJpq2jHlTx0IrBI3/jBfF7lrhzY7G3
         GJdPWhSJWdbs+KD5tD95UmD+bnIivkP81t0mFdels79w6mR3UhgSudgKE5iLvVIUNFJN
         Jn1g==
X-Forwarded-Encrypted: i=1; AHgh+RoNJx+kkq23/DkKGZrSqSozjDUxJkscbm+LcuRwlfQ4NTF4yPs63rmcweSDCbBaGO470Wo05g77@lists.linux.dev
X-Gm-Message-State: AOJu0YyOseGYYRTR+VBnAiSbBDtSwECB7G7loEOzRIPQcNorTVzx7OdM
	s/FDva6ify8slAbZl/zuexKhBTD+/iNyhAegUwcq2j6TmiZT+dpSJ3zkFL4/DteCTRk=
X-Gm-Gg: AR+sD10Q5R96GBZgDYus6/YenBtq/WkCY7O2d4IE2kkxYsp1Jia3mdz3zzU1T8LUqEd
	3/5Gig7Eu+bShWwQogEdLOYkbBq2rHbqD4s90okZhJUruW1aqkTSESM/6oiGBzdyflaBDh32fV4
	0Bsw3z0MrO4/TGX+0zGvP1k4TWfxIgTknZMgz1mhIFAEz3SGIrbnW9ATV3M/z9MSCD9t/Sw7i0c
	1Ni0jvrAIYdqtnqXYOa7p6MXO9i7nEKTWgnVLY/cdG4TvxiZdfxK1CbhgaZBYe30SkzitHMp3MB
	P3IebBiZ10qoON0uN1OpsZ4UhrXo/Z/THw0mD+Ljk5ZhMy7we6bMGcdMeO/kPAlkVvAkv0jIE5X
	uD6yme882T8tTfnDWRsmMw/o/S7FJLXNQRAHoBPXjQduSKpSP0T07P2sOmygN5y9asFvu81Xoa1
	U/2jZfCj6mwlWsiDnvmrw2hlHrojqXxg==
X-Received: by 2002:a17:907:9629:b0:c15:de33:a018 with SMTP id a640c23a62f3a-c1c50c335cemr97901766b.45.1784795836249;
        Thu, 23 Jul 2026 01:37:16 -0700 (PDT)
Received: from u94a (27-53-97-40.adsl.fetnet.net. [27.53.97.40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f38757esm28977445ad.75.2026.07.23.01.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 01:37:15 -0700 (PDT)
Date: Thu, 23 Jul 2026 16:37:07 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 0000/1226] 6.6.145-rc2 review
Message-ID: <amHSEwZcutUhO5tL@u94a>
References: <20260722143258.264584003@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722143258.264584003@linuxfoundation.org>

On Wed, Jul 22, 2026 at 04:33:42PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.145 release.
> There are 1226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jul 2026 14:31:21 +0000.
> Anything received after that time might be too late.

BPF selftests compilation is currently broken. But with [1] applied it
will build, with test_progs, test_progs-no_alu32, test_progs-cpuv4,
test_maps, test_verifier in BPF selftests all passes[2] on x86_64 and
aarch64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://lore.kernel.org/stable/20260723071334.39630-1-shung-hsi.yu@suse.com/
2: https://github.com/kernel-patches/linux-stable/actions/runs/29987147891

[...]
