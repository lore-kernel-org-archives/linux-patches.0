Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B707B4EB5F;
	Sat, 27 Apr 2024 14:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714226944; cv=none; b=lgZ0FODGRqcfhok1uO2+ore2WlS4jH86RKajh15bEfD0XANPaqd66bMgWMVbzyS+3MOQYJi9C97wj8eMa1BIq+ZI+UZDADjg/2hOw/1pBUufpPjW1frNNEaSI6g3SFJFP8qaAQadctHEZId+5YOObMXK00wT6mLX4okTbZ8ZXlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714226944; c=relaxed/simple;
	bh=yAIBluyr4m7ZPbE2jFT64eDNJQ1GDVrppWdTA9F5FBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=loBneXMDyAY41Fat73ty1TTAEFHkRNiTpvFqjVyBGbbeEM8jpqNm0mGWeNygIW2JPwNxmjEUv3LqYNPLbff2vdmyIA4sdx46xXG/i/bEjTi8YpWTyCWdX7/jqw4FZgZNKX5OasXusk3YTroJHrFB1RBwnxBde6imt3xwMFj6kyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNycrrX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNycrrX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825AEC113CE;
	Sat, 27 Apr 2024 14:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714226944;
	bh=yAIBluyr4m7ZPbE2jFT64eDNJQ1GDVrppWdTA9F5FBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CNycrrX9nXEnQgAMvI/EZh4Wr1RhJCSHf0i0QA6OboawrjP7n+sTzR6h1bKsbe7Yx
	 kE8CrOqTZW6/lthdXW3UNysTS6isA1E+ah6NN/HCwIs4VMCzxz7s1xifBo632LSaCA
	 FtX+5G3+fIybt15K18OI2akD+4rcPDDge1gLJsmU=
Date: Sat, 27 Apr 2024 16:09:00 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 072/141] usb: pci-quirks: group AMD specific quirk
 code together
Message-ID: <2024042753--c208@gregkh>
References: <20240423213853.356988651@linuxfoundation.org>
 <20240423213855.550710788@linuxfoundation.org>
 <eaffa3e6-9ef7-4352-8da2-8be633f5741c@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaffa3e6-9ef7-4352-8da2-8be633f5741c@app.fastmail.com>

On Wed, Apr 24, 2024 at 08:28:55AM +0200, Arnd Bergmann wrote:
> On Tue, Apr 23, 2024, at 23:39, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Niklas Schnelle <schnelle@linux.ibm.com>
> >
> > [ Upstream commit 7ca9f9ba8aa7380dee5dd8346b57bbaf198b075a ]
> >
> > A follow on patch will introduce CONFIG_USB_PCI_AMD governing the AMD
> > quirk and adding its compile time dependency on HAS_IOPORT. In order to
> > minimize the number of #ifdefs in C files and make that patch easier
> > to read first group the code together. This is pure code movement
> > no functional change is intended.
> >
> > Co-developed-by: Arnd Bergmann <arnd@kernel.org>
> > Signed-off-by: Arnd Bergmann <arnd@kernel.org>
> > Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > Link: https://lore.kernel.org/r/20230911125653.1393895-2-schnelle@linux.ibm.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I see now you had it for 6.6 and 6.1, so it has the same
> problem as the other one, with the dependency on fcbfe8121a45
> ("Kconfig: introduce HAS_IOPORT option and select it as
> necessary")

Now dropped, thanks.

greg k-h
