Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F471AAE3A;
	Wed, 31 Jul 2024 09:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722418121; cv=none; b=C2Mu8wwTgJoLGbjPf7kHg7An3Bj+A5q5bBuTIgzBsOiA/JEeVhZNzIk/RpmHivnDZ11CsndqxEZ6y8jfd3U4J+U0OuLaa4QrnrEM/xK1YxirJ3PPlEM7nhkQlwnjfti/q6uZoTGkRED/pXvAx0zYQCWk+Jt70GQ+mFb+FprHZ8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722418121; c=relaxed/simple;
	bh=COdq1RVb77IUjNE9K22BKe/No8gvKusuIPqh2LW5SVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eKighTHpgI2zaMlGcsBOUcsR9vW3HR39X9w0nSxsTmGKfTKS4UevvjvKiIAEzKZ794Zcky/WhAA6nxqX7gqBZXv5h9Kz/713t0pdogdMrjvn9Cav8Uz6jpvLwxQHBzoyfcDiF90T87HiajFtGfKKaVXqkNmlIUg1hbzKTLsLQYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDqo5QNB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDqo5QNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7604FC116B1;
	Wed, 31 Jul 2024 09:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722418121;
	bh=COdq1RVb77IUjNE9K22BKe/No8gvKusuIPqh2LW5SVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dDqo5QNB0ZNO1n4Dvw/zVoqWi9EK1bc5KcT52KuZsGojB+EZ8WyswFDMQL0CSnoFM
	 8VEZ5kmHYybgt1j0aqSsN3X71edtkQB1bTKar+k7QDol13JxuXeJipVpfHh34sL5U/
	 7oRzwmczULo6u+WrVVLXGORMcAoENFuyhkb5MJBQ=
Date: Wed, 31 Jul 2024 11:28:38 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc2 review
Message-ID: <2024073126-idiom-degrease-e351@gregkh>
References: <20240731073248.306752137@linuxfoundation.org>
 <Zqn/mmF1HF1AEsi7@duo.ucw.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zqn/mmF1HF1AEsi7@duo.ucw.cz>

On Wed, Jul 31, 2024 at 11:10:50AM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 6.10.3 release.
> > There are 809 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> We see build problems:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1394947350
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/7470084220
> 
> drivers/net/virtio_net.c: In function 'virtnet_poll_cleantx':
> 4494
> drivers/net/virtio_net.c:2334:1: error: invalid use of void expression
> 4495
>  2334 | +                       free_old_xmit(sq, !!budget);
> 4496
>       | ^
> 4497

Ugh, so do I now, sorry for that.  Let me go fix it...
