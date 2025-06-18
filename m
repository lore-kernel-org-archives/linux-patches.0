Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DEE27FD63;
	Wed, 18 Jun 2025 09:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750237701; cv=none; b=teLmlSIGzhMB1aVNpszXsPp7d03TPATM/DEFRZtk1Cmp/eaQ1yqxO0fsIH5HtzWyWS+3j3lDi8Kim4ZQ6bdJXI0SvP/6NZ9roOmhJ7Hzn5ESbXvojfCyK/4F0hG1CmN6zx12hT5WCu/+08K/D1UIDpiMpIkHjvLV1S6JHFeWFBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750237701; c=relaxed/simple;
	bh=urZT13M+jj+4z8uxKfr0o7/K5bLZmln4etr2g0xxka8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jlSWBs0g6ZjlL87XD0d5h8taQxeb7ZVAAI60NAOj6L1cll3fwWm2xjhzUA38E3CJT+PpwATeLmKfr+8M7o0SuS/NvIDN5J/8r0Rry1OJeItnu7y0ac+ROzW/kTzoC+BJ0GFS1GOwAI76q1cnZSsANgJ6MgRxAm7zuqihOq+6d2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EUpiXCe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUpiXCe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6877EC4CEE7;
	Wed, 18 Jun 2025 09:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750237701;
	bh=urZT13M+jj+4z8uxKfr0o7/K5bLZmln4etr2g0xxka8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EUpiXCe5Hanbh3XKNh/H7CpmsppllUoPEvTwWT9hJb7GdBovbNXiaE7a7Ehk0rCSF
	 nQ3/X3KQWx/+xaREYLxPAsQM6UjZSpt6Jp1Gfp5ee430Jxkmz7G9xYwVqmm39eM05R
	 sCYHiPsPwZ+8V6MvNXnJq996dY9T4IV4GU32rUhmKJUX4pbUl3BnJVwfyks8H7DeHa
	 eEcG0AAEyBptT9vwX44B/H0Tlrtcjxgcamp5PTO+IyuzpXTy8iZPOhl4a8w2LVpIyX
	 JoKydcuERwKBfd6FNsEQkrJN7AuDlzSINpuiJ7RT4mA1Hiw2orZksdueZMAxpZ/F3/
	 NsTTgZwLjuSWA==
Received: from johan by xi.lan with local (Exim 4.97.1)
	(envelope-from <johan@kernel.org>)
	id 1uRomJ-000000003Bb-21ax;
	Wed, 18 Jun 2025 11:08:20 +0200
Date: Wed, 18 Jun 2025 11:08:19 +0200
From: Johan Hovold <johan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.15 546/780] USB: serial: bus: fix const issue in
 usb_serial_device_match()
Message-ID: <aFKCA_MJfeKKY9lk@hovoldconsulting.com>
References: <20250617152451.485330293@linuxfoundation.org>
 <20250617152513.744328939@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617152513.744328939@linuxfoundation.org>

On Tue, Jun 17, 2025 at 05:24:14PM +0200, Greg Kroah-Hartman wrote:
> 6.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> [ Upstream commit 92cd405b648605db4da866f3b9818b271ae84ef0 ]
> 
> usb_serial_device_match() takes a const pointer, and then decides to
> cast it away into a non-const one, which is not a good thing to do
> overall.  Fix this up by properly setting the pointers to be const to
> preserve that attribute.
> 
> Fixes: d69d80484598 ("driver core: have match() callback in struct bus_type take a const *")
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I believe I already asked for this one to be dropped since it does not
really fix anything and therefore does not meet the criteria for stable
backport. The stable tag was as usual left out on purpose.

Johan
