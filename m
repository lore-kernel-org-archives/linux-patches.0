Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6D417D88C
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 23:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719357554; cv=none; b=CxDAueyB0Nx4VPc3JQRbcW1jpBzk9/ognFteHATkLgoe8YYRH6gpo/yxQv20V9UL+54HWi03r5dv2ySFuvT2Fk7WJ65PkVFf7A8OZlcf7VBHrx0DX+FKKEE5dur6REfRnkHcQvfG0FKafkXwPaPC0EAM/HhKlbWgRZJuE9q1wMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719357554; c=relaxed/simple;
	bh=3cLkEoQgP1YdwO0BfLrc2Nt9hXh8gTQtQS3drljKsUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I0lnsJB0pMTJ70TeL4WzxL2InfMoQ0sDjgTlvvtwJRP7WSN2J8el41zenMDC7EnxJ68d43EEEJzviVn5uxxfPMi29OjX7T8qXL9Mf6RIsV0HqeMh6xmj5FLE2/o9THYx6K2z6coafFKxlttVO/rj8KnxaA+bNwsbBvCnn1/MNf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=QO6bNSPI; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="QO6bNSPI"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7ec2d71059dso234789139f.2
        for <patches@lists.linux.dev>; Tue, 25 Jun 2024 16:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1719357551; x=1719962351; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W1GHJHK8fYZOK8MQRqagipkH8Y/cWBs/Aado6nOWSJY=;
        b=QO6bNSPIGo54pLnxbIbujF5c2tlY0npPWeWDF1Cu7zlgmkwgejItb0a4Hl9sKBDlEI
         httwOx93y7b+FOiGePgGOhc+NiiIqUporR1V853gEdTWdjv2cldeBtHa9vosCH/iEwGv
         J6haAbfng8Zd68tTfwxJUlV/cXuq1b6QDUjUY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719357551; x=1719962351;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W1GHJHK8fYZOK8MQRqagipkH8Y/cWBs/Aado6nOWSJY=;
        b=uj6zYdhCN1U43bYeeU6gCgH3h8JeLiglqF7+akTVZQpPi66q0Z4uAfoQ0BZzSClrfB
         drUD9sZUyBLPPGPtnoc8tKGb1drxauR+KMt26G3Oyxk+n1zzul1xWjaaGDrMyyQElG/j
         Zd48/bAeJEqqIP2Q5lywn9rVdr4XJ++moBOQPJ4FOsztK2CvTg/8yvCawuMkcPkbLelm
         QQJwNltbj/uD/VUjC8J8sLf3hAWQxta4Uj0DKcPFKoXXnT16lELIb6Z1jHpDYD8/K29D
         +ThBY9dqYFgC5dS2wgiJJBYaHNGaPTYLK1XjXIWmaFh7C+nntK1BjignHdnTjMwc06J/
         8suA==
X-Forwarded-Encrypted: i=1; AJvYcCWObJYfqs5aeqedpVk9MSvVYPlC0c3aHbs0L3e/5x3sB9kfc34qbf+5vHh5teD25io8nT25eTXQ/q0GTlbm10/OqlQ4ZM13+w==
X-Gm-Message-State: AOJu0YxFzfwx/PWffU0e6iqDhJIIIl4wbS6WDzxYjJYAUwcVrywIv1YR
	PicfMGsJwbammE2DXSRj3R1RZLzrHy6ixOFoXaIdzDjKz6c9eUtMyqXMLLxLiA==
X-Google-Smtp-Source: AGHT+IF9PvWW+uGfCOxuE7/74/1AIT0M4Il4mBFOfwU/j90/kgt3HudyWaRkt4x9JkWeKxP9KFOJEg==
X-Received: by 2002:a05:6602:3fcc:b0:7de:a982:c4a5 with SMTP id ca18e2360f4ac-7f3a7532b56mr1053100839f.6.1719357551339;
        Tue, 25 Jun 2024 16:19:11 -0700 (PDT)
Received: from fedora64.linuxtx.org ([72.42.103.171])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b9d127b6f0sm2837019173.178.2024.06.25.16.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 16:19:11 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 25 Jun 2024 17:19:09 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/250] 6.9.7-rc1 review
Message-ID: <ZntQbVyebJZZCbh_@fedora64.linuxtx.org>
References: <20240625085548.033507125@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>

On Tue, Jun 25, 2024 at 11:29:18AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.7 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
