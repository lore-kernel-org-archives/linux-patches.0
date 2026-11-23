Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795423379;
	b=xyPAWRFkSixNrL4NLYA15crMbk09cNR4lauQeOoLYVuOCYeI0Ey756Ok6UIJwVvChket
	 5D0C74/vHVgg7LY9/GPm8u9XBcc5m3rl9P4D54eFhvduNfraFz/3bj9gHk3RdE+5A0Qi9
	 c65DPtPgUp+iDeGf2GeNlHkDWvJjWBgTLJeS21dLgwCU3nbOw0Wa1io1QCHXtq6k0qNog
	 W9+MBY/W8UcuSfVlhqftOzyZ9KbbTHxRX9AkI8UQb99+aedPnZC11owV3ZIjmiBn6TeI2
	 Eg59NNxI8RNbaXrBMBVGwJIdkTdoLFGEjg5wSE4zfXJPPe0dDtpCtMaSk0Q7zNVF5UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795423379;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=14j6GVUX8bKzUqVOr/edz5Afyr2YsuEZHfuka7z/IDM=;
	b=qNOfeSTgu2EmA3tGcSbyViKCwTb2iBWRCzfHHX382p2lucMDd/3BsxfAsA8745IobPv8
	 fD1fCzlht0vIs5AfownkVMc1elCtfGKNqywq6BLuFRCLEv01CxHdy5jaojTZabRMlzzZ6
	 Ck2GsGd7X50HfODw+zlkRt/OVjhOkeFXd/ja+4a4dJQVXm4XwIXF4GSQ0SMF1GXbSun5Q
	 sVYQ2bfSElnduVIFhhEFKv6bhhEDFxi+8spaF2LPBPx/coEMGb/EYRD1JMGhFD19hXfwq
	 MsqVo8myXOOkKHQxTIzvaKMfsvJDDPxgyxdmqD2ki9XH2Dj57Soc7QJsgR30Co6MoTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wf3epqOY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899C5606A31A;
	Mon, 23 Nov 2026 08:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wf3epqOY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A371F000C0;
	Mon, 23 Nov 2026 08:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795423379;
	bh=14j6GVUX8bKzUqVOr/edz5Afyr2YsuEZHfuka7z/IDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wf3epqOYfzYkk4Z3MC5NnDllcOWq3xiwUo67BjmPQfsBOYU+0xC8YcZC+chplHUV3
	 PTDJdxP+UO2uBlt+oKKc8lsQ8dKqNwLz1qCYqKBnUi1JftJMWTVgFYdJZXOMWSSyr/
	 50djJSv8VmEgypiOkRb4g4HQnvHbgUSe1L9Q2Yjg=
Date: Mon, 23 Nov 2026 09:42:56 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 07/10] device core: Add helpers to record confidential
 device acceptance
Message-ID: <2026112312-simply-celestial-9810@gregkh>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-8-aneesh.kumar@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123083337.2731019-8-aneesh.kumar@kernel.org>

On Mon, Nov 23, 2026 at 02:03:34PM +0530, Aneesh Kumar K.V (Arm) wrote:
> Add a flag to record whether a device is accepted for private memory
> access, with helpers to set, clear and read it. Setting or clearing the
> flag requires device::mutex and fails with -EBUSY if a driver is
> attached.
> 
> Follow-up patches will have TSM drivers mark devices accepted after
> verification and setup. PCI DMA setup will check this state before
> allowing the device to access private memory.
> 
> Based on the original patch from Dan Williams <djbw@kernel.org>.
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  MAINTAINERS            |  1 +
>  drivers/base/Kconfig   |  4 +++
>  drivers/base/Makefile  |  1 +
>  drivers/base/base.h    |  9 ++++++
>  drivers/base/coco.c    | 68 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/device.h | 22 ++++++++++++++
>  6 files changed, 105 insertions(+)
>  create mode 100644 drivers/base/coco.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a3ee234d79ae..142ba5af8798 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -28553,6 +28553,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tsm/linux.git
>  F:	Documentation/ABI/testing/configfs-tsm-report
>  F:	Documentation/driver-api/coco/
>  F:	Documentation/driver-api/pci/tsm.rst
> +F:	drivers/base/coco.c
>  F:	drivers/pci/tsm.c
>  F:	drivers/virt/coco/guest/
>  F:	drivers/virt/coco/tsm-core.c
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index a9acf4575f4f..be8d1484f210 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -242,4 +242,8 @@ config FW_DEVLINK_SYNC_STATE_TIMEOUT
>  	  command line option on every system/board your kernel is expected to
>  	  work on.
>  
> +config CONFIDENTIAL_DEVICES
> +	depends on ARCH_HAS_CC_PLATFORM
> +	bool
> +
>  endmenu
> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 435710f643a5..8f5725e3e670 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -26,6 +26,7 @@ obj-$(CONFIG_DEV_COREDUMP) += devcoredump.o
>  obj-$(CONFIG_GENERIC_MSI_IRQ) += platform-msi.o
>  obj-$(CONFIG_GENERIC_ARCH_TOPOLOGY) += arch_topology.o
>  obj-$(CONFIG_ACPI) += physical_location.o
> +obj-$(CONFIG_CONFIDENTIAL_DEVICES) += coco.o
>  
>  obj-y			+= test/
>  
> diff --git a/drivers/base/base.h b/drivers/base/base.h
> index 866b2beb6baa..97a9fcb10c97 100644
> --- a/drivers/base/base.h
> +++ b/drivers/base/base.h
> @@ -108,8 +108,13 @@ struct driver_private {
>   * @dead: This device is currently either in the process of or has been
>   *	  removed from the system. Any asynchronous events scheduled for this
>   *	  device should exit without taking any action.
> + * @cc_accepted: Device accepted for private memory access. Bus code checks
> + *		 this state before enabling DMA during driver attachment.

No, please do not do this, make this a "state" like the trusted device
series does.


>   *
>   * Nothing outside of the driver core should ever touch these fields.
> + *
> + * All bitfield flags are manipulated under device_lock() to avoid
> + * read-modify-write collisions.

Why is this added now?

>   */
>  struct device_private {
>  	struct klist klist_children;
> @@ -122,6 +127,10 @@ struct device_private {
>  	char *deferred_probe_reason;
>  	struct device *device;
>  	u8 dead:1;
> +#ifdef CONFIG_CONFIDENTIAL_DEVICES
> +	u8 cc_accepted:1;

It's a bitfield, just always use it.  But again, this isn't going to be
needed.

thanks,

greg k-h
