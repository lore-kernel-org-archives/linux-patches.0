Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A06210F0;
	Sat,  8 Aug 2026 14:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786201199; cv=none; b=mSoGti4hJcab2l3Lp77irwGwpizXI64+0ANYWGItiwcUZ66RDe4hZHGQwoOSuZlx+oOGyPAfpUWl0Ti0KcOCPI/VK/aI1V5yJV9U6J4zwoPT2Oxu9K++dFRGMfM4A7yO0bfVvv2J65bEO8BqiJ8B1vzNxuNuuD2NQGezgmmu2dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786201199; c=relaxed/simple;
	bh=ccLTPcbpf5pc0UyAWwPWp5jeRVeo3VuSsrv3zGYCryY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MGn0vpr7uN/5O1zMvOPyRooNWVBhHLsrouJcw0lO4mQap8RhgwD4sdCo1q4Era61fq4XNejZwmmRisw+yPP8MOtsQISgigAp2jZQ7/samc65miaWLHUtqksNeXULxJdbkfDtpa5fv0BJtD5etpCe8Am153sfL+KZwLR1E8Fx89c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SeQNvNB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SeQNvNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988391F000E9;
	Sat,  8 Aug 2026 14:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786201198;
	bh=bsEQ0YXrhI0ZTPpE93umg2TelbgrGlo/at/oYtbgyA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=1SeQNvNBZ3zP0oXwVKtmLxHxe6USIz9Ru+Iv9T8FiKv+c3GAaw1uG2az6U4l62RW+
	 WbGyxD5vjQrXeufs7ffIWiX5nHmMZ/A81SRHNpWUkqflE70P/cvValYTho26oa8OMp
	 q1z7+Y8uYKNtSMxj8ZiXRE1Fw8YObQQ0WaaOyRQc=
Date: Sat, 8 Aug 2026 16:59:38 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Hardik Prakash <hardikprakash.official@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: Re: [PATCH 7.1 326/438] i2c: designware: defer probe if child
 GpioInt controllers are not bound
Message-ID: <2026080830-shaping-retainer-c970@gregkh>
References: <20260807143428.008222056@linuxfoundation.org>
 <20260807143434.924930262@linuxfoundation.org>
 <a7b06f6d-b9c8-4e2f-abf8-8d2a84f287d5@leemhuis.info>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7b06f6d-b9c8-4e2f-abf8-8d2a84f287d5@leemhuis.info>

On Sat, Aug 08, 2026 at 11:05:09AM +0200, Thorsten Leemhuis wrote:
> On 8/7/26 16:38, Greg Kroah-Hartman wrote:
> > 7.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Hardik Prakash <hardikprakash.official@gmail.com>
> > 
> > commit 0a4bb2abc3e56d7be6e69b050c88ba52c87e22bf upstream.
> > 
> > I2C controllers may have child devices with GpioInt resources that
> > depend on GPIO controllers being fully initialized. If the I2C
> > controller probes and enumerates children before the referenced GPIO
> > controller has completed probe, GPIO interrupts may not be properly
> > configured, leading to device failures.> [...]
> 
> Hi Greg, just noticed yesterday with mainline that this change broke the
> touchpad of my ThinkPad T14s Gen 4 (AMD), so you might want to consider
> not backporting it for now:
> https://lore.kernel.org/all/b4a4eadb-282f-464c-843a-19d415a34d0c@leemhuis.info/

Now dropped, thanks.

greg k-h
