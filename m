Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F140A250E0;
	Wed, 28 Feb 2024 08:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709109665; cv=none; b=BBT7sWvRRgMLVMQbmuUkjHzyNCRYscVALkm1MyjLtg/bZnY2zD4e5PQ0vuXoN5c3SS8GrcnssheGJV3PYOPDY4Os3/tYNWYQFy/MYy5/EMs5zU7ewQLDOb+Jx0tjm+ZcE8MFcuKHHyOO4uwF/X+iLomrhK2NxtP+CG8uBI9DA7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709109665; c=relaxed/simple;
	bh=taafjeMyLx+9A4Iby9wddzCXCgysrqJkoAayHjldvJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XWU8I9ZcSxHqKpFbmxXIa1e0lmAhny6S5WAr2qGsLaGTLWdAP/4+s05bpNZsMu3glpoMjFhIMM5Gc5e9PGPMzETw1G1iHJrsGxzrUhM1w8PdnBfjFTamHhTIzUx019vm8yY8hS8ECmVkPkFf/CLraJAfp793gSGBrokOAVeHBq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1K1wDlxw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1K1wDlxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E5EC433F1;
	Wed, 28 Feb 2024 08:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709109664;
	bh=taafjeMyLx+9A4Iby9wddzCXCgysrqJkoAayHjldvJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1K1wDlxwagH9FXS5ejZTkpIRH03hI+OXuCp+2qxgSLqThN5b6P8k9fWdzJAw3ryta
	 WEjoDRm7HevLEW1uVzK3HCbOPvcEUrDO8tcsqXO1wXuK9o5Udd7KpyyiSIRFvDGecv
	 G3E//UuB1RL/tISXQKIaH9V2xkr5AxmEjcDebv+Q=
Date: Wed, 28 Feb 2024 09:41:02 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	Lennart Franzen <lennart@lfdomain.com>,
	Alexandru Tachici <alexandru.tachici@analog.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Nuno Sa <nuno.sa@analog.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.7 260/334] net: ethernet: adi: requires PHYLIB support
Message-ID: <2024022852-drowsily-matchbook-7363@gregkh>
References: <20240227131630.636392135@linuxfoundation.org>
 <20240227131639.320153289@linuxfoundation.org>
 <66b4f46f-bcbd-42da-b4d6-0ecd507f8bd8@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66b4f46f-bcbd-42da-b4d6-0ecd507f8bd8@kernel.org>

On Wed, Feb 28, 2024 at 09:06:20AM +0100, Jiri Slaby wrote:
> On 27. 02. 24, 14:21, Greg Kroah-Hartman wrote:
> > 6.7-stable review patch.  If anyone has any objections, please let me know.
> 
> This patch is not nice and should wait for its fixup IMO:
> https://lore.kernel.org/all/20240226074820.29250-1-rdunlap@infradead.org/
> 
> It makes PHYLIB=y even when not needed to be actually built in.
> 
> > From: Randy Dunlap <rdunlap@infradead.org>
> > 
> > [ Upstream commit a9f80df4f51440303d063b55bb98720857693821 ]
> > 
> > This driver uses functions that are supplied by the Kconfig symbol
> > PHYLIB, so select it to ensure that they are built as needed.

Now dropped from all queues, thanks!

greg k-h
