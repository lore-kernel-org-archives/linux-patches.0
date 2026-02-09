Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95208385509
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 16:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770655713; cv=none; b=VCRudWtvmbEHbWO1g7MZjDzZgJg8p6buROkJgEt6SONrKbZ/wYVNxz+NKfS1VqY6Pc9yNAvoE+gCJ5nR8pDUMfKknWXFNcTIKWDoBI6gMjkO6+jxNba3EQV/2rLTY63ZU4duBU4BOSrk6Sb/TGYjgRliGzz8lHyxb74uiMRhx7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770655713; c=relaxed/simple;
	bh=8NDDATG6aQ6LMvQ2gFNNY4PrGqtPC+/SDVHQYiKC1pY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PDgbkw0bc97pl3qHbAVyjEqkZSuK8zcmpMPzcUn8tSQ+7ryNR0+QWtZOJgSY//cjF5uLcUDpbWTFBH8sYEMzf9LXJhlBPWJ/PtslzXq29NT1r4IQzaH79MtVgFJNHow/YyUUYWWb9KSaYVIN9XBwh7wpQHqI5oTsMbuvHJQslnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=L13ej2gP; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="L13ej2gP"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id E6F121F83E;
	Mon,  9 Feb 2026 17:48:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1770655711;
	bh=XCuyql1A4cm4vlvW0yd8NJcLJKnkOX6g229lSvEHuJM=; h=From:To:Subject;
	b=L13ej2gPlvfi7QN0vdmNX4mJ7j0HkwR9QU724jgG0ViJzVvLNH5IDjCIJ1LyqH1f2
	 TdoPA4zAcLHegX74FRXVG6P9aoA5MUsycgy+ZSg+q+f3Nnjh1MBpFYSSOmgqLjmCRZ
	 fBh0u+BI3gGfIYVgbaGRgpEw3S8zHdaxwLdhTcunhbHIqFpI0LPuIzGCc188WkJ2lW
	 e9AxmKi2wataPR60R6pjHgl3N/uIIGDd/J5P5i5bFApphmmvLD8GdO3jH9z3DdUhOS
	 +CLtxRnh35WgdwSwMvK6pz2dpjl9WRG7grWvfP6zcrvszMnKFviHjAlOq3T6W3gaz+
	 G7fc4tUpWQWuQ==
Date: Mon, 9 Feb 2026 17:48:25 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 00/69] 6.1.163-rc1 review
Message-ID: <20260209164825.GA239077@francesco-nb>
References: <20260209142301.913348974@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>

On Mon, Feb 09, 2026 at 03:23:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.163 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin iMX8MM
 - Verdin iMX8MP
 - Colibri iMX6
 - Colibri iMX6ULL
 - Colibri iMX7
 - Apalis iMX6

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

