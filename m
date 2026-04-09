Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6504F2F745D
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 06:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775715396; cv=none; b=S39iTkTnNlv3bD7Eh8VUVFu6XrJavt7VGKjnMILAVdEBd2RcN/OOHZK/YQ5RFUVguhP4vLQpbxacqrG4T7KiFU5eyAkI/sRh0c+DnW2d4bW9j37vacuVBRhaOZXjvcxmGlq4sK6Ctx/kMzA9ni32GfPPulqjoqdslRxM9eInaB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775715396; c=relaxed/simple;
	bh=6mtZ2X/mdA60+76qSb3+Yz+RcEgdrZe9vvYKjMR4EV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QcsTSmNpVeR9OCMAUGROVzvnXMKHRsQ5FdPCEveSGdQcBlfbezWbgn93Lvud0P5vJCjVVVCtJq67ykqVFHHsxirShDy4GGsx3qVbMJRkJzjZAVYbOL4MFX73PQJXHS5UZZWJxR5sCbZ+NbYBBOITzNxbt0bmGldl82Ux1Zvu1Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WnEkq7AQ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WnEkq7AQ"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488971db0fdso4812035e9.0
        for <patches@lists.linux.dev>; Wed, 08 Apr 2026 23:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775715394; x=1776320194; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3pwoe3OCa92TGfyBz5HTxfCfcGY3puyChc6eX9sLAHM=;
        b=WnEkq7AQpzJU8NdwGT5C8Kh7nlKHaTDyrH40vt/UuCAHTG1txvdBffm6dIBgqL2gQ5
         CJISuLP4jSHG9EjMxBssR23MFVmwVr79ol6YDAtshDFoKCVX7rWYvne5Ob2ZkAPM7nbh
         hrKjSSz0oVVbJHmCCzsGm6Hp/W4SR65/Lw0/QX5c1I42jm+1lyLC8mK+aQYHgshVcKj1
         2rhHmvtHQKt9ETtPDZjN8aIvI4CncC/eqtAdeUL3qnAOGMAq6v57jX/oVQDETRS3C4rR
         1YsZpCVsyZ9fyrOV2sXkkrersvt8xyVmWW6L7wz1wAP/cYz0PpbeBXuR6l8FcvJ/S2Sh
         UB5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775715394; x=1776320194;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3pwoe3OCa92TGfyBz5HTxfCfcGY3puyChc6eX9sLAHM=;
        b=jw21ZuucZDPnhQA4J8/pXg1gsUff4tLlUdBbQaAdWzYk4bfo3CENkmBbAq+uwWIxqs
         hKIByheQ2nBQBs5KYEUauLnVbrQ4Vst3Mi6E28VgIzDGNTyCXqyyVOcNy8USz/5toovU
         g18ptP2z53jv2jgSg20oMXrQ4zMNq7/Myo134TJdWf8c5xpnV7emMR9X3ZeUpPORehaK
         pN/d0faqDUJfwp/ESmzL5WK+im6C1uNqOc1uE+o/HdYCDfaGN+KwGnHtIycEljSZ8orz
         hylJKDQPo/0A5Sm5bdKug/ju4OGVF1x4LIeZTJqOiVFz58b5cgpggcuPYazO/p8ys+BR
         Ck1A==
X-Forwarded-Encrypted: i=1; AJvYcCXezf/gJLjolNyt+E6vvCfsNRvhIXQ4qN1wjbEjOFmFbOwhvLn6s6IX9lWdtCOQjznI4sC/wUzo@lists.linux.dev
X-Gm-Message-State: AOJu0YwY2sdJUyl1T9UnNiXepTAq51+CrYLJ0PJlRdzaiOM8Vp4ylQGz
	mYqHM8M8PZx/rpJ9mpcbSW5T2JCscl6v7R+u6daSSl6Hw5NbiLB31lB2n1C5y5aM0gc=
X-Gm-Gg: AeBDievvORQjMRdkX0KXpQlwaDqhXHk3nP3MBOxMvXWMx1tfqZbriZGgQ6RnnavwAkg
	AdDx66X1R1i7f+o64uv8Nsay8eX1IA3MCh088Ndd009pj6rYZZAqKE7Hx/o8mHx85gQ0mwlyTzX
	nN5S0vUnzihAPs6kkDC9xXqAwIvcs2ZPnZh/hOCgyr3US/fKXZZrNzPk9qL+cKXRpSo92wx3feg
	7iT+3olX847xl10iiuUPyLDcuVlP3u+mHFDoal8R0vjTrKT/Gt8T5uj8cknZUgYXVNJZZxo+KZq
	Z04q5FyIshQVNWnsO0jLPaxSw46+crNdRS8C30U4CdaL7lgy1GI8VPgp/rrbVZ277c3Zrw3jgN+
	wFm8ro6y/ja3r1DQ3tW7dPJ6i9YfrhW/EuhwhCKQAU4mRvtgAZCIhdgy0BHAgyHEjXRSRkqDQUm
	XVAMMzJ0Wiqh8aecaYbHJDo3nf8EMUXWc7SQ5WGGHGMWJEtM61
X-Received: by 2002:a05:600c:c10f:b0:488:869c:edaa with SMTP id 5b1f17b1804b1-488ccfa937dmr21335925e9.7.1775715393819;
        Wed, 08 Apr 2026 23:16:33 -0700 (PDT)
Received: from u94a (114-140-130-35.adsl.fetnet.net. [114.140.130.35])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-953fbac435dsm17406228241.11.2026.04.08.23.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 23:16:32 -0700 (PDT)
Date: Thu, 9 Apr 2026 14:16:15 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/277] 6.18.22-rc1 review
Message-ID: <7w3vhnc4trepnsgwqp7qotxre3crgpnsenqnupxec4d6z6gmev@l2eh3sbjfb7g>
References: <20260408175933.836769063@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>

On Wed, Apr 08, 2026 at 07:59:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.22 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/24153838933/job/70487760128

[...]
