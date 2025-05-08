Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DB78472;
	Thu,  8 May 2025 05:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746682296; cv=none; b=nrfUqrcd3ZM+7DstKGujmb4khiqYz3xSGnJ/RKmkpwxUxLb3JY5VhWNqh9sJiphNHtHnyDLfomaPEv8W0iH1dbU4OHWx4zdS+sAm3E9qzA4Jh4yrDb8tw0LUjaV7kCBm4LW0m7Ijfx3JE00rNivqIvwkK7Bu+MXCxt7SxFZfV4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746682296; c=relaxed/simple;
	bh=OlPhbI3x3AZ1gs9WaWYuSN9YWKFxO7U0sgGUlEfeRrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ayB4rYtksIoUe21nCpuDkGEpEJeu4K4bXFuZZNcX0v3AKb2kFMujxNujWC33C+M2SZUI7IK/dx0DiBA5BM1dRC9Vkgru+FKsSvYs4v/zIS2Ax2voZnJiDqsaK8ywOvXxtprr8EBFU6ASRmPapBAWkp2rrLlWU7DOdChO5RoKssg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmBXAKG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmBXAKG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58525C4CEE8;
	Thu,  8 May 2025 05:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746682295;
	bh=OlPhbI3x3AZ1gs9WaWYuSN9YWKFxO7U0sgGUlEfeRrg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jmBXAKG6exS5Cp3WG7RGKUB7Hy2W8+w7CaN+uJ4oAfp/qRaaDh7oZWWkr9zAjsngV
	 KWasR9mGxa5ZA16S4nwLsJoIKXWrJCnyhOkJGn36J2DcVnf76n3ZQLsLoRH8Jc4xJ/
	 F9g1DsXe58l9C42ZXANnHStVIbg6bvnpOY8tBytA=
Date: Thu, 8 May 2025 07:31:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 6.14 030/183] dm: always update the array size in
 realloc_argv on success
Message-ID: <2025050813-denatured-stabilize-d824@gregkh>
References: <20250507183824.682671926@linuxfoundation.org>
 <20250507183825.912392976@linuxfoundation.org>
 <2c92ae25-854e-2d60-4b6c-a4cbcd5f4ebd@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c92ae25-854e-2d60-4b6c-a4cbcd5f4ebd@redhat.com>

On Wed, May 07, 2025 at 10:34:32PM +0200, Mikulas Patocka wrote:
> Hi
> 
> I'd like to ask you to also backport 
> f1aff4bc199cb92c055668caed65505e3b4d2656 ("dm: fix copying after src array 
> boundaries") to all stable branches because it fixes a bug introduced in 
> the commit 5a2a6c428190f945c5cbf5791f72dbea83e97f66.

Now added.  Sorry we had not caught that, but as it's not in a -rc
release yet, our tools don't know to look for it.

thanks,

greg k-h
