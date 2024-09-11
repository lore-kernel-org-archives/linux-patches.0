Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCA31BB684;
	Wed, 11 Sep 2024 20:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085698; cv=none; b=Qq5HSHsMgvK1VAVDynLL1g8n5CNwMSgGfMoPgDNrp7t73uJ3LfCzpgwGJRRSTvCoXEFzZaLf60E7CrlX8I6zmL4AzSoPGuTVB88Oc1XotgKgq+iP0yiwK9kUgt64pxpB/EGiroBX8SjoZv9xOoaB0IFII7b1HYS2+yMPtcSJkjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085698; c=relaxed/simple;
	bh=tTzueqvJZSwNGtAUxZsJa3Qkf8M9iYbOpXyKF9YvBIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dCIOUty4HbOePzHDt7hawrzBXGYQgxcIVRmErmBO6zgBvl5Dwk6MEW0BviKRrweosnFYa7kP2J8c8k6U51VSC/obPMLt0CdjL+FC8yLOcVZ3nx9VpwtLM+rlolpctr8BktSg6gdXTQRROYOYMYTO72MIjp477frjS5TY8L+IOls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oc1UXcoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oc1UXcoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC7BC4CEC0;
	Wed, 11 Sep 2024 20:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726085697;
	bh=tTzueqvJZSwNGtAUxZsJa3Qkf8M9iYbOpXyKF9YvBIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oc1UXcoQikN7QJc8eJ+K9TOkXKU+4cSkUrBKXBjBLVfNhBRw3u9UNHTBbt4oHhVmV
	 FQ3yNVv5tZkwU7laOglXcL4bUI08tF6LRxqbEldDho8b0N9Sy18pG9hMV5N1r+GVMJ
	 124vk+S7H/9BrcsfIZtPz6Qa91Bo+sQH2FiFhlJs=
Date: Wed, 11 Sep 2024 22:14:54 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/212] 5.15.167-rc2 review
Message-ID: <2024091145-pavilion-probing-04e8@gregkh>
References: <20240911130535.165892968@linuxfoundation.org>
 <9bbb8370-758a-46bf-a01d-7e4d4f3c3a68@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9bbb8370-758a-46bf-a01d-7e4d4f3c3a68@linuxfoundation.org>

On Wed, Sep 11, 2024 at 11:25:32AM -0600, Shuah Khan wrote:
> On 9/11/24 07:07, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.167 release.
> > There are 212 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 13 Sep 2024 13:05:05 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.167-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> All good without the iio/adc/ad7606 commit

Great, thanks for testing!

greg k-h
