Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752992E36E6
	for <patches@lists.linux.dev>; Sat,  5 Jul 2025 19:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751744276; cv=none; b=OgXgjJu+3sramXksxFbnj/7tqsLWqLyf3lY/yJwdhPAfc2Wj9M7XUhgl838xSjDSo3jFku1db1lmZPbP8ut1Mb2o3n6E2B4cIkRS0izSgVK1qII4Uw7qRg1VkOWsLnJS6QZeSzKidBXAWzZRiOO51K6qWBIo4UxF4cTFYbldETk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751744276; c=relaxed/simple;
	bh=rhkYdI0qaK2SWqPGukgpUJQl2Y1xf63RjS+xGlf+ENo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zt3BfkwK5MATSObZcjjh8UdVZ6NXEPbWecA8iRM08r5EZ4zSOelQ5Nl1Renk8X1fi2PjOL95uot/in96/qzDt4vzivN+R+7anUmzATuUrilQLNQ7b/UVllrSpZrDy1tfMQQq4n1Ia/dSXo3VfMPT+vPyRPhF46ZmtoIxj8xPWjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UZ9YnKAh; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UZ9YnKAh"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-879d2e419b9so1250905a12.2
        for <patches@lists.linux.dev>; Sat, 05 Jul 2025 12:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751744274; x=1752349074; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UdsPWIihv5HWhO3SsoK85fdkL/eyjqb/7Z3okGZnaXE=;
        b=UZ9YnKAhm3kcY1IZ8BSurkj2UBnwdx2wLuRLvTQDe1vzNIDNGM/veOPMFxVaUZJ6Hh
         hb78Ypdjzoon6LNKWPLEdHV+UFtZCGgWZ9On4SPg3cjhoEbSeSeG9WvKiYtNIxdGnQjZ
         IuySu/V9ecY4YWUFPgb8ZFxeYwyQZGep9/4fU/dKYsOvfif9MOwF/mcNzZPcY1IvVzVo
         lvudl1dq/mQQO6y9YfW09n2RF6LH5UpTg6yoQbqiRhO26yeu9dvi32XHSDLxlV26lqI6
         A1mdaTB6epmDNJ6WMQmrWkkgpqwjmEsyIIABInpCtOxFn+8wyJ4J5SyF1pprKthLPguL
         LCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751744274; x=1752349074;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UdsPWIihv5HWhO3SsoK85fdkL/eyjqb/7Z3okGZnaXE=;
        b=jT2WSsJzYlHlP8M3ugq4yNzQ7zHpzNf+irvjoETe0Vtgfhn5Gj3E5lRNLVQG3YBLz4
         QpvlBv/Nwxrivz+e6vPCuZUFniX+xPaVG0PkFLt+lP3GqmBA5+2ImYYpRlJgf66Q9UEM
         4jd+zFtaURN6znM9EQCUTfE5UX42Sl/ahGF2bzYV1spNp33fS5JtVkFQxsPnf/HjZnVv
         VGVI85SWm+HRQgdhXFvdbDDjKnt5d67W/XLDY5/4aCw4Ukjf0JnAeHXDErxKW/gIlYcM
         jE+O7KAk4ZcsGCuOA80kdqy05IitNr7WvgJC3XU8+Yd3IToFZvD3fgmckPBSUDXjHfHb
         bqVA==
X-Forwarded-Encrypted: i=1; AJvYcCWgtcBU20T2+se4NbCh8V3NpY94UXkNGviZ/SV7PUStOV+LcShe2BGmxS+vNNQFUuppAn/KO9Ph@lists.linux.dev
X-Gm-Message-State: AOJu0YzPPs3brcJDxUcOf5EOooA2igGVnOJaYGAZ/O56z589lS/XaPxU
	XIdj27L+5HU8StOPDy4UYw4Y/lSAC2P40/nYKAmS0GlOiZ2chArVXgTD
X-Gm-Gg: ASbGncuRhLwsyVR/eGS9schS4NKhlaAXoRMXEWEMaqKk/U00/2KMOkNB2bbwc9oeWCK
	XIWWt9yGnqt9GzOQxRZOzhecDh0+R3Gos6Mu5F43a5d9B0lvkEIE2K+AbbGxIoK5MlZMCtiaAKK
	rJXyXRQ5tMbhEmQV15xrt7Dr5/+QWIyXuUWfe70jehbqcTNwhwKwWzxVw2n+/Q1nUPysL5qB4gk
	a5mSoedY++SBJbjBJig6GNohYsJ1qud16UIcYwUw77QbvI03eFHE0ZIXa1nQZ+yD82vWmysSab9
	dvYe9d1CF+nikjzsGcqRyViJQ1JNtfxDBzu3uZdY4ogG9PKTJRn6Ocmtwuyb1MpYZE88gPs6WLc
	=
X-Google-Smtp-Source: AGHT+IGfY3WUKLQ4Yk5uf0Fkrth6sHY9ow0rMP3Y/0jgNKH6keGdaw88vCvOFt9UHv0SUx6yzeFNuQ==
X-Received: by 2002:a17:90a:fc4c:b0:315:b07a:ac12 with SMTP id 98e67ed59e1d1-31aba84b709mr5335559a91.14.1751744273648;
        Sat, 05 Jul 2025 12:37:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31aaaf5ae08sm5305720a91.41.2025.07.05.12.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jul 2025 12:37:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 5 Jul 2025 12:37:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/413] 6.12.35-rc2 review
Message-ID: <3037c3e6-558b-4824-8c78-a36990f4e4d6@roeck-us.net>
References: <20250624121426.466976226@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624121426.466976226@linuxfoundation.org>

Hi Greg,

On Tue, Jun 24, 2025 at 01:29:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.35 release.
> There are 413 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
> 

Some subsequent fixes are missing:

> Tzung-Bi Shih <tzungbi@kernel.org>
>     drm/i915/pmu: Fix build error with GCOV and AutoFDO enabled
> 

Fixed by commit d02b2103a08b ("drm/i915: fix build error some more").

> Shyam Prasad N <sprasad@microsoft.com>
>     cifs: do not disable interface polling on failure
> 

Fixed by commit 3bbe46716092 ("smb: client: fix warning when reconnecting
channel") in linux-next (not yet in mainline as of right now).

> Jens Axboe <axboe@kernel.dk>
>     io_uring/kbuf: don't truncate end buffer for multiple buffer peeks
> 

Fixed by commit 9a709b7e98e6 ("io_uring/net: mark iov as dynamically
allocated even for single segments") and commit 178b8ff66ff8 ("io_uring/kbuf:
flag partial buffer mappings").

> Yong Wang <yongwang@nvidia.com>
>     net: bridge: mcast: re-implement br_multicast_{enable, disable}_port functions
> 

Fixed by commit 7544f3f5b0b5 ("bridge: mcast: Fix use-after-free during
router port configuration").

> Niklas Cassel <cassel@kernel.org>
>     ata: ahci: Disallow LPM for ASUSPRO-D840SA motherboard
> 

Fixed by commit 3e0809b1664b ("ata: ahci: Use correct DMI identifier
for ASUSPRO-D840SA LPM quirk").

I assume the missing fixes will be queued in one of the next LTS releases.
If not, please let me know.

Thanks,
Guenter
