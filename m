Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB923CEBA9;
	Mon,  4 May 2026 12:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777896713; cv=none; b=NTehyLW2VXkROS8mNhSDaSGwHpYs7k7W/HaEMZ1l+IkI9GgJjeZ7CVwj33/tsWWaR03DkcnnwxQZrm1IygArSekbunJmCtXnPCRqtX2LZmk3f2WPlv2aqr2u36WyZi4xVLPhUFBWlHZ9+C+9Wl5W3kSa3zhiMNHXc2agZluxprw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777896713; c=relaxed/simple;
	bh=GZK4hVDBtdbAqGAL7vLJb6Mh5FFKl/o4snGJKCZhcTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3oZhHhWuMPSYKb7slFpKpRFoDIzkYWI4KYFYVF9+YupSqw/oJbIBGKtkf4cU0e4aDq9Gumbd2zEFo9aTzdhDjOm05cOkCJqQkZ3+/rjAaS8dl6dmTeh/tFYh27wobyXIQJm3vq7Kc3o0eWrb/gJ3pw9c80KE3o53JuYGCIvvfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6FAkOan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6FAkOan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44185C2BCF5;
	Mon,  4 May 2026 12:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777896713;
	bh=GZK4hVDBtdbAqGAL7vLJb6Mh5FFKl/o4snGJKCZhcTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E6FAkOannRNgwtaNvjn9p9enXZQ7XbM+H3xfWbd4GDEk3yjVDf8topJsE4s1HRIOi
	 J3o6XvqV4H6rNRiiRAkgSxRqhkXcK+b+bi2tziV7T+Qcfonbu0gR4a1zf7d9qm7yee
	 uBFpsVwzNxzHsGRTERyqyTv2W4z4z0KsoAWo41O8=
Date: Mon, 4 May 2026 14:11:51 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.19 001/311] drm/amd/pm: disable OD_FAN_CURVE if temp or
 pwm range invalid for smu v13
Message-ID: <2026050438-shadow-riddance-1f71@gregkh>
References: <20260408175939.393281918@linuxfoundation.org>
 <20260408175939.452810365@linuxfoundation.org>
 <a196b98a-a4f7-4e97-9005-d8a9f5e4814b@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a196b98a-a4f7-4e97-9005-d8a9f5e4814b@kernel.org>

On Mon, May 04, 2026 at 08:15:46AM +0200, Jiri Slaby wrote:
> On 08. 04. 26, 20:00, Greg Kroah-Hartman wrote:
> > 6.19-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Yang Wang <kevinyang.wang@amd.com>
> > 
> > [ Upstream commit 3e6dd28a11083e83e11a284d99fcc9eb748c321c ]
> 
> This appears to break 6.19.12 wrt fan speed on Radeon Pro W7700:
> https://bugzilla.suse.com/show_bug.cgi?id=1263854
> 
> 7.0 is broken the same way.

I am guessing that 7.1-rc2 is also broken this way?

thanks,

greg k-h
