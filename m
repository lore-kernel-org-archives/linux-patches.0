Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905B27E
	for <patches@lists.linux.dev>; Fri, 30 Dec 2022 09:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D48DC433D2;
	Fri, 30 Dec 2022 09:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672391811;
	bh=kZWcStAvie3G58rVTjxtLdxTfwyQh2a6SEBAVt1L6jg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P53UyW3vrgmfeRWo8GsjNVCGgeFynLOVrI7I8VIT5HCIhhEOrYxmNp2dv9coqHg9/
	 rBeENbmMxe0F+DlEgaiagMeP+kUaKXuGaU0BNZ0a+qhiCOt3/z3ORFR3uRqB4k0iz0
	 r5wxheq1ozrb3IC3GdzbravkDhtA56vxt2vfC9T8=
Date: Fri, 30 Dec 2022 10:16:49 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sean Anderson <sean.anderson@seco.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 152/731] powerpc: dts: t208x: Mark MAC1 and MAC2 as
 10G
Message-ID: <Y66sgU+uDY2tEYY1@kroah.com>
References: <20221228144256.536395940@linuxfoundation.org>
 <20221228144300.959873542@linuxfoundation.org>
 <c46e40a7-d110-0968-e331-987e77c565a5@seco.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c46e40a7-d110-0968-e331-987e77c565a5@seco.com>

On Thu, Dec 29, 2022 at 11:00:19AM -0500, Sean Anderson wrote:
> Hi Greg,
> 
> On 12/28/22 09:34, Greg Kroah-Hartman wrote:
> > From: Sean Anderson <sean.anderson@seco.com>
> > 
> > [ Upstream commit 36926a7d70c2d462fca1ed85bfee000d17fd8662 ]
> > 
> > On the T208X SoCs, MAC1 and MAC2 support XGMII. Add some new MAC dtsi
> > fragments, and mark the QMAN ports as 10G.
> > 
> > Fixes: da414bb923d9 ("powerpc/mpc85xx: Add FSL QorIQ DPAA FMan support to the SoC device tree(s)")
> > Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> This shouldn't be backported without [1].

Thanks, I'll drop this from everywhere.

greg k-h
