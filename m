Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBAB1F37BC;
	Tue, 11 Feb 2025 10:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739269786; cv=none; b=q8k7AD+3AMWIlUin7t32v9MRGv24T0kqPPpebBXbgE282NV0CTFR4qOd06o+MmdTiHtJQvBiM660YBZ50EPskBaxvTVp+maABv+Oshj7e635ZpBnHjs1j+Eq4HMFQ+LTTN2Q5L+bUj1kxaAxZ2eZcgxNeq0XITntf9Qo5hSmbSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739269786; c=relaxed/simple;
	bh=to+syaS1cNTftbqkhLAjoWWr+w0MHBD4xGRdyjrKsP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D5vs5WCSceM8QU8L6dCxNm2Oc/ZLuevgWvlNe/X41i7lyNXiwxE3uilJAxGiyWqrKnksIf4OtTtn1we5vr2uqf9doUEoBfc0uNbQqu0DvCxWaT+Q7E+lbG8HErb0+iA5Lfk1Khpmr30a6EcLVCeZ8rOxCzc6r8S6p84XtYLoWPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNeP1rAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNeP1rAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBC7C4CEDD;
	Tue, 11 Feb 2025 10:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739269785;
	bh=to+syaS1cNTftbqkhLAjoWWr+w0MHBD4xGRdyjrKsP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WNeP1rALtKFaX9ffl5Z6g9GoueXFKyDJRJPiIQhXNYgrVUEHQwjk/W3oaL0MijRu5
	 x2izhIK6lu+9yVUpcyF2YZkcskjouX5NWoFuxqJ0OOI7G/kludrOTCKkjBWWsNeeQM
	 A06NOcMi5O357L6teE+x83idZVQhzJ1JRXkTp1TQ=
Date: Tue, 11 Feb 2025 11:29:41 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Michael Zimmermann <sigmaepsilon92@gmail.com>,
	Chukun Pan <amadeus@jmu.edu.cn>, Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 6.12 026/114] phy: rockchip: naneng-combphy: fix phy reset
Message-ID: <2025021128-untrimmed-city-0ead@gregkh>
References: <20241230154218.044787220@linuxfoundation.org>
 <20241230154219.070199198@linuxfoundation.org>
 <Z6itgi4kAoNWi0y_@aurel32.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6itgi4kAoNWi0y_@aurel32.net>

On Sun, Feb 09, 2025 at 02:28:34PM +0100, Aurelien Jarno wrote:
> On 2024-12-30 16:42, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> It probably comes a bit late, but this patch broke usb and pcie on
> rk356x. The other commit from the same series, commit 8b9c12757f91
> ("arm64: dts: rockchip: add reset-names for combphy on rk3568"), also
> needs to be backported.

That commit does not apply, can you please provide a working backport
for us to queue up?

thanks,

greg k-h
