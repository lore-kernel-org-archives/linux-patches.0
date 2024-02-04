Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBAC28688;
	Sun,  4 Feb 2024 20:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707078727; cv=none; b=kow6sqyn1yIHXqFq6BiiFyiNgO6qXwrHjDKKFHHsXAa0EUEkunNTcwiJ/x0lNXNifwhGN5//FOpFmurtOY6OkdB6BXs1vRFdPAxpIvg28Y4zEEC6t7SnjtKWVptSmHKggpVhWkCwdTgxSyli+9EcgYQEUEKEIliglYRHgin8S54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707078727; c=relaxed/simple;
	bh=dxhoQ6gha6jprWyOLA1prEutTcOkboFoDMbU9dgUZ/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IRCwHUXuEvKkseNhObN1Y1hv0XtY5RQEb6WcdkiiBkZn4zOh5iM0r9tSBnTk+3S22Yu2ahA4wb4EmPhC1XR9Hr11K+IP28stwM5A/eZ0np6MkipMVtQuBauWZ8sBdTaLps+ItpJ1Ru8usPrqXILwdO2Wd2YUaDNnjOjuqR0Yi3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=TISutnB0; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="TISutnB0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=PDoQmKoIo+4pyBX8IxmJjNLKSWVkWqDmvzeuM7hEdyg=; b=TISutnB0Zld8cjXp773EH2WRMx
	8qqEFllTEiWimZnMosmELTaueeV3cm69r+oj53++rSG3TwkQTxMTu6EoixFE6fI/ZEWdcJdzdzzn0
	Fpq3UKrPSSXhIvzNx55yljsnzq+Ugc2WX8NZI5k/MmsE5cLWkrpOSUoCwyEvEOjmtKiLUpjBokc5G
	xhtnKBxsBBzbwNQptvmrZrhjmVOKhT4/tN9PaHpxbqaw9gsIhO0df3+5FgNZcT1YOxQiwB/30avKc
	SGcyJeoR4nGKcVk1gnggBBmhGGFOFFUq8/61c7CbeoMDC88/JwaQ0mzJIEXFrq7mn4o0ylvgGMFPy
	amz06Y6g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <carnil@debian.org>)
	id 1rWj9a-00Aqkl-D4; Sun, 04 Feb 2024 20:31:50 +0000
Received: by eldamar.lan (Postfix, from userid 1000)
	id A2052BE2DE0; Sun,  4 Feb 2024 21:31:48 +0100 (CET)
Date: Sun, 4 Feb 2024 21:31:48 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Justin Forbes <jforbes@fedoraproject.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 6.6 003/331] docs: kernel_feat.py: fix potential command
 injection
Message-ID: <Zb_0NEeCqok8icwz@eldamar.lan>
References: <20240129170015.067909940@linuxfoundation.org>
 <ZbkfGst991YHqJHK@fedora64.linuxtx.org>
 <87h6iudc7j.fsf@meer.lwn.net>
 <CAFbkSA2tft--ejgJ58o3G-OxNqnm-C6fK4-kXThsN92NYF8V0A@mail.gmail.com>
 <2024020151-purchase-swerve-a3b3@gregkh>
 <CAFbkSA25o88DjaWHc3GRk5vkvANnpi-NJ61XJudz4=ARTyrhtw@mail.gmail.com>
 <CAFbkSA3M74kvF+v_URm593xSnJTVzeKmy2K6dw0WQYw7BDdwmg@mail.gmail.com>
 <CAFbkSA3vHDn-Pk9fB6PbWeniGHH6W3bo=jQ9utE9xh88S8bzxA@mail.gmail.com>
 <1a160e5f-d5ce-4711-b683-808ab87b289b@oracle.com>
 <Zb_DwdZ3PUr1VbBg@eldamar.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zb_DwdZ3PUr1VbBg@eldamar.lan>
X-Debian-User: carnil

On Sun, Feb 04, 2024 at 06:05:05PM +0100, Salvatore Bonaccorso wrote:
> Hi,
> 
> On Thu, Feb 01, 2024 at 05:34:25PM +0100, Vegard Nossum wrote:
> > 
> > On 01/02/2024 16:07, Justin Forbes wrote:
> > > On Thu, Feb 1, 2024 at 8:58 AM Justin Forbes <jforbes@fedoraproject.org> wrote:
> > > > On Thu, Feb 1, 2024 at 8:41 AM Justin Forbes <jforbes@fedoraproject.org> wrote:
> > > > > On Thu, Feb 1, 2024 at 8:25 AM Greg Kroah-Hartman
> > > > > <gregkh@linuxfoundation.org> wrote:
> > > > > > On Thu, Feb 01, 2024 at 06:43:46AM -0600, Justin Forbes wrote:
> > > > > > > On Tue, Jan 30, 2024 at 10:21 AM Jonathan Corbet <corbet@lwn.net> wrote:
> > > > > > > > Justin Forbes <jforbes@fedoraproject.org> writes:
> > > > > > > > > On Mon, Jan 29, 2024 at 09:01:07AM -0800, Greg Kroah-Hartman wrote:
> > > > > > > > > > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > > > > > > > > > 
> > > > > > > > > > ------------------
> > > > > > > > > > 
> > > > > > > > > > From: Vegard Nossum <vegard.nossum@oracle.com>
> > > > > > > > > > 
> > > > > > > > > > [ Upstream commit c48a7c44a1d02516309015b6134c9bb982e17008 ]
> > > > > > > > > > 
> > > > > > > > > > The kernel-feat directive passes its argument straight to the shell.
> > > > > > > > > > This is unfortunate and unnecessary.
> > 
> > [...]
> > 
> > > > > > > > > This patch seems to be missing something. In 6.6.15-rc1 I get a doc
> > > > > > > > > build failure with:
> > > > > > > > > 
> > > > > > > > > /builddir/build/BUILD/kernel-6.6.14-332-g1ff49073b88b/linux-6.6.15-0.rc1.1ff49073b88b.200.fc39.noarch/Documentation/sphinx/kerneldoc.py:133: SyntaxWarning: invalid escape sequence '\.'
> > > > > > > > >    line_regex = re.compile("^\.\. LINENO ([0-9]+)$")
> > > > > > > > 
> > > > > > > > Ah ... you're missing 86a0adc029d3 (Documentation/sphinx: fix Python
> > > > > > > > string escapes).  That is not a problem with this patch, though; I would
> > > > > > > > expect you to get the same error (with Python 3.12) without.
> > > > > > > 
> > > > > > > Well, it appears that 6.6.15 shipped anyway, with this patch included,
> > > > > > > but not with 86a0adc029d3.  If anyone else builds docs, this thread
> > > > > > > should at least show them the fix.  Perhaps we can get the missing
> > > > > > > patch into 6.6.16?
> > > > > > 
> > > > > > Sure, but again, that should be independent of this change, right?
> > > > > 
> > > > > I am not sure I would say independent. This particular change causes
> > > > > docs to fail the build as I mentioned during rc1.  There were no
> > > > > issues building 6.6.14 or previous releases, and no problem building
> > > > > 6.7.3.
> > > > 
> > > > I can confirm that adding this patch to 6.6.15 makes docs build again.
> > > 
> > > I lied, it just fails slightly differently. Some of the noise is gone,
> > > but we still have:
> > > Sphinx parallel build error:
> > > UnboundLocalError: cannot access local variable 'fname' where it is
> > > not associated with a value
> > > make[2]: *** [Documentation/Makefile:102: htmldocs] Error 2
> > > make[1]: *** [/builddir/build/BUILD/kernel-6.6.15/linux-6.6.15-200.fc39.noarch/Makefile:1715:
> > > htmldocs] Error 2
> > 
> > The old version of the script unconditionally assigned a value to the
> > local variable 'fname' (not a value that makes sense to me, since it's
> > literally assigning the whole command, not just a filename, but that's a
> > separate issue), and I removed that so it's only conditionally assigned.
> > This is almost certainly a bug in my patch.
> > 
> > I'm guessing maybe a different patch between 6.6 and current mainline is
> > causing 'fname' to always get assigned for the newer versions and thus
> > make the run succeed, in spite of the bug.
> > 
> > Something like the patch below (completely untested) should restore the
> > previous behaviour, but I'm not convinced it's correct.
> > 
> > 
> > Vegard
> > 
> > diff --git a/Documentation/sphinx/kernel_feat.py
> > b/Documentation/sphinx/kernel_feat.py
> > index b9df61eb4501..15713be8b657 100644
> > --- a/Documentation/sphinx/kernel_feat.py
> > +++ b/Documentation/sphinx/kernel_feat.py
> > @@ -93,6 +93,8 @@ class KernelFeat(Directive):
> >          if len(self.arguments) > 1:
> >              args.extend(['--arch', self.arguments[1]])
> > 
> > +        fname = ' '.join(args)
> > +
> >          lines = subprocess.check_output(args,
> > cwd=os.path.dirname(doc.current_source)).decode('utf-8')
> > 
> >          line_regex = re.compile(r"^\.\. FILE (\S+)$")
> 
> We have as well a documention build problem in Debian, cf.
> https://buildd.debian.org/status/fetch.php?pkg=linux&arch=all&ver=6.6.15-1&stamp=1707050360&raw=0
> though not yet using python 3.12 as default.
> 
> Your above change seems to workaround the issue in fact, but need to
> do a full build yet.

For Debian I'm temporarily reverting from the 6.6.15 upload:

e961f8c6966a ("docs: kernel_feat.py: fix potential command injection")

This is not the best solution, but unbreaks several other builds.

The alternative would be to apply Vegard's workaround or the proper
solution for that.

Regards,
Salvatore
