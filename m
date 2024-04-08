Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7251DDEB
	for <patches@lists.linux.dev>; Mon,  8 Apr 2024 19:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712605289; cv=none; b=gSPTHIf6c2SErYKQoDZnNzjgq56YdHI0wc+RkFyXIcUUBi89rEJc9RZt8bvkhBUGaN1ICFyhS8g2VERWs+cwUb+ivcM8BKHPGs19SJRduvZQNyKqkYj6PohfvCp6xREt9o5y8vQ43KX4qewOOl1PHpOkYFbayZ4A+JcEABoupl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712605289; c=relaxed/simple;
	bh=S3xOTyU04Fo6JmhxwRhR9/wKIYvQLxQ0GQTLvmmFAII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X945bbQmHo6JrDY6qn0XdrG40OvRy4IhkQJ6dJqUkH9Jthbttbt+1qpUS2U+yWXLO7VPHjz0qVaCvE9K4VhOvu+H+E9L5A6KaaiW7kLroCYKHfOdA73IL1GjjKQFf6TjN7xTWdE/jGF51F9qid+9Qkvm7VqDS1LnQh62Fojm0hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=A5JxKENr; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="A5JxKENr"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3c5ec0c5696so242852b6e.1
        for <patches@lists.linux.dev>; Mon, 08 Apr 2024 12:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1712605286; x=1713210086; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vlG2+sb2I/nukv22GaTz5r2V7S8vwQAqFCnvBWEiOp0=;
        b=A5JxKENr3Plz52Cz4F7GMkF652J6QQPTelMA+ZMUa1YPVxuOpU1HHTj9/tIQPQFsNn
         8NdZvb43F1JcDST3/V6bVDbS1FBCbMDzjmkulDcfUeeNCaoy8zCtwz7PlLvWrQafc3sU
         WxIesdY9ehcXrQiKY5JrlhQQHkkCCM/zfKBdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712605286; x=1713210086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vlG2+sb2I/nukv22GaTz5r2V7S8vwQAqFCnvBWEiOp0=;
        b=kiWoRGGrHfl+t8M1fB4x3d2jKhsbfvEFQVTGhXkv/gT9V82UDDxfbGSN4QW/WPEDaR
         fvvV77nEWkFhpAku6co7TBmZTT7mJWSD6M1db7IcedVrxjNGOe5QCtqcuoJd6Wx+NPcV
         5TA5IgSTjjYlRwE+6QCTchQNpOsQ+U2mLuC4J4uU20LHeNS8SvMsVLypCrw5rUHkEru/
         hMXjhjBXrFRsZdsC37QKwYRrc4pQBkoqpfha7JS5Y2QIyDI2PcMq/hPmGgv7lckUE9Q/
         lup9UJIYndwENAWNnAKovNCZtJQi23ey4ji1A98Y7N68XdrLMUaBtgECQBcZ8lJwzfy+
         Nl0w==
X-Forwarded-Encrypted: i=1; AJvYcCXEAXMbUtKx8uCLXiLERiskjogx7Ha0BLkZA3Hu/GXdotI5ULj+G8doCkPyILk/zux89OXqo6OKWSYKh4MeyTbsB/H8sadm6A==
X-Gm-Message-State: AOJu0YyNPUzEANnjU4r0HkWqMs52kbSHH8mvd8UGNMMe38pKs/eyYI98
	zZO9LRM9MYa3A79vVM55qOFF7/DDuzXqdhT4GL5VwEcCk1ObPScsrIgCUmUYGw==
X-Google-Smtp-Source: AGHT+IGek7isLuUjx9ixY5A+C0MVHTE+URqlTgRG2I5lQX2fHlVkLgSJN2j/OD4vraUj3CKdt55rjQ==
X-Received: by 2002:a05:6808:1c7:b0:3c5:f77e:6133 with SMTP id x7-20020a05680801c700b003c5f77e6133mr2667584oic.34.1712605286570;
        Mon, 08 Apr 2024 12:41:26 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id k1-20020a544401000000b003c5f66569c9sm357473oiw.46.2024.04.08.12.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 12:41:26 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 8 Apr 2024 14:41:24 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/273] 6.8.5-rc1 review
Message-ID: <ZhRIZDN-cnwQLuwL@fedora64.linuxtx.org>
References: <20240408125309.280181634@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>

On Mon, Apr 08, 2024 at 02:54:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.5 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Apr 2024 12:52:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
