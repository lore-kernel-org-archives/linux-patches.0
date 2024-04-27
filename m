Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C637663B9;
	Sat, 27 Apr 2024 14:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714226955; cv=none; b=mk5hMKDp9ZxsAS7kXKNcStUSBZ5sUzxUyLTvw7zeVNNs9H7ESluBFFH5QzpE7YvF1H22rcp8VPi6l1l4i5Oy6rLi+XCBPqphnqyqkBuwS+fBHB0kDL8UaAry1Q3rUnBiQx1PD6NB8XLQfMQtQB4Oeee+EAZYPtuvhtMJ+x0ANwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714226955; c=relaxed/simple;
	bh=P2z+g+vjKGPWMyIYKbx/WfsBA2Ma25StkOANAoXPNeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NezU0FdHLsO7aTwlFklFqAwgKKEIHLNMBJaiwNGENk/JDU/wVtVCkOCvWCNNUclvD/i/Z+WA5yHNstqHA2XUiua7XcaTHCW3kuJj876O4wK+gfIaJYApeN/ih/d609R4bZtgkRR9EI0bSXFfery/yQLKmbBI3E+TgetSB5C1Rs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DS5/8lXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DS5/8lXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02F3C113CE;
	Sat, 27 Apr 2024 14:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714226955;
	bh=P2z+g+vjKGPWMyIYKbx/WfsBA2Ma25StkOANAoXPNeU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DS5/8lXAwWkCatT+u0RWbOINVpeAvU3gcQFD4OdRWw8QhY8PN7KTa3sqlLywjv0Ya
	 d1CUV/l9jG+Lp6qMRi+rmyBpzM5MVJY5PAgCYEcR1A2iBfvUAFfRRJ5YdzLFlAxq8i
	 aFfqxJ+0tCVWaJSSQ2q4wAAltvWcQFSh3fzMFjoY=
Date: Sat, 27 Apr 2024 16:09:12 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 065/141] PCI: Make quirk using inw() depend on
 HAS_IOPORT
Message-ID: <2024042706--33af@gregkh>
References: <20240423213853.356988651@linuxfoundation.org>
 <20240423213855.355112439@linuxfoundation.org>
 <a3f702a6-c6b2-46a5-8c15-f048e30dcd31@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3f702a6-c6b2-46a5-8c15-f048e30dcd31@app.fastmail.com>

On Wed, Apr 24, 2024 at 08:23:44AM +0200, Arnd Bergmann wrote:
> On Tue, Apr 23, 2024, at 23:38, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Niklas Schnelle <schnelle@linux.ibm.com>
> >
> > [ Upstream commit f768c75d61582b011962f9dcb9ff8eafb8da0383 ]
> >
> > In the future inw() and friends will not be compiled on architectures
> > without I/O port support.
> >
> 
> This was only a preparation patch for a coming change, and it
> depends on commit fcbfe8121a45 ("Kconfig: introduce HAS_IOPORT
> option and select it as necessary"), which was not in 6.1.
> 
> I don't think we want to backport fcbfe8121a45 or any of the
> HAS_IOPORT changes after it.

Agreed, now dropped, thanks.

greg k-h
