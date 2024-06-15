Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20404409;
	Sat, 15 Jun 2024 10:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718448902; cv=none; b=glIP74yh7X2oMGutT8Mp3Q8K5B3wXcWP4ydKjaShm/BSwnbDSLmmh2/Djj9Vlj9SCzztwh0bU8Hq1Wd87xMz4IqiEo6K09PyU/NjqGhzFTCb9B9qWopk6t/1TbCOZ0YVweCs4B+Xgh0z/3zbFJ8QyNke/fckWEAJZK/Pvzw9H/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718448902; c=relaxed/simple;
	bh=1/bI1faT88w4LX8bhg+Ey+f/7yLeiE3GUl/WjYaEyRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=owq5bCxK4dFEjXzcR1JRbgz/OVfuBhol4oWj66q6m38ZTL5+hVyurbO/DaDqgifVJ9GZ9cEuQPmQq7TIxBM8HjybiFfcuey+j+6VW1TVuTC7hl/tQmYOtkjllWnMxSuDtSsaZUx7VyLTC9uw9QqZG0ZSsf7hxOTg2uEGk9WxerM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqL37M+r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqL37M+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E13C116B1;
	Sat, 15 Jun 2024 10:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718448901;
	bh=1/bI1faT88w4LX8bhg+Ey+f/7yLeiE3GUl/WjYaEyRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YqL37M+rbM/E6yxg50FiBm/lzyEMF8zOUAtJNmjba82GcD92jSgvj4T0m9J8dhGcP
	 mST/IkjS465dNfHDe5qU0ATdY3mPPp7PX2eaqVnei6WyCLiDeKfykRLg8Wi05e5Duk
	 f07YsRES7KeD3SYJOKfjhRJ0Yv9rYqb9wJCCaqng=
Date: Sat, 15 Jun 2024 12:54:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.4 000/202] 5.4.278-rc1 review
Message-ID: <2024061527-skinny-recent-5ed3@gregkh>
References: <20240613113227.759341286@linuxfoundation.org>
 <3ed1ecee-78bb-450e-933f-1e06b1e392bd@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ed1ecee-78bb-450e-933f-1e06b1e392bd@roeck-us.net>

On Thu, Jun 13, 2024 at 09:35:07AM -0700, Guenter Roeck wrote:
> On Thu, Jun 13, 2024 at 01:31:38PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.278 release.
> > There are 202 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> > Anything received after that time might be too late.
> > 
> 
> net/nfc/nci/core.c:1455:15: error:
>       mixing declarations and code is incompatible with standards before C99
>       [-Werror,-Wdeclaration-after-statement]
>  1455 |         unsigned int hdr_size = NCI_CTRL_HDR_SIZE;
> 
> Maybe enable C99 on older kernel branches ?
> 
> The code is
> 
> +static bool nci_valid_size(struct sk_buff *skb)
> +{
> +       BUILD_BUG_ON(NCI_CTRL_HDR_SIZE != NCI_DATA_HDR_SIZE);
> +       unsigned int hdr_size = NCI_CTRL_HDR_SIZE;
> 
> Swapping those two lines would be another possible fix.

Odd, I fixed this for other branches, but it didn't trigger for me here,
must be a build issue somewhere.

I'll go fix it up now, thanks!

greg k-h
