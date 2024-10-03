Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7907839E3;
	Thu,  3 Oct 2024 07:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727939494; cv=none; b=G0X0cREAVR7dvDd0UXk9IU7x+1pOdv/3R7r8Pb8EtTTVr9mND1e73IvdlrM0PEyFsGCcxikn8xi+f4EKtwdBExZuNdcONUiOBJLsjNjdLxALu7jubo+/G2dW4gGMgp4auHt2YIP7Fo0t8Y0oFhqfnzqgY5pz+YZ2V7hgZBvMOFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727939494; c=relaxed/simple;
	bh=YYDJ4YDz/e60ZyR/MOXCJPhUS9/2KgB08sv2x0fJagM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YBcFlhbBaomh3dAXLQEloDUEnald3YFxLbs5z9BGmYwYP6sp09rCQ5QneHjTu5rMjRlcN8laUsf+LtqzCaeCqtfEZqGSqNfD1DuUEgDJKNPztGCHx6Htr1kspPEA1I4I8n7B8Ojv9lDah1MeShkDM1fgZc11R9C7nhed35h+S08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdecK8SL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdecK8SL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8279BC4CEC7;
	Thu,  3 Oct 2024 07:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727939494;
	bh=YYDJ4YDz/e60ZyR/MOXCJPhUS9/2KgB08sv2x0fJagM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rdecK8SLNrHyncxs68hGbtXHgA71BoamUegSF0IYw+yL0wyOBkFhF+Ny3vfvroOfI
	 L7o3pIbxz1EKUpx8c71q4giN9CHS3TzQ8ZJXYEowHGNfproI5a69VeLewCNHuk61qV
	 cDae2HeA+mnqv6gt3HZQYFV47Ss7+lnlCoxIi+/4=
Date: Thu, 3 Oct 2024 09:11:30 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marek Vasut <marex@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Pieterjan Camerlynck <pieterjanca@gmail.com>,
	Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 288/538] leds: leds-pca995x: Add support for NXP
 PCA9956B
Message-ID: <2024100303-giggly-coherence-b8c4@gregkh>
References: <20241002125751.964700919@linuxfoundation.org>
 <20241002125803.624242401@linuxfoundation.org>
 <e999b9d5-0283-4d86-a0dd-e4d9c29c91eb@denx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e999b9d5-0283-4d86-a0dd-e4d9c29c91eb@denx.de>

On Wed, Oct 02, 2024 at 05:00:22PM +0200, Marek Vasut wrote:
> On 10/2/24 2:58 PM, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Pieterjan Camerlynck <pieterjanca@gmail.com>
> > 
> > [ Upstream commit 68d6520d2e76998cdea58f6dd8782de5ab5b28af ]
> > 
> > Add support for PCA9956B chip, which belongs to the same family.
> > 
> > This chip features 24 instead of 16 outputs, so add a chipdef struct to
> > deal with the different register layouts.
> Seems like a feature patch, not stable material ?

As the patch said:
	Stable-dep-of: 82c5ada1f9d0 ("leds: pca995x: Fix device child node usage in pca995x_probe()")

it is needed for that one.

and we add new device ids or quirks all the time, this one seems sane.

thanks,

greg k-h
