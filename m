Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B89319858
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 08:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772526125; cv=none; b=bF6GQDG4g8KtNK5TqLWla0bKbkePyafQ/6MM5TftzBK+EEugaaCC1CKAqBHk6Rt62HZZHoUefETQcyzOG67hnO2KiijTdvgFLZIjI30uO12Bu9uspW7wkEZkNhhr9zMDOpoFOeqBLgEXntCTMKLCHaY9D/lALgeM6qysXm4HDjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772526125; c=relaxed/simple;
	bh=PUFB0NUQZXnYOsuV3qEWNxl3eeGZ5hBfVsFaZtUzQO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=omrmnzlh11ex745yzIozsvc/dJe6ulpOx8b6X/8IIbEdQIOi40S/OzI6MCoMovHTRVPNgCRkbIf0f2//ENcZdEDzSqrwXEjx70XPwf2oWwTERSiP6FcS5aHvktVknRXzdV6Zg6+fwT0Ufn6KlyolgqyynurMzEzQ4RI+FUckzQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A+cmY3GR; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A+cmY3GR"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4836e3288cdso36781035e9.0
        for <patches@lists.linux.dev>; Tue, 03 Mar 2026 00:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772526119; x=1773130919; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=On50ef0D99xDSDSa3UlsoEDTxBrrk+dP52qqCJlGCsQ=;
        b=A+cmY3GRBr0vE2uu5IjUKXfOgQEeB0Ve35SbOQrK16jhxNAcJ8ct6KPK/mWdetRn2K
         uGZxPySqSFgNdl+JsyLnrzGLfy5ax03d8LL/OtAgEyvlEwd/pBNuJv5ViQTl5S+jEzXE
         y0l11LGidBYV/ipXCftGuR17ldqeUnOW84X2VwjjELJ3s4y4eLBsWfVD/WUAeqkYdgPJ
         tM6g7fz3s3182d5d6zFTZSYIFTIIq0UJUd4/h3XwuoOfEoIs00Q7L85+uaRD+iEe58lH
         JnD5WVZjvfVKd/YKgvp57zGMzXcoC/DflKiT8w9l6y887XGhTiWUUVEp78jxv9TA1vLH
         vlGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772526119; x=1773130919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=On50ef0D99xDSDSa3UlsoEDTxBrrk+dP52qqCJlGCsQ=;
        b=CfIX6ncTuipl4jiT5vDcMPA5M8oXOAOZg+EJHHUiG2tYQoGyDnkaLQSuOJiiTIGzFJ
         uIvdyNyPXDtpWVycgMqmRoa6g+s92g66TLHeXaLNLUa+ZorrjWRF/QUEmfs5x5Brnd0n
         7XlQmMHkZ3npRMiRRRd6eyS1P7LAyylqKsCAaj0JkdRLM5ifEhf47doixwReNj+GUZlh
         98GcO9VY+VtihfZeJheB3w6WwyUnr5dVdB46dZz5IiWQb4zTMWDAVQ1unR61jsS+sLW+
         sd15dBnjhab+BPThHSQoCbBikBEOYq0NkmI+ybQbN/6ba+uRug6abJ1AGF9zYgxNEKku
         qjtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKF/Z5UYrMdiyIpRqbdEFP2cKD7RzL5c0kmiHy9akBOR/+VEimwjQWAwwirg2mNsXlQj4RaSwS@lists.linux.dev
X-Gm-Message-State: AOJu0YyhDdp7qhrloksIgkLdbGRXS+E025ijsGS+PTWDOgpSU8C62lgO
	Y5a7Nu8XbTFZFFYkM4z118UDFKlsAF/r9YXX/kIEQ8BD+j9tNInCWISHJCHVIhkBva0=
X-Gm-Gg: ATEYQzxIbRduqKMzFDxtnSTTSTvGA3EkuDGBj1B3M5pHHOk1CR9QV3K9OdWCiyrkEB0
	z/D6GQFqid5dxhlqg6wE4Df7bXnAXeobNs4ynYxazz7lH/YSX4cZvl5CNXFE1ezC5t8S+/5RdkU
	88UZr4wBsJdMNoVljZT4/f5XMewfJ/83inuLkng3kcIusxUMmjF5vrc9nEUN3KSJBg0E/5Rp0aa
	oRNGaK/OZovqObLJR0aSepJ6Z56NnFhetC1rUjyZZ62fox7SK8N4RblJUEDtlg1GjkcoCbEvb3N
	J84dk9KHIKpblZLmAm/hyWdq6e9DDozT5mRn9sx531vn6yy88aFPU8gQSANZj0111GOioLzVov5
	gUPj7IBRmbVJmE93j75JetB9b/49Sf0WqzDF57/QQGWjMuZEaDf9B1HH6BpbHcnZw8tNhtNOdRw
	nTniIIYETYM0yP7XKV+Xc=
X-Received: by 2002:a05:600c:648a:b0:483:6fe3:bb49 with SMTP id 5b1f17b1804b1-4851370354dmr23706105e9.0.1772526118662;
        Tue, 03 Mar 2026 00:21:58 -0800 (PST)
Received: from u94a ([2401:e180:88b0:32b4:4c71:af95:b813:9623])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70fa806295sm13805656a12.16.2026.03.03.00.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 00:21:58 -0800 (PST)
Date: Tue, 3 Mar 2026 16:21:51 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	gregkh@linuxfoundation.org, patches@lists.linux.dev, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/956] 6.12.75-rc2 review
Message-ID: <d3mqwnyunzez4fh5mtaevb7wau662m7kvzpl3ykwgcvdvulosm@al3hgsanxu7r>
References: <20260302160918.2520730-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302160918.2520730-1-sashal@kernel.org>

On Mon, Mar 02, 2026 at 11:09:18AM -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 956 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:04 PM UTC 2026.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/22590800040/job/65447954928

[...]
