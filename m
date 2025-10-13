Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [213.167.242.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E22F2E7F1C
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 16:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.167.242.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760372014; cv=none; b=jbcljh6neP8lSKTmFRoXIjhfho5mx9iXcA1L+MHZAtc0fWdLumHlDW6uyS7/z3BgCb7KafU+V+r/5PUpXraMr7bcV8sn61b0lZZ+jr71+0Vxk2O7FLxsheglFi8O00ss9M0cFvksMvomCzCJeGvlOIpNdZTJOegcQwyt5To/yAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760372014; c=relaxed/simple;
	bh=azNU3JfWUGCf0nszOib4Sv36wDAINQl80jSZWmf5kZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gjPd52AITOg2N07s4EerUqpAKgau5dO+ibL7e0gLzDrtei5KOFDhOGIWZZhpUBbsKDXplTI3kL4S31lk9M2E0Lif50zWnSjgqv70E5svsYLx+M4Ca4bjVFz/d0WHGAnwRoWW8eH7sgX6Cp3vpfQvDi6hEHsCa56TXqs5zfxxmgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com; spf=pass smtp.mailfrom=ideasonboard.com; dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b=pQSPGo7c; arc=none smtp.client-ip=213.167.242.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ideasonboard.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="pQSPGo7c"
Received: from pendragon.ideasonboard.com (82-203-166-19.bb.dnainternet.fi [82.203.166.19])
	by perceval.ideasonboard.com (Postfix) with UTF8SMTPSA id 9E0DA557;
	Mon, 13 Oct 2025 18:11:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
	s=mail; t=1760371912;
	bh=azNU3JfWUGCf0nszOib4Sv36wDAINQl80jSZWmf5kZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pQSPGo7cczYaHDP2Ypcze0aNoBsVawmlZZZ0OgWcxC2fGeZ3lRdC2JDh0GQA9b3Ef
	 7jwokNrHyFYmyava0NamNVBeTfk600VaNT1N3+aGBhkbmoUm7zWCl0c7xXW7F9osZh
	 LGJTp3byopC3O3BCT8G2+5hwzf1htlgvsCQ+ebBU=
Date: Mon, 13 Oct 2025 19:13:23 +0300
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Message-ID: <20251013161323.GB6599@pendragon.ideasonboard.com>
References: <20251013144314.549284796@linuxfoundation.org>
 <20251013144315.044387377@linuxfoundation.org>
 <20251013150022.GB1168@pendragon.ideasonboard.com>
 <2025101327-footpad-boxcar-7049@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2025101327-footpad-boxcar-7049@gregkh>

On Mon, Oct 13, 2025 at 05:25:55PM +0200, Greg KH wrote:
> On Mon, Oct 13, 2025 at 06:00:22PM +0300, Laurent Pinchart wrote:
> > On Mon, Oct 13, 2025 at 04:43:06PM +0200, Greg KH wrote:
> > > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > This is causing a regression as reported in [1]. Ricardo is trying to
> > get his hands on a device to try and develop a proper fix. In the
> > meantime, can we avoid backporting this patch to any stable tree ?
> > 
> > [1] https://lore.kernel.org/r/CAOzBiVuS7ygUjjhCbyWg-KiNx+HFTYnqH5+GJhd6cYsNLT=DaA@mail.gmail.com
> 
> I can drop it from this queue, but it's already in the following kernel
> releases:
> 	6.6.110 6.12.51 6.16.11 6.17.1 6.18-rc1

Should we merge a revert as a fix for v6.18 and get it backported to
stable trees, or can we revert in the stable trees directly ? It will
take a couple of weeks to get hold of a device and develop a correct
fix.

-- 
Regards,

Laurent Pinchart
