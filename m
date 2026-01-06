Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1046347BCA
	for <patches@lists.linux.dev>; Tue,  6 Jan 2026 17:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719872; cv=none; b=SQDpmqD+Os2vLsPGAKEydLuqf1gABO0zQFtFgxz/dOEHQ2SfXvSUVOZ4eq3Xgqr7gk66SgUdn95Cp8Z/7o6iPqRSUfxzj8cOzZ9Noj9O97weCatWHTU8Mzk3/aIY4G6an2ZOaZGzwNAnQIgrU/R1LFfGtgNlsDbKlTz4WBm61Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719872; c=relaxed/simple;
	bh=YTJB/i+vPC02qNPFBRqOwxmRLc/0LEElGkrjh0ebrKU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Nq1KlZelvU6HUeuMNZMizfJCZ8SfVtQPQcW1NAnT0f8r4+86ztABCNjhUInQFt4yXpa5Y7fckC0nQrdBRKTtLxvKl35LGxM3LFcfrlkSDoXDJ9bR2J3SvVCZZcbENnKWfPPuUHkx4v+QQUAMwJnK2KmiAFKO0AHK23194AX5Ldc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 61E2592009C; Tue,  6 Jan 2026 18:17:48 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 5C13292009B;
	Tue,  6 Jan 2026 17:17:48 +0000 (GMT)
Date: Tue, 6 Jan 2026 17:17:48 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Magnus Lindholm <linmag7@gmail.com>
cc: Askar Safin <safinaskar@gmail.com>, 
    Richard Henderson <richard.henderson@linaro.org>, 
    Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org, 
    kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, 
    patches@lists.linux.dev
Subject: Re: [PATCH 1/1] alpha: trivial: remove ^L chars
In-Reply-To: <CA+=Fv5Rw3vJGLsEyuKOBMyZTcQd=ayV5jT6bhWNn=uzXKsw13w@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2601061656070.45251@angie.orcam.me.uk>
References: <20251228063440.2623595-1-safinaskar@gmail.com> <20251228063440.2623595-2-safinaskar@gmail.com> <CA+=Fv5Ra7fFTd2wA77iM_6X7NooApfoMJX5z1j60cXex_uxm7w@mail.gmail.com> <alpine.DEB.2.21.2601061310110.45251@angie.orcam.me.uk>
 <CA+=Fv5Rw3vJGLsEyuKOBMyZTcQd=ayV5jT6bhWNn=uzXKsw13w@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 6 Jan 2026, Magnus Lindholm wrote:

> >  As a matter of interest, why would the presence of ^L characters cause
> > any issues?  That is just another instance of white space and it has been
> > commonly used across some source code to separate functional parts, e.g.
> > in the GNU toolchain.  It can be ignored unless you actually send the code
> > to a printer (which I suppose hardly anyone does nowadays).
> 
> I guess you're right, at this point it's mostly aesthetics. ^L is just
> whitespace and the compiler ignores it, likely a relic from the old
> days. Some editors display it a bit oddly, and most of the kernel seems
> to have pruned these over time, but a few still linger in arch/alpha,
> which fits the age and heritage there.

 FWIW, ^L is printed just as ^L here (VIM), but I can imagine a GUI text 
editor might show "--- page break ---" or suchlike in a graphical form 
instead.  If it does cause odd behaviour in an editor, then it should be 
filed as a bug in said editor IMO; it's a standard ASCII character after 
all and a valid preprocessing token separator in ISO C (IOW the compiler 
does not ignore it, but treats according to the standard).

 As to the change proposed itself I have no opinion either way; I agree 
that the commit description leaves something to desire.

  Maciej
