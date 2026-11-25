Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795595503;
	b=vpigWH22k0IvF4CSmTZHsUwLFA1X/UzXyECL9YF8b3d8xGp5K8Dc3thcZzdVcVRuo6yT
	 +kkEbU/s3eEBNae4GsVps+DV3bbVvzxGGt+nyFl19O2iqG9qZeXbe8pw78uvwK+59jRri
	 FW5xqBXpLfwi7RcqXcKu5F/T8fD/zkd6EmDnyeOAbqyWl2tpmk6uqCtZvjd33L4eEm2Me
	 NNjMT81p0JxRJ2iz0Q/FotPEaj/u7THnjC9E43JtCXbEuqOJEGkl4jjTdgGB16jaPPUfN
	 RhE6N9G0Q6+LQXMm3+zXryhYecVhs2gsHb7vmBd1w3Gtcd4dKc9c+J85PPihC7B9ZIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795595503;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=NR5n9vnMwUztju7EXEqCo7XSLAUDb4Xqk+VIxyLE7/c=;
	b=lxEr7T41g6MmeooyjYitfYQaaNxUH6v1LNmEPpgV3tmwSDWIawqaqVImq4N9EYb7ib0F
	 /fQ7p1RvPOElCk32Gw1UI2xpb8QbRSLL8sy/RIJvB0rc/Q7rjl7pRObJkfpBxiMQWxsgO
	 oD6KwqEqUMzIXLVvrUPd1NcP+z/4l3uwlxO9zdO8GldAL5jRKWmFthG4Tx0dfP63SEcx0
	 wVt7+9DGCXxYosnV0Hc+ns681Y1D+cBbmDXfaUendqYC0rmBmYe7m6Dx3OIId4kZPJKIS
	 iS01kyrkyAyx/NSCtmBQAPV+dVCPvRnrf2djGGHTJSA3K/4hj1xCeCLMw4eQzmimI0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HLC5lvWP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02349606A329;
	Wed, 25 Nov 2026 08:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HLC5lvWP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC321F000D1;
	Wed, 25 Nov 2026 08:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795595502;
	bh=NR5n9vnMwUztju7EXEqCo7XSLAUDb4Xqk+VIxyLE7/c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=HLC5lvWPvpRSC9jTJfKtu4fMESxtMMFO5C7Yoj6vnnCP9MiS9vmvYmuW53XLNVPbf
	 HlkfJuTvtxYb3uLi3GqPy7wHWypzMIziP36kJXFP3kP/OfsvpInni9uBdbhD5H3anj
	 KliWQaHd8M6l5d0Y5ZYx77+zWobP9kWCN3ChdsaX8pNOtmy420MjoDG1h6OwUnE8Lo
	 Zztk1Fhxinh2x5d3aCA2xHVndIF4WoZphX5261LJt/OiEKq/EIhlhB7Mwo2O13HOs/
	 5gWu5PraXInicwPXcrVCMWymSwF9SzxCcWQ0e1oVS52EIyab2KWntUhLfeczOeCfH1
	 w9qhP7GoDTDVQ==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Alexey Kardashevskiy <aik@amd.com>, linux-coco@lists.linux.dev
Cc: Dan Williams <djbw@kernel.org>, Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 03/10] PCI/TSM: Let TSM drivers discover the CMA DOE
 mailbox
In-Reply-To: <4279cc50-0e05-4d86-ac12-398adcfb6091@amd.com>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-4-aneesh.kumar@kernel.org>
 <4279cc50-0e05-4d86-ac12-398adcfb6091@amd.com>
Date: Wed, 25 Nov 2026 14:01:32 +0530
Message-ID: <yq5atsl59usb.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Alexey Kardashevskiy <aik@amd.com> writes:

> On 23/11/26 19:33, Aneesh Kumar K.V (Arm) wrote:
>> Move CMA DOE discovery out of pci_tsm_pf0_constructor(). An external
>> Endpoint requires a mailbox, while an RcIEP can use device assignment
>> without DOE. Let each TSM driver enforce its own requirement.
>> 
>
> It is DOE of a PF which will be passed through (or its VF).
>
> The AMD hardware has such devices too which are still PCIe so I'd
> think it is the same TSM driver. imho this is quite common and needs
> to be handled in the common code.
>

If this is common across TSM drivers, we can move it into the common
code. For the next iteration, I will implement the arm requirement
there, and we can resolve any architectural differences later?

>
> And the patch does too many unrelated renames, a bit harder to see the
> actual change.
>

Sure, I will drop the unrelated renames.

-aneesh
