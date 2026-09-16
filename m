Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8158F4ACC86
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 09:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552655; cv=none; b=pRR2VrSsdpswilyCI0kvbkfwJgTJehQTzBhLIvA4+pxfI6rNRA58a68TJQVv8HkPNr8SU68Y95wZgR/CB/Lg8rzL/dnFIDgCbWqfzVI13zrEkYSCicKtzdClt5Uy9W2kXMpalpCNU8WE7eGzGwZZNAUHH9RBevYIVM98LeIwz0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552655; c=relaxed/simple;
	bh=r4MxKVUpVOphBodMJ8sw/Wpc7j8tML5z/BSxDV9WLps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DIOAm+MS7oM4tJU6m0qi4W8vjrW8j8fgpQ8uKPnfevEGI11OoC35vmwcSm3EyfGx8xHyRbCdhXthgBNbcrcamB/YPvTo4Vrq1evD2Up/n9wx4Ih+FiW7MBXRcURXVryAqkWp5OjSwpZJYlCShXoj7eYu6KPZHow5bzc6RncC9so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aXVFMsUS; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aXVFMsUS"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2dd1dcdcf95so16483825ad.1
        for <patches@lists.linux.dev>; Wed, 16 Sep 2026 02:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789552634; x=1790157434; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y4XoxT2FpvN2jeEt9ImVCB0YUQFanB/NfCBuFC1HNkg=;
        b=aXVFMsUS4/d1TKhQ18UBYKOFuHIBy7FS2N48ptxHXrcvtvDu+RCbBmnY/jqTX7zwYY
         fgJD23cd/+Zz5lb6hs2Q80oUqLoPYDVlHyHFHwvXa4aPHGX7rUIUNI3Lw5BT238Bbwol
         M9kWcsfORck89EFtZAgbh4tPk6zl+Itd23+qa/ElgliAjknFjyao6FmSQnS34ehxYZSB
         Ldk6+xCIoP+9+k/6yhEbUSMT08sfDr5SKGz/g150eyd7m1+Hu7OV4HgkEnsFJvgeCVYj
         29Fqv1Kfjf3vD8fA6memX7fYwDfEoiQY9BfrW3LatEbRR9Ov1QSBYd0KokBQ5pHiPwRQ
         6udA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789552634; x=1790157434;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y4XoxT2FpvN2jeEt9ImVCB0YUQFanB/NfCBuFC1HNkg=;
        b=gxj5UzalIg/1z8EFiv0tRMz7O/8Kck1kl4qn4nEiwbBEkBYU8U8PkTnEynizdjm/yf
         PbfkyRMz+2r/aMk9uYTAtq17Wit5JdDCy/HLpYW86HmoEdd3ZaWNQL2A27matrILr3+R
         e3LC25cdzhe+FureWhQmf4HrGA9t3/ri/Y11JbR530igzqNOX1S34OFwL7ifNLMdIPN4
         GfFr6E0+zJNb+DHbgo3gDX04yiThw4NG5OV8Pi/Nb5ezWI5HaCs1hXBNjUaS1NbJsxNk
         rBwvmPi+marhMS/HRhMVLGKAyauNfVsiWTYAc/RMTGXsSBKt19GvR7mCYUgd6+vLEx3f
         6w2A==
X-Gm-Message-State: AFuF++mC42ZZ7CVBGJgjvAZQ9Rv8IMSYyyWyGrcI7FM1C4n1HrFnWHoP
	7exXM+rLXmDA0QxtSYQ2o5yWbyPHbRZNb2oXD9sw9zS5M+SL6hWoPOAe
X-Gm-Gg: AYBFou3VJ/axl7hjXBYEZc56Vg532FYtwrJwABPG96T0KAG6hoS5ab+lvP/xFvxW5J1
	e/sqVmbCcXS5blP2dV1K4Q7kRExW4TNbQL2TvEKT8klRxnVWK2ByOhhB4DUou/Ol4iLLZiPRuqs
	moxnN0x9ldRWquIApHOWU/PpItxq8MPN9ny3vdq13D3eEIt9zc0kaQooGmNI7xKJJ+XHYE/6aiu
	ThvUHpyI90aI93CwasTEHPj0tFjTEHnlWnAgl99tZis2fRFZwYs5C1CO19eDcJwzFvBlsPOjqad
	H0EmSubqC5Jry7b+e+q5Rqs5LBOJfG5MVYojb0cbfBI9c9dXBzJiRjXcEi+M/y2q1ZzTkEEe620
	OmEvnUaIFCiDo+yNZwZ3klFwxwpO/3sGe3Ouha6L2K9OgQOWp+fCMDp+l1zZuiswRfprDzVWaw0
	e1+0FBWY74Z6BAfNT2C7fyweBSLOMQ0SVphXT1UuA3bSedIDhmV8+6s/lmAO671LMgcinfag==
X-Received: by 2002:a17:903:324b:b0:2da:e553:c6ff with SMTP id d9443c01a7336-2dd764c1b47mr95237755ad.9.1789552634365;
        Wed, 16 Sep 2026 02:57:14 -0700 (PDT)
Received: from localhost ([2001:19f0:8000:3e6e:5400:6ff:fe38:3d01])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f34921sm8679235ad.84.2026.09.16.02.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 02:57:13 -0700 (PDT)
Date: Wed, 16 Sep 2026 17:56:31 +0800
From: Inochi Amaoto <inochiama@gmail.com>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Anton D. Stavinskii" <stavinsky@gmail.com>, 
	Inochi Amaoto <inochiama@gmail.com>, Chen Wang <chen.wang@linux.dev>, Sasha Levin <sashal@kernel.org>, 
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 6.12 0889/1376] riscv: dts: sophgo: cv180x: Allow the DMA
 multiplexer to set channel number for DMA controller
Message-ID: <aqpnHyo8p2ygP1-8@inochi.infowork>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065627.376202771@linuxfoundation.org>
 <812a006e-a7ad-4a66-ab8b-45865cbe47f4@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <812a006e-a7ad-4a66-ab8b-45865cbe47f4@oracle.com>

On Wed, Sep 16, 2026 at 01:30:56PM +0530, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
> 
> On 12/09/26 12:25 pm, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Inochi Amaoto <inochiama@gmail.com>
> > 
> > [ Upstream commit 5011466bade64483bb52bc4a926719d6794e6dab ]
> > 
> > Change the DMA controller compatible to the sophgo,cv1800b-axi-dma,
> > which supports setting DMA channel number in DMA phandle args.
> > 
> > This dts change does not break backward compatibility as a fallback
> > compatiable string is added.
> > 
> > Fixes: 514951a81a5e ("riscv: dts: sophgo: cv18xx: add DMA controller")
> > Reported-by: Anton D. Stavinskii <stavinsky@gmail.com>
> > Closes: https://github.com/sophgo/linux/issues/9
> > Tested-by: Anton D. Stavinskii <stavinsky@gmail.com>
> > Link: https://patch.msgid.link/20260511063818.463877-3-inochiama@gmail.com
> > Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
> > Signed-off-by: Chen Wang <chen.wang@linux.dev>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   arch/riscv/boot/dts/sophgo/cv18xx.dtsi | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/riscv/boot/dts/sophgo/cv18xx.dtsi b/arch/riscv/boot/dts/sophgo/cv18xx.dtsi
> > index b8063ba6d6d7f..e519a72c093d1 100644
> > --- a/arch/riscv/boot/dts/sophgo/cv18xx.dtsi
> > +++ b/arch/riscv/boot/dts/sophgo/cv18xx.dtsi
> > @@ -298,7 +298,7 @@ sdhci0: mmc@4310000 {
> >   		};
> >   		dmac: dma-controller@4330000 {
> > -			compatible = "snps,axi-dma-1.01a";
> > +			compatible = "sophgo,cv1800b-axi-dma", "snps,axi-dma-1.01a";
> 
> 
> I ran an AI-assisted backport review, and I have verified the report. It
> looks valid to me.
> 
> The patch adds the Sophgo CV1800B DMA compatible, but 6.12 lacks the
> matching driver support from b49c70273801. The generic fallback
> therefore matches and still calls dma_get_any_slave_channel(), so the
> phandle channel number is not honored. The branch also lacks the CV1800B
> mux driver db7d07b5add4 and its syscon/mux DTS integration from
> 126a1b3c61cb.
> 
> Upstream driver code after b49c70273801:
> 
>     if (dw->hdata->use_handshake_as_channel_number)
>             dchan = dma_get_slave_channel(&chan->vc.chan);
>     else
>             dchan = dma_get_any_slave_channel(&dw->dma);
> 
> Downstream 6.12.y code:
> 
>     compatible = "sophgo,cv1800b-axi-dma",
>                  "snps,axi-dma-1.01a";
>     dchan = dma_get_any_slave_channel(&dw->dma);
> 
> Downstream falls back to the generic match and ignores the channel ID.
> 
> Maybe we should be dropping this or reverting this.
> 
> thanks,
> Harshit
> 
> >   			reg = <0x04330000 0x1000>;
> >   			interrupts = <29 IRQ_TYPE_LEVEL_HIGH>;
> >   			clocks = <&clk CLK_SDMA_AXI>, <&clk CLK_SDMA_AXI>;
> 

I think this fix does not change something as we already have the
fallback compatiable, even if we does not backport the driver fix.
As this does not change the behavior, I think this could be kept.

Regards,
Inochi
