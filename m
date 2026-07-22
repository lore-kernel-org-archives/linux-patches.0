Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7429D3112A5;
	Wed, 22 Jul 2026 05:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784698114; cv=none; b=KTNDvKVMFYOBMHCXLfJwd7Uv8bAfy/w1MNRZJkjSvNgg5dqnVB2pZ4UcdHJfpDUTKty2LCDks27Y24z4LJclXaNyqhTMumAeURz5MxVXURIc+w9W98n+8y9uz2xDNsbkzO4514LCWEMihgy7EB8W0dBoTsHCYdo/0mJHOtKfOWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784698114; c=relaxed/simple;
	bh=7xTjLseZlMmz9BMcu1ZcECQ6Bn8DNKjpyorKhVgkbUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NHLBjCn0HOrs3ZnWD/iZMJCWraXg3L1UsgQ7MTmYHZcN2Ds0YYZK6Ai9cAUJqluDvyWfvNcuOL5YpOzMMw5ZoDIjn8KpB/wPiYYeqM6dvrkyA6wxn1PiKuEdFRKaS1dTJ8a62jH8wwDGV6jxnYnW5v8SVe39w3OXX2xs6xsbcyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gKDb+KEF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gKDb+KEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BDA1F000E9;
	Wed, 22 Jul 2026 05:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784698102;
	bh=x1qIsixBbmJzLUkw7UXzCKTm+RzhlwYJSLksCWC5Qoc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gKDb+KEFzPtvIEGrIHVnU4TXq1WAmNCbln7kZ7EGCiq042JU0vbQtam7qSJCSQ6N0
	 vVpePwMO3quzujRZBQC7z/4T/Z8nhpox68VI4k0a5q//mAtw2hHzwjE4JwRywVoFVp
	 /8LjrKUeLnpyHoDK31StOBmeM1kTuSHCAog78OHg=
Date: Wed, 22 Jul 2026 07:28:12 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Gibson <daniel@gibson.sh>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH 6.6 1020/1266] platform/x86/amd/pmc: Add delay_suspend
 module parameter
Message-ID: <2026072230-volatile-citric-73fa@gregkh>
References: <20260721152441.786066624@linuxfoundation.org>
 <20260721152504.653512550@linuxfoundation.org>
 <980c483b-d3ed-41be-94e0-9b28fc42b482@gibson.sh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <980c483b-d3ed-41be-94e0-9b28fc42b482@gibson.sh>

On Tue, Jul 21, 2026 at 11:07:35PM +0200, Daniel Gibson wrote:
> Hi,
> 
> On 21.07.26 17:24, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> 
> No objections, I just wonder why the commits
> 037f0b03c663a2 "platform/x86/amd/pmc: Dont log during intermediate wakeups"
> and
> a0738abd042f74 "platform/x86/amd/pmc: Avoid logging "(null)" for DMI values"
> 
> are not added for 6.6 as well (they're added for 6.12, 6.18 and 7.1).

Because they do not apply to that tree, and there was no explicit
"Fixes:" tag on the commit so we just backported them as far as they
easily went.

If you want these patches in a stable 6.6.y release, please provide
working backports.

thanks,

greg k-h
