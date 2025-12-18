Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771F4339710;
	Thu, 18 Dec 2025 12:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766062642; cv=none; b=tHSUysSHgkiIGCPVB6H32Adxy4n5cS4TQzb4PaBpd1JsR0+i+0IZR1Bnv6STSWxwbhHU6hkZxKrI6Ql7Yf83M7lIrLn4YN6gMBccgNs4TOCnwmiqdihb8h94SpD6METX6+6Cv7IanIWA0TDTdsJjmd1snilQDNLHnFAH02xI1tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766062642; c=relaxed/simple;
	bh=hnUYg1kyjZ/p73J0U3xmjMnitlshlxvaJXxPx7sPdB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gLKxcxTZkjjREuwNm2Ez7lGEsomIfLe6hXkB6JqXfynnY/9cIB0KjXWB6CK8C6J4ybVZbWIgaXkRBXN7lb715M1DHtN5jLQNwZ6nF1bDk80xRgdaEJjgbKbUG62NpDT7KwlbKqWw79vI75qPnmpW6Asee1f103UjP0nxh4q0b+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNvA5ZEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNvA5ZEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A563DC19421;
	Thu, 18 Dec 2025 12:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1766062642;
	bh=hnUYg1kyjZ/p73J0U3xmjMnitlshlxvaJXxPx7sPdB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oNvA5ZEhAAdjuKHLJgTknwH+sjQrgydH+YvTxtkdyuXZ0uiss7dpmy4DNmgHRag9J
	 j1MILBiG5Jn3btPOZYdyBIjEwgR7iAp6i4msBT2qsoBA9tZGGdv7juMjeWHG6O+ptt
	 9EY8HFbh5V9IBQ7Ko+U6O5HiJCG5cSjZt1FNH+5A=
Date: Thu, 18 Dec 2025 13:57:18 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michael Kelley <mhklinux@outlook.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Tianyu Lan <tiala@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.17 248/507] Drivers: hv: Allocate encrypted buffers
 when requested
Message-ID: <2025121811-theft-skillful-e47f@gregkh>
References: <20251216111345.522190956@linuxfoundation.org>
 <20251216111354.479243388@linuxfoundation.org>
 <SN6PR02MB4157D6A6FF1F5037FAB1EE05D4AAA@SN6PR02MB4157.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR02MB4157D6A6FF1F5037FAB1EE05D4AAA@SN6PR02MB4157.namprd02.prod.outlook.com>

On Tue, Dec 16, 2025 at 06:35:09PM +0000, Michael Kelley wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org> Sent: Tuesday, December 16, 2025 3:11 AM
> > 
> > 6.17-stable review patch.  If anyone has any objections, please let me know.
> 
> I don't think this patch should be backported to any stable versions.
> 
> I see that it is flagged as a dependency for backporting 510164539f16 ("Drivers: hv:
> Free msginfo when the buffer fails to decrypt"). 510164539f16 is indeed a bug fix,
> but it's a minor "should never happen" memory leak, and I would be concerned
> about the risk introduced by this patch being pulled out of the large-ish patch
> series that implements a new feature.

Now dropped, thanks.

greg k-h
