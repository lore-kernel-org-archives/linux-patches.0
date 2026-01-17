Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C000136349;
	Sat, 17 Jan 2026 15:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768662433; cv=none; b=PIHI8oFrJ2+RfawzSuKXfX1oxEu2/QoJXxL24dRTkOSi/6Ln9XU10KKZZUZvakmvG5Dhi4Fl7isc+FA7y2jtFcjQKl+WplaF6b2e0QYyWEUmS3FcG92X9tp9joWCBWiwoydalpKaqZUWk5f+aTOusTtlN2NaJBJvHvy4HprPYa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768662433; c=relaxed/simple;
	bh=XpebRY9L+5uRxtK/7uy7K2nZ4kO0m7agnaLPUSgPwmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IHmS1LQXaQfS1XROt5tHN50Rg3Sz2yFkc3l4Krwd2qDaCA6btUju6Tq3AxpKBhEZ7lIOtTmYdYgyGtsOMGCrkDDX4Sp0/4iNOpO9ElhbzksWq07q0/BSbyW7Zqt2vQx+OsZ3w+jYy+slkquHG1HtQfTTntIwtDwx83GYFbKEPi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thYoDNxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thYoDNxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61165C4CEF7;
	Sat, 17 Jan 2026 15:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768662432;
	bh=XpebRY9L+5uRxtK/7uy7K2nZ4kO0m7agnaLPUSgPwmY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=thYoDNxNwElXK2XUFNWon6IHuObraOigCZwtxMpuDk7uFnpzuegEVEKczkpWwXuac
	 nC62Zl7th1Ru8ZDoPRVOTUtFW21k0JliWsja4S3AevMhrzOCDK8V/qAwnFq46TRXgJ
	 oi/Q7vv6priwFDVuH7SNN6u0Gqfbp40Rl+j97ukQ=
Date: Sat, 17 Jan 2026 16:07:09 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 048/451] i3c: remove i2c board info from i2c_dev_desc
Message-ID: <2026011724-florist-brook-5f1f@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164232.636822339@linuxfoundation.org>
 <fd91b4ae9640cfaf47fa96b97c58f410245c5358.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd91b4ae9640cfaf47fa96b97c58f410245c5358.camel@decadent.org.uk>

On Sat, Jan 17, 2026 at 01:28:31PM +0100, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:44 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jamie Iles <quic_jiles@quicinc.com>
> > 
> > [ Upstream commit 31b9887c7258ca47d9c665a80f19f006c86756b1 ]
> > 
> > I2C board info is only required during adapter setup so there is no
> > requirement to keeping a pointer to it once running.  To support dynamic
> > device addition we can't rely on board info - user-space creation
> > through sysfs won't have a boardinfo.
> > 
> > Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > Signed-off-by: Jamie Iles <quic_jiles@quicinc.com>
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > Link: https://lore.kernel.org/r/20220117174816.1963463-2-quic_jiles@quicinc.com
> > Stable-dep-of: 9d4f219807d5 ("i3c: fix refcount inconsistency in i3c_master_register")
> [...]
> 
> Commit 9d4f219807d5 is a legitimate fix, but it does *not* depend on any
> of these other i3c changes.

From a "does this patch apply cleanly" point of view, yes, it did need
those other changes.  But from a "does this patch do the same thing"
point of view, you are correct, it didn't.  I'll go drop the others and
fix the real one up by hand here.

thanks,

greg k-h
