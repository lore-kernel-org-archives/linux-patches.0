Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBF935CB63;
	Wed,  4 Feb 2026 14:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770213883; cv=none; b=Xm9Ssg7KzvObfgjtCUjVAhMcxwjIeHoz4Qt0dNQHRTHabNzMaxHXX//W7+ZXuebTqcM7/ni+LAU95yE8kgQSG2MFIQbJKooueirpKGa6taDUryHkFHP1Z2F8B4tCg89esDt+dHz3imKkqQQliw26hrgxudfqxMfLOQo0KCC/F2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770213883; c=relaxed/simple;
	bh=93UPL8o/lH5aHomDg1q3bVeXoZWZC0VmLMR/Y+DzwSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eKHr4Sg5Cxd6T4wtIAj8GLz8BMv8mBwDQYrpizYAT1/6AXJL3zhLC+/eF2WFb9n4aTxgGmD8+0x6plAMR6HnrGVkPvWjP/ZMefgOGT12kcaZihsB+y3xTowSkN7Ua5uWOZy7hlACtcoQp8zicFfnpPRusvegBLTPs3byAY9LHm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzKPOIff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzKPOIff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B22C116C6;
	Wed,  4 Feb 2026 14:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770213883;
	bh=93UPL8o/lH5aHomDg1q3bVeXoZWZC0VmLMR/Y+DzwSI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yzKPOIff3U9MF6rJdzuCwZsVP1jOv+D126v/pEuxRLxooHQh/n/7n20rEEe62Ud7C
	 CcTuRHNY+R2q/nskdMGhpw/t2wJHI/sALBs41oOXh2HzwION8+UlDhccOX7+0w3Cfe
	 +JuTQ5JZcyCg3LQJVxbAUZmzfgJHUCBb/TQai2j4=
Date: Wed, 4 Feb 2026 15:04:36 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>, Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 117/300] selftests: Replace sleep with slowwait
Message-ID: <2026020430-unnerving-watch-277e@gregkh>
References: <20251203152400.447697997@linuxfoundation.org>
 <20251203152404.953619835@linuxfoundation.org>
 <b052b71589bb576dcad441eba38c20da81443a46.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b052b71589bb576dcad441eba38c20da81443a46.camel@decadent.org.uk>

On Tue, Dec 09, 2025 at 04:22:52PM +0100, Ben Hutchings wrote:
> On Wed, 2025-12-03 at 16:25 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: David Ahern <dsahern@kernel.org>
> > 
> > [ Upstream commit 2f186dd5585c3afb415df80e52f71af16c9d3655 ]
> > 
> > Replace the sleep in kill_procs with slowwait.
> 
> The slowwait function isn't defined in 5.10 (or any stable branch older
> than 6.9).

Now reverted, thanks.

greg k-h
