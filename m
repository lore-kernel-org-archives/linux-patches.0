Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC6C1FD1
	for <patches@lists.linux.dev>; Sat,  7 Oct 2023 11:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bBXwYLyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7471C433C9;
	Sat,  7 Oct 2023 11:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696679833;
	bh=0yt73kgAPYECXihzzq92WeV8qT2NdU3GEyERzOSit4o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bBXwYLyCuthuf8wsye76/C/pOhMzc9i5GERBM0kM5HdbHS5h4JNN6YH7yaYQXFh7O
	 XR2NzYF+Csj8TMjq5yJjmCFuVOpC2yX/UT1aMh609tNvtGl6wSr1RdQ4tImFfSYDdA
	 cqx78vorYwmh/V7VKf50hTwYRh115cvoLHjMAD+E=
Date: Sat, 7 Oct 2023 13:57:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: Re: [PATCH 5.10 397/509] PCI: qcom: Disable write access to read
 only registers for IP v2.3.3
Message-ID: <2023100736-enlarged-return-6dc0@gregkh>
References: <20230725104553.588743331@linuxfoundation.org>
 <20230725104611.936185910@linuxfoundation.org>
 <f23affddab4d8b3cc07508f2d8735d88d823821d.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f23affddab4d8b3cc07508f2d8735d88d823821d.camel@decadent.org.uk>

On Sun, Sep 24, 2023 at 11:15:35PM +0200, Ben Hutchings wrote:
> On Tue, 2023-07-25 at 12:45 +0200, Greg Kroah-Hartman wrote:
> > From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > 
> > commit a33d700e8eea76c62120cb3dbf5e01328f18319a upstream.
> > 
> > In the post init sequence of v2.9.0, write access to read only registers
> > are not disabled after updating the registers. Fix it by disabling the
> > access after register update.
> > 
> > Link: https://lore.kernel.org/r/20230619150408.8468-2-manivannan.sadhasivam@linaro.org
> > Fixes: 5d76117f070d ("PCI: qcom: Add support for IPQ8074 PCIe controller")
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/pci/controller/dwc/pcie-qcom.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > --- a/drivers/pci/controller/dwc/pcie-qcom.c
> > +++ b/drivers/pci/controller/dwc/pcie-qcom.c
> > @@ -771,6 +771,8 @@ static int qcom_pcie_get_resources_2_4_0
> 
> This fix was supposed to be for v2.3.3 of the hardware and originally
> changed the function qcom_pcie_get_resources_2_3_3().
> 
> However, the backports to 4.19, 5.4, and 5.10 applied this change to
> the similar function qcom_pcie_get_resources_2_4_0().
> 
> Please move the added function call into the correct function.

That function is not in those older kernels, which is why patch tried
it's best and moved to the other function.

I'll just go revert the offending commit from all of these branches,
thanks for noticing!

greg k-h
