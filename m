Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE88101E6;
	Sun, 18 Aug 2024 08:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723971266; cv=none; b=pm+nObQCkTXe39FqXXn0YCpdZSzgDcNuLYCUX09alqQnoLYm3cixKfwMzTgIsrIZvN5rI9/CRzY6AtSnIrS/GruXavPV0SahdUA6WHY7dO+ZYAMn6OvjUYVTPpeBpv3ccMWcQZcQYP6QIRaTs0KvSbzd0y7mYUNiJE+j+xvNeyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723971266; c=relaxed/simple;
	bh=Ahn8HPKiGMYDixpZGtPWS2i5JSvQ1q1/PaZPfbACdcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKmy4CIYFRVKv8tx+KOg8ytTLFe84t1H+TlsZzzsQyeN3r4IyDsXDxOHtbRYgjwZl7+VX+X9+Tdcw/7Jr4QLgtXVRAMsEsdYHchE7K1/N8i8qCY0V8gSpYI5t2+Y7hGRegPaNIRxWjKgNrWVrXhN3eSnD/me/vLc5p9YYx7jc38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/VWEVu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/VWEVu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C86AC32786;
	Sun, 18 Aug 2024 08:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723971265;
	bh=Ahn8HPKiGMYDixpZGtPWS2i5JSvQ1q1/PaZPfbACdcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l/VWEVu1c8S1JWj87ssJQ6ewlibcJjW+zprFm/M92beRlyrZqM4+TrRODGxhUIWqT
	 5KK+2miXsxxUoFulK8EkS+JmTwZrH7mj5bPMbMd5cIcU+X8BVBdKCYYkaz5dvnz2Mh
	 1Rc36yk6W1DpayrACOVxmlHVzqO66wBEeo6C9pWQ=
Date: Sun, 18 Aug 2024 10:54:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 00/25] 6.10.6-rc2 review
Message-ID: <2024081850-wise-ladies-5162@gregkh>
References: <20240816085226.888902473@linuxfoundation.org>
 <886e729c-d3fd-432f-8fce-6f6926b1fdbc@googlemail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <886e729c-d3fd-432f-8fce-6f6926b1fdbc@googlemail.com>

On Sat, Aug 17, 2024 at 01:40:57PM +0200, Peter Schneider wrote:
> Am 16.08.2024 um 11:42 schrieb Greg Kroah-Hartman:
> > This is the start of the stable review cycle for the 6.10.6 release.
> > There are 25 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Now I'm a little bit confused. I saw you announced a new 6.10.6 RC and I
> wanted to (re-)test it. Your subject says -rc2, but when I git fetch from
> the kernel.org linux-stable-rc git repo (which I always do) what I get is
> -rc3 from today, however I have not (yet) seen a mail from you announcing
> -rc3. Forgot to send that one out? Anyway, -rc3 is what I tested, and as I
> already reported for -rc1, it is fine on my machine, too.

You are right, I forgot to send the email for -rc3 out, my fault, was
trying to do other things on a Saturday other than kernel work :)

now sent, and thanks for testing!

greg k-h
