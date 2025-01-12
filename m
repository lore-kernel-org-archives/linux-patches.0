Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CFB1C07C3;
	Sun, 12 Jan 2025 17:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736702671; cv=none; b=e01udIDY7CPpPsefoshLoi2ZmSOf3Cu6R7KukmVBdg5DXaMZvXmh5+Ky3Cm24uowp3w3rCH4H3m1yEmZw/gna7eenHIItx6285Ds4jbIfqWnGhlKsU69ITG6oVDiqsNXi8yTDU248jV06yhDzrIib1EkTNdCdZg+qpFW4uHwSOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736702671; c=relaxed/simple;
	bh=Tui79WJVcRIARvgBWgKsKD3aEGPGObSK5nusmmeg4b0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BaZQlYYIBqhVR1NWvIrsCUlRCjE44akG8j1ZF1OVVw5g/0Io301VP4NqrRR+Q6CuyiT/oefedDQQene9pWdFhdcrkSTxb8SSBuRGO4Rb154qux3RgCle62ndX+3RgiU7aqQmnV2wQeSq4dtzAfIoTaRiuJcv9FgqbpmQ3oMucYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBzlDkbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBzlDkbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E1BC4CEDF;
	Sun, 12 Jan 2025 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736702670;
	bh=Tui79WJVcRIARvgBWgKsKD3aEGPGObSK5nusmmeg4b0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kBzlDkbdeUzlZwAj09+ukBcRXzlE7RhTQYxshXaLGsZWi2Kvu6YShO3KWjwHBFW+N
	 5GWxM5bF69KrOagsd3/jBzeRuPgm2T9QlB/8qweGv7akST+EqxHjLouqQkOP0ZjT3t
	 kKvFPmF7XsZlt4CvKaeIT+0FWby7JmU2jrBb/fVc=
Date: Sun, 12 Jan 2025 18:24:27 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Neal Gompa <neal@gompa.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	tech-board@groups.linuxfoundation.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 3/3] docs: submitting-patches: clarify that signers may
 use their discretion on tags
Message-ID: <2025011240-gating-departed-6d5a@gregkh>
References: <20250112152946.761150-1-ojeda@kernel.org>
 <20250112152946.761150-4-ojeda@kernel.org>
 <CAEg-Je-Knta8BtYSbZgX8cZ9Gd-2cpDAUE83dCJZbTbqmSfcKA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEg-Je-Knta8BtYSbZgX8cZ9Gd-2cpDAUE83dCJZbTbqmSfcKA@mail.gmail.com>

On Sun, Jan 12, 2025 at 10:47:02AM -0500, Neal Gompa wrote:
> On Sun, Jan 12, 2025 at 10:30 AM Miguel Ojeda <ojeda@kernel.org> wrote:
> >
> > Tags are really appreciated by maintainers in general, since it means
> > someone is willing to put their name on a commit, be it as a reviewer,
> > tester, etc.
> >
> > However, signers (i.e. submitters carrying tags from previous versions
> > and maintainers applying patches) may need to take or drop tags, on a
> > case-by-case basis, for different reasons.
> >
> > Yet this is not explicitly spelled out in the documentation, thus there
> > may be instances [1] where contributors may feel unwelcome.
> >
> > Thus, to clarify, state this clearly.
> >
> > Link: https://lore.kernel.org/rust-for-linux/CAEg-Je-h4NitWb2ErFGCOqt0KQfXuyKWLhpnNHCdRzZdxi018Q@mail.gmail.com/ [1]
> > Suggested-by: Dan Williams <dan.j.williams@intel.com>
> > Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> > Acked-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > ---
> >  Documentation/process/submitting-patches.rst | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/Documentation/process/submitting-patches.rst b/Documentation/process/submitting-patches.rst
> > index 7b0ac7370cb1..6754bc15f989 100644
> > --- a/Documentation/process/submitting-patches.rst
> > +++ b/Documentation/process/submitting-patches.rst
> > @@ -614,6 +614,10 @@ process nor the requirement to Cc: stable@vger.kernel.org on all stable
> >  patch candidates. For more information, please read
> >  Documentation/process/stable-kernel-rules.rst.
> >
> > +Finally, while providing tags is welcome and typically very appreciated, please
> > +note that signers (i.e. submitters and maintainers) may use their discretion in
> > +applying offered tags.
> > +
> >  .. _the_canonical_patch_format:
> >
> >  The canonical patch format
> > --
> > 2.48.0
> >
> 
> A tag must not be dropped without the tag submitter's authorization.
> Otherwise it doesn't matter what you write here, the submitter *will*
> feel unwelcome.
> 
> It is rude and discouraging to do so without their acceptance of doing so.

I accidentally "drop" them all the time by virtue of them coming in
_after_ the patch is committed to my git tree.  I can't rebase, so they
just don't get applied to the commit, which is fine.  The tag stays
"as-is" in the email thread for forever, so there's no real problem
here.

Also, sometimes, we can't apply a tag from some entities for various
reasons, so please don't think that anyone can force a maintainer to
take things that they aren't allowed to, or want to, take.  But this is
a rare occurance.

thanks,

greg k-h
