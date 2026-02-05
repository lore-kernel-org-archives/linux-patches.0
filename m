Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F7FEACD;
	Thu,  5 Feb 2026 14:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770301817; cv=none; b=Ndl3Fk7tys0IaRQ3pYmdjQ6wOrYGdTS4SJtUeSPR8osfEFKlZSH+TZuLPfUeV4ksIBmw3or5Bj0oy+tvJPLbTqE46cvCLuXCDcCccY8Y/0hQFRY9e8l/WG79LKJKHfxbJXPw3fCaT3taQmb+aKBDLB+RS/gJUtwNnok860tKmuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770301817; c=relaxed/simple;
	bh=HWwUmvsakuIbr283ynIn8TSpX0eLq6bewdUN5tqaKcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aLUdXt820KOfAynaiYRQLlya2L5dEpNqopxn+2BXuBlmYVFelneKUIInHRDGDvDzvTMMNQk7NwXX3dIvH+COm7pnHX9gYykZ0H4ar8R1Ypm8C4vhyaNDqbyRxFusoxEQ1Sl1WG8d3CPXwsKv+2isq0VgMLLCpyUBDVDAKsWrI9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZQTdAUj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZQTdAUj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651A1C4CEF7;
	Thu,  5 Feb 2026 14:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770301816;
	bh=HWwUmvsakuIbr283ynIn8TSpX0eLq6bewdUN5tqaKcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SZQTdAUjVDPKD0vVjoJyLnkZzFKiiDF9Vuoo+PPSpI2TUjdsfYhEk72bcRuMC+XiV
	 QgkEElqz1cpKv4eU503+AxsrMs1UKULNcwZfw4DerEINQA24OAQzs0OtcghvDUJN2r
	 Lw6h6g+YNYiXdTbBtD8/A7gqNJQUCmzMXm2oLijY=
Date: Thu, 5 Feb 2026 15:30:13 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Daniel Palmer <daniel@thingy.jp>,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH 6.12 75/87] Revert "drm/nouveau/disp: Set
 drm_mode_config_funcs.atomic_(check|commit)"
Message-ID: <2026020544-deluxe-caucasian-66df@gregkh>
References: <20260204143846.906385641@linuxfoundation.org>
 <20260204143849.619741696@linuxfoundation.org>
 <5951f289-a7ef-43b1-badf-f1e7cd04c02d@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5951f289-a7ef-43b1-badf-f1e7cd04c02d@roeck-us.net>

On Thu, Feb 05, 2026 at 06:28:22AM -0800, Guenter Roeck wrote:
> On Wed, Feb 04, 2026 at 03:41:13PM +0100, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: John Ogness <john.ogness@linutronix.de>
> > 
> > commit 6c65db809796717f0a96cf22f80405dbc1a31a4b upstream.
> 
> Not questioning the need for it, but this revert does not exist
> in the upstream kernel ???
> 
> $ git describe
> v6.19-rc8-45-gf14faaf3a1fb
> $ git show 6c65db809796717f0a96cf22f80405dbc1a31a4b
> fatal: bad object 6c65db809796717f0a96cf22f80405dbc1a31a4b

It is in linux-next and I was told it would be in 6.19-final, which is
why I took it here.

thanks,

greg k-h
