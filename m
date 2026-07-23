Received: from mail-ej2-f2.google.com (mail-ej2-f2.google.com [74.125.228.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D67733689A
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 08:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784795669; cv=none; b=UOQjeJiA0C93jVANXEbo7jkbuwjWjzWfjkQ2dN6bqigKqLdG0wLr4MSHKPSCI7ZOY5/XdDXINx2IDjk3mArxNrwzA2sV9HvK9Iog6B40D3dBzFl5LZQXEfBNLnDMmkvH+rEMcCbxSX9aGNZztlRYX90rmUSI+h6jvnruSGPI6y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784795669; c=relaxed/simple;
	bh=eDcM7H/qX1tb9OEYMsB+e7w3gjgm19H+kyxAAgQNGko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ar5qFmoL5fdZ3ZfKVgPfsvhI1XueXce4fNpjngYIa733woAiZyvWLe9Vvti1VNmrv3ILToW7RdYvElFjb8A4c/XMxxJgLtPqqzJ4yKxTUHZb5YlO7QA3vBLn3bmDL1b6SaD1o+HqOtUIm8Km8T/hibMh81XyE2Dwb2daNTtzeB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gN6ELcAx; arc=none smtp.client-ip=74.125.228.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gN6ELcAx"
Received: by mail-ej2-f2.google.com with SMTP id a640c23a62f3a-c15b719d71eso29603866b.1
        for <patches@lists.linux.dev>; Thu, 23 Jul 2026 01:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784795665; x=1785400465; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WM4LrVEAVbzwFnCna7mTJoAGomEWS7gZwnhfoNmmkfE=;
        b=gN6ELcAxcItF1x6TYphQL8v60SXoOOG6YxMGS5nBmma6QQl+sF7SUFGAzJmmV9fZ82
         FYxUCqZl9Imvw92Nl/jKv1KDfhM8Mx3diBy3btQU8OPITRD0aTugVQ+Bzfx9jncnEV6I
         E1xnnYrkBqC2GrCfypXohLEXdSYmZZPARU9hyAEYqMx9EH2XIZdM5q/a1OtLYV8NMYco
         NHEiFLFpxbHC8q48cuSUSIrSLXZTZIBBxTbbp9l0ll3gQK2Av4ad1hI2v6kCIfhf0Wnl
         DjVaVhki9AVBJG/sVXRDcrH55KKqzCtGVTKtvWd22I9W1R8u80wdMZfAt/dNp/x0bD9h
         iHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784795665; x=1785400465;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WM4LrVEAVbzwFnCna7mTJoAGomEWS7gZwnhfoNmmkfE=;
        b=cmFajBWfdxFAAnpBbjluhwfAJTvxcqcbIDOmLGWD1W3SmNZ4DkT+wl1YFwoRXgF8Gl
         JPDCf1pyVy5Yyii1/epLQNiUNkIMpBOXR5fM4tILww4IlkcVX5ZPsArCt/1uHOoVcLgm
         Rhmk0MdNimfVTOUL6/Nea2p2Etf/Mf2UIJ7q23NpNHM3z+L+uSMa7h5gBE2tZDg4iNuG
         xmB/t6i8xCzvkrrilLfXpV4DoJtOc/lZbgV24Qec1V7J2VQId2J3OF26MafM7vfqOfhz
         whMur2l/bLZxZlrzoxMj/49MzIOBxp5P/nKpMGYn6BuWvo08kwn8mq+mRRczB3CgEM9i
         vmkA==
X-Forwarded-Encrypted: i=1; AHgh+RoRcfWLF/gB3e2Ft/cqoX7qti3wO038W+35Orb3MDGVHXnlhWbNBqiNeQETRQPwd2jBxt+594Pg@lists.linux.dev
X-Gm-Message-State: AOJu0YxGA57pGbPn9M7jb95xXTyJ6l84sr698DV2OLu0Cy2qJwVhn5Fb
	M3VUiRIJaITBJ4kNsPHOrNXlUtX6FAO6jWId3+Yfmb31lbCjHN91+tI6vHp4/HOiwsw=
X-Gm-Gg: AR+sD13wfNdu0MfOOVHWwTtk/J3sl+eCix73fyhhQc9wHvg9ysj7V7d67goFP3elToa
	STRder+oCijd7iNX+WjkbTT23pnbbs3i+DKOEm5jZZi5Q8QvNtEPyzAHHXas9XvNnTImzuFV/7R
	e9snr/fQQg2kYJshfpV/jjetcqMzNYWwXJYX+7b6cWxwNO8MpxShCUUw71QLEye7Y9XA5aDBn8x
	47nmiEzoknZsJor7TVwalmkFoP/8rTnzDY3QRhoPQtjDtfCJEswLEhYFgUTQMahZelZ8zspmA6i
	4tUdu+6iNYsQHxu4dF4RvYL0Gdkq92u1j17Bz9ToedB7kIX5eYloBSIKj071TwrwHI/XBzQKAaF
	vHAl6SypaQD8u2Uc6Ph6N3P/QYOzrnlCcVKiuhGaFaYX/7BI2QRdK/2WB+2LhMrWHv7q2lpcBZ1
	L/6pwoLfcc6v8/YrsFLDE=
X-Received: by 2002:a17:907:972a:b0:c15:f4e0:72a7 with SMTP id a640c23a62f3a-c1c50934a52mr104803366b.39.1784795665148;
        Thu, 23 Jul 2026 01:34:25 -0700 (PDT)
Received: from u94a (27-53-97-40.adsl.fetnet.net. [27.53.97.40])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f0d6a52sm2432265a12.4.2026.07.23.01.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 01:34:23 -0700 (PDT)
Date: Thu, 23 Jul 2026 16:34:15 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.1 0000/1029] 6.1.178-rc2 review
Message-ID: <amHRf2CoKvS9qwJZ@u94a>
References: <20260722143218.909123637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722143218.909123637@linuxfoundation.org>

On Wed, Jul 22, 2026 at 04:32:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.178 release.
> There are 1029 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jul 2026 14:30:58 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps, test_verifier
in BPF selftests all passes[1] on x86_64 and aarch64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/kernel-patches/linux-stable/actions/runs/29956182704

[...]
