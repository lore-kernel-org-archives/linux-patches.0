Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3355410788;
	Thu, 14 Mar 2024 22:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710456392; cv=none; b=LpY5Asl6kLLKYgZS2ci2hpdSkSc1Jwk836Q8wNHjEgDAyVegMYqgYxSfuEGO6kbOvN2yhTuwADO5QNG6ureiGrbstkxw4HoUQOjtwWiM6Jjiq4UDrh2j5K0Lz2KVMBh8B0vjaNweI+UiyJIvCU0Y+s1y4smm1d8HYwlsOZ3ZEDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710456392; c=relaxed/simple;
	bh=7/aeb6My+Chr6s3GLseBkS9GYEPKlZ4FVcrhCXbQHso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iRcaSiHjxAalxArTwe/tmyd3V2Dn4EVFbigzfCodNGRyErwIk/ydWOk32etHYOo/RquO8/+ZRiIpyCzTNGWshKYYPlU+yTb6QNf94qEaN2k41DUzGq81qAjPblEE2MNewLwMCzYph5Htej7+vXgcBpbXiIhF0y1ikkC8swWtLeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m1M066pm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m1M066pm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739B0C433C7;
	Thu, 14 Mar 2024 22:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710456391;
	bh=7/aeb6My+Chr6s3GLseBkS9GYEPKlZ4FVcrhCXbQHso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m1M066pmsUAPPHOYImvNoL1WcBw4u8Vtwq/o6NcG/yIVjiP6TEAjEqiFrjqKNqiQs
	 ZX+heEEa7cc7fTr4BShOuTJ+0wQ7fHivotmVGR4zPcHx4l3eqktN56Pllsx078NFxC
	 VyvzqTjz0BurbsoDZtGww+AHxxXM5EpkjvW3Em6EUm2wgYA8qe1Eq5WWc7LT4LeUP3
	 EZ1tYGKwOhf7gu/g0XpZhC+nptKfYF9By1xyta4CMb22pA3R5VjzR6kmkUUDH/fM1b
	 dyGQOYPnmEz8ylK00VGmC5SNmV8CUf39/VHIB505QW+tbFZUbLt4yHB/H6KabfOZ1e
	 0KpCaEZGS7S7A==
Date: Thu, 14 Mar 2024 18:46:29 -0400
From: Sasha Levin <sashal@kernel.org>
To: Johan Hovold <johan@kernel.org>
Cc: Yongqin Liu <yongqin.liu@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Bjorn Andersson <andersson@kernel.org>,
	amit.pundir@linaro.org, sumit.semwal@linaro.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5.4 015/267] arm64: dts: qcom: sdm845: fix USB wakeup
 interrupt types
Message-ID: <ZfN-RQLgC9i64VyK@sashalap>
References: <20240221125940.058369148@linuxfoundation.org>
 <20240221125940.531673812@linuxfoundation.org>
 <77f1c6a6-7756-4168-a69d-583a35abd8ab@linaro.org>
 <ZfKxGUmi_IXjA4wA@hovoldconsulting.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZfKxGUmi_IXjA4wA@hovoldconsulting.com>

On Thu, Mar 14, 2024 at 09:11:05AM +0100, Johan Hovold wrote:
>[ +TO: Sasha ]
>
>On Thu, Mar 14, 2024 at 01:48:36AM +0800, Yongqin Liu wrote:
>> On 2024/2/21 21:05, Greg Kroah-Hartman wrote:
>> > 5.4-stable review patch.  If anyone has any objections, please let me know.
>
>> > From: Johan Hovold <johan+linaro@kernel.org>
>> >
>> > commit 84ad9ac8d9ca29033d589e79a991866b38e23b85 upstream.
>> >
>> > The DP/DM wakeup interrupts are edge triggered and which edge to trigger
>> > on depends on use-case and whether a Low speed or Full/High speed device
>> > is connected.
>> >
>> > Fixes: ca4db2b538a1 ("arm64: dts: qcom: sdm845: Add USB-related nodes")
>> > Cc: stable@vger.kernel.org      # 4.20
>> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
>> > Link: https://lore.kernel.org/r/20231120164331.8116-9-johan+linaro@kernel.org
>> > Signed-off-by: Bjorn Andersson <andersson@kernel.org>
>> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
>> > --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
>> > +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
>> > @@ -2503,8 +2503,8 @@
>> >
>> >   			interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
>> >   				     <GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
>> > -				     <GIC_SPI 488 IRQ_TYPE_LEVEL_HIGH>,
>> > -				     <GIC_SPI 489 IRQ_TYPE_LEVEL_HIGH>;
>> > +				     <GIC_SPI 488 IRQ_TYPE_EDGE_BOTH>,
>> > +				     <GIC_SPI 489 IRQ_TYPE_EDGE_BOTH>;
>> >   			interrupt-names = "hs_phy_irq", "ss_phy_irq",
>> >   					  "dm_hs_phy_irq", "dp_hs_phy_irq";
>
>> This patch only causes the db845c Android builds to fail to have the adb
>> connection setup after boot.
>
>Indeed.
>
>> In the serial console, the following lines are printed:
>
>>    [    0.779411][   T79] dwc3-qcom a6f8800.usb: dp_hs_phy_irq failed: -22
>>    [    0.779418][   T79] dwc3-qcom a6f8800.usb: failed to setup IRQs,
>> err=-22
>
>> After some investigation, it's found it will work again if the following
>> two patches are applied:
>>    72b67ebf9d24 ("arm64: dts: qcom: add PDC interrupt controller for
>> SDM845")
>>    204f9ed4bad6 ("arm64: dts: qcom: sdm845: fix USB DP/DM HS PHY
>> interrupts")
>
>Correct, apparently the PDC controller was not added until 5.10, which I
>should have noticed and indicated in the commit message of the follow up
>fix. Sorry about that.
>
>> Could you please help to have a check and give some suggestions on what
>> patches should be back ported to the 5.4 kernel, or are the above two
>> patches only good enough?
>
>Based on a quick look at the sdm845 dtsi, the PDC driver and their
>history, I think the two commits above should be enough.
>
>Sasha, could you pick the following two commits for 5.4:
>
>	72b67ebf9d24 ("arm64: dts: qcom: add PDC interrupt controller for SDM845")
>	204f9ed4bad6 ("arm64: dts: qcom: sdm845: fix USB DP/DM HS PHY interrupts")
>
>to fix the regression?

Will do!

-- 
Thanks,
Sasha
