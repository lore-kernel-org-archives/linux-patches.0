Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D89387346;
	Fri, 27 Feb 2026 14:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772201445; cv=none; b=IPF0tgggT4VWzhscD/8YMn7jUP9dDXZ5ciNMmMiO4LWI/wQKCu9D4MUbhmw5C1huqatsUD/G06v+n50Bjhce4gJkwV5bD4wjqTz5RWk/BapooLuEC/19tsPHxkO1c9CvUe8Ftgut4FakEbwQH5gQO1xCS00lRC0xWJJ7DXelqvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772201445; c=relaxed/simple;
	bh=+8HKyQb5ESJqbQ/xnCc/TQxt9Gzs22k9LSs9+7Khgko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nv7iQgOFI0f0h9Vxz6j9ywTllsttMQvxJDkWHMozwlTFiN/CuaJffzkq21Vrz5fMJQoZuJ9/6X/6ws9lw+nTeVP/AysgaTarZO8fPoQz1zfUFvi21o3+gdRwlQ/oKmc/ZsSRRNYRF3CCCk1a4jjU1SKj+pxumqKKMEEkhznr/+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJ6rXboD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJ6rXboD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F843C116C6;
	Fri, 27 Feb 2026 14:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772201445;
	bh=+8HKyQb5ESJqbQ/xnCc/TQxt9Gzs22k9LSs9+7Khgko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YJ6rXboD+qyeX9++Hu4wlXaHX6FjT0x7R99QftvER9k76nujnDW6hWyKQqvhxqb//
	 SvWc5iONizHA6ayY3rjYJ6b+x6DxYZyrLvYlCj07slLGtYN7oaZkt0AX3+gqOiGi20
	 XG1EbklMoVlLvETF1j0SnLQ7WYz1GUMW72luRZVY=
Date: Fri, 27 Feb 2026 09:10:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/641] 6.18.14-rc2 review
Message-ID: <2026022711-unpicked-boozy-2eb6@gregkh>
References: <20260225151847.709818960@linuxfoundation.org>
 <0cc404f7-f2be-4e31-bf6a-1c46e9d07b54@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cc404f7-f2be-4e31-bf6a-1c46e9d07b54@sirena.org.uk>

On Fri, Feb 27, 2026 at 01:47:51PM +0000, Mark Brown wrote:
> On Wed, Feb 25, 2026 at 07:51:50AM -0800, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.18.14 release.
> > There are 641 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Tested-by: Mark Brown <broonie@kernel.org>
> 
> (I mentioned what looked like a regression on IRC the other day, it
> looks bogus from my investigations - just bad timing causing a flaky
> test to flake consistently everywhere I think.)

Sorry for missing that, have been traveling for conferences.  And glad
to hear it was just a flake.

greg k-h
