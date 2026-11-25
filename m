Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795595848;
	b=r44hRd52i4pfMbVde6/OTqbdDPa21RjW2BaFFY0nGYZ3PdFjYfSuuFTVHwKDrdWFGvRZ
	 oTIVuI5k7yktBeRAQsxCKNquEbuuOBasp6bkN7b3kwH1Idw9ZfhfM9C3DTA40OBtA2bbO
	 3odPZaAA9aVyFXF9djWO94tmS2sBDhBnWZuKH/BJC9Y6XKkT8qpwTk8kBEpahuRbi6SPg
	 7U4jOYHF7uXbFO/RkuOooO7QhX5JkiiTVBAiNQpy1E/nSmmjl+6AMcOP7GdBRrB7O0qt3
	 x3ONZ3z/6hB5v2X7hvbdn3cFCn1sp4/OI1ohFYAwCL1si9W40L67W7yEVDmoIJcDszA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795595848;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=zPQ6zQ8uV4eKmUcVRQ1hIv+A3D6QwvcOfGuZSPbSW+c=;
	b=C1qWGQA5ObvF6y1ajc1HniZ/Yjv3Q+h27GEojHQi7C5Ndd/Uq69q2ASdGXlArAIyQtnb
	 mlb9dcjcusob57Ls32EQWaFDdySFWkk7kgqkj6BGUEKx3z0leNXqEYzh6HFyVWzztHo71
	 3OqKemj2V5xtk//scH9R3ONG3esy3zcacjHde+/5OYVe5dEZPacn4YDnS2gfczzJsPhoi
	 QSni4Fni14+PS4ifsCsONFf2i0D0VDypwcT3wM+H4sfBg3Rhi7uwAj8Kk/HTClIGfo20L
	 V3/ARfCvVsUMwuMgNg+q9AkZRUUvcVqz0rLFRVbpj0QPlvXekDyClUPpCpPfp4im7rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RqwuNeO+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CB1606A326;
	Wed, 25 Nov 2026 08:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RqwuNeO+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378A21F000C0;
	Wed, 25 Nov 2026 08:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795595848;
	bh=zPQ6zQ8uV4eKmUcVRQ1hIv+A3D6QwvcOfGuZSPbSW+c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=RqwuNeO+en6ylIrQjzIoRLSLJhqQ/ZEyfYT8SJDHB3wI2f2OzxEgKMPBIlvgaqk1h
	 c6xRRn988L/1TZNfg9RGOfrRNNLhx1dMzqvvTtj6c7Loysu62HBh/uAKDr5B3KbF6y
	 p0Z+DNpiOhk02aH8n36HkVQmg0/jgCIaJUWy2a9uWWel2U0JlbonYZV9CjE+eZjCda
	 4eEbSnB40uO4ASwHyxUjLcYHzrPtrCG3FGcNIgX1MpH9N9fkfCCW2QcEEvpp8c/yjw
	 bFMpMfj49pN8fXhTM8egt0MwzWw8FMZoyQ9nwPNeG1rHL1dQ5NaC2jopXjoxN4Gttf
	 2U9by7pYmIEkA==
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
Subject: Re: [PATCH v1 04/10] PCI/TSM: Defer TSM vDEVICE allocation until
 device setup completes
In-Reply-To: <5e04323f-dfdc-4956-acee-bcc09926726d@amd.com>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-5-aneesh.kumar@kernel.org>
 <5e04323f-dfdc-4956-acee-bcc09926726d@amd.com>
Date: Wed, 25 Nov 2026 14:07:19 +0530
Message-ID: <yq5aqzg99uio.fsf@kernel.org>
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
>> A successful connect does not necessarily complete the checks and setup
>> needed to assign a device to a confidential guest. Authentication and
>> userspace evidence acceptance may still be required.
>> 
>> Add pci_tsm_pf0::ready and pci_tsm_set_ready(). While ready is false,
>> pci_tsm_context_get() returns -EACCES, preventing TSM virtual device
>> (vDEVICE) allocation.
>> 
>> Initialize ready to true to preserve existing TSM driver behavior. A
>> follow-up CCA patch will clear ready during connect and set it after
>> evidence-accept completes the required device setup.
>
>
> If the host is not yet happy with the device, it can simply not pass
> it through to a VM, what is the value of doing this blocking in the
> kernel? I'd drop this one. Thanks,
>
>


That is what this patch does. If IDE setup is not complete but the
device already has tsm0 attached and connected, pci_tsm_context_get()
returns an error from cca_vdevice_init(), preventing the device from
being assigned to the VM.

static int cca_vdevice_init(struct iommufd_vdevice *vdev)
{
.......
	ret = pci_tsm_context_get(pdev, viommu_tsm_dev);
	if (ret) {
		if (ret == -EOPNOTSUPP)
			return 0;

		return ret;
	}
}

int pci_tsm_context_get(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
{
	down_read(&pci_tsm_rwsem);
 ....
	pf0 = to_pci_tsm_pf0(pdev->tsm);
 	mutex_lock(&pf0->lock);
	if (!pf0->ready) {
		rc = -EACCES;
		goto out_unlock_mutex;
	}

}

-aneesh
