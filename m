Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873471DE4CC;
	Tue, 11 Mar 2025 09:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741686703; cv=none; b=EZ2T7E3lSpZx/TFvQtNNjKYyn2lTnK3BQG7lvfEIhD27KLmU6l5BKXryzrn6weMY5+hvGLezByPlY0cGV/2ndATN0qG/z5VyqT5hIs+3o+9Y5ggaK08r1IMKTTIQMBRgExWuz8qOzbBFKeddt2Oe8uNNvSqgSYeeE7fTke4l3TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741686703; c=relaxed/simple;
	bh=mC924MFNic96f4FBrsEaN8y408FnozoKf5prbDZEIAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=to0zIeMxNwFSXVCUKS01pJWZhPsl6L2ZFulEzQV3O8zVa/5O3tgLs652dakHuSDE/WqVmHjVgKWf8KPo6cuoYkW965JdebjSKSxdvq62ZAgPGBnhjXKHLWjeZ99jybXdVXLR8QTE/6fyY1m485yMp3HY5IbFseGEWllRm7tnHUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWdeknam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWdeknam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689DEC4CEE9;
	Tue, 11 Mar 2025 09:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741686703;
	bh=mC924MFNic96f4FBrsEaN8y408FnozoKf5prbDZEIAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HWdeknamqmhButtcURF1/kPfGoNQq7mwDhU6opGASj1mMUAtOQe+7u4uoCx3MriPI
	 WiTR/q0gbWVmWDwtvFoX6zeYepRfpXpvcfGdKtnOTLYsMAuVc8CmN3N3HoL9Zq10EV
	 iOrHd6Sypwc5QxPpkhs1q972ylpBBmDDRjDijkSg=
Date: Tue, 11 Mar 2025 10:51:40 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Quentin Schulz <quentin.schulz@cherry.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Farouk Bouabid <farouk.bouabid@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 005/145] arm64: dts: rockchip: add rs485 support on
 uart5 of px30-ringneck-haikou
Message-ID: <2025031129-exemplary-spent-2516@gregkh>
References: <20250310170434.733307314@linuxfoundation.org>
 <20250310170434.958553347@linuxfoundation.org>
 <6fbfebac-2a36-4307-8e3f-3f5961fd12a1@cherry.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fbfebac-2a36-4307-8e3f-3f5961fd12a1@cherry.de>

On Tue, Mar 11, 2025 at 10:01:02AM +0100, Quentin Schulz wrote:
> Hi all,
> 
> On 3/10/25 6:04 PM, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Farouk Bouabid <farouk.bouabid@theobroma-systems.com>
> > 
> > [ Upstream commit 5963d97aa780619ffb66cf4886c0ca1175ccbd3e ]
> > 
> > A hardware switch can set the rs485 transceiver into half or full duplex
> > mode.
> > 
> > Switching to the half-duplex mode requires the user to enable em485 on
> > uart5 using ioctl, DE/RE are both connected to GPIO0_B5 which is the
> > RTS signal for uart0. Implement GPIO0_B5 as rts-gpios with RTS_ON_SEND
> > option enabled (default) so that driver mode gets enabled while sending
> > (RTS high) and receiver mode gets enabled while not sending (RTS low).
> > 
> > In full-duplex mode (em485 is disabled), DE is connected to GPIO0_B5 and
> > RE is grounded (enabled). Since GPIO0_B5 is implemented as rts-gpios, the
> > driver mode gets enabled whenever we want to send something and RE is not
> > affected (always enabled) in this case by the state of RTS.
> > 
> > Signed-off-by: Farouk Bouabid <farouk.bouabid@theobroma-systems.com>
> > Link: https://lore.kernel.org/r/20240208-dev-rx-enable-v6-2-39e68e17a339@theobroma-systems.com
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > Stable-dep-of: 5ae4dca718ea ("arm64: dts: rockchip: Disable DMA for uart5 on px30-ringneck")
> 
> I don't mind the backport of this 005/145 patch, but this Stable-dep-of
> commit has already been merged in 6.6 with a conflict resolution, see
> bcc87e2e01637a90d67c66ce6c2eb28a78bf79f2.

Odd.  Sasha, did something go off in your scripts?
