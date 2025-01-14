Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D073620F06E;
	Tue, 14 Jan 2025 23:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736896416; cv=none; b=SWNU69GnKVXiy7FHFOU+AEkuzWSlHARjsYljSKAVf7VJHb9JUXsx0XHk3Wajwy5C4v4RH3w/R7NpRrr8ibYYhun3l2pKU+gqe1MZTbJtO2I3WwfeJcV/wp7ahKuOWYahraHTe5z+IQ3fCodpEnNR+7CHyMs118MD/LUGFb5d0Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736896416; c=relaxed/simple;
	bh=iR8QU+rczGb2qsvf7AIZ656l99fVtsoVlDabbf0pOXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ix1PXQMJPTfVjc/2YRkmv6hMNVxmm6eTQKLa4LLus57zvwZ4UP71rIGomhvrCIR+WiNGIifS8/4bKqMpYK7279pWYcnxY4emWvvyCh49+TdiD7cJhevSI0NEpZDFi3Ig3yL6Hhl6Ad1gIipvhE5CNBmtQ9du4LT5NQy7MK5hXJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZGPqWSLd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZGPqWSLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42964C4CEDD;
	Tue, 14 Jan 2025 23:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736896416;
	bh=iR8QU+rczGb2qsvf7AIZ656l99fVtsoVlDabbf0pOXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZGPqWSLd7il3hPscg0I4wD3+h1pqNiJFz5o6A6zUqqEvKO3wHGQDnwr5HQg4E/lOr
	 6KIglzJyiXAbGrUfO7vZ1/7EPBwtUm+W09PPF8YtbFKVJu5SWYUAQAC5DZmsi4ps0C
	 DAoFNqkBd5Aez5brss4BmUxWcQ1EYP2iza0Za75lSTh6fnY4kj51oeXzxeOe6zYlqj
	 T8zzBHc084HsurtbMANX7LmGuJuXUJmhMZyzKutSdDidDX6GtNJfE4K0upuXA2WCd5
	 UiT+TYCAYbmuujfw+TeCHTthhx9xBjYH9P8YRBax6p1gmI7hB2dk2yPzX7tQOfoilN
	 HTaHND+VxnDiQ==
Date: Tue, 14 Jan 2025 15:13:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Neal Gompa <neal@gompa.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	tech-board@groups.linuxfoundation.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/3] docs: submitting-patches: clarify difference between
 Acked-by and Reviewed-by
Message-ID: <20250114231335.GE2103004@frogsfrogsfrogs>
References: <20250112152946.761150-1-ojeda@kernel.org>
 <20250112152946.761150-3-ojeda@kernel.org>
 <CAEg-Je81VAYecajUjYVJKBJUT+YqKemWsWEoWFgOcF=vtfPRPw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEg-Je81VAYecajUjYVJKBJUT+YqKemWsWEoWFgOcF=vtfPRPw@mail.gmail.com>

On Sun, Jan 12, 2025 at 10:50:32AM -0500, Neal Gompa wrote:
> On Sun, Jan 12, 2025 at 10:30 AM Miguel Ojeda <ojeda@kernel.org> wrote:
> >
> > Newcomers to the kernel need to learn the different tags that are
> > used in commit messages and when to apply them. Acked-by is sometimes
> > misunderstood, since the documentation did not really clarify (up to
> > the previous commit) when it should be used, especially compared to
> > Reviewed-by.
> >
> > The previous commit already clarified who the usual providers of Acked-by
> > tags are, with examples. Thus provide a clarification paragraph for
> > the comparison with Reviewed-by, and give a couple examples reusing the
> > cases given above, in the previous commit.
> >
> > Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> > Acked-by: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > ---
> >  Documentation/process/submitting-patches.rst | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/Documentation/process/submitting-patches.rst b/Documentation/process/submitting-patches.rst
> > index c7a28af235f7..7b0ac7370cb1 100644
> > --- a/Documentation/process/submitting-patches.rst
> > +++ b/Documentation/process/submitting-patches.rst
> > @@ -480,6 +480,12 @@ mergers will sometimes manually convert an acker's "yep, looks good to me"
> >  into an Acked-by: (but note that it is usually better to ask for an
> >  explicit ack).
> >
> > +Acked-by: is also less formal than Reviewed-by:.  For instance, maintainers may
> > +use it to signify that they are OK with a patch landing, but they may not have
> > +reviewed it as thoroughly as if a Reviewed-by: was provided.  Similarly, a key
> > +user may not have carried out a technical review of the patch, yet they may be
> > +satisfied with the general approach, the feature or the user-facing interface.
> > +
> >  Acked-by: does not necessarily indicate acknowledgement of the entire patch.
> >  For example, if a patch affects multiple subsystems and has an Acked-by: from
> >  one subsystem maintainer then this usually indicates acknowledgement of just
> > --
> > 2.48.0
> >
> 
> This doesn't make sense as a distinction. What defines "thoroughly"?
> To be honest, I think you should go the other way and become okay with
> people sending Reviewed-by tags when people have looked over a patch
> and consider it good to land.
> 
> To me, Acked-by mostly makes sense as a tag for people who *won't*
> review the code, not for those who *will*. Blending Acked-by and
> Reviewed-by just creates confusion.

Not a maintainer anymore, but --

I only give out a Reviewed-by: if I can say with a straight face "I read
this code thoroughly and understand it well enough to transform / build
on top of / maintain it if need be." I'd accept one from anyone who I
thought was either really familiar with the codebase or has become their
manager's stuc^Wappointee for maintenance.

Compare that to an Acked-by, which means "I scanned this while
doomscrolling fsdevel over coffee and none of it is now in the
keyboard", which is a much lower standard.  I'd accept one from pretty
much anyone, because that just means you're in the email blasting radius
if/when things go wrong.  Even moreso if the person qualifies their ack
with a "# XXXX" to contextualize their acknowledgement.

Concretely, I might ignore an RVB from Sam Naghshineh if he showed up
claiming to be an expert on some ext4 thing, but I wouldn't drop an Ack
from Neal because then who do I pull in when boffins demonstrate that
fallocate implements a Turing machine and hence in need of a libvirt
port?

I would, however, explicitly point out that maintainers can drop or
ignore tags as they please; and that doing so may discourage future
participation by people who feel ignored.

--D

> 
> 
> -- 
> 真実はいつも一つ！/ Always, there's only one truth!
