Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C725A7F;
	Mon,  5 Feb 2024 01:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707096564; cv=none; b=qHiuXUsIyvNYx1RSZqOGaHoOBwGlN8sQm/KHckSKEoywzCLKmVwyCZL7oHRyg6HNLvREp1pH/THDyfZiHIGTYqPP1UY6gFtMjOz4CwYwkZldtRbeqtm90zfiJGHMMoTVQJbowJ9HOCZT9/JvEHAC0/lCwxTFet2n4xelB6IOVpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707096564; c=relaxed/simple;
	bh=IboaFFEnLezIgEoUZ9g56kPSleqX5Yyo+MKySpAAuAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WJYXvuz/HFgyDqFoYEeja1F7g/43mSKPNYqVW1jsRVtXRJ+WbPp6oY3jJBdqcBhCSyDslL5rbhaQlH8qCXBuTg0BaFiQAwK8owtzWC/Iq1ndX48r5n2JENeBp2EomMRvhsvPbPxHjmOCBmcjjsqwlh2EqPBH/4erdpLsBuFhy7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ea47tLCh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ea47tLCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545D5C433C7;
	Mon,  5 Feb 2024 01:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707096564;
	bh=IboaFFEnLezIgEoUZ9g56kPSleqX5Yyo+MKySpAAuAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ea47tLChgkqLBZ8k9TVRcxfALSlSX5TUx9tXfQueiKVS9ANgl41uhzaTZb9ne4rkD
	 2I9BCkCHkzdapD+FSCngV1V3eik9IjiqsVjIKhWq4c6LL4LNBPgsH7lVT9V9ftzMqM
	 AkddvSCXUNV0O14obgbzAFK0qqB9yA7PzVSAr5Xc=
Date: Sun, 4 Feb 2024 17:29:23 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Vegard Nossum <vegard.nossum@oracle.com>,
	Justin Forbes <jforbes@fedoraproject.org>,
	Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 6.6 003/331] docs: kernel_feat.py: fix potential command
 injection
Message-ID: <2024020402-scotch-upchuck-9e11@gregkh>
References: <ZbkfGst991YHqJHK@fedora64.linuxtx.org>
 <87h6iudc7j.fsf@meer.lwn.net>
 <CAFbkSA2tft--ejgJ58o3G-OxNqnm-C6fK4-kXThsN92NYF8V0A@mail.gmail.com>
 <2024020151-purchase-swerve-a3b3@gregkh>
 <CAFbkSA25o88DjaWHc3GRk5vkvANnpi-NJ61XJudz4=ARTyrhtw@mail.gmail.com>
 <CAFbkSA3M74kvF+v_URm593xSnJTVzeKmy2K6dw0WQYw7BDdwmg@mail.gmail.com>
 <CAFbkSA3vHDn-Pk9fB6PbWeniGHH6W3bo=jQ9utE9xh88S8bzxA@mail.gmail.com>
 <1a160e5f-d5ce-4711-b683-808ab87b289b@oracle.com>
 <Zb_DwdZ3PUr1VbBg@eldamar.lan>
 <Zb_0NEeCqok8icwz@eldamar.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zb_0NEeCqok8icwz@eldamar.lan>

On Sun, Feb 04, 2024 at 09:31:48PM +0100, Salvatore Bonaccorso wrote:
> On Sun, Feb 04, 2024 at 06:05:05PM +0100, Salvatore Bonaccorso wrote:
> > Hi,
> > 
> > On Thu, Feb 01, 2024 at 05:34:25PM +0100, Vegard Nossum wrote:
> > > 
> > > On 01/02/2024 16:07, Justin Forbes wrote:
> > > > On Thu, Feb 1, 2024 at 8:58 AM Justin Forbes <jforbes@fedoraproject.org> wrote:
> > > > > On Thu, Feb 1, 2024 at 8:41 AM Justin Forbes <jforbes@fedoraproject.org> wrote:
> > > > > > On Thu, Feb 1, 2024 at 8:25 AM Greg Kroah-Hartman
> > > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > > > On Thu, Feb 01, 2024 at 06:43:46AM -0600, Justin Forbes wrote:
> > > > > > > > On Tue, Jan 30, 2024 at 10:21 AM Jonathan Corbet <corbet@lwn.net> wrote:
> > > > > > > > > Justin Forbes <jforbes@fedoraproject.org> writes:
> > > > > > > > > > On Mon, Jan 29, 2024 at 09:01:07AM -0800, Greg Kroah-Hartman wrote:
> > > > > > > > > > > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > > > > > > > > > > 
> > > > > > > > > > > ------------------
> > > > > > > > > > > 
> > > > > > > > > > > From: Vegard Nossum <vegard.nossum@oracle.com>
> > > > > > > > > > > 
> > > > > > > > > > > [ Upstream commit c48a7c44a1d02516309015b6134c9bb982e17008 ]
> > > > > > > > > > > 
> > > > > > > > > > > The kernel-feat directive passes its argument straight to the shell.
> > > > > > > > > > > This is unfortunate and unnecessary.
> > > 
> > > [...]
> > > 
> > > > > > > > > > This patch seems to be missing something. In 6.6.15-rc1 I get a doc
> > > > > > > > > > build failure with:
> > > > > > > > > > 
> > > > > > > > > > /builddir/build/BUILD/kernel-6.6.14-332-g1ff49073b88b/linux-6.6.15-0.rc1.1ff49073b88b.200.fc39.noarch/Documentation/sphinx/kerneldoc.py:133: SyntaxWarning: invalid escape sequence '\.'
> > > > > > > > > >    line_regex = re.compile("^\.\. LINENO ([0-9]+)$")
> > > > > > > > > 
> > > > > > > > > Ah ... you're missing 86a0adc029d3 (Documentation/sphinx: fix Python
> > > > > > > > > string escapes).  That is not a problem with this patch, though; I would
> > > > > > > > > expect you to get the same error (with Python 3.12) without.
> > > > > > > > 
> > > > > > > > Well, it appears that 6.6.15 shipped anyway, with this patch included,
> > > > > > > > but not with 86a0adc029d3.  If anyone else builds docs, this thread
> > > > > > > > should at least show them the fix.  Perhaps we can get the missing
> > > > > > > > patch into 6.6.16?
> > > > > > > 
> > > > > > > Sure, but again, that should be independent of this change, right?
> > > > > > 
> > > > > > I am not sure I would say independent. This particular change causes
> > > > > > docs to fail the build as I mentioned during rc1.  There were no
> > > > > > issues building 6.6.14 or previous releases, and no problem building
> > > > > > 6.7.3.
> > > > > 
> > > > > I can confirm that adding this patch to 6.6.15 makes docs build again.
> > > > 
> > > > I lied, it just fails slightly differently. Some of the noise is gone,
> > > > but we still have:
> > > > Sphinx parallel build error:
> > > > UnboundLocalError: cannot access local variable 'fname' where it is
> > > > not associated with a value
> > > > make[2]: *** [Documentation/Makefile:102: htmldocs] Error 2
> > > > make[1]: *** [/builddir/build/BUILD/kernel-6.6.15/linux-6.6.15-200.fc39.noarch/Makefile:1715:
> > > > htmldocs] Error 2
> > > 
> > > The old version of the script unconditionally assigned a value to the
> > > local variable 'fname' (not a value that makes sense to me, since it's
> > > literally assigning the whole command, not just a filename, but that's a
> > > separate issue), and I removed that so it's only conditionally assigned.
> > > This is almost certainly a bug in my patch.
> > > 
> > > I'm guessing maybe a different patch between 6.6 and current mainline is
> > > causing 'fname' to always get assigned for the newer versions and thus
> > > make the run succeed, in spite of the bug.
> > > 
> > > Something like the patch below (completely untested) should restore the
> > > previous behaviour, but I'm not convinced it's correct.
> > > 
> > > 
> > > Vegard
> > > 
> > > diff --git a/Documentation/sphinx/kernel_feat.py
> > > b/Documentation/sphinx/kernel_feat.py
> > > index b9df61eb4501..15713be8b657 100644
> > > --- a/Documentation/sphinx/kernel_feat.py
> > > +++ b/Documentation/sphinx/kernel_feat.py
> > > @@ -93,6 +93,8 @@ class KernelFeat(Directive):
> > >          if len(self.arguments) > 1:
> > >              args.extend(['--arch', self.arguments[1]])
> > > 
> > > +        fname = ' '.join(args)
> > > +
> > >          lines = subprocess.check_output(args,
> > > cwd=os.path.dirname(doc.current_source)).decode('utf-8')
> > > 
> > >          line_regex = re.compile(r"^\.\. FILE (\S+)$")
> > 
> > We have as well a documention build problem in Debian, cf.
> > https://buildd.debian.org/status/fetch.php?pkg=linux&arch=all&ver=6.6.15-1&stamp=1707050360&raw=0
> > though not yet using python 3.12 as default.
> > 
> > Your above change seems to workaround the issue in fact, but need to
> > do a full build yet.
> 
> For Debian I'm temporarily reverting from the 6.6.15 upload:
> 
> e961f8c6966a ("docs: kernel_feat.py: fix potential command injection")
> 
> This is not the best solution, but unbreaks several other builds.
> 
> The alternative would be to apply Vegard's workaround or the proper
> solution for that.

What is the "proper" solution here?  Does 6.8-rc3 work?  What are we
missing to be backported here?

thanks,

greg k-h
