Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333EF21C9E4;
	Fri, 30 May 2025 14:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748614170; cv=none; b=XPjv0oDwjWDpe5NLX0FajjdrYh6zwIPHX0CjPFv0M88eSBfAXpzJgvA90KoMZyT1suQSl0OvCUX5DjDt8rfoITlV8GLijJyi1XZZXkPDrfnWGckI0AZFVIEW3fx0prb+0KTdznb8BBPCPHgEHIunYstmA4vXTtH40j3TH2VLa24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748614170; c=relaxed/simple;
	bh=H4i5vrsqiPA3+CdVu29VS7V6mnDaMBMTWw1PHdjJzPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kby4t1ZPnUSrf4XzJZE2oI2i6Nu8gsBhpZXblXzJxEPKpBeJeVPDl9oFt5TTNODyspa/iECm96X4dnfvgNGESxYsvaKtWCl6SBP/ijAToSU3a1afGLfDzdL+xPXrQv1hPPCFhcsR2ytLqOUMIjF4TRWyO4NMuLdVgy+mGDAYlZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqRI2g21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqRI2g21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEA1C4CEE9;
	Fri, 30 May 2025 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748614169;
	bh=H4i5vrsqiPA3+CdVu29VS7V6mnDaMBMTWw1PHdjJzPQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aqRI2g21Pt03cqgsSPSM9B0cVfxFwsGFVOfxxwzJAkpoujNKN2+3WhfX/ffUbCelK
	 LDKSbkyBEDHd+1ZUGiwkWBbcpGtHDx++cT4/noQEKWva2oNzMIziziMuHJsBqBQiFB
	 s/f3ZpY9TOM0SctKhr4HkNa/IWMhlEag3BxJKDpo=
Date: Fri, 30 May 2025 16:09:26 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>, Kate Hsuan <hpa@redhat.com>,
	Jiri Kosina <jkosina@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 645/783] HID: Kconfig: Add LEDS_CLASS_MULTICOLOR
 dependency to HID_LOGITECH
Message-ID: <2025053000-theatrics-sleep-5c2e@gregkh>
References: <20250527162513.035720581@linuxfoundation.org>
 <20250527162539.405868106@linuxfoundation.org>
 <27b9765e-c757-41c7-9cbe-fe1c915fdf2b@web.de>
 <2025053022-crudeness-coasting-4a35@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2025053022-crudeness-coasting-4a35@gregkh>

On Fri, May 30, 2025 at 04:08:40PM +0200, Greg Kroah-Hartman wrote:
> On Fri, May 30, 2025 at 03:44:22PM +0200, Jörg-Volker Peetz wrote:
> > With 6.14.9 (maybe patch "HID: Kconfig: Add LEDS_CLASS_MULTICOLOR dependency
> > to HID_LOGITECH") something with the configuration of "Special HID drivers"
> > for "Logitech devices" goes wrong:
> > 
> > using the attached kernel config from 6.14.8 an doing a `make oldconfig` all
> > configuration for Logitech devices is removed from the new `.config`. Also,
> > in `make nconfig` the entry "Logitech devices" vanished from `Device Drivers
> > -> HID bus support -> Special HID drivers`.
> 
> Did you enable LEDS_CLASS and LEDS_CLASS_MULTICOLOR?

To answer my own question, based on the .config file, no:
	# CONFIG_LEDS_CLASS_MULTICOLOR is not set

Try changing that.

thanks,

greg k-h
