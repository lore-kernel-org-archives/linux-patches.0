Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CAF171A0
	for <patches@lists.linux.dev>; Thu, 27 Jul 2023 14:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55ECFC433C8;
	Thu, 27 Jul 2023 14:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690466788;
	bh=sFJyPGV/EaWMtxNW18DM0zyyyTFZ8AoL3UCavqRq6lg=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=OUJoXbOYqPStZpCTeKFcsNKUp9Oyvui/fH6x4IFpzsIfFDjzavv4J7lzbHqOi+ic0
	 OHWa8HvpToB26wjuBfP5NG+1swh7IrPikLmqnctlp8Kc8f6a6Ik4BDU9VP10cTXEMZ
	 NRV59Hi8Dv7oH3mL/YHX9AVIFvObDRSBrpLOlP5qumBo7HjJz1XMY8W9VnSQ5/ShSN
	 mg20WM9nTFpZyPwo7NKj6HC2SzZhiDmrJP/e7vb5hNHShzp8te1ypwRY9I0uyE8pGc
	 QVUOAUKCulKohiBgnTnOjE5b5tbZCTg+x+SpEBvrNEcqzfd9Rwr05MjWCokOSbKhS1
	 C7xNEIIifghUQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id D9A5CCE0AD3; Thu, 27 Jul 2023 07:06:27 -0700 (PDT)
Date: Thu, 27 Jul 2023 07:06:27 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Pavel Machek <pavel@denx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, rcu@vger.kernel.org
Subject: Re: [PATCH 6.4 000/227] 6.4.7-rc1 review
Message-ID: <0751f5a8-2727-4a08-8bb8-50bbd4244c9c@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <ZMJWet00+9yIl/9c@duo.ucw.cz>
 <78722041-D1F7-45FA-BA1C-41B92209BA6C@joelfernandes.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <78722041-D1F7-45FA-BA1C-41B92209BA6C@joelfernandes.org>

On Thu, Jul 27, 2023 at 09:26:52AM -0400, Joel Fernandes wrote:
> 
> 
> > On Jul 27, 2023, at 7:35 AM, Pavel Machek <pavel@denx.de> wrote:
> > 
> > ﻿Hi!
> > 
> >>> This is the start of the stable review cycle for the 6.4.7 release.
> >>> There are 227 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, please
> >>> let me know.
> >>> 
> >>> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> >>> Anything received after that time might be too late.
> >>> 
> >>> The whole patch series can be found in one patch at:
> >>>    https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.7-rc1.gz
> >>> or in the git tree and branch at:
> >>>    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> >>> and the diffstat can be found below.
> >> 
> >> I saw this when running rcutorture, this one happened in the TREE04
> >> configuration. This is likely due to the stuttering issues we are discussing
> >> in the other thread. Anyway I am just making a note here while I am
> >> continuing to look into it.
> > 
> > So is the stuttering new in 6.4.7?
> 
> No it is an old feature in RCU torture tests. But is dependent on timing. Something
> changed in recent kernels that is making the issues with it more likely. Its hard to bisect as failure sometimes takes hours.
> 
> > 
> >> Other than that, all tests pass:
> >> Tested-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > 
> > ...or you still believe 6.4.7 is okay to release?
> 
> As such, it should be Ok. However naturally I am not happy that the RCU testing
> is intermittently failing. These issues have been seen in last several 6.4 stable releases
> so since those were released, maybe this one can be too?
> The fix for stuttering is currently being reviewed.

Or, to look at it another way, the stuttering fix is specific to torture
testing.  Would we really want to hold up a -stable release only because
rcutorture occasionally gives a false-positive failure on certain types
of systems?

							Thanx, Paul

> Thanks, 
> 
> - Joel 
> 
> 
> > 
> > Best regards,
> >                                Pavel
> > -- 
> > DENX Software Engineering GmbH,        Managing Director: Erika Unter
> > HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
