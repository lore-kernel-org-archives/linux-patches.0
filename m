Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD078332909;
	Fri, 21 Nov 2025 18:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763748054; cv=none; b=E91BAbA50MziDePBcteuQyS9oWk9c8+1ODAkpH+8IOf9pMPpbOsAe8q9q1gCuIaJlbhOkK6ep4vW87JRCXRnOa4shupkg2+/sX+V5lZ0gGz87mzZmRunUJl+a8WaqkqFvjXqEWSMkGsAgxGvCQne7Vue4JTpgZRo6LyOFgd1ask=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763748054; c=relaxed/simple;
	bh=CZHQnN3iOCJ6aN0E5u5hK1R02monCvhynklOLawB+FQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCZ9cVXSCjG6RxgjOpOJXz80Z6ty0GQQbcH1HokIwz5B1FRLA1l9xVex4cPGobMy9f+6CJqFnqrHKWaIE1SQIlD51P4dVG6IL9ySDy1y5Rl33EXNLTjM/H2fYw2+Xw1U6wOFEIbTkdtz7TcDP+9tiYK63/y+3YGGCHFGm9nE8Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aERrClO1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aERrClO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBCAC16AAE;
	Fri, 21 Nov 2025 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763748054;
	bh=CZHQnN3iOCJ6aN0E5u5hK1R02monCvhynklOLawB+FQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aERrClO1nZEVOGDNM/yjtuedLrKj0ht6vKFy4SL08A+VU6hRFYCXisY6O9OCKFS3X
	 yivuNVF4+31DClBs72OZ/2lXc+vWiCyu0FyQzPoVNW8CAcDXLrD6aETyy95B2RT/7+
	 Wdb08ip1N1eB/ZL2PVOOGyzDlWE7TYZ3LY2K/nDvNl8tz2dDJ/8O74uA/Fz2lb6xW+
	 NyQ/C8+SfHBs0rt2p/4A+H8sLB976pGv58enbOwk3tPEb9sHkhv7gvt6+Ps4Y2lRos
	 W6WHnwdnTh27h7l51afVwft+9ma/J6xNDiklN2Lg0aS1r4Txhg39CDqisP2SpmGo53
	 vc7hMKLLA4/rQ==
Date: Fri, 21 Nov 2025 10:00:53 -0800
From: Kees Cook <kees@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Russell King - ARM Linux <linux@armlinux.org.uk>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Subject: Re: [PATCH 5.15 000/411] 5.15.186-rc1 review
Message-ID: <202511210951.39AA2F97@keescook>
References: <20250623130632.993849527@linuxfoundation.org>
 <CA+G9fYuU5uSG1MKdYPoaC6O=-w5z6BtLtwd=+QBzrtZ1uQ8VXg@mail.gmail.com>
 <2025062439-tamer-diner-68e9@gregkh>
 <CA+G9fYvUG9=yGCp1W9-9+dhA6xLRo7mrL=7x9kBNJmzg7TCn7w@mail.gmail.com>
 <2025062517-lucrative-justness-83fe@gregkh>
 <202511061127.52ECA4AB40@keescook>
 <2025112157-renewable-batboy-7b5c@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025112157-renewable-batboy-7b5c@gregkh>

On Fri, Nov 21, 2025 at 10:36:22AM +0100, Greg Kroah-Hartman wrote:
> On Thu, Nov 06, 2025 at 11:32:18AM -0800, Kees Cook wrote:
> > This thread got pointed out to me. You can put this back in if you want;
> > you just need the other associated fix (which had a bit of an obscure
> > Fixes tag):
> 
> What exactly is "this" commit?
> 
> > d8720235d5b5 ("scsi: qedf: Use designated initializer for struct qed_fcoe_cb_ops")
> 
> Can you give a list of git ids asked for here?  This thread is confusing
> :)

Sorry! For stable, you want these, if they're not already present:

960013ec5b5e ("net: qede: Initialize qede_ll_ops with designated initializer")
d8720235d5b5 ("scsi: qedf: Use designated initializer for struct qed_fcoe_cb_ops")
e136a4062174 ("randstruct: gcc-plugin: Remove bogus void member")
f39f18f3c353 ("randstruct: gcc-plugin: Fix attribute addition")


An additional bit of confusion is that the fix in 960013ec5b5e landed
twice via 2 trees:
6b3ab7f2cbfa ("net: qede: Initialize qede_ll_ops with designated initializer")
960013ec5b5e ("net: qede: Initialize qede_ll_ops with designated initializer")

Obviously either is fine.


-- 
Kees Cook
