Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0F52F8BF5;
	Mon, 13 Oct 2025 15:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370369; cv=none; b=qpPYiTrBFS5r1GB/gF1F193Fi4smIRaXd1ta9cFiYQ4srFPDhl38Y+2XDsQEbyzW6cvKnTosAkkleT5YDqfCvvjAMxiand7OBBRRWQNsx5A16LBMEpeaAIg2dIdC2HUW4fGMlD4hit67M/q1o0/o4/jBKQG4ZEchgWaZGVTuLis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370369; c=relaxed/simple;
	bh=rBt3OMtt6UyJNg7ljMp8OP3Ab2Z9biY1NcVhDBAhF4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W9w/JsOHcpGqL+zV8eyBB7Kj0tpFLiM9QZXf7jY8kWsK6Mk52bP7/liYxK6VW2edGdyf2gQBNnAAfnrl+XqDDEBNQed3MOuFI+eauuxoULRbESJpUJ+hVxphvxSG/WyxSWMaEXvDgxjrEDrxdrfl3z28kbSVHA2nwZDe7WDvHRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVP/XElJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVP/XElJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44554C4CEE7;
	Mon, 13 Oct 2025 15:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370369;
	bh=rBt3OMtt6UyJNg7ljMp8OP3Ab2Z9biY1NcVhDBAhF4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xVP/XElJyiYya//9S6zA4MmAgaczFM6mEohqIfnINLQYsDVbKG0dZ6Qy957duigeq
	 c8cSZ+7Yym3K9zCADa4wC58Ep9m3UBzDy0iPV/dOJPnHtgn/7UK4+E7cezeb3qZ54L
	 CwfTC7ZF3/SDhdEb465tQ6sOviAyKobUOEEPXnY0=
Date: Mon, 13 Oct 2025 17:25:55 +0200
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
Message-ID: <2025101327-footpad-boxcar-7049@gregkh>
References: <20251013144314.549284796@linuxfoundation.org>
 <20251013144315.044387377@linuxfoundation.org>
 <20251013150022.GB1168@pendragon.ideasonboard.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013150022.GB1168@pendragon.ideasonboard.com>

On Mon, Oct 13, 2025 at 06:00:22PM +0300, Laurent Pinchart wrote:
> Hi Greg,
> 
> On Mon, Oct 13, 2025 at 04:43:06PM +0200, Greg KH wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> This is causing a regression as reported in [1]. Ricardo is trying to
> get his hands on a device to try and develop a proper fix. In the
> meantime, can we avoid backporting this patch to any stable tree ?
> 
> [1] https://lore.kernel.org/r/CAOzBiVuS7ygUjjhCbyWg-KiNx+HFTYnqH5+GJhd6cYsNLT=DaA@mail.gmail.com

I can drop it from this queue, but it's already in the following kernel
releases:
	6.6.110 6.12.51 6.16.11 6.17.1 6.18-rc1

thanks,

greg k-h
