Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4773085D4;
	Thu, 19 Jun 2025 04:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750307226; cv=none; b=uvp8ce/qg6QrE3rZapy45zA33DnT6bU2tvp3jT1fhGUhaZU78FpPd3buMLd8VVeivjMC+CN6vplKKs9aycbf3YbQ5tOMPWirLjaO0733MeRav4Kjq+GfmBdgChjlWP0zDVfVnoS9STVgYly+IAORb895dYES2IIQVRSpNwW7jZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750307226; c=relaxed/simple;
	bh=N2vpBSPNlKoUrqHDLG0SPqnnjPg3ghTIKjqLMrRarVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLRZumE+NDkCj56OrT8lOY10AdIRlmG4y16geqbb1VQV7x/bRb7rV3bcLpyghfufgazeukasxYnqODL/CvbzxvCDFsoE/jq7J5SxCLpihuES/CIG4W79mLGq5szbsmOq65TIMlOFX8QAzZH38MuZ1T75m6ZkVxORQdqrTT0cuUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ppw9lp+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ppw9lp+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EECC4CEEA;
	Thu, 19 Jun 2025 04:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750307224;
	bh=N2vpBSPNlKoUrqHDLG0SPqnnjPg3ghTIKjqLMrRarVA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ppw9lp+/zop4/18SACWOSBY7yCRclPZjzyszPIefxrKuGL0/lUI/H4j3ba6hfdciv
	 +V9F7ZKjp16dGorniuepLNSC+QcvWrVIUoLVYw6+u3N0JsttbQ/64+4TK/gQk+tuch
	 v2RsbhlHY6JqCUYPZ5o8Fif7Zfk53ndqdQAKZIGQ=
Date: Thu, 19 Jun 2025 06:27:01 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@denx.de, rwarsow@gmx.de,
	shuah@kernel.org, srw@sladewatkins.net, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 6.12 000/512] 6.12.34-rc1 review
Message-ID: <2025061928-equal-track-76af@gregkh>
References: <20250617152419.512865572@linuxfoundation.org>
 <20250618125710.1920658-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618125710.1920658-1-ojeda@kernel.org>

On Wed, Jun 18, 2025 at 02:57:10PM +0200, Miguel Ojeda wrote:
> On Tue, 17 Jun 2025 17:19:26 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.12.34 release.
> > There are 512 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 19 Jun 2025 15:22:45 +0000.
> > Anything received after that time might be too late.
> 
> For arm64, with Clang 18, I got:
> 
>      drivers/thermal/mediatek/lvts_thermal.c:262:13: error: unused function 'lvts_debugfs_exit' [-Werror,-Wunused-function]
>       262 | static void lvts_debugfs_exit(struct lvts_domain *lvts_td) { }
>           |             ^~~~~~~~~~~~~~~~~
>     1 error generated.
> 
> I assume the reason is that `CONFIG_MTK_LVTS_THERMAL_DEBUGFS=n`.
> 
> In mainline I don't see it. I think we need commit 3159c96ac2cb
> ("thermal/drivers/mediatek/lvts: Remove unused lvts_debugfs_exit").
> 
> It cherry-picks cleanly.

Good catch, thanks, I'll queue it up.  The "Fixes:" line in that commit
refers to a wrong sha1, odd that it made it through linux-next without
any errors because of that :(

thanks,

greg k-h
