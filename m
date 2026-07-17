Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39FB38B148;
	Fri, 17 Jul 2026 07:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784273127; cv=none; b=OfTV+V2hOTtZ8kXo9cWP9ubEoTekBGJnWylhBJGc5Nd19zDUJgzWMMe1O/9dIoB6badpLXC9k8ujadCgXFmWA5dNJYZFiW8f+d7lqdquUViOgHKkzoGuYhT5t0ZSdx9KQngw59pXFuu0lEoFTKLAiGGkAfQh3xolbaS2f2oF4Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784273127; c=relaxed/simple;
	bh=cRvfQvKB0rOaiI0oeMy+a5QpBNyItzpIifWoFTC9EuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jjIFNt7ez/NsQ/jclH52NrYq87dPS+WwOS+8NOqdA8c5xqhGQQ8LwhGvhjOy9EcWkWinHgHF9jiDFAUDGZ3zH8DGWQp5wnkGlaGT1mVkPSWaDM/2ilwq/94OuoYiC/FbAuiUJFabXN8IFKqoeffM88OV58RJEPbOPa/7RCKyzm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EceAxlpH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EceAxlpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A3B1F00A3A;
	Fri, 17 Jul 2026 07:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784273123;
	bh=3JUe8o0h6z34R87YsvDzVRbVqxIA6z3v50uSejThdHI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EceAxlpHC0McvhEvrQAx6ovzdTpG7tDgbdVnBudZEHgAdcH2Ne1LzzSc0ILuKrKxB
	 jnoJBcZDVaoW5lygCLX4kremAKkMxyfWN2MsV1HVn8HWL2d2Uh2gdiY3TdKG+PwfhS
	 xqE58OpMFH6UIIJwtCxa7OdOH7sYlW0ptQJbbnfY=
Date: Fri, 17 Jul 2026 09:25:16 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 7.1 021/518] rust: Kbuild: set frame-pointer llvm module
 flag for CONFIG_FRAME_POINTER
Message-ID: <2026071749-craving-unplanned-1c53@gregkh>
References: <20260716133047.772246337@linuxfoundation.org>
 <20260716133048.240591252@linuxfoundation.org>
 <CANiq72nR1X9Mb614koFqALMJLf39K6wXsUcF1WegM26UNg99Aw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72nR1X9Mb614koFqALMJLf39K6wXsUcF1WegM26UNg99Aw@mail.gmail.com>

On Thu, Jul 16, 2026 at 05:58:42PM +0200, Miguel Ojeda wrote:
> On Thu, Jul 16, 2026 at 3:36 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > [ - Adjusted Cc: stable@ as discussed.
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> >   - Added comment with link to the PR, similar to what we did in commit
> >     ac35b5580ace ("rust: arm64: set uwtable llvm module flag for
> >     CONFIG_UNWIND_TABLES").
> >
> >     - Miguel ]
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> 
> Something strange happened here... :)
> 
> It seems your SoB got interleaved with my [ ] comment.

Yeah, my tool found the first blank line after the s-o-b area and added
it there.  Thanks, I've fixed it up now on all of these.

greg k-h
