Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3DA229B01;
	Wed, 12 Mar 2025 07:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741765600; cv=none; b=HPvqnae9RKACv4OM/mzNfUjRJz5IkLJP8sFinIsp+/UHczohyV6fjzqC8eDLBhufbO5m4Iumdsk4lT+Bcbti5Yg7oGmIW/wK2NRmgI9fzfsCM/ANNRWNl1Ed3MPT8ZJN3hFoHMHpa6JvQgXuNWJz+KYVesqQenjigizE/v8E64w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741765600; c=relaxed/simple;
	bh=J09aGGbgQYsRoQG3/u8dc0PBWybNtqjKp9EQ69smHyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZCjUnyZSLO0EoaNBEqX0jPIKaRK/TFFq+XkCimW12eIiIOK9/JACV6Wf56DYSEtnxkPQ5pivAVoQw4UzWIoKf5l0ENbbXkZ/8JY0mQr5BiBty+dOBUigG9p6CTmIirAX7BphED9QDBcBTanN74Hn/CUF/5K31nLndRxXUpvS51w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xB9bojV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xB9bojV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70942C4CEEA;
	Wed, 12 Mar 2025 07:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741765600;
	bh=J09aGGbgQYsRoQG3/u8dc0PBWybNtqjKp9EQ69smHyo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xB9bojV/z8AcQJVR2q8gB3bj2fjuKdy4GIcKHArMxWMS+Z9qT6+jX8O+BA4frFadf
	 UVcGreEyKvL2YJtkJTbEbdFPtALMCQwDjvvF64FmH00rQqXKea/rKgTz9u21eN2FRV
	 yj+ah2RIbjOuaSwcOqUe1c67YTPGcn6jKN7laXlI=
Date: Wed, 12 Mar 2025 08:46:37 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Benjamin Berg <benjamin@sipsolutions.net>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/197] 6.13.7-rc2 review
Message-ID: <2025031219-tutor-lyrics-021e@gregkh>
References: <20250311144241.070217339@linuxfoundation.org>
 <00f382c4-1347-bc6d-b3ec-427de5658cf5@applied-asynchrony.com>
 <523cf45116bab7a653994d5eaf17496ed57f8351.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <523cf45116bab7a653994d5eaf17496ed57f8351.camel@sipsolutions.net>

On Tue, Mar 11, 2025 at 09:17:49PM +0100, Benjamin Berg wrote:
> Hi,
> 
> On Tue, 2025-03-11 at 18:45 +0100, Holger Hoffstätte wrote:
> > On 2025-03-11 15:48, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.13.7
> > > release.
> > > There are 197 patches in this series, all will be posted as a
> > > response
> > > to this one.  If anyone has any issues with these being applied,
> > > please
> > > let me know.
> > 
> > Still missing a followup for iwlwifi as mentioned on rc1:
> > https://lore.kernel.org/stable/5d129bda966b7a55b444f4d48f225038361e9253.camel@sipsolutions.net/
> > 
> > Not sure if that refers to the whole series or only the first patch,
> > maybe Benjamin can clarify.
> 
> I meant that particular patch as it fixes a regression that was
> introduced in "wifi: iwlwifi: Fix A-MSDU TSO preparation".

Let me go dig into that, as I don't see it in Linus's tree yet...

thanks,

greg k-h
