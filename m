Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0310D215062
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 21:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738792478; cv=none; b=AdwzvgqipIzbvLmyw+Sne+U9o/Pe2J7gj9VFIoIH0qjI38Pmxy2Ob3zafHkvMlPCkdzDcWsr0ARwLZSTKQ156KE97qyyqprz49wXNl7uY5E1TXztiBOrYax+5i515gAY2A49flvFrsP0sCsVUtRraphAfzbaYiRhrh8uMLy9Mss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738792478; c=relaxed/simple;
	bh=7hYv5dIku61xxB4YYzq3uEp5CTiTbBzQk/a/gUrOKVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXRROP9+1o9uHM6tYYNPf27efVRXGy7XhqmxHbNfmtXyzypx+If2fr6ExPMTcPssnqiX700BnXKLbCyDUqbhLl0jBzIef4mdSrUwNvhqJyOeqCLjl0aRHt0nf9zULnoqgqzW/b1bYxftWpVamkOqXJ1jQOYgW8Eexae8cYtP1uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=cm+35kOv; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="cm+35kOv"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3ce868498d3so658065ab.3
        for <patches@lists.linux.dev>; Wed, 05 Feb 2025 13:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1738792475; x=1739397275; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3P496XEFyd48SqnxWvUc186zaYO6NAXCLlCQfz4QFBQ=;
        b=cm+35kOv/M05l5b+ltikwuCJT2CemduRvFO6djkm8orBxb+J3j0L5uRb54DHRnTmMb
         BHE5hYi45K50xxPh2Omz0rcraWIEjZTQ5JDfT4qu77csBZY/d4PlDBDeIYMukHjCJaAY
         7L6CLA3uqcJIz/tgJmqqhOprsZD8038VFwqVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738792475; x=1739397275;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3P496XEFyd48SqnxWvUc186zaYO6NAXCLlCQfz4QFBQ=;
        b=LN8KXi4mSQ5jUxgJVdMicM2J28S0GQpp47xzeanjju2FlHzryBzOQHO+FvlV1X/N0P
         GSWQ4SHa6FxI7sT1gFNeZrFJT3H53cgvSqE3iwKlP33cbd5FA0e+XaerLfskka+K68H/
         ph1m/I1Tmvdur+H2pfR4mE27kEgnJdw6w16d/nPORrwB6Gc5MLwxjRepTBep+r8cQsI+
         gABuXUBscYtVUKX+VL3Ok763U8+r6ovyVRLjjiaAozEOHAVvPDO06VkiNbS3/PaeR6M+
         RV6P2KxvPAFKNVQuRAtxn3vxhj8D0ynXB91DBzsHrnhwFRcwn+/LRGGd2+yLNs6ihrkb
         JMFg==
X-Forwarded-Encrypted: i=1; AJvYcCWCAbEuG7atVfkwl/hOGxnbhxxV7cUY/q4l+MXQuJydj5S+ud2JPVUAwUPNTRXl7V+JIAkbh7KR@lists.linux.dev
X-Gm-Message-State: AOJu0YwLFi+efAs/24o5F3k14gdbPdKKhRNsTCsrsZ1kHD9ocEHyfrQH
	0pggXix9nlYCbwDrl+kLw0wh1Uih1bwbRWSRerCt5gQamg6LH02bacKLtqYzmw==
X-Gm-Gg: ASbGnct7eM6hjfXNcHb/91IpIsGxGoe4kOu0nTobS2/cp9AFUnQjjzl/HAtiUYUtXBc
	rFfc1lt8ASdTkA5oO7OyfsXJl2/oErTjRUBVb3tr5OUN0zevjO6DL4sC3IZ8EpccgZoytDZdCQO
	PkWlpYKbt/6V+1sQbNz1zKaHyl/HDhiAXEKIs4sZl5erBIBEVqZjGDq0L3BYmJAh7ucWRYNrecD
	OoDJU0Oc3in0AKXjXtCI4WtzykXgNi3IROGz3PgHTSZiAhIbd1gGcLIufvXoTHeWomPTHTK8maF
	HjRzjcOR9jX9JpEft8ywZA4jCNIzT9rN
X-Google-Smtp-Source: AGHT+IETeY6aK5dolIEu79iP3omSgxyhTR84StQvlNAIr8vYtLnLrdK4f/+SZ2p9/owFtG6WQwhh1w==
X-Received: by 2002:a05:6e02:1542:b0:3d0:235b:4810 with SMTP id e9e14a558f8ab-3d04f403570mr46060005ab.2.1738792475025;
        Wed, 05 Feb 2025 13:54:35 -0800 (PST)
Received: from fedora64.linuxtx.org ([72.42.103.70])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d0505dec79sm5502915ab.13.2025.02.05.13.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 13:54:34 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 5 Feb 2025 14:54:32 -0700
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/590] 6.12.13-rc1 review
Message-ID: <Z6PeGEp__6A2D4DJ@fedora64.linuxtx.org>
References: <20250205134455.220373560@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>

On Wed, Feb 05, 2025 at 02:35:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.13 release.
> There are 590 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Feb 2025 13:43:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
