Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B39386C25
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 04:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789618121; cv=none; b=JKGbseCGDUFOozSGx1DwjXRUoidMIsV3C/lV30SEQ3wlC6zWbPTn2tHkv4NHfr5efq9wnd1JynWhdYLSvyLVGe77+oKWb9kiRhvlXO5UkzJ8O50ZwhhLSDL2B9aKfEGpX9PXr+ZsZjuLeYNFcb0TZic01bpWBO8CQQItgGGHLd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789618121; c=relaxed/simple;
	bh=HwauYC9D4u3O794NhMrtXulcF3FuA+UuKQ+QwgJBzfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BLr/85T4dP2yQtfALUpR7ROq/p/SKQiUQHDJ4uB7Iy1lcucRqYB/Xiutkhu+OwyVSnWQg6tOXUuOaQrmkLS58ulKYQuYztCRuwhsL605o2m/z/tVf5KFzgUvzhTQqTYfULMxjqVJj7xmCAqsyFBtaRMTAYrwlx61OFMFcmAAG7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LC3YSart; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LC3YSart"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e7d2bb404so742205e9.1
        for <patches@lists.linux.dev>; Wed, 16 Sep 2026 21:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789618117; x=1790222917; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=upbDFswdev9zDbHI+yVPYldzxiCqjAm18ndZfHkWv3s=;
        b=LC3YSarthUiZzSVy8crmE9Euwb1PR7REx3fVXJFKCaYRHMnuGo176l7x1rbYoOue5C
         HkTKLF8oQdPg0dLALk5tZpJFkGbFx//owTWW0tPXoJfLfYbxFK98o52OvqnuuNA/Sum8
         Sll2p954BKs0XRW7LwbgbqrSkwLvjUwLZ2RV5QoA8aJurK9/CSEKxPwe1LOLI8rfwPEW
         XWUgnuoL+bnvG1n14zn4fs1m8ch00vqQviKEclf/5N5GNoa8SOsi/8A6icuDbLyXqAK5
         bPWhLig1BifC73Cslj0drHwvs1bAqI3yejUeTuOGFJXo2Um2plG25ffi9q2SjXomJQCS
         wgRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789618117; x=1790222917;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=upbDFswdev9zDbHI+yVPYldzxiCqjAm18ndZfHkWv3s=;
        b=MUc+SyafYYOA2mQPqfctSG5PZBugICtiNyjhTGAogxw3JDvKNADnp+RidN47LOMx/H
         +iqgKJWZ9/Y3h0h+x1Z63rC2cT6ruQMr/NY8pH5gEzPn6+yP3eyxC4TyGwY2Uo14h9f6
         neHGlBOq6cQYsRl/Yp1Z+mYmlrJVG8J31T2zDo9wdBX4HcHrQH2fkAWlcE5PJlU0iUeK
         khbbDXMQgfsFW46ljb0lDG3eXuL+kSJXMi2eOZAcUZeXlIYtK7fg3/ZsIfcVRZfn7C/I
         rMPlGgd52ZfSVtBG0jIpUHN3X/FvSg4Q2T1DGVzkmd8EX6WNaxgxmXslzY0CWYal4Bl8
         r3Eg==
X-Forwarded-Encrypted: i=1; AKwUvBxcM6lJZ/l8POFPuI/VAFO9XterewX+imdgRDl8QRZ0DGu4GRAruadkVpIl23n4vvb7L/puHsko@lists.linux.dev
X-Gm-Message-State: AFuF++kXpBSrQRTAqQr4OyYzHGJ/Eh7v4PO41QjTnnw1srmAG9olp4XL
	f8zOmZUwArPxm3SXgiSv+7kKJ14SQ74ct4XNNTVBFt+nsbGfiqwjJUCv
X-Gm-Gg: AYBFou0F5Y67C/czXWNYJOf0LIirHde0gbwCjOsWnw6nLhgMHzuj7daaxSDkSsaMWnn
	FgYsXIvRzhRqdn++WC3g2pQ+1acNGVVIIyXWZLv9OV0H+/TJMGrd2CvNZP2IPrBm2VTzJsuqWZP
	51qOBib5Gem5s2pffa6PBFXvg9OUnTT3trTHnJZ990Qxwpo11/3jz2AsQbsWiKCTk4qvZ2OHVKE
	ycfwZNpzT3xDxYZQP10/Mo0qVgslNN1cSW1lJDxBIVpVTgNwJi7RkPEnHvdUuCx72ocBdPfASol
	e5oGCf5B5ErVAzP2Jrv+xRz3hXANJWS+lT9fJVYEgnUhtxRJP+FodRISNo+/zZAuPDCrlrOztMm
	gf5XzikPuNRSnmr109IlNRd8Ggmo9+Dx8O++RL9IlkoHqaINHKUWzXIu9JxIEtxYjFGrn2JoUCP
	LE/t52CsTAZ+zGftFQqlLT6mwD04fZ1rd5tHIFA0LWsNsDdTrLUaeo/IIR/fjLkxRRLMhruQYaO
	RH5Lz1e1UXUL6VfcWgP09p/tRCWovMDiUIyRNYzE0FYxM0dC7SxQoRWhmMpCShLKQe4fSUBGUJr
	rQrUj0+c1lV9/bfOP/gi0jeI7RsdQKPqTSIglkktoufjYs2cyoWdHrkOHzUpd0VmdRSSfqUXgQ=
	=
X-Received: by 2002:a05:600c:a11:b0:49e:63cc:6324 with SMTP id 5b1f17b1804b1-49fbd1c2448mr21678245e9.6.1789618117494;
        Wed, 16 Sep 2026 21:08:37 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-9dc6-c001-54ee-4741-4927-0a28.310.pool.telefonica.de. [2a02:3100:9dc6:c001:54ee:4741:4927:a28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd23ac75sm39976185e9.13.2026.09.16.21.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 21:08:37 -0700 (PDT)
Date: Thu, 17 Sep 2026 06:08:35 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Edward Adam Davis <eadavis@qq.com>, Luiz Augusto von Dentz <luiz.von.dentz@intel.com>, 
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5.15 879/935] bluetooth/l2cap: sync sock recv cb and
 release
Message-ID: <aqtnK6b1rvxwJjSU@gmail.com>
References: <aqoaFdvSsDiiLb5I@gmail.com>
 <daily-reply-20260916-0024-re-l2cap-5-10-revert-hold@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daily-reply-20260916-0024-re-l2cap-5-10-revert-hold@kernel.org>

On Wed, Sep 16, 2026 at 03:28:14PM +0100, Sasha Levin wrote:
> 
> Thank you for running that down. I am holding the queued 5.10 revert of
> 89e856e124f9 ("bluetooth/l2cap: sync sock recv cb and release") out of the
> next release until your series arrives, since shipping it alone reopens the
> NULL deref you reproduced.
> 
> I also withdraw my objection that f1a8f402f13f ("Bluetooth: L2CAP: Fix
> deadlock") is unlandable on these trees. You are right that the fix is the
> l2cap_core.c and l2cap_sock.c hunks and that the hci_sync and hci_core hunks
> are an unrelated hci_dev_cmd() refactor.
> 

Both are now posted.

5.10.y, one patch:
https://lore.kernel.org/stable/20260916193454.9996-1-kmehltretter@gmail.com/

5.15.y, two patches:
https://lore.kernel.org/stable/20260917040004.21041-1-kmehltretter@gmail.com/

5.10.y needs only the one patch because it already has 89e856e124f9, so both
L2CAP hunks of f1a8f402f13f apply there unchanged. 5.15.y never received
89e856e124f9, so it needs the conless lock first and the guard second.

Thanks,
Karl
