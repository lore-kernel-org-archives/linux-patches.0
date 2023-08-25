Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5223D6E
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 08:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF0EC433C7;
	Fri, 25 Aug 2023 08:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692951994;
	bh=jNR01QnbVvkLaNT68ey5tgbJzM2fnE53O4iIHKpT3rs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1U6KlNrajAy3rGD3kS5NKy0dD1C+Pfk8/T2fvsGEj8gXsOdS3mEDzw9GsWvmHWtD+
	 kIt/10PtNDeHAo7YMB7tWqskmpQaSSzQyhoIN5E8bkkeH5eKpCiLZRp3Yeff0w+ecU
	 8doMGBK3BxaHTJwI9EkG/c80OeS2BLOZPOCPxEwA=
Date: Fri, 25 Aug 2023 09:13:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pawel Laszczak <pawell@cadence.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Peter Chen <peter.chen@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 054/135] usb: cdnsp: Device side header file for
 CDNSP driver
Message-ID: <2023082520-finance-cognitive-ba30@gregkh>
References: <20230824170617.074557800@linuxfoundation.org>
 <20230824170619.509775632@linuxfoundation.org>
 <BYAPR07MB5381AFFA172B5646A78FB009DDE3A@BYAPR07MB5381.namprd07.prod.outlook.com>
 <2023082541-reshape-bagel-f9f2@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2023082541-reshape-bagel-f9f2@gregkh>

On Fri, Aug 25, 2023 at 09:12:29AM +0200, Greg Kroah-Hartman wrote:
> On Fri, Aug 25, 2023 at 07:01:52AM +0000, Pawel Laszczak wrote:
> > Hi Greg,
> > 
> > I don't understand why this is queued for 5.10 stable version.
> > 
> > Driver has been upstreamed into 5.12 version.
> 
> Which specific driver?  cdns3 is in 5.10
> 
> > >Because the size of main patch is very big, I’ve decided to create
> > >separate patch for cdnsp-gadget.h. It should simplify reviewing the code.
> > >
> > >Signed-off-by: Pawel Laszczak <pawell@cadence.com>
> > >Signed-off-by: Peter Chen <peter.chen@nxp.com>
> > >Stable-dep-of: dbe678f6192f ("usb: cdns3: fix NCM gadget RX speed 20x slow
> > >than expection at iMX8QM")
> 
> The patch was taken as a dependancy of this commit, which is fixing an
> issue for the change that went into 5.4, which is in 5.10.y.
> 
> Maybe the dependancy checker got this incorrect, let me go see...

Yes, the checker got this wrong, it wasn't needed at all, thanks for
pointing it out.  I've dropped this from the queue now.

thanks,

greg k-h
