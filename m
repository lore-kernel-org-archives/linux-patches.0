Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA2A396D04
	for <patches@lists.linux.dev>; Wed, 25 Mar 2026 10:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774436199; cv=none; b=OPWkQ9kRNsqF0ndvR9aIoF1DGLs2D1bsRuIAKh0nY1SVHY2vbni9oAJgHpE1f1MZlN80jrKp9QEoFqnGsRcR9NAWfeJP1r83VKsTP8Ux8oS8Prj3wyq1BdY3iwuLqze4nd8uLMZLRXVhZvlZiOMgk6lTmXt4vNmL2OTw8fpRTu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774436199; c=relaxed/simple;
	bh=aThMs7CHryE7CkoLYXzvwMpdt+joZGHszDjPdsusEdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dwp7CxRx1DiZzPQ2xrLPoWwWEzgFN1WAS12ZdqQxsoc66C0CXuFD5KUiHAW+h4OgZIIZPggEXQDxx5NDitgpdaI/FgkxuNZRUBnTY2eVbUKJ6ChQbLhY6two+4l/11JagVh20JGNlK5yQwMwYscNWIWupj+6u8D2ADIL3xWdO70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BF9ve1HY; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BF9ve1HY"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-486fb14227cso24388855e9.3
        for <patches@lists.linux.dev>; Wed, 25 Mar 2026 03:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774436196; x=1775040996; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LXy/m9lI8oK0hGzNGrxRb/OaeFsO4shJQYX1qu7UPoA=;
        b=BF9ve1HYE3u6mfHu011lAodvfFe5Lt7AFZwmYq0we2xZr5+HczscLg8YxMC11xAbua
         YzgNowCUOYsMw5+r66eJs7Kvll4AhU4Kb2D/d5n39jeraSpmdrN8bE99f/dVeJNy8geI
         KLqQw9A3cHcViymWRE9QGSPNWKsdH27t1FYw79BW+oOZMbVp1nyDshxWMNP9XPOAN+W2
         nr0O5j5p8kGS/0JdcWtzNfX7WKyRiuXpTU9j3Hkg95Y8jZbEV2etKIU/z+W79MWKSyln
         jtcUgGnl2KSkxPcYfOZx3FjQf5N/KbptWVoeQiNgd9+WNy2z7caUjBo0eTyCwc6mZ9et
         cQWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774436196; x=1775040996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LXy/m9lI8oK0hGzNGrxRb/OaeFsO4shJQYX1qu7UPoA=;
        b=IMTQf7d1UYi4J7pdJuWlrE/BiLL+m1znSO9DpRO1QBKNyelmUDg5t5i7Zm7RniAV+f
         IBnz1RX9Wzlfo64p3L79ndOSdzxU9p+Er+VXn+EdpVsbg5O8gUIOQAkE8SozBIt7LeNs
         f0bhx/4QdHKOo7yefGIn6XFHgL7dKVGoDiTVdtwwUL3FcLtxhp3zUyjzgmQFW1/zbMjD
         IPk3/Nu3Aw2Ic5k/kYurBz0JlwUdTQB3H3imyh3Ap/eIE0q1N/K7nKal38vK83grnsAC
         EI2ypzlVQBbaYHsEzn1RkmSm6wcjB1q3gHmRV6q14b6+esiIGEFTqzXHjwgKju6s3s5w
         qdMw==
X-Forwarded-Encrypted: i=1; AJvYcCWCkhg4CjHdCWWRzAxArAcLaxUiWZDL3aEMMlij4BtaGkMYvF4onyubtSM7+uGKhS14W4NzM3pr@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1gqOE7Fg40fiF7D2XNHg/V0GpBEIS+cdX5Qof/Nfbi0TxUUHx
	JGKf7p6eRJeCBBgJxnes0vCdYiVliG+67MVwxkXb9JjfMUKbeWN8ZbRDDGmi5gKbVEY=
X-Gm-Gg: ATEYQzxeDq/PZRbU2L4G6IimP+UkX61Cbm8aMxHK+R4PXcwiBfCaosN5PuPYCHWQfsk
	efbG5wTVuHYr1iLEWUrccPO/Ipmd9pQrsCgorp3PHQEg78hbWXWHKjgilpRcoqOE3MclLDPBBXJ
	79TFMQmoefs6q7Y2ID913p7sH4iFDBaxtrubmNiNadEvOsw5eKIV8N6Iq6yw8uk/UlSpVXuHwUG
	LBLfbTbxfkp41CKY4yKLNbRFYlkZT6MC/ZFcAzGrUHZC3fhV+HzOt0+IvclK1aLKdOBlGluYZy7
	VEf6uZrRS2y6wm5JpeT1tXtzb2i8FYYzValG+MRdYSLyOj5QMCXw5BkXG4av0oGPrpLtfFSvUwU
	nllaVPv5IV3nVmIUF/lfbUdBBQvC6lnIQtRtH8pRjbLz4mjbWnb1rWDXo8/TyRaG8skNtn353zW
	a4JBnRGpWeRKsa8R62KQ==
X-Received: by 2002:a05:600c:1f95:b0:485:40fd:8390 with SMTP id 5b1f17b1804b1-4871608323cmr44167395e9.26.1774436196185;
        Wed, 25 Mar 2026 03:56:36 -0700 (PDT)
Received: from u94a ([2401:e180:8d68:92ee:b67c:a5bb:13e0:f6f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0836a3066sm175807585ad.75.2026.03.25.03.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 03:56:35 -0700 (PDT)
Date: Wed, 25 Mar 2026 18:56:25 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/212] 6.18.20-rc1 review
Message-ID: <oghve3ghagpn6txd5y7degpy2souymqonz6hkq2kuys6n7d7ah@e5vf4hucvgn5>
References: <20260323134503.770111826@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>

On Mon, Mar 23, 2026 at 02:43:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.20 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/23507388452/job/68418868880

[...]

