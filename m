Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AFAD34D38F
	for <patches@lists.linux.dev>; Sun, 11 Jan 2026 17:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768154343; cv=none; b=ICVhJCy+5hnUggTMcXw4BUi+c0Jwgl/tD3cqh1MtTldQyPu5hMgrDoiAaZ+LXPqaVPDykaTr3ylllhMgLR2wM+mYz57Uu0+CY+jnLXtjMlN8QKaIMqrI3OoOQovNmSID+E/ihCkin8i/1hiLZj/MBwDoGNFoxvYy5ezeK5Iy/Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768154343; c=relaxed/simple;
	bh=+J/nRSm2XyRHF4OmLhAPR45Cdfa0FEIlpVyqCrCHSIg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=g8iBqtTtT+QbTwitJ9+ed/IoCrXGHB3fyeSp8DXHl6vpBxDEAoMQRtz8bt97niTtBQYqaH2YPIPl8qWoJ6taCCaoKtfY8ddU7D9uqgkS8OYMIOa+XUbq7iMIUDkyT0OPGV+IPRHVX5cm1uKw+1/HcLoxtxb2SkfSA/fsUHM/ioM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 7D1F792009C; Sun, 11 Jan 2026 18:58:53 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 793EE92009B;
	Sun, 11 Jan 2026 17:58:53 +0000 (GMT)
Date: Sun, 11 Jan 2026 17:58:53 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Askar Safin <safinaskar@gmail.com>
cc: kernel-janitors@vger.kernel.org, linmag7@gmail.com, 
    linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, 
    mattst88@gmail.com, patches@lists.linux.dev, richard.henderson@linaro.org
Subject: Re: [PATCH 1/1] alpha: trivial: remove ^L chars
In-Reply-To: <20260111113505.2146705-1-safinaskar@gmail.com>
Message-ID: <alpine.DEB.2.21.2601111743490.30566@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2601061310110.45251@angie.orcam.me.uk> <20260111113505.2146705-1-safinaskar@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Sun, 11 Jan 2026, Askar Safin wrote:

> >  As a matter of interest, why would the presence of ^L characters cause 
> > any issues?  That is just another instance of white space and it has been 
> 
> I have shell script, which allows me to remove given config (for example,
> CONFIG_NET) from whole Linux source tree. To do this, this script parses
> .c files, Kconfig files and makefiles. So, I want them to be as predictable
> and easy-to-parse as possible.

 What prevents your shell script from interpreting ^L as yet another 
white-space character?  I don't think any limitation of the tool you've 
chosen is by itself a good justification to change the work the tool is 
used on.  Fix your tool or use another instead, i.e. match your tools to 
the work and not the other way round.

> P. S. I don't see your emails in my gmail inbox (not even in spam folder).

 Correct, GMail rejects e-mail sent from here.  It has for a while now.  

  Maciej
