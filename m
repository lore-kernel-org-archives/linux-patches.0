Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3AC84A51
	for <patches@lists.linux.dev>; Wed,  7 Aug 2024 20:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723062916; cv=none; b=qTaTws6tsD1hB8JEZennpYDgORZcQi8fpnI/2lwgKlqKeRf2hWdZNrZCu7iWkT+G3Fvn4yqjHhj2KA+bxrn8zteI2P1sd5ls6Ii1oLcK3ZJhIi15QtSJXRO7jn47q03lHfR14ry/Tq7tMrkvfC/TvXAAXo346CKTwT02iViyap0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723062916; c=relaxed/simple;
	bh=qBbWL/E7dVwm/+E2BMlbjiTzO0J3JlgIgKy7sLixUfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YxXB+fWXptjZj2+kk9yd0c/iiRfWDoYgj7fjuJ+L65nlHcZZiAMS5lLkpBv6fzv9RuGtT/pd8Hlw8oBwg6lZVK6hrw9mT1gitEtDKsBwsb/22dyXCPE4Ut+z3VPQvyHcOaGJDDCa2Dsvrw0pBBoK4EdSF6RKkuSQa3onDntOpYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lzbUcdZi; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lzbUcdZi"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-368440b073bso159313f8f.0
        for <patches@lists.linux.dev>; Wed, 07 Aug 2024 13:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723062913; x=1723667713; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lNxGrrfKIhfJF4Io8gZIBAgwnq2hHF0xRbZogrcKOpI=;
        b=lzbUcdZizgeok7s1+4vgSyLUes6Z9VxKEmO3Yal6d1RKqUUiAYdtDfQx6S46LsYbvY
         sDyZoLrXgD/EHOpNmBf/cU5MSJxOw8gEMOvSr7j4YEFBE0B1azxu7a0zuyff/5hFqdKI
         8nbowi69r38hM9LBH2HuOC8UCfPm1AfgWAUIfIOmFA1i70gYreblF/P7F154JH0VDpyg
         ZMfdvdzV/3N4ApAeQKQGJdeUFW2CdmsFzEVtpbps/vJGR+fuFl6OT0IPnPJqLY7T2XPk
         ohSClDBjEPlk8SewOBs5KYKYRBdhQ0kEFXoAcgG7dREFYX2yf5+8bbiDjiVx1LY4pr18
         TlNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723062913; x=1723667713;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lNxGrrfKIhfJF4Io8gZIBAgwnq2hHF0xRbZogrcKOpI=;
        b=mgBsJr2WRJrsHhduze3UzVegzZL/ac37aHB9B4R8k2pxTuULqvv0jPMpTHWkxfMNXD
         riOWZfcI9ZD8eoYysRwcymUNMDb0ZL6VL3rb/rcK5uVUP8UVMhxwoh8SQ9Czt3ZGpBIG
         naANqSdwsFodV4KQ+XnSj1lT8T9ZmADV2nKv9iKH6d38Gl8vOtXieRzN2xME/EdF+5FA
         UNfjs42tw7KdqILEWhsCHvvoIj8UhgY5HSTMRg/93vges0SU6VyXaJLAVFszsaGKF3jA
         LS76sxZm181d8DLJPL2S++Bar5kiKXhya/DiO+fNl2a/iW040OBYHoMekY2a+Ke2SsLj
         LbFA==
X-Forwarded-Encrypted: i=1; AJvYcCXgRlSneM7AFrg/Tm9pASep6yaTHQAQ0HaDlmn5cXOab8CSrASPrwGVGCSgkaVelhde5U63p4ROk08Q/UJ+fbt1Iy3Gl49/uQ==
X-Gm-Message-State: AOJu0YwxUakg6dkcK0wgA4LnqpSuNaoX3336cNMDbmygfLWASgBGP0dm
	seD4YWNhbM8DSfFZYJ+uqC1OCeqbb80KswNMwlgobXzG3s86+6eG
X-Google-Smtp-Source: AGHT+IGcPA1L+NIrYOGJiS0c9GwB7dYI5msYuSnJXjCW+syfUwF8BTHYfKMjXvwQRrEJNb8b0j50FA==
X-Received: by 2002:a5d:6483:0:b0:367:938f:550 with SMTP id ffacd0b85a97d-36bf0f6e472mr3441387f8f.25.1723062913094;
        Wed, 07 Aug 2024 13:35:13 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36bbd01ede3sm17096780f8f.47.2024.08.07.13.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 13:35:12 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 7D5C3BE2DE0; Wed, 07 Aug 2024 22:35:11 +0200 (CEST)
Date: Wed, 7 Aug 2024 22:35:11 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Akemi Yagi <toracat@elrepo.org>,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: Re: [PATCH 6.1 00/86] 6.1.104-rc1 review
Message-ID: <ZrPafx6KUuhZZsci@eldamar.lan>
References: <20240807150039.247123516@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>

Hi Greg,

On Wed, Aug 07, 2024 at 04:59:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.104 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Aug 2024 15:00:24 +0000.
> Anything received after that time might be too late.

6.1.103 had the regression of bpftool not building, due to a missing
backport:

https://lore.kernel.org/stable/v8lqgl$15bq$1@ciao.gmane.io/

The problem is that da5f8fd1f0d3 ("bpftool: Mount bpffs when pinmaps
path not under the bpffs") was backported to 6.1.103 but there is no
defintion of create_and_mount_bpffs_dir(). 

it was suggested to revert the commit completely.

Regards,
Salvatore
