Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A861C5D63;
	Mon, 13 Jan 2025 15:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736782609; cv=none; b=F9AHLDwXGJZZcHgZb3pxmqahk2z803ADt6oBMpo2BAr1DRQ90tcqIac82dUnBlqJfEw67wDJXoY3vROlP2mMC/uTOISyGU0GD5f5I6/eYfZkM9Q3ESWwOlX+yJTv4td+MpngiWgIkPl/PomwX5My59ZEsrSylBY/NfDf8t+CsHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736782609; c=relaxed/simple;
	bh=aTaFsOVTUvhaciB6oEEHAAJtRFXGI0RHnENI65tSv+o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dK9mY/bxJrCL03vkukiuj/n8kksVnfTctxdxys+0TymicLHys2bxFrC1SvqHuP9FxNMHU0DCZvg3ZHLDVKLVJ58qYvTqxv2VMV7zzYgiwVIJYxiDKfsB/Q7hALmJzpGAcSXgtS/LFERmKReyMYuHXwijHBaisNX9ycgWT6fdJnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2EAC4CEE4;
	Mon, 13 Jan 2025 15:36:46 +0000 (UTC)
Date: Mon, 13 Jan 2025 10:36:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Neal Gompa <neal@gompa.dev>, Miguel Ojeda <ojeda@kernel.org>, Jonathan
 Corbet <corbet@lwn.net>, workflows@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Sami Tolvanen <samitolvanen@google.com>, Masahiro
 Yamada <masahiroy@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
 tech-board@groups.linuxfoundation.org, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>,
 Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 3/3] docs: submitting-patches: clarify that signers may
 use their discretion on tags
Message-ID: <20250113103645.1f23b3b7@gandalf.local.home>
In-Reply-To: <20250113142227.GE1514771@mit.edu>
References: <20250112152946.761150-1-ojeda@kernel.org>
	<20250112152946.761150-4-ojeda@kernel.org>
	<CAEg-Je-Knta8BtYSbZgX8cZ9Gd-2cpDAUE83dCJZbTbqmSfcKA@mail.gmail.com>
	<20250113142227.GE1514771@mit.edu>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 13 Jan 2025 09:22:27 -0500
"Theodore Ts'o" <tytso@mit.edu> wrote:

> On Sun, Jan 12, 2025 at 10:47:02AM -0500, Neal Gompa wrote:
> > 
> > A tag must not be dropped without the tag submitter's authorization.
> > Otherwise it doesn't matter what you write here, the submitter *will*
> > feel unwelcome.
> > 
> > It is rude and discouraging to do so without their acceptance of doing so.  
> 
> In some cases, if the reviewer hasn't taken the less than subtle hints
> that their reviews are unwelcome and are discouraging patch
> submitters, as far as I'm concerned, if they feel unwelcome, that is a
> *feature* and not a *bug*.
> 
> I'm not saying that is the case for you, but there are reviewers that
> add negative value in the ecosystem.  The assumption that all tag
> submitters are people that need to feel welcome might mostly true, but
> it is not always the case.  This is why it MUST ultimately be up to
> the maintainer.  I do not want the rules that force me to reward
> people that should be discouraged, not encouraged.

I try to add all tags that are meaningful, but a lot of times I already
pulled in the patch, and there's been several times tags came in after I
did a pull request to Linus! (for fixes patches). Once I do a pull request to
Linus, only Linus can have me change that commit (if there's an issue with
it).

For linux-next, I will add tags, even when Linus told me to avoid doing so.

That said, I have ignored several "Reviewed-by" tags when they appear
random. If you send a "Reviewed-by" without a single comment, and I don't
know you, it is meaningless to me, and I will not add it.

Now for people I don't know, if they came in and found an issue with a
patch which requires another revision, I will most definitely add their
Reviewed-by for the next version (if they send one), and will likely take
Reviewed-by tags from them in the future without comments (up to a point).

There's also been several cases that someone sent a Reviewed-by tag and
when I take a look at the patch I find an obvious bug. That will cause me
to ignore that reviewer in the future. Adding that tag comes with
responsibilities. As I mentioned in another thread, if I give a Reviewed-by
and a bug happens on that commit, I will spend time to help fix it.

-- Steve
