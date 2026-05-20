Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FF0374E55
	for <patches@lists.linux.dev>; Wed, 20 May 2026 20:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310548; cv=none; b=oa6iCke9Y/0+eD657poaH0VldG/+7Dz5QOf/yhiiUTeci/5Mg3xc6jRsTS3ZrdrIfP//6dNsBDxF811m03SomRszVeRa/SkTDRvKjWZpgb6DlV6JP3/yt3nEMSXsvknn3LWqlgSbaL5pkanPLEVENSitpaTVbWJtrn4CxPOdBTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310548; c=relaxed/simple;
	bh=RNhi+VrJKeyp8QxPIcStj3ZSn3BJqKFpD9tswgBlpY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U3GA1pFabEozXTR3pB3MjjeY8eJkqGwtPTKwXgGHKyHl70lZ+D/su4GYuolFmabISrAZGim4SIOuGXB2h6goFDm3mJSmq5eS84auV6QYTC4sodfbOS437KjHKOGDaKoXQaCeEUxnks00emaWxz1rESsPz/iDYMnGY4Wp+eQuJJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=QbdxHFye; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="QbdxHFye"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-132d1b2519eso12373908c88.0
        for <patches@lists.linux.dev>; Wed, 20 May 2026 13:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1779310545; x=1779915345; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rf4adrALhwhE5Bg7Hir1wi5ddzsEvpjUUPdqrQb8HSg=;
        b=QbdxHFye4BJHDTs7z4AUQmUW/dsBXbfQLHBvY/U/tNLY7gjQc04cj7Mtc1BTMvI9hk
         u2lEwfWgKhRM7M7ePrSOQZeoa3SD/rvjpDTaS3cFyiwyH0Fb3vt6A1rAi3ncQ/QBOU36
         Cquo0YM76ek58F4h3HT6jR6s+ohHdv5tqbcRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310545; x=1779915345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rf4adrALhwhE5Bg7Hir1wi5ddzsEvpjUUPdqrQb8HSg=;
        b=iKfwr52cDoOCPu7mHAkpKCZrbDAM6ckSf17mSDck4r0m15lt7rDk2YcjZcsMauIjKy
         yykIg//bKgQSg0nc52lQKAD7Tk8fWBMVh+an3/Mx596fUboYulhB68ByDv49en4wId6n
         l1nvNBb4RxcqKZoBVA0qNtznvVUsBVKL63QySC6GY3yG9AUC6NUjTtKV8+1VEB0yJjRh
         eWN/cu3YAhqy5U2TQeLJhxfxtHY5mVQNRxaGN7qrGSWyGHz1fuGliosocFegbezy5I9I
         ZWNKQK24u0BmyrDcwmpeu0XZR+RcH9y66z6l9VYy32bUI0/tyQ5TyJZ8fHFe2XwCYMjN
         4Afg==
X-Forwarded-Encrypted: i=1; AFNElJ/claMYo4AXc+s0XVMyXcxUAost0PoSK2B3PPHiVZgOHv8LtlZgZ3Ztgr3/9p3U+BKJWmrBNDLl@lists.linux.dev
X-Gm-Message-State: AOJu0YwGB115cAbTfYJUVjQ6BW54HeuLUaW9a1OozHAtSA/a7phhLoF8
	6ebJ+o2GVgIVCWC8XgeSJ3tq+Obly56BCzmlK2EETwxIXNPlZPBRLeQeCJ1z28CKQQ==
X-Gm-Gg: Acq92OGoAY7PPXsiFaRK+gRQQ2x1OpAY7hm5UEM5Pu7R7UQq7wMe3otuO5OwxPsgl9T
	UP/P4C0o07MIgEYpsoTcjrMi7BfGhIhCf1vfYLDvbxLfbMAd7k++GXrjdvtdlN+YNhXrw+ySqqt
	tmCGONHyaKycw9t6KlFO3fostI31a4e/DYSvQOinjXqK2tDVUgg0YjEpStdo53/yFJ3B6Mck6g0
	4GMqkNIXZnLPp3NP1sfXWJgWOhjZ3k7G28+0OwFcJ3kl5dNXj8RYQtYTsO0zx5XOTawZmj4weTL
	z7r8NoOWrSEVdUaMeVu8eETrQzRnwOl2GkI5X7IMH7EbLsrRW8KPhpQEzcbFeMPI48SdOcO/d3d
	3GWiRkT7Kc0jaQnl5gWKyT/25sdn1VejWbsL4qSWiPQ5V/iUMc7oI8qzdppdFUjtRog4FwjM25l
	qfX7Gus5fC6EU3qnXdx/+jjh0+5d45gDK8VhP+3QV/gXOJmQcAZ02w
X-Received: by 2002:a05:7023:b8a:b0:12d:e126:b7c8 with SMTP id a92af1059eb24-13632a0824cmr128746c88.13.1779310544318;
        Wed, 20 May 2026 13:55:44 -0700 (PDT)
Received: from fedora64.linuxtx.org ([98.97.105.211])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-134cbcb93f3sm28204367c88.3.2026.05.20.13.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:55:43 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 20 May 2026 14:55:40 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.0 0000/1146] 7.0.10-rc1 review
Message-ID: <ag4fzH2-dUdDHGtv@fedora64.linuxtx.org>
References: <20260520162148.390695140@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>

On Wed, May 20, 2026 at 06:04:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.10 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 May 2026 16:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

If I revert:
rtla: Use str_has_prefix() for prefix checks
rtla/trace: Fix write loop in trace_event_save_hist()

Everything builds fine.

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
