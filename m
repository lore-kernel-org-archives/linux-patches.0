Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF01A34D90D;
	Sun,  6 Sep 2026 09:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788687908; cv=none; b=mWVbhpQ+kY23hdrAQ1fgrOevGnnjT21ncWkZMKIKiCZQlG1gRzsKudEe2gFyIDrwWstjm8ggjTtzizxxYd1N4CMwwRsOU5+mpN2Tef54fu+veMrn4qohez74rTMB2A3rI+yh/kAXAN4VxmsG1kxOx36pT2UUG1JGW+1TM+5kCvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788687908; c=relaxed/simple;
	bh=nt230KuKNGFTxiHlmNNiik2eqoA7gMBlvJjeqsUkpi8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eyvrEGLqTrrF6HfvXSN2hhLnW0++f8nsY8mfO2m6mgqEa/hFObwgDgxc+pCpXQTrXA1gVm1yy0hXE1CMjWX5YYK7TEvSnd/vwKjU6R71sW+RPlZOmmWxcd7zHuRCM5GsuI3S6lGamxFR1jTZTC2grzEEGUkiFfTuIYbYrT3M5Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igceVYoo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igceVYoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8441F00A3A;
	Sun,  6 Sep 2026 09:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788687906;
	bh=7qGNwKl4/nIp92eRoe0ETh8LAuuVS2rHKOovRIgxnUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=igceVYooP1WvT4fpC4bUfMrUXbW+zEaE4MytBrqyun7sLSv12okrSVfhS2heZwLyE
	 UgUFu6sFpVHpRJS4dg6giUM1L/9sQ0FkGj7KWB+J9O0UkE0xEP5SYhxUcFeu0P0hrk
	 MqDPlY2uN+bdJnUVJosNM6RaCHvgBfc6+lLfqCTc=
Date: Sun, 6 Sep 2026 11:43:21 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.18 024/552] rust: bug: fix warn_on macro build error on
 UML
Message-ID: <2026090611-shortcut-varnish-ea40@gregkh>
References: <20260904045747.813364717@linuxfoundation.org>
 <20260904045748.373148168@linuxfoundation.org>
 <CANiq72=EounScE9CxhQVRYTMe6XxgZzfid_cJZ5dxmkz7MQ2kw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72=EounScE9CxhQVRYTMe6XxgZzfid_cJZ5dxmkz7MQ2kw@mail.gmail.com>

On Sun, Sep 06, 2026 at 03:04:33AM +0200, Miguel Ojeda wrote:
> On Fri, Sep 4, 2026 at 7:41 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > +                $crate::str::CStrExt::as_char_ptr($crate::c_str!(::core::file!())),
> 
> In 6.18.y, this needs to be:
> 
>   $crate::str::CStr::as_char_ptr($crate::c_str!(::core::file!())),

Ok, now dropped for 6.18 and 6.12.y, thanks.

greg k-h
