Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A26E19DF9A
	for <patches@lists.linux.dev>; Sat,  8 Mar 2025 15:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741447477; cv=none; b=TnOAMOvp+pohzw/XmSUpiS+abtkjKiTe9vgpNiMn0l/Cs1cn39BFZh6V7cUVTIMF0z2BkkZ7V6e1wT0Pg5ACG0H0AHPwzA7otTfCwgFrSyli3aG70BtSnL1F+5bwK/mVBzMz1qclUt4+9d02yJEG9QosC6tNV+XpNn8DiC7tNTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741447477; c=relaxed/simple;
	bh=+ksPnQkYFLq9BBBIQN5ECaD4K+JAR/8p7m68GDKx5EU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oTTvvQs9yfPJYWsTRtBp0ACFCsVrSWOYSUj/1cm1acJI7Oy74qtWAPFlGXQ6F1B1gJwseLinsy07Hk9Jtmzg+c/xDyBT8RgNf30uAyFP4+M22urefIxLBYt6pZDPuqQFZOACpgoezPworOakFuFMHOZmdd7qM1rofngn6VLT9Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XdoyDNlw; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XdoyDNlw"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-224100e9a5cso53138895ad.2
        for <patches@lists.linux.dev>; Sat, 08 Mar 2025 07:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741447475; x=1742052275; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AnyqBsmlqD/tBRZnGec00fMxsrhMgvwfzn2a+aeT/JI=;
        b=XdoyDNlwM65KABMel7usTJJJQkUUWvEUSJL67sPMliUXFLSusGYLsBKbGIhBEpBHJB
         zUsZa/RmmJk7n76wZo/lpSxRfJgGM0g0lKK4fMZx9sEduQtacELV6zr+28W5ARDkItQn
         MTc5/fpY+dF+rkq9562AmJlvZz1IYswlrnpo/9Pl6iyJcVSMaIefWjJlkIbhRZtatmQS
         B9EWPihiIhMbRlOac9bpdRfJF0HDBBiQ/Xk5HXlolwhAk0euK5unO5IFkFfmxXmZmnV7
         GYLxyuZsRRf9RwmK6ZJbWtrVm4oJucNCJ3SGuqft3h4mo8W0caKJoQT5/l+QIJrkwyYN
         1xyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741447475; x=1742052275;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AnyqBsmlqD/tBRZnGec00fMxsrhMgvwfzn2a+aeT/JI=;
        b=LJq0X603v6+BsXKoYh2U1av0r/G8NKKT7Zp9FbEUL10MZM1RjJN5vHM27yrxpA9u2G
         JwNfYmkvx2Gq83LSNPpWOGynUKW5kMgw+Uh0osC6vutnsXaNSoWOr9e/5DeRg4lTpTGb
         GhrmxRLsHVoMRQl6IP9YPG8ZGtl06dCRFHcpdMWxaR3mv8OMvJs3OyS5HwEpQ67OSMlh
         JprDt+jVEU0K779heddfR3QeF8GdoiqguyrQu1a9fn3fQQUL1OiGdY4Hrjd44r7RdByI
         Apz+FMghkTTxCSsobxYEdHzu0Bzmke4nPGbr6RZj02Rpvb/m+e7XYQKLPJVnA4SWXv42
         tLeA==
X-Forwarded-Encrypted: i=1; AJvYcCXOdt86rv5MeoQ/e3dFwKQx1wuf/u6bHxLZHf6NAxazMvDBRDLVdIPAC3gJVKEthBFCIF9ihVg0@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8W5BTB8Ve+PUKq+2veG6fxEkJ/1xTWlrvxLhBs++4IYx8us2F
	wEMPDBkpVqE8/i9jyQ9OlQzhUxXeZCTrrH/eEAFaU3oFpaNQiBEU6Ko1/w==
X-Gm-Gg: ASbGnctmEsyiG9laevi9KhSCvUJgnq36JJL3+/Wnre8IW1e9CvAdP16OO0xwPFOsJMB
	42mqfrKTNTRf2k62IFOoa7KaJTYvOg1Flg97m3yZIdUOEYbTjEAolJctNIk7ol+AcEcarxus83N
	GVNokNaPNasaK/E/Rs6Ike2BPjyPpe4yJ+eajfslPfeYq3ShpkKaULarG6nrg8Uy0e3jevGYy4J
	bxhna38agyZciwj2MfBOW3n7vGkhhO+CaMpXmDfDx99fr28w7PHe5zmVonSsOaETP7NjO5km5Dj
	f+Od6thfme4JkFLyqHMhi1EWgaKOURM6wFcnOAInn7vhZtgkCaO1WoD9PA==
X-Google-Smtp-Source: AGHT+IHHaus2ApAqxcrdFmQ+yT7IfhTtas4VZTKJvwI8GomHS8+8SKSibt2Tu+bsbFhxp0QEXMB/LA==
X-Received: by 2002:a17:902:e745:b0:223:fabd:4f99 with SMTP id d9443c01a7336-22428886adcmr132213215ad.5.1741447475574;
        Sat, 08 Mar 2025 07:24:35 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109ddcd9sm47970025ad.10.2025.03.08.07.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Mar 2025 07:24:35 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Sat, 8 Mar 2025 07:24:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/147] 6.6.81-rc2 review
Message-ID: <ac26ddda-4268-4f59-bb33-5f68ea00a9cb@roeck-us.net>
References: <20250306151412.957725234@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306151412.957725234@linuxfoundation.org>

On Thu, Mar 06, 2025 at 04:20:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.81 release.
> There are 147 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
> 

Building i386:defconfig ... failed
--------------
Error log:
arch/x86/kernel/cpu/microcode/core.c: In function 'find_microcode_in_initrd':
arch/x86/kernel/cpu/microcode/core.c:198:25: error: 'initrd_start_early' undeclared

$ git grep initrd_start_early
arch/x86/kernel/cpu/microcode/core.c:           start = initrd_start_early;

Caused by 4a148d0054f3f ("x86/microcode/32: Move early loading after paging enable").

Looks like 4c585af7180c1 ("x86/boot/32: Temporarily map initrd for microcode loading")
may be a prerequisite, though I did not check details.

Guenter
