Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990D02566;
	Mon, 13 Oct 2025 16:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760372704; cv=none; b=gM9WSdlA6RLCM+x8Cjo8kTtl1ejVB/I8qgh2v1EfGM69VGwqBFNdoclRO88kmiuAN9wXrusFiW7tfcmiet0b4YnGzvwaM1mn6B0dwNzx2fWVGca8XaSHwHRZNtezNYVF8Ue/976PrPY0SOsVUItxxD+2epWLqk6wEml1/1rArs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760372704; c=relaxed/simple;
	bh=DephRdo7HceRe/fBW/f3ci1haOKLh1RTIIEIfZTXpRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kf9RImEjC1ZnkZz9DHIfbAZdB+fC8nCVU9sIGHCo46XjNU+FKZkNLbJNBKMDQrAXfwFWVQeZ5jbEO8SDK7kn4yEpp+PrslpxADz0ggIo6lQl9U3MCA9fITZWKUODGAQI/qLBTLMedx64Ci1lCsh+h7chSYoxTK1QGw1lfDDI5y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YAY/m3LM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAY/m3LM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DD6C116D0;
	Mon, 13 Oct 2025 16:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760372704;
	bh=DephRdo7HceRe/fBW/f3ci1haOKLh1RTIIEIfZTXpRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YAY/m3LMefOb+1Tm88K7JFjKr6e54+fVD3IsNWRTZ1QAbi6+I9ZZEiEZ4ZRNw/qyy
	 DaDGUYf8k6+PaYJ7EMFGKAxAYx6XrpTAokoE2qEdawgkwxmewk9P0tRwqAYyGnJmnT
	 H8rfpsuWWRJPoqaQeRv7BzGMEmQ72vnPcDtEZb+I=
Date: Mon, 13 Oct 2025 18:25:01 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot+0584f746fde3d52b4675@syzkaller.appspotmail.com,
	syzbot+dd320d114deb3f5bb79b@syzkaller.appspotmail.com,
	Youngjun Lee <yjjuny.lee@samsung.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <hansg@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: Re: [PATCH 6.1 013/196] media: uvcvideo: Mark invalid entities with
 id UVC_INVALID_ENTITY_ID
Message-ID: <2025101333-exemplary-bankable-5585@gregkh>
References: <20251013144314.549284796@linuxfoundation.org>
 <20251013144315.044387377@linuxfoundation.org>
 <20251013150022.GB1168@pendragon.ideasonboard.com>
 <2025101327-footpad-boxcar-7049@gregkh>
 <20251013161323.GB6599@pendragon.ideasonboard.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013161323.GB6599@pendragon.ideasonboard.com>

On Mon, Oct 13, 2025 at 07:13:23PM +0300, Laurent Pinchart wrote:
> On Mon, Oct 13, 2025 at 05:25:55PM +0200, Greg KH wrote:
> > On Mon, Oct 13, 2025 at 06:00:22PM +0300, Laurent Pinchart wrote:
> > > On Mon, Oct 13, 2025 at 04:43:06PM +0200, Greg KH wrote:
> > > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > This is causing a regression as reported in [1]. Ricardo is trying to
> > > get his hands on a device to try and develop a proper fix. In the
> > > meantime, can we avoid backporting this patch to any stable tree ?
> > > 
> > > [1] https://lore.kernel.org/r/CAOzBiVuS7ygUjjhCbyWg-KiNx+HFTYnqH5+GJhd6cYsNLT=DaA@mail.gmail.com
> > 
> > I can drop it from this queue, but it's already in the following kernel
> > releases:
> > 	6.6.110 6.12.51 6.16.11 6.17.1 6.18-rc1
> 
> Should we merge a revert as a fix for v6.18 and get it backported to
> stable trees, or can we revert in the stable trees directly ? It will
> take a couple of weeks to get hold of a device and develop a correct
> fix.

A revert now probably sounds best.

thanks,

greg k-h
