Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B5820F064;
	Thu, 23 Jan 2025 14:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737641481; cv=none; b=eS961sxmdtkE5HXlo6JaBDmIL2tOqQmi3qWGTlvijjc9IKNY5ZxhiCt99cjBqL7cEKLsd00yYskEcGGBhfcG4XJUruSGCd4327w3IqvLvyyKHD865ENpE1uY7XUQafd389QuDdXV6oWOLjb64wv+jGB23Am1BoAuzP+gVeDF7ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737641481; c=relaxed/simple;
	bh=aqJKtOWUELsqDb6sVjS+/8vhWARd3/LryBUFJ8VErsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cLaw4ZuK6XKH9wTC1201rUumBaR7inSBX+LgF0rZ79qNgK6ENnziv64+0/q6QEA4I4UOE2YWEw26PjM1/xzjfiJUV+gYoqD5bKfQlrvPEtSbRkBxfv/0Z0RjE2f0bC8l1EjkhAXe4kbBT2GF+AtF3hwGQ/+zR57OQWhYYptyIR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKmrbb14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKmrbb14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3244C4CED3;
	Thu, 23 Jan 2025 14:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737641481;
	bh=aqJKtOWUELsqDb6sVjS+/8vhWARd3/LryBUFJ8VErsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fKmrbb14b90vwOD45bKGfu8/ZMmCQMeHY6fvI6z5frHGk7hJlL0KHETP4U7c/Qqxj
	 +q3KW/VTXQggn9HMRHHAQ3AKXEuDnymvkh70AmJl7uqZsqFVgI3zogR1MXIXenwMNM
	 C6WSbxHIQtP23mX37GoC71Jm9CzsiruWreFKOxeU=
Date: Thu, 23 Jan 2025 15:11:18 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/127] 5.15.177-rc2 review
Message-ID: <2025012347-storm-dance-adfc@gregkh>
References: <20250122073830.779239943@linuxfoundation.org>
 <010553d5-4504-40d9-a358-8404f57ebe9a@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <010553d5-4504-40d9-a358-8404f57ebe9a@w6rz.net>

On Wed, Jan 22, 2025 at 05:20:54AM -0800, Ron Economos wrote:
> On 1/22/25 00:03, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.177 release.
> > There are 127 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 24 Jan 2025 07:38:04 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.177-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> The build fails with:
> 
> drivers/usb/core/port.c: In function 'usb_port_shutdown':
> drivers/usb/core/port.c:299:26: error: 'struct usb_device' has no member
> named 'port_is_suspended'
>   299 |         if (udev && !udev->port_is_suspended) {
>       |                          ^~
> make[3]: *** [scripts/Makefile.build:289: drivers/usb/core/port.o] Error 1
> make[2]: *** [scripts/Makefile.build:552: drivers/usb/core] Error 2
> make[1]: *** [scripts/Makefile.build:552: drivers/usb] Error 2
> 
> Same issue as with 6.1.125-rc1 last week. Needs the fixup patch in 6.1.126.

Ah, ick.  It's hard for me to build with CONFIG_PM disabled here for
some reason.  I'll go queue up my fix for this from 6.1, and then your
fix for my fix :)

thanks,

greg k-h
