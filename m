Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB6B1DD0DB;
	Thu, 17 Oct 2024 12:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729167529; cv=none; b=W7KrTqL/x1E+r7PeDo4dSrKHHCafMb1sYjDA7N4wR+9VFm3p2xAnJl3epwKrfOVTbNLEv4F/YIiQr4m8yzF3DMUu5wzrsSxAL/p8ng+Kl93bo7TTeIUjOmJ1oZBuhqqq5Z0Ggvttfv4GxPwa2no66ukIzkZ+wT+F3EYpCmyhuts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729167529; c=relaxed/simple;
	bh=A7eEhjsXo+WCet5U3z24IGzwdxHmXpfehW2kecLy1CY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KSRxBjXjvmgJLphSeV8P/yJ+i75+VGSZv2Q2vR2g22oVL5skKEVYVV8oWDuT8qUOHnOYjU3zEgNN3nqui8g6ICyevp6PzG73outOlCHI9IMlNM06ZaeAyoEOwxZleik35yNGy4X0J2rl8Nw6EkNqWRFoN/cDW7W0snIS8BkRw4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PsyAghQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PsyAghQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5708C4CEC3;
	Thu, 17 Oct 2024 12:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729167529;
	bh=A7eEhjsXo+WCet5U3z24IGzwdxHmXpfehW2kecLy1CY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PsyAghQ08GDSHb5TEFOvDroJedniaripuOM7ZbdzbtFZpzy2u8r0hRK/OgHIxy5r4
	 DY3HHbKOXd2xyr7UORc7B5shk1uE8Zi3W1wTXG9ky+ntlnk19qSWO67jKvJfNVMGLn
	 MvfL8f06Ku1htEX4W9aMvsWxk34A7vhq8okELltIHZaHKOn9jqgpGDMJndta+tR/q0
	 e5IS86n5wvyVPia6Kxtlj5urjoCe4x0k9vvSbXV2weJfOjyr2GuQ405HveI25eysjr
	 M1e6cKQIIRmYykpwrRP3/3/bkk23h9Hj7X0/zW4UrqQPn61kr9/lTQJj+E1ZKMzgUL
	 Rr7/xVHp9OT+Q==
Date: Thu, 17 Oct 2024 17:48:45 +0530
From: Vinod Koul <vkoul@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@intel.com>,
	Moritz Fischer <mdf@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 257/518] usb: renesas-xhci: Remove
 renesas_xhci_pci_exit()
Message-ID: <ZxEApUzFuY6eFQUW@vaman>
References: <20241015123916.821186887@linuxfoundation.org>
 <20241015123926.907865055@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015123926.907865055@linuxfoundation.org>

On 15-10-24, 14:42, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Moritz Fischer <mdf@kernel.org>
> 
> [ Upstream commit 884c274408296e7e0f56545f909b3d3a671104aa ]
> 
> Remove empty function renesas_xhci_pci_exit() that does not
> actually do anything.

Does this really belong to stable? Removing an empty function should not
be ported to stable kernels right...?


> 
> Cc: Mathias Nyman <mathias.nyman@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Moritz Fischer <mdf@kernel.org>
> Link: https://lore.kernel.org/r/20210718015111.389719-3-mdf@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Stable-dep-of: f81dfa3b57c6 ("xhci: Set quirky xHC PCI hosts to D3 _after_ stopping and freeing them.")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/usb/host/xhci-pci-renesas.c | 5 -----
>  drivers/usb/host/xhci-pci.c         | 2 --
>  drivers/usb/host/xhci-pci.h         | 3 ---
>  3 files changed, 10 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-pci-renesas.c b/drivers/usb/host/xhci-pci-renesas.c
> index 96692dbbd4dad..01ad6fc1adcaf 100644
> --- a/drivers/usb/host/xhci-pci-renesas.c
> +++ b/drivers/usb/host/xhci-pci-renesas.c
> @@ -631,9 +631,4 @@ int renesas_xhci_check_request_fw(struct pci_dev *pdev,
>  }
>  EXPORT_SYMBOL_GPL(renesas_xhci_check_request_fw);
>  
> -void renesas_xhci_pci_exit(struct pci_dev *dev)
> -{
> -}
> -EXPORT_SYMBOL_GPL(renesas_xhci_pci_exit);
> -
>  MODULE_LICENSE("GPL v2");
> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> index 88f223b975d34..4a88e75cd9586 100644
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -533,8 +533,6 @@ static void xhci_pci_remove(struct pci_dev *dev)
>  	struct xhci_hcd *xhci;
>  
>  	xhci = hcd_to_xhci(pci_get_drvdata(dev));
> -	if (xhci->quirks & XHCI_RENESAS_FW_QUIRK)
> -		renesas_xhci_pci_exit(dev);
>  
>  	xhci->xhc_state |= XHCI_STATE_REMOVING;
>  
> diff --git a/drivers/usb/host/xhci-pci.h b/drivers/usb/host/xhci-pci.h
> index acd7cf0a1706e..cb9a8f331a446 100644
> --- a/drivers/usb/host/xhci-pci.h
> +++ b/drivers/usb/host/xhci-pci.h
> @@ -7,7 +7,6 @@
>  #if IS_ENABLED(CONFIG_USB_XHCI_PCI_RENESAS)
>  int renesas_xhci_check_request_fw(struct pci_dev *dev,
>  				  const struct pci_device_id *id);
> -void renesas_xhci_pci_exit(struct pci_dev *dev);
>  
>  #else
>  static int renesas_xhci_check_request_fw(struct pci_dev *dev,
> @@ -16,8 +15,6 @@ static int renesas_xhci_check_request_fw(struct pci_dev *dev,
>  	return 0;
>  }
>  
> -static void renesas_xhci_pci_exit(struct pci_dev *dev) { };
> -
>  #endif
>  
>  struct xhci_driver_data {
> -- 
> 2.43.0
> 
> 

-- 
~Vinod
