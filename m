Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379131C3F1F
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 16:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729529827; cv=none; b=leKrqdCYCM48bn6Cfq/XE7cHU6tXFmHkvefGIX1FAjWQaKAKM+ERjprDezV6K83dT2A3Yu9keRDDBwVkZBlfF7snaL8KKjpB5lsvTyf4l7wKKkhhjdM/5gjAUX49ymCjwYMoawug+0HTJND4uKLOgkQamcuEZIqcg5UiXBK7kJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729529827; c=relaxed/simple;
	bh=5S0TGg8jgrQlW57qIoAG0g2eeDejXK0LPq804MUBGwQ=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WpNGWPDMv/7kr9nqKEEIyByyiMNgEezIly/56bbwVS59LYrn05oKuwt15CRRqkEX6Ka/1squASzVLQxz1qS5/mhU+W1f2t9O+J9uV2y/oQvxsJoaU1l8iOo2dapGQKtmZDwafsQlolQkfmNEKjEvdJKPipIMHS0ELEDjnFrplsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eJv1ice0; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eJv1ice0"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-539eb97f26aso5342581e87.2
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 09:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729529823; x=1730134623; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M273fnt+DSl6Al76DCKRa+RzcpBVSp9P2WGr087VQgs=;
        b=eJv1ice0CA364ajlGULdtKJ2iY2k1b1jPlnCin9S9ZklekOkGPdGdQYkqb5jCfRbaX
         A49w0s59gwX2MNqgY+A7JrCV73x9a0+SzH1iX+vDKs6jww2mrvx1HSsxBHoEC+1uWgGC
         naONTsj/RXdIkwJupgQJ1ua1MGWytQexet7sy3skXXYnWDLm6+a15bC/qzI3c0wOGyrC
         iuYrFc0JZZSV/1HLgHa7a4UYNilze7kYXQVZU7n0Oh34DRWR91H5eErmoBj36XdPxsfx
         Qocp9Yft2fjS2gSu4p5rmGHP/GdeBfSAvWDplde3ZF/3P0Y6bkMrNMlatS4XKqVBf3YZ
         FcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729529823; x=1730134623;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M273fnt+DSl6Al76DCKRa+RzcpBVSp9P2WGr087VQgs=;
        b=BsGqqOXp/yG57jovMWKyPpL2OzrHhxzjbNWRaDqh4aBMosWPp5zVTNwk8egdpBOToo
         0QBSyCBoGa6v54iRH+Ct6Ice3zWcMOnBQtolsuUyOzBmcqN77h0yyxb9//dMbKQawtzc
         I/0rifgoiEIc3vfs8PnqEUpO9HyWBCzo5P9ar3Mix33o3gUwZzc7KL2B8GR3M6LgSKmB
         uR0Z9y3LexZJkpAS+vWgntkR4NVVb/3uiE22kdeBiNmSpcQK/ZIUtvoMjZf8bWCFfsGP
         VQ8YVQctwPKVbInkjzkbdtmSe73yqcfLCyWPhPiy4XyDjud5HGgAcGlDeOL7qQZC9dpO
         0GdA==
X-Forwarded-Encrypted: i=1; AJvYcCWhiOKI5CJACk7qkVPlrVlBEEOiybt+qyrWd+TKOZ8e6/VpqI7s6z/+tDJ6zJCWyTZI2jgDLBeO@lists.linux.dev
X-Gm-Message-State: AOJu0YzLY7i2AErNJXmB/MREv47eI+RDfUbYSBfRnYRjHAzQjG/hcqgY
	WSUttQjjiqcjV6lNMJDzS6/yt0jm+OwjzhlNHtXRmjP/LbBUmu4r
X-Google-Smtp-Source: AGHT+IFYpm/XNpPUmsU0edtr5Nc8/3sONWWu91dkTXMHsL2/ggGcRxWNKSri284ojmcZ6O875LoDDg==
X-Received: by 2002:a05:6512:ac8:b0:539:ff5a:7ea5 with SMTP id 2adb3069b0e04-53b12bfdabdmr371844e87.15.1729529823031;
        Mon, 21 Oct 2024 09:57:03 -0700 (PDT)
Received: from pc636 (host-90-233-222-236.mobileonline.telia.com. [90.233.222.236])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a22431548sm517613e87.223.2024.10.21.09.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 09:57:02 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 21 Oct 2024 18:57:00 +0200
To: Suren Baghdasaryan <surenb@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Ben Greear <greearb@candelatech.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>, Vlastimil Babka <vbabka@suse.cz>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.11 024/135] lib: alloc_tag_module_unload must wait for
 pending kfree_rcu calls
Message-ID: <ZxaH3KsZD8voFtBL@pc636>
References: <20241021102259.324175287@linuxfoundation.org>
 <20241021102300.282974151@linuxfoundation.org>
 <a4163f51-cc1a-0848-d0fd-e9b94dafc306@candelatech.com>
 <ZxZ_uX0e1iEKZMk5@pc636>
 <CAJuCfpGwBixidbi1D-+6b6BrM7Ggob-1NZApo_+dny_T2qNAzw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGwBixidbi1D-+6b6BrM7Ggob-1NZApo_+dny_T2qNAzw@mail.gmail.com>

On Mon, Oct 21, 2024 at 09:51:58AM -0700, Suren Baghdasaryan wrote:
> On Mon, Oct 21, 2024 at 9:22 AM Uladzislau Rezki <urezki@gmail.com> wrote:
> >
> > On Mon, Oct 21, 2024 at 09:16:43AM -0700, Ben Greear wrote:
> > > On 10/21/24 03:23, Greg Kroah-Hartman wrote:
> > > > 6.11-stable review patch.  If anyone has any objections, please let me know.
> > >
> > > This won't compile in my 6.11 tree (as of last week), I think it needs more
> > > upstream patches and/or a different work-around.
> > >
> > > Possibly that has already been backported into 6.11 stable and I just haven't
> > > seen it yet.
> > >
> > Right. The kvfree_rcu_barrier() will appear starting from 6.12 kernel.
> 
> I have 6.11 backport for this fix which also includes
> kvfree_rcu_barrier() backport. I was waiting for this fix to be merged
> into Linus' tree and now I can post it. Will send it shortly.
> 
This is good, i reacted because i have not see the "other parts" yet.
So, sounds good!

--
Uladzislau Rezki
