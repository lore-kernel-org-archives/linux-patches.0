Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1238F74E13
	for <patches@lists.linux.dev>; Tue, 30 Jan 2024 14:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706625163; cv=none; b=UfPMK9SvgXHNFOXw5GuPaqu7Aw/u/oleP8NKQUS2MnuWvQ5Gf8QvszstuHD6g/32NuDZHMLA1O4RgaiND8zU0MagypILuOUJJvxWL9Lls0rbRRJjLX9GMZOPl7QKtff1Lr31DmEQD7EYe3bjBXFI2w1nKKilpShsIprYcEh+zRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706625163; c=relaxed/simple;
	bh=nuQGv1Jds4FtXlqqQLPGMEKmNz6TXTY7xb77Rn4Uis0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kSkXBpRJQAFCUmMkbH5NWTvqBg4t3XOQeb/aUZNpC2qpYfHsUwi9Bxuvn0Yr6cbEpBrTe35hsCDx1Qz71iat82bsWgK/olTafMrmdBNjb47TxH17+REcQC1fEG8Nx5Ok9HSh2ckRKfGAaooFAZa+QBioc4pXDVTHSmHCe2EM0iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net; spf=pass smtp.mailfrom=gmail.com; dkim=fail (0-bit key) header.d=marliere.net header.i=@marliere.net header.b=hOx88CkY reason="key not found in DNS"; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="hOx88CkY"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5ce07cf1e5dso1832114a12.2
        for <patches@lists.linux.dev>; Tue, 30 Jan 2024 06:32:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706625161; x=1707229961;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n1bRZI/oUopCNXOjXdeojE7GQGN2Uu9IDwrj3sROkxw=;
        b=RYVac5MaiACFaoDj5KRoG+gYo6Jmbw6XIQ95hLxwj3IPZtAIbxbRIrLaWuSFGK2Em6
         B17O5PtjGNbzsFizNbTtjgbJM8Tq1Xza4sECuKddhQaZjWpiBOfjsnlQXirBWuufZLXo
         BJxZn50GHTbPCBTi+W5dI+Q5QyzwTH05jy9DdYEtews/A1o+uauX7QcOr/O7I1TQocY0
         VTLsWOdR5rGGJoTN9uNSZxHZfM/pU+3jAq3gshPSo731ehOVfFpnlzVXE1VFltTstgR5
         CtY2ja1Sfopt6BNXk9ddo2AtSVChMGRSwip77pX1CmLuIyt70v6TslGkdM0gz0OAwXhh
         do9w==
X-Gm-Message-State: AOJu0YwD/Jm+GURT7NPa9jOy3Vnbg9kb9lY6kv7a3QFmKwLb/nCcuDwB
	bgHBnnQZJ2V24SoFBQANg3wgezYnviwRnVbh/2bHMSo97WkHsBMY
X-Google-Smtp-Source: AGHT+IFiv7dYpDESmpNj9u3X8FlcxqrpBMcMuVqkQU4azqWhgsppFKd2Eu2fF4hLHtoNgEOAQcofDQ==
X-Received: by 2002:a05:6a20:6d91:b0:19c:7e49:495a with SMTP id gl17-20020a056a206d9100b0019c7e49495amr4123145pzb.57.1706625161337;
        Tue, 30 Jan 2024 06:32:41 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id a8-20020a62d408000000b006dbdac1595esm8469877pfh.141.2024.01.30.06.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 06:32:40 -0800 (PST)
Date: Tue, 30 Jan 2024 11:33:01 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1706625158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n1bRZI/oUopCNXOjXdeojE7GQGN2Uu9IDwrj3sROkxw=;
	b=hOx88CkYwmXA3RcMYHBDx+Zk6hEYtjKrKCCssw5Xw2NpUTGcVyGUl4Zm0c9U+9o9m+Xzf2
	c5gLOskrGzneBORNFPToP+UcrXO4GYW5htTamgBgThdQdxYmY3QNX2GB5VGVcGPdVyNboB
	hFp9tCXH9Clkx/swjh/olFBhA3wB7luaqeUxkyjdg0C/rwyJl2cPp2+plVTvQ77ob6mAcc
	DPR9aqkkFsr71u0p1FYrrA8kdCmWtIMVWVEgzdZ1QK7hoAoboo90j2vHAnAOfBgb1O3mnk
	SvT8bsdZH7j+ZOz+W9IL94QzWAeOh/BgB8vwaMjLUBFyGejuGmY2YwwDifbcJg==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/346] 6.7.3-rc1 review
Message-ID: <pivme2beq4h7wrbmjt7s6s4jgihyh5y2tt5rjt3c2flvtto4ao@y5iflivhyz6u>
References: <20240129170016.356158639@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>

On 29 Jan 09:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.3 release.
> There are 346 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Jan 2024 16:59:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
> 
> thanks,

Hi Greg,

No noticeable regressions on my system.
[    0.000000] Linux version 6.7.3-rc1-ktest-g7c05c677b6ca (rbmarliere@debian) (gcc (Debian 13.2.0-12) 13.2.0, GNU ld (GNU Binutils for Debian) 2.42) #2 SMP PREEMPT_DYNAMIC Mon Jan 29 22:13:17 -03 2024

Tested-by: Ricardo B. Marliere <ricardo@marliere.net>


Thank you,
-	Ricardo.

