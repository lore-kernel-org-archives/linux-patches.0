Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CC82E36E4;
	Fri,  4 Jul 2025 16:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751647427; cv=none; b=qAza/SPh7eMmSfCCNUJQ4Qn1T95JaNLVPO+W7L4bw67UUWueCkN6nR2woacy8uG3UPzkwk7SeFWLZLeSJHgt2tRBdE5Zqjqvz8F2KgLTVrgOPQG3wj3C6b7LBr5xloU1zIbX9QQIRt8Gty3za+oOlnQxHhhMdXNzOrfTn1EiYmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751647427; c=relaxed/simple;
	bh=R4BsiiBz9ryJMAmO03Bk60+54Y4XTyAxRbYS99fvu7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4PM1POF/3qC9Ty7JE/ycMXNOOzLliriArJSieds9vH50mAXBx8gcyToVGeJ9eYvJErG5rJifwW2xfXWc4XNvGlbohHoj691WGXcUJZ3izpKHTHlyxApPq7eqijqNlN6Mw47r2Slw+OA6kKXq8sJ0sGmIEo8anL5we+lyOpauD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U9uytmMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U9uytmMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1D3C4CEE3;
	Fri,  4 Jul 2025 16:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751647427;
	bh=R4BsiiBz9ryJMAmO03Bk60+54Y4XTyAxRbYS99fvu7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U9uytmMASRttIRK9nkdpf3l36W5hylDXVXHUN0p4p15Y34hUIo5oILOzxRu4ryiYJ
	 iHmnqXtdf9HjvVPY+3tpg21yYM4GYdvL5k1O8Nuav22g3bVjWtrMy8jwv5pt7IIMGC
	 FKNXtt+tYTdERBAxsEC/lRzBtRaNKs72LCAxKqIg=
Date: Fri, 4 Jul 2025 18:43:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 212/218] spi: spi-mem: Extend spi-mem operations
 with a per-operation maximum frequency
Message-ID: <2025070409-perjurer-swifter-449f@gregkh>
References: <20250703143955.956569535@linuxfoundation.org>
 <20250703144004.692234510@linuxfoundation.org>
 <mafs04ivs186o.fsf@kernel.org>
 <2025070449-scruffy-difficult-5852@gregkh>
 <mafs0zfdkyn6i.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0zfdkyn6i.fsf@kernel.org>

On Fri, Jul 04, 2025 at 05:45:41PM +0200, Pratyush Yadav wrote:
> On Fri, Jul 04 2025, Greg Kroah-Hartman wrote:
> 
> > On Fri, Jul 04, 2025 at 01:55:59PM +0200, Pratyush Yadav wrote:
> >> Hi Greg,
> >> 
> >> On Thu, Jul 03 2025, Greg Kroah-Hartman wrote:
> >> 
> >> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> >> 
> >> This and patches 213, 214, and 215 seem to be new features. So why are
> >> they being added to a stable release?
> >
> > It was to get commit 40369bfe717e ("spi: fsl-qspi: use devm function
> > instead of driver remove") to apply cleanly.  I'll try removing these to
> > see if that commit can still apply somehow...
> 
> The conflict resolution seems simple. Perhaps the patch below? (**not
> even compile tested**):

I dropped all but the relevant one now, thanks, and test-built it! :)

greg k-h
