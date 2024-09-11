Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAD9183092;
	Wed, 11 Sep 2024 12:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726058573; cv=none; b=jrKWNLLVXY0QTG4TqmCRNFCR+4wKvAppdlReA6fk0+Fe6Sn6HMIdooMOI9dBxCP4RePuN481MimALZPHJzP1GZyvG4L1B+P3Iv8DU9YawHEzyhrRdPbhj8DFdiQbAOjTkTFjDTWCk6MKwY3JeLyuti4QOl7mq3Ufph2+/xm+tl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726058573; c=relaxed/simple;
	bh=IGxNS2eEsN1Yn9P5c0VtCI9G+p++iPNV2/kh+WlS7Yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZtM/njDSbyCtiRPgvX+JL5niO1HS/zQT+1IiiMJu3AvfeF+FYeu1ps7rORBZknAnogsNQ0wVoORLq6Zijlkxi30aFUx01s/Xk7xJ37/0acKfV26PJA/GFZCjKwj86z5mlvA6QGedxtOvKEts8Ix2tADrtF7XgwyukdH7ogrJIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRZbP4pl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRZbP4pl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A6DC4CEC6;
	Wed, 11 Sep 2024 12:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726058573;
	bh=IGxNS2eEsN1Yn9P5c0VtCI9G+p++iPNV2/kh+WlS7Yg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tRZbP4pl1ld9RtV+B8TjuWThUPn9Jq0QJoY5CJD5VSe6OSp31L+Yh4edEHvo4Jd7R
	 uQgsDkpJNESxN0Dtb/+8iR66SsfT+u998UTJI173kZGpqljRsE0/gDyx4rVlFDkcVy
	 sZV+ze86OJNL/NrIErlvlV4r//oS5sR2mfevEhKQ=
Date: Wed, 11 Sep 2024 14:42:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Boqun Feng <boqun.feng@gmail.com>,
	Trevor Gross <tmgross@umich.edu>,
	Benno Lossin <benno.lossin@proton.me>, Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH 6.1 153/192] rust: macros: provide correct provenance
 when constructing THIS_MODULE
Message-ID: <2024091107-spur-tattoo-e662@gregkh>
References: <20240910092557.876094467@linuxfoundation.org>
 <20240910092604.257546283@linuxfoundation.org>
 <CAH5fLgi7_=3W3WdPR2KcUW73Ma=SXo-dX20z0xx+AK4S_N3SwQ@mail.gmail.com>
 <CANiq72kvESNP0StA6DRukSJ7K4q2a4EtTsNTDECSAsWjmhp5-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72kvESNP0StA6DRukSJ7K4q2a4EtTsNTDECSAsWjmhp5-g@mail.gmail.com>

On Tue, Sep 10, 2024 at 01:14:34PM +0200, Miguel Ojeda wrote:
> On Tue, Sep 10, 2024 at 12:25 PM Alice Ryhl <aliceryhl@google.com> wrote:
> >
> > On Tue, Sep 10, 2024 at 12:12 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > Fixes: 1fbde52bde73 ("rust: add `macros` crate")
> > > Cc: stable@vger.kernel.org # 6.6.x: be2ca1e03965: ("rust: types: Make Opaque::get const")
> >
> > The opaque type doesn't exist yet on 6.1, so this needs to be changed
> > for the 6.1 backport. It won't compile as-is.
> 
> +1 -- Greg/Sasha: for context, this is the one I asked about using
> Option 3 since otherwise the list of cherry-picks for 6.1 would be
> quite long.

Sorry about the delay, yeah, this is why I didn't apply this to 6.1.y,
but Sasha picked it up as he saw it looked like it applied and didn't
break the build.  Maybe we aren't building rust code in our systems?  I
know I'm not, I need to fix that...

Anyway, now dropped, thanks all!

greg k-h
