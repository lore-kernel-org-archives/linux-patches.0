Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC583168E1
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 03:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776224883; cv=none; b=SHyO3lao7mSBRPUldt8dIeXhfogdXYs5m3SGu83zWOYC9rJ8q5JexfZzsHlMo6FS0hi7OQCHxPegLCM8GHqNQRwp48CMnsrEUwOMHF0Wi5oV/WgRLpoo18Y1fSVNg8tvg3ZhOPInjur3GL6OlEdMtBCaBStbbxgHTGD78yM6V+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776224883; c=relaxed/simple;
	bh=WNzLf4fzSkYbBrCWrcCLK4C43z17fYCHhgs6scvVfzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lhRE5/hGnmYDq8o1/QXc4vtvxXw364ZsGuIhYLdx2Y7BU9DQ5y8XCQMAAuqUnzPqoepmd8txBJOlkkcGP1C56KSsXNUsoi9nM96q+qAMScPGUzC3hqBjXNHsFCLlbVkOmcEfDouFLWBiqcxRBb1wJMb2zfVbporc9AzqewmDYZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gdATYSBn; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gdATYSBn"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48374014a77so84569065e9.3
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 20:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776224879; x=1776829679; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L1RuLOTXQPaCNCdRlFZU592xjC6rgmWgeC9PPu1OpTk=;
        b=gdATYSBn6Y1UTJVoTrqZz/jBStDUaoCPTsuU0Pb6IjI6sklXCqzzYVo/Oe31aYW2lN
         iDi1aLmR4/Te6MkaPuNAXIYqPLqhxoW3XxHTOLt3WGdk4Ilshe185Z4n7m4SUfEdZtN5
         nEvXzRse2nR088KGublybxAGgANLp0ScErl9RqALUp1LJxMw0vQhd57kBonEQjmdJc+T
         4/OMf5TzMQxrMjALV468CpptAAgo/DNotxrgQaamS8H3ED4uTiT4T+d9W9ilCDed1uAv
         OE3bJmhIRbQasu6cUHrdiB2t2KKYeAPdVCL1obnbehmcY7DWC4vzoUNHB14him8+lQ0C
         NKqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776224879; x=1776829679;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L1RuLOTXQPaCNCdRlFZU592xjC6rgmWgeC9PPu1OpTk=;
        b=EjhXqEwJiyCHnQczMJdAieyWdHOLkM1USZ4NDPtuPZfZpeagqME4w8SUreg/Iks3Mn
         eIMi4avp/2dTubT6fMMD++dGuCVTKic005hsuTWjln4z1Syr9wSp3hvnnMQw6x8124vq
         Tju9iBlX84ZArCbddyab3PDGhpfIVdtAV6wamxGLJRJGror6dr7mOymVmsLYiUHVsaee
         4scyfZxrOepRDxV1rIom7oQK0GqfzS9eIYZ0e5WKBuMYHXLVDxljwU+wnzbhJmrskc6i
         DA6AmarhoLLyfzhRdOeTWRmS9KmZjx3JijKSDQgroQ+w2g4GBo0yGsgMPJZk3OGnXqlX
         z0yw==
X-Forwarded-Encrypted: i=1; AFNElJ/ZlcRbi9B5XbEf61Id/TXmd97K+qdYENua92bFC2WVeo5te8K7yrzXF+v93hnX8FX8ovG7u0gt@lists.linux.dev
X-Gm-Message-State: AOJu0YxO4DZpzHy6fZ3OfUmDYCjc68oW+xhe1tEjhvv9Rl/WjEkHU6P+
	yoCxWbDn0JNUG+3tmR6skYAn/fAEnxvUelG6nrtEyxi9Ea64Ye/1gIY1DiMJiO/ammA=
X-Gm-Gg: AeBDiet/0M1xYcDi8Y1xJnADZWIl7RAXa2dmj2ct3zBYOfljf5E4xlA8DvJmNQIZw87
	nn/4umw/LQu6qgHydr4ySLOQEtRXyhJxWRpS5FCy6CwF+drxKdjtGi8xpCsiePHvWrCetbt9uf4
	QvmKDKuxzjSnZorBgp8b6AE3Eq2DSdzE4YxQNmBPyBYn0+N9LlRSlXxXHz8jPJWFTUVQEj2m3Z2
	tAzvDyjK4922lSFkHIwq9tgNN9kRGlcldf0vUOR1KrITmJkaLu8iXr8oswr8QpunWLxO+XNl1Mm
	zjxrM/MXMMHLXuktbxKkhOcdG57hoAgyQgjf6Sw/WDbV1IaTAlDslE72tWtAxopo1B6nhavMws1
	l0LJ8/ODDuW7YZ9sxs33kZfqlCSVIMDeg2jOPr1BUKb3YLIETIEXZ6mQw5Xekt5HkycppjNSGzV
	dEEceKbd5v0C4mZCdFykzq+m9XFOCED5ZWGS0WJ3GS37L2o647WOU=
X-Received: by 2002:a05:600c:c084:b0:485:4006:960c with SMTP id 5b1f17b1804b1-488d685b86bmr196803845e9.16.1776224878665;
        Tue, 14 Apr 2026 20:47:58 -0700 (PDT)
Received: from u94a (27-51-0-223.adsl.fetnet.net. [27.51.0.223])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2de8f65f9bcsm1050289eec.22.2026.04.14.20.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 20:47:57 -0700 (PDT)
Date: Wed, 15 Apr 2026 11:47:45 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 00/86] 6.19.13-rc1 review
Message-ID: <3nreag3thlhdth46opxzaae2glgj5kvul3o52sizwvupgapl2g@rmhzbsozkpv2>
References: <20260413155731.568515178@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>

On Mon, Apr 13, 2026 at 05:59:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.13 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/24418242274/job/71333106576

[...]
