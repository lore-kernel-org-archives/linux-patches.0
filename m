Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D24735CB7D;
	Tue, 16 Dec 2025 12:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887029; cv=none; b=TwBZ9oNA5ZrJebigF6CFyKAlGLNQ+gOUdg+e9gDmEs3vE7V5upTTTfspdk0yVxZm4Nt/1kUKJ6MDqQN2bSbko9bLYyzrCPcqs0h5KMh8TWBH1ldDZPV9HlrsUoDZzgzIME81FWPAbroAgFwXN/FvuwR+wXtfX8ftY2VoS3wLqmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887029; c=relaxed/simple;
	bh=Ukvac/PC6VT9CPI5Jv9iXasF2oStGxJCs1eoK/0qiOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ksvb03y5wJ8dURuTFAhWUdYdvPik71ZWvbhRDOyhoxjzJQ+2afJaj0SSn9II2MOh/n9N/1F1Ma6UxtUcKJh/KzH8edJzaC7lKUeRn7/KFH8iKiL2f8nNbyz7CML2duhJqEZ7F9M1sxCbUOcpzrpM7Q9NEyZBffNQlJ4Br7WW+y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Date: Tue, 16 Dec 2025 12:10:08 +0000
From: Brett A C Sheffield <bacs@librecast.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.17 000/507] 6.17.13-rc1 review
Message-ID: <aUFMIK_av7G3aKui@auntie>
References: <20251216111345.522190956@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>

On 2025-12-16 12:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.13 release.
> There are 507 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.

git has 6.17.13-rc2 not rc1 ?

