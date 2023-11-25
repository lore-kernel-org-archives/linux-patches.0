Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C536AA4;
	Sat, 25 Nov 2023 15:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5vXejIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F89C433C8;
	Sat, 25 Nov 2023 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700925666;
	bh=AAMGg9IjgxzajNoJUcm5ZgK9JUFUKnSkVI/XtASRMGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B5vXejIYH92bgfGCBFRVaILaobTlbYY4EkozG+AlPkSFfs9iZb040S1W4G0hunL1A
	 9VS+rko6ZlshSBkH54Te4E1CM3WnG5hTmpLFvKv74GOeXUxXG360ORtF0K7i6ceyZz
	 QDpIB+9apLPlhejmAAUbkIsRRC1WTDQD/OY/oqxs=
Date: Sat, 25 Nov 2023 15:21:02 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Philippe Perrot <philippe@perrot-net.fr>,
	"Geoffrey D. Bennett" <g@b4.vu>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 088/530] ALSA: scarlett2: Move USB IDs out from
 device_info struct
Message-ID: <2023112551-scorn-attire-9424@gregkh>
References: <20231124172028.107505484@linuxfoundation.org>
 <20231124172030.757235707@linuxfoundation.org>
 <87leampakb.wl-tiwai@suse.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87leampakb.wl-tiwai@suse.de>

On Sat, Nov 25, 2023 at 08:16:20AM +0100, Takashi Iwai wrote:
> On Fri, 24 Nov 2023 18:44:14 +0100,
> Greg Kroah-Hartman wrote:
> > 
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Geoffrey D. Bennett <g@b4.vu>
> > 
> > [ Upstream commit d98cc489029dba4d99714c2e8ec4f5ba249f6851 ]
> > 
> > By moving the USB IDs from the device_info struct into
> > scarlett2_devices[], that will allow for devices with different
> > USB IDs to share the same device_info.
> > 
> > Tested-by: Philippe Perrot <philippe@perrot-net.fr>
> > Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
> > Link: https://lore.kernel.org/r/8263368e8d49e6fcebc709817bd82ab79b404468.1694705811.git.g@b4.vu
> > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> As already mentioned at
>   http://lore.kernel.org/r/87edgkpiig.wl-tiwai@suse.de
> this patch makes little sense as a stable update.  It's a part of the
> code rewrite series, and no real fix.  Better to drop for avoid
> confusions.
> 
> Ditto for 6.5 and older kernels.

Now dropped form all queues, thanks.

greg k-h
