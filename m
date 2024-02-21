Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4C485C7A;
	Wed, 21 Feb 2024 18:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708540017; cv=none; b=iAOF0vPguCkA3h3VuBlWxkEe1P+cfPxkfmtmf87Ejb4eOPgSzZ9hrJ0BZWyBrDk/nkpxiUCCEjJW9ieFV2Q/nwhUtnGJ/5eTSH0VB13TGC2Zjz7tSWJXQ2oVDiSqbiBoIQ6gt8dE2QBW1t78k1ETmJbL7octrTUSuMe/8nTmD7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708540017; c=relaxed/simple;
	bh=58AJTvRqsidy6n69RFy69mDV+GDJW6WJ657BWr7Jjy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lFnu0wBAdC4T//EnbDAcwmf9p8nY7ewb6HalAViVTKnbxB56h/NJSGofTyLRhJW/DjGethTZua6CReOckZW7LauAw3ItppLjPV/FsqBqlzkruM/dFjBKuUoB8TWHCLRLRL0KLVsakQjqUA2iQoFOKfEwTdhkdAeLWus8MjhfFIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3xbOfWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3xbOfWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F194C433F1;
	Wed, 21 Feb 2024 18:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708540016;
	bh=58AJTvRqsidy6n69RFy69mDV+GDJW6WJ657BWr7Jjy8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O3xbOfWDhNH4cclhGhPilcMMAyGGLp4M6g/f+0HfFJBV9RQXD7A+V9UWKBLTuFhyf
	 I6DD0TMl0FdEmIBDe89WrV6fr3Mp2nXKODm09ty0XfZVJ7kxwLp9p5sW0XsAHXDGhv
	 O7QxwoByJMd8Zo0x65/aimMwzhv1iQ3LBWtGcx5g=
Date: Wed, 21 Feb 2024 19:26:51 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 151/267] misc: lis3lv02d_i2c: Add missing setting of
 the reg_ctrl callback
Message-ID: <2024022140-pond-plant-ad19@gregkh>
References: <20240221125940.058369148@linuxfoundation.org>
 <20240221125944.808861688@linuxfoundation.org>
 <1943e2b2-6232-4566-9793-2b24eed89d59@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1943e2b2-6232-4566-9793-2b24eed89d59@redhat.com>

On Wed, Feb 21, 2024 at 07:16:38PM +0100, Hans de Goede wrote:
> Hi Greg,
> 
> On 2/21/24 14:08, Greg Kroah-Hartman wrote:
> > 5.4-stable review patch.  If anyone has any objections, please let me know.
> 
> This is known to cause a regression (WARN triggering on suspend,
> possible panic if panic-on-warn is set).
> 
> A fix for the regression is pending:
> 
> https://lore.kernel.org/regressions/20240220190035.53402-1-hdegoede@redhat.com/T/#u
> 
> but it has not been merged yet, so please hold of on merging this 
> patch until you can apply both at once.
> 
> I see that you are also planning to apply this to other stable
> branches. I'm not sure if this is necessary but to be safe
> I'll copy and paste this reply to the emails for the other stable
> branches.

Not necessary, I'll drop it from all, thanks.

greg k-h
