Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13D120B800;
	Tue, 15 Jul 2025 15:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752592280; cv=none; b=WkMkNxlIyEDnRSy8eEvua3RkRFlVt0I10jCybbmdcA5NlFi+we6rYgbGBlg0Zk3sR9SOqB/WCvzdbfOksHle72//mgDj59vWQeFyJFzFLFtVnKb+ncKQfysZTQml+ZA9YbIIiTJeTA1rGjnNSv4g9QD7erMOXvhe9dAgzkvfspk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752592280; c=relaxed/simple;
	bh=mhVQZmZ+FqDBwUNJkhEO6SH66vkS5/asCSureVLx2io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYdCDcMmUs3L0HfjymqKQGGZIbDT4CnbAPbWlj8FiIn9cnMVlFt3sPfWHpQjLtGdVKCmS1HA8pL0M3HNSeY4FlBKHBtIv/B+PqiqrEomVhXVVrOuXaNFShCUuESepUuuab4neciJne1ZIwgUfELxsHx9ng55XJIFz+uJolRDxko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/wZw3pM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/wZw3pM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D58C4CEE3;
	Tue, 15 Jul 2025 15:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752592280;
	bh=mhVQZmZ+FqDBwUNJkhEO6SH66vkS5/asCSureVLx2io=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O/wZw3pMdGmt7Dn7fLUYYt+AaVfX2tZzWqZi2e/us/TArnR2gIB9g2yoaJglEvedm
	 YB5Rd61mcQiPY+f0XJ1GZwOiINKp53b12j18PwzvfmIKr/zSCwO7kHOde8OdP6PXdY
	 3kVF5K5waMZn5eDFanh0mP86JN+vGPJ4F7xgVFrU=
Date: Tue, 15 Jul 2025 17:11:17 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guido Kiener <Guido.Kiener@rohde-schwarz.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Jian-Wei Wu <jian-wei_wu@keysight.com>,
	Dave Penkler <dpenkler@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 022/208] USB: usbtmc: Add USBTMC_IOCTL_GET_STB
Message-ID: <2025071536-rummage-unlit-70d4@gregkh>
References: <20250715130810.830580412@linuxfoundation.org>
 <20250715130811.725344645@linuxfoundation.org>
 <b7899ee9fddb4a39bce1349d7d1224ad@rohde-schwarz.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7899ee9fddb4a39bce1349d7d1224ad@rohde-schwarz.com>

On Tue, Jul 15, 2025 at 03:00:52PM +0000, Guido Kiener wrote:
> Greg,
> 
> I got the series
> [PATCH 5.4 015/148] USB: usbtmc: Fix reading stale status byte
> [PATCH 5.4 016/148] USB: usbtmc: Add USBTMC_IOCTL_GET_STB

Odd, that second one shoudn't be there, right?

> [PATCH 5.10 021/208] USB: usbtmc: Fix reading stale status byte
> [PATCH 5.10 022/208] USB: usbtmc: Add USBTMC_IOCTL_GET_STB

Same here?

> And I assume we should add the other two commits as well to complete the series:
> USB: usbtmc: Add separate USBTMC_IOCTL_GET_SRQ_STB  (commit d1d9defdc6d582119d29f5d88f810b72bb1837fa)
> USB: usbtmc: Bump USBTMC_API_VERSION value (commit 614b388c34265948fbb3c5803ad72aa1898f2f93)

Nope, I didn't, maybe I should just drop both of the above ones, as it
doesn't make much sense to have only the one, right?

thanks,

greg k-h
