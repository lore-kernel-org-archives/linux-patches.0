Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E1A2D9EF1;
	Wed, 18 Jun 2025 13:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750251700; cv=none; b=GfaYkfWHZKWlFCN6oofIKsoJLsQYtnwjshItziLQxdHOP/HY8ljyPgLIYSFCXW9MyCbU2uHT11QmwtYaqsuj8m9yh5qPqtTLA6WF7+72d/LF2eVGdwNcN4nEumr3M2SbFzp3j+sgzFjpMTm1GCQWW5hB1jE0IbTlUvzLPDC2x2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750251700; c=relaxed/simple;
	bh=oU+m19ZA+FBg+WCYIjk0HQPjyIJa3/l1rJC3amio7/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Buo/gSnX0p/XrAROnIq0FFK4PPX47eeF6rnhWiRZrVBUN8a09UXF4psdOaMgQN5Ir64KFA/ow4Th5f4orVAKRCeAswIEjPulP4ZAyeOh2q8IFHwjRWnqI7lRG0aFGQph070E7zjQ1H13O+4LqvG0J/uWrn216+D/zhooa2uhh90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0rrqxg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0rrqxg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536CBC4CEEE;
	Wed, 18 Jun 2025 13:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750251700;
	bh=oU+m19ZA+FBg+WCYIjk0HQPjyIJa3/l1rJC3amio7/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y0rrqxg54tFmcVwJQOZ6h/VYkAwBlgTZnNe4FoC/YV31gQN4SPjTbqMn45Tvae37M
	 9uZrIYhrlT7J6hi/XvtZnBFxq2w88rie0Gp5/yPJwSzCI2ni2oZIOXqA89cOlzgxpW
	 wS9rhkSrI3Of301AIdo1hYVZ13kP/rwv/Hg96cno=
Date: Wed, 18 Jun 2025 15:01:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johan Hovold <johan@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.15 546/780] USB: serial: bus: fix const issue in
 usb_serial_device_match()
Message-ID: <2025061827-relapsing-uninstall-118e@gregkh>
References: <20250617152451.485330293@linuxfoundation.org>
 <20250617152513.744328939@linuxfoundation.org>
 <aFKCA_MJfeKKY9lk@hovoldconsulting.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFKCA_MJfeKKY9lk@hovoldconsulting.com>

On Wed, Jun 18, 2025 at 11:08:19AM +0200, Johan Hovold wrote:
> On Tue, Jun 17, 2025 at 05:24:14PM +0200, Greg Kroah-Hartman wrote:
> > 6.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > [ Upstream commit 92cd405b648605db4da866f3b9818b271ae84ef0 ]
> > 
> > usb_serial_device_match() takes a const pointer, and then decides to
> > cast it away into a non-const one, which is not a good thing to do
> > overall.  Fix this up by properly setting the pointers to be const to
> > preserve that attribute.
> > 
> > Fixes: d69d80484598 ("driver core: have match() callback in struct bus_type take a const *")
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> I believe I already asked for this one to be dropped since it does not
> really fix anything and therefore does not meet the criteria for stable
> backport. The stable tag was as usual left out on purpose.

Now dropped from everywhere, sorry about that.

greg k-h
