Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A4B2517AC
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 01:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769651668; cv=none; b=TWNGxzZjpmjWBRQAdZRA1fr8Av+jfyF6k69Ke3UndDS+LWwYqQ907EyRM4oKyYzqFk706LzFzGHcGMRQCfmCWecDhQ4VkvVZMUCYwfPKe+Cij9KD6X2UYUsb4zcjihC5wfmo4gczqaB9MNtTes7OngOCQtxP/UCOc4rbHCVK/t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769651668; c=relaxed/simple;
	bh=7Bv5MXAF54AT/TX8b27fHhixrRhstAtaoxlfbglQOt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvUH1NvwT8MWPddHobgeX/ZAJgdAQvzwKl6YawFMNbBvo293exnxmeJSSZSi0s2gSyIvniTZlQFYisfpmug3co8csBewPZCbo5xB60AA0XikrnjH8WFFh7Eg1eoNMnQ9tUNb+iHEl2uoNzXLopRFGYtcDQwuca4Q5DbIXfNu/xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OvUF1pZ0; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OvUF1pZ0"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47ee07570deso3430725e9.1
        for <patches@lists.linux.dev>; Wed, 28 Jan 2026 17:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769651665; x=1770256465; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+/pdda4yJPhKCs4dndz1QQHrVODMArj4piI4Sx0+Qk4=;
        b=OvUF1pZ0EW2vErkqO61FhsWFq0/Tn6yt1LWRB9kWDb+cTTC5hND2rwi8mBPaKPuArl
         JhDlgRUX23OWSmQPMlrpRJhusxTBIyTgRai5pgJZBBdYgTVEK9QWurWMXgyHvreyPaJV
         OZqCg6Wk82eIKCYohU9XooUiNz/HuEPcV101yhr5tgb9Rh+WLy6URdlH84QdTaOstIRI
         ohvMW3PfCmyYTF7CP75seTnd6B+OmYeyB/MF+hvtsVC5HHLRWhivQABUq41IEFtYuzDj
         enuhoB2HkBkQbf9ulHvjDTafSenmvx2z1akl7YlTMk4y7kZwfiKWHqVxH3y15qQ6oUVH
         JGww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769651665; x=1770256465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+/pdda4yJPhKCs4dndz1QQHrVODMArj4piI4Sx0+Qk4=;
        b=Td6a1zwlLvym7FA6PfHu6sWUBRRhchDawWQx9nBu6xPomziq89wSOuj2OyVVFkpLq2
         AwxPJAdHlPT1e+Cfnv4K/Pso7HClhtWdKrQPfRZrZiztqaq7IT5EZkbmdeuaLB4xRoc5
         ++qZ7V2OfGarBF8nSoCV9HdTaKIUQGkHMW+gU7TMfaxRN5ve1ja4W5ybY/ltZWJNMCo3
         7YI0f0AYiT8X0BQ5gRAT6pk+OSGpEsqjCMptE5UuITjE9wqOTGkRewGJ/X61MC4enMGI
         8RetG1KNXgwnikpBCm+mKBalcx888VBqzai9maaaFp9PPsQovNvM/DHz7nZ63quMJwiQ
         +XBA==
X-Forwarded-Encrypted: i=1; AJvYcCUL9Ot4WJbpbjqwFN28XvPJo5jtkzNROTvvWmF4lYA9BHWNgl1jSBfdXT9nMcysvsorfSYexi9j@lists.linux.dev
X-Gm-Message-State: AOJu0YxpjRNda7hlxL7JoFM2Cyk47SQVxJ04SeTFMI8uMnMbd7RAS99t
	/1itxEMeTDZV7/6HhAdsl0o57Jus3Sxk6GhYFladzasyuXv+LH+f0NxsDsmobrkom8nfZCp+Puo
	0PdHi
X-Gm-Gg: AZuq6aJXMVBRzsWaTwvr1TrfZOwAOlrjw+pJrL24ZLRx4nXMngQ0wuWzNgcXOYVCjIv
	ieXzt4SrihSmKLn2luaFPs6wqIEDsgN/3RQOBvtkQ6amULDzzIsNhyp17cybIEeQWzF4w9bE58b
	Fh39UxPebpcmAxean3YTVGbDsZpXjC97TLQEQc5nR8b6F8VRKKgcupDKJazluOxd5u0Og+zwbl0
	ERryX/ilcjBlwdshOObxRUy6FJDlRyP0dAiwo5yCkaT8p1p4i90iewzCDpf2hASSxnPhbCAU7D6
	sGmpjup6/zDdVV7pJJ1aHxnGJGhUfUOEnX8oCSnsvcrIGllCgXrNENo5+fcCNhVvz+TVgyvoroa
	GgH77rUUkgcR2GZOEMZ9S0/cp1fRD8ggx1k17GuRc/pR0kJrAv0i2cOl7DE7p13NSf9fO8AHNGr
	97k4PMpA==
X-Received: by 2002:a05:600c:45d0:b0:46e:4a13:e6c6 with SMTP id 5b1f17b1804b1-48069c7887emr77995955e9.19.1769651665413;
        Wed, 28 Jan 2026 17:54:25 -0800 (PST)
Received: from u94a ([2401:e180:8dfc:3cc3:8fe9:e99:6cdf:244e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a8bd76538esm6139395ad.76.2026.01.28.17.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 17:54:24 -0800 (PST)
Date: Thu, 29 Jan 2026 09:54:17 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/227] 6.18.8-rc1 review
Message-ID: <mqy5kxqjgc5ec46hkh7ddn5japl6623no7uo4ks2k4w23grxdr@3stxzreu523o>
References: <20260128145344.331957407@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>

On Wed, Jan 28, 2026 at 04:20:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.8 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/21450963930/job/61779347640
