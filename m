Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9814E18A6C2;
	Wed, 20 Nov 2024 07:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732086089; cv=none; b=daV5iPqnWstNTKPRBpuYQpqiIkQjBhFwOECz/6AunVcnBCw7SAEAeeouxhmXnRgAsL01Z1KpGoWrk8nOgR6y7kOORejKz14Ur966VsehSH5BeVtnLIsU4i49NqYhuRq+U4f7ODnfSZh2F0YzEt+aA3nALqY3rfAxiYMgHfwNQ+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732086089; c=relaxed/simple;
	bh=YfY9O7wSH3eO92M+fpGPgneosedEVw+4tWw9KEXSXxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NQ5Kw75414vUI5H2X7ly4SS2FtcAPpjJmsEdX65XM6Fc1yaIjX0ZMcH/iCVCkntC8tOpJYWfNQbtlzR0pS4FZQx+XJvTMWo+AaX8KhgoI0XTZpd/ryNwCXp65FWoARwn9xC/hg7TUsVgt9yeAe3zmmgrf29qi5cQZUFJsVS51O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K5rTR1lt; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K5rTR1lt"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a9ec267b879so859376566b.2;
        Tue, 19 Nov 2024 23:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732086086; x=1732690886; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wuhGZa1wphlMJu5BT/9fX23QNVaQXhewHRgLxFfqZUY=;
        b=K5rTR1ltcoNKZ5FnR4U5nJQS6fCQSxItBLBcSt2n5n9IbCUKcWTXBJGHEra4OYFYUe
         W6R+yDjTD3hRzt/PYjcfgZU13pJyQ3aIHimxZnek1bGJ4XDC2DLl57J+ig0EzAjHwdHV
         cNG9uwN9mZIq9D3CjMXXawNTpdqEa6xep3X50sI/YZ09WhP/MTrtxUyCpfCKWIkKZtqX
         XRfiKwi46dG3iQmEPeF+am/CLe4C72Qs8656kjUS9Rp5mvGqSc9A8QSkDcezzrZsWhqr
         f1/PJ1EoEuOwIT3pcm1SO5g/i6wOIiTcV6hg779waff6g/tTtIYDVYOmc4MSeJxPIfjr
         aC5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732086086; x=1732690886;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wuhGZa1wphlMJu5BT/9fX23QNVaQXhewHRgLxFfqZUY=;
        b=SFgrgAKEONm1qpnTPAaUn/2mUELNO+wsUYhbY3LPCkpMdAN4LhhTCRTT4bSe3Owvn3
         hzgTBxY6ZrQLFcf7s6AMC1fJNBCvO1cfxi/hXx0pyEmGGyqkE4ZSLvuT55QBd6dV3a8r
         NO80xfHVnftWAXAgRd6kMCg9vjkWNRRfWZYgN8XT9Pflszf2CZt/Lo4C0suRyL0lCyo2
         EOtVttC1mFFJ6rO2oPc3nhYnKid3wx3F5NTMb0RRZ8W0a5+kJx0BZUv1zb0/A/7a08PN
         F0iMWqoROmVUcrTpd6BWSXrjYTxyItkE8JrDoPFejsaJliPaVztwLxMI4da/SzUk4x54
         izfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbuz8CI8jnpFJMeU08tYmHbyOZFev6Cf/11GePcX2o2kW+EXSV2Wq2MBLsO8Vjwc0Vk95gkcgm@lists.linux.dev, AJvYcCXUPopWdWh86ZwN/gIFHvdrteDG4naLwofFpjQbwtme+uUpub/GLhZU1qxeW70jQSpoVgCE5bZArzjDY4E=@lists.linux.dev
X-Gm-Message-State: AOJu0YzfXwonaBdClNBZt5AFbRlE75BS52lwUTzaDG2620e8PXK0GJ/H
	wlD91EX/dbGbbcSzAoBGdUQZgYzxSVWMvPvpDftc7t8iFefaIasv
X-Google-Smtp-Source: AGHT+IGQ/p9RGsj/UtKWUzs6dPt72UBwcdLUCoTcS5a12Ok5zybtRplyc9AOLKJDgxlyx+B/wkPMzA==
X-Received: by 2002:a17:907:84c:b0:aa4:9b6a:bd77 with SMTP id a640c23a62f3a-aa4dd551bbcmr156944366b.17.1732086085636;
        Tue, 19 Nov 2024 23:01:25 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e044b59sm726873866b.143.2024.11.19.23.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 23:01:24 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 007E4BE2EE7; Wed, 20 Nov 2024 08:01:23 +0100 (CET)
Date: Wed, 20 Nov 2024 08:01:23 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, y0un9n132@gmail.com,
	Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiri Kosina <jkosina@suse.com>, Sasha Levin <sashal@kernel.org>,
	regressions@lists.linux.dev
Subject: Re: [PATCH 6.1 175/321] x86: Increase brk randomness entropy for
 64-bit systems
Message-ID: <Zz2JQzi-5pTP_WPx@eldamar.lan>
References: <20240827143838.192435816@linuxfoundation.org>
 <20240827143844.891898677@linuxfoundation.org>
 <Zz0_-iJH1WaR3BUZ@codewreck.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zz0_-iJH1WaR3BUZ@codewreck.org>

Hi,

On Wed, Nov 20, 2024 at 10:48:42AM +0900, Dominique Martinet wrote:
> Hi all,
> 
> this patch introduces a regression in some versions of qemu-aarch64 (at
> least as built by debian):
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1087822
> 
> It doesn't look like it still is a problem with newer versions of qemu
> so I'm not sure if this should be reverted on master, but it took me a bit
> of time to track this down to this commit as my reproducer isn't great,
> so it might make sense to revert this commit on stable branches?
> 
> (I don't remember the policies on "don't break userspace", but qemu-user
> is a bit of a special case here so I'll leave that up to Greg)
> 
> 
> I've confirmed that this bug occurs on top of the latest v6.1.118 and
> goes away reverting this.
> (I've also checked the problem also occurs on master and reverting the
> patch also works around the issue there at this point)

Interestigly there is another report in Debian which identifies the
backport of upstream commit 44c76825d6eefee9eb7ce06c38e1a6632ac7eb7d
to cause issues in the 6.1.y series:

https://bugs.debian.org/1085762
https://lore.kernel.org/regressions/18f34d636390454180240e6a61af9217@kumkeo.de/T/#u

Regards,
Salvatore
