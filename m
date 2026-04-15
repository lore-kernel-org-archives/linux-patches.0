Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE5C32E126
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 03:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776224924; cv=none; b=B73TEZX9B1Z0zToVmsu/LPLvscZXU28sOD6rfKNeKxGJoNLaEcHL63L31bT8+wnEj8UQ+vQruA1XQ8iFrMjy14yxtO03JYTcbrQC8FID1QePDoBBcPNs7xHxiYQ1t8GNoyxvcGae1Z99nvkdpXwYHkW6vMpvONxcx6bLwvrb2BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776224924; c=relaxed/simple;
	bh=xmpNKr3sZuNm1DpxCF6va8lyNv0z5vBmJL4GoSKGiUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eWjzFm9gS+sYa8nptbnipIDxBQ+lbcua0E55BUuMaBoBG6HXVv+AhxFXSMsTbdmZcqrgZNFuDQdU0Vg7HEB7HpB8nZPF6BMDRsCrSu0Qj1tUVsFc89mFt8r6Ie7na4yS/W/n+cMd6xYoKfBqVC3EE8tI0atrpT8YTLUaKYqG+ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IRx0koTM; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IRx0koTM"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso72832755e9.3
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 20:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776224919; x=1776829719; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DbVbyOkSh2lyvTzg2JMw4q6y5V7NZGtrZdqzKB2plGE=;
        b=IRx0koTMmgn0VZi2SUWcu55cw717JsWIxxWO29NpBhUVYRKhJHBYiCjQ1Ix5vULQZ/
         olVe4pPOPr7PH/kiNjEeGUO1I5WFDQVCAEpeAHXIt4YKXMnyUAxUixFJ7TTigQ+4Lh+d
         ahbE3S3xg9NewkoogZEeo9RvtuMc7dnjfBDdS29e6plHreb/lJ84hpsSA3mofSa8g11W
         Av15ye2S3v7yH0FY47JXkGf6zKBdeq8IvaukOcpXi7ui3JwECjDCekThEsOJtLaAVsEG
         HAztI/Z/vcSJm5eqFZJ0blQ/Y5AjKvFWLmj5odsnhXD8SijEWNGT5pR8MDiyRGtBkCot
         QlcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776224919; x=1776829719;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DbVbyOkSh2lyvTzg2JMw4q6y5V7NZGtrZdqzKB2plGE=;
        b=M8q8YomaUxy81LH1eD42BS/MR+QRok0D0dV6Nz+Ji0WlJ8wcpdOjFtaoq+k4n2QRNo
         S+EcP3QXsmyja9HgUdpkH/j0DYHAS0/bZ2GfpHolnH9toF6Rf1ri1oZ/a5MsGTH+Jdau
         AVrjdwRFnoGylbCgxERwpypSBWi8n6LsYhEAOH3MpsRNLq/Quowjzo8f4o9b20oN7Ymn
         oOpKysyJ0G5x8IXdjBLKgZjgryX+yFIqRCi34/hQZr4M86ys1MUlGhN7mlxJZN8EW8o6
         u8osle5hbB3yIOykQb5YlT5wHFi5T361XGpf2r/UWPu/phwbvF4DGKaCsYvocoZyK8g1
         TknQ==
X-Forwarded-Encrypted: i=1; AFNElJ/zKp4dFc1bAqF19WLYFvoCNI6xwRZXrWCFMqkaJKUXysiU78IEbkEgYvYySUbsP2Jv35SbQ/TT@lists.linux.dev
X-Gm-Message-State: AOJu0YyWi9NP/Vc8iu3zQ56rwq8Tqupp6qIvnRhDH6vgbkvKn5t4+nf9
	fyZPsD9AOpfiVc62Q6FkGiAeAnjSMWuxHlvQECzzCM91mQDvg/6SAaHIkKwImLb07dc=
X-Gm-Gg: AeBDievWcs6K1dt7Qc7Umgh9Q6Qyf9kYQd9APAP97yPzrkFzV+Ai2pvasO5I5mmOZed
	GdnrqADkoOiyYuzCnUtN4+kuOHfxssKwPxILeWb15LRBdTKcgAJ8lxk4bbsc3onIWzkMJPEKub1
	MJ+De4vLlnYe99vjOGdPRR8JDDOTu4/02lZOPG+cBOUeVEwCJYr0V+vk3wMGhlNVwSs7FE+w5L7
	gJHYCQ/IW3U9eqnHZYnFF3h1tOVbwKiTmMX62lEgSTn2T9OoLqTOmkdkLCYu34BbVjMKSHA0bwu
	gLbFqgUPQ/rQ8ecpH3r7oeOSoksTrUclzc2HyNpVWvD2KqvZza5hcjUxYZAfRcLTESCcA2tBx5B
	LfCES9x6tu7PhLEykzGTHW1cN4gWyrI/HA4LkH6HW0DtGesdkGhHqs5i95ezpe0aqLgiRHH1b6k
	wjidOqa6osQ6mwrL54P9KZziIYCFShjcPo1MG8S7NUy6Dnt+i8a+M=
X-Received: by 2002:a05:600c:8883:b0:488:a82f:bb95 with SMTP id 5b1f17b1804b1-488d689c18fmr207549915e9.29.1776224919347;
        Tue, 14 Apr 2026 20:48:39 -0700 (PDT)
Received: from u94a (27-51-0-223.adsl.fetnet.net. [27.51.0.223])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2de8eb848b8sm893258eec.16.2026.04.14.20.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 20:48:38 -0700 (PDT)
Date: Wed, 15 Apr 2026 11:48:30 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 00/83] 6.18.23-rc1 review
Message-ID: <f3m5vrsdq7avvqxhn23ghxn7itpxt65ydfvnduwguu4uze2lpu@xjzcfitxjg23>
References: <20260413155731.019638460@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>

On Mon, Apr 13, 2026 at 05:59:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.23 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/24418242274/job/71333106647

[...]
