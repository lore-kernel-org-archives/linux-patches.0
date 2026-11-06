Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793970877;
	b=v+rcR8375eh4p4+/XAvk2ZSAjmSDhSTkbJm682Tiu703O7Xcvmf8bpcBkk0jDL+WMpFQ
	 V1HWrPe4SsIuVlScSRbWL4+EjDJwdDAHQT8C1Zaklw4fKeDZL7GqdTzxjAHWJEKR1up0K
	 u8AhYxAEyJokiyvaP3aWZeT6XY120cExmPdgypcXfKaBoWUB8x4hQpSBoAromlFTSuG1u
	 ydta75dOQTEGYAhN1kOiBD+ZnkGWTEQxG2a9I/8V0ldCuj/0vAk9Lrq5xvlz+JpA/5Sd5
	 /wMkwiRMdydwkXLzPNSiLT/WVUu4Rhwl5sj1j9FrdTYyDtFBEu5mOEpMoYIle88gpnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793970877;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=qZjwqiba5bUNH3pkEKo3iy7rbBZN483QtsXx0LXeUhg=;
	b=ER+LHgxlxm6KUFouMxIRUAItYxOe1lef3oHeIEkCgzjhVTZbMdLB2RyUqFBcpjhJP1WC
	 lGQDjxiVVc6wPHaAFjAvhzhGJl8XLh2qJUSyfaQ9kvCI/2oayoHzqifWhPObHFEizn62+
	 xq2TayAlNhHJSb4x6The5oeIULyKpkqiiZJfQxI3P/y4uRxQEf65Rokwd/R6c1dapCMxZ
	 cb01/IRNTRPXkqGwV93puZQ8LZB/xsHNqluvYKuh679it+qIzH6ahHK8hy/RQunY7mUU4
	 lC/SXuTzX13oQsnLIbn7ShPyifntDY6p2hjgfmohYgheB4uh99H5D4uGdVYEH4AX6GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O5f70+Kv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53765606A326;
	Fri,  6 Nov 2026 13:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O5f70+Kv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013F01F008A1;
	Fri,  6 Nov 2026 13:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793970877;
	bh=qZjwqiba5bUNH3pkEKo3iy7rbBZN483QtsXx0LXeUhg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=O5f70+KvoQ3ewOhGX8DsJ5bLgXg0XXhsW9ZfpBhFgcSN+ecOlUJZBmfiLfBDlw8X4
	 JT7/ZKreXJPIeqsrmYD5XLXQxNuTqc9s9KxnPX5YXLK5DB98w6NwjotJ6PGz9JNeaP
	 gNun7vjI0D9yBDNlHqRh8x6HzgwHvvKNjIVfy378yjBOlZ1T07P1kY12Gn1Of7u0ki
	 GzW90yE67vSGU9JAdIERrm/plLfsefBllSJ0jKjzkCi6TKP6zSfbFs4JBlk30cnra3
	 Yj+UnOycwjYCPygezMJq5aiM294fXEyTszOHU8wRHp/sF5We5hxeJzGPrc+ozaGccl
	 illNDMsQiRytA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Alexey Kardashevskiy <aik@amd.com>, linux-coco@lists.linux.dev
Cc: Jiri Pirko <jiri@resnulli.us>, Kevin Tian <kevin.tian@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
Subject: Re: [RFC PATCH v1 09/11] crypto/ccp: Defer SEV-TIO link setup until
 evidence acceptance
In-Reply-To: <e8785bcb-45ed-492f-af66-deadfba6ac25@amd.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-10-aneesh.kumar@kernel.org>
 <e8785bcb-45ed-492f-af66-deadfba6ac25@amd.com>
Date: Fri, 06 Nov 2026 18:44:27 +0530
Message-ID: <yq5ao6c2p0ek.fsf@kernel.org>
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

> On 29/10/26 02:26, Aneesh Kumar K.V (Arm) wrote:
>> AMD SEV-TIO currently establishes its SPDM session and enables IDE during
>> connect, before userspace can retrieve or accept the device identity.
>> Move AMD link setup behind its evidence_accept callback.

 [ ... 49 lines skipped ... ] 

>>   	dev_data->req.sla = 0;
>>   	dev_data->resp.sla = 0;
>>   	dev_data->scratch.sla = 0;
>>   	dev_data->respbuf = NULL;
>>   	dev_data->reqbuf = NULL;
>> -	sla_free(dev_data->output, tio_status->spdm_out_size_max, true);
>> +	sla_free(dev_data->output, dev_data->output_len, true);
>> +	dev_data->output = SLA_NULL;
>
> This is a bugfix (thanks for pointing!) and does not belong here. Want to repost, or I can (and should, really)?
>
>>   }
>>   
>>   static int spdm_ctrl_alloc(struct tsm_dsm_tio *dev_data)
>> @@ -674,7 +672,7 @@ static int spdm_ctrl_alloc(struct tsm_dsm_tio *dev_data)
>>   	dev_data->output = sla_alloc(dev_data->output_len, true);
>>   
>>   	if (IS_SLA_NULL(dev_data->req) || IS_SLA_NULL(dev_data->resp) ||
>> -	    IS_SLA_NULL(dev_data->scratch) || IS_SLA_NULL(dev_data->dev_ctx)) {
>> +	    IS_SLA_NULL(dev_data->scratch) || IS_SLA_NULL(dev_data->output)) {
>
> the same.
>
>>   		ret = -ENOMEM;
>>   		goto free_spdm_exit;
>>   	}
>> @@ -773,7 +771,8 @@ int sev_tio_dev_create(struct tsm_dsm_tio *dev_data, u16 device_id,
>>   free_data_pg_exit:
>>   	snp_free_firmware_page(data_pg);
>>   free_ctx_exit:
>> -	sla_free(create.dev_ctx_sla, tio_status->devctx_size, true);
>> +	sla_free(dev_data->dev_ctx, tio_status->devctx_size, true);
>
> and this. Is this codex? :)
>

Yes. 

>
>> +	dev_data->dev_ctx = SLA_NULL;
>>   	return ret;
>>   }
>>   

 [ ... 179 lines skipped ... ] 

>> +
>> +	/* Reserve TC0's stream ID without programming or enabling IDE. */
>> +	memset(ids, 0xff, sizeof(ids));
>> +	ids[0] = dev_data->ide[0]->stream_id;
>> +	dev_data->cert_slot = 0;
>> +	ret = sev_tio_dev_connect(dev_data, BIT(0), ids, dev_data->cert_slot);
>> +	ret = dsm_collect_identity(dsm, ret);
>
> Cannot librspdm do that collection, directly via DOE? Ideally in the
> generic code? There nothing special for the PSP to do and stopping
> SEV-TIO's connect half way is weird.
>


This patch does not use rust-spdm and avoids introducing that
dependency. It uses slot 0 to initiate the session, retrieve the
certificate chain, and return it to the host. After host approval, it
resumes the session and enables IDE. Only slot 0 is supported, and the
host can reject the device identity before IDE is enabled.

>
>
>> +	if (!ret)
>> +		return 0;
>> +
>> +disconnect:
>> +	dsm_disconnect(pdev);
>> +	return ret;
>> +}
>>   
>> -	tc_mask = streams_setup(dev_data->ide, ids);
>> +static int dsm_evidence_accept(struct pci_dev *pdev)
>> +{
>> +	struct tio_dsm *dsm = pdev_to_tio_dsm(pdev);
>> +	struct tsm_dsm_tio *dev_data = &dsm->data;
>> +	u8 ids[TIO_IDE_MAX_TC];
>> +	int ret;
>>   
>> -	dev_data->cert_slot = pdev->tsm->evidence.slot;
>> -	ret = sev_tio_dev_connect(dev_data, tc_mask, ids, dev_data->cert_slot);
>> -	ret = sev_tio_spdm_cmd(dsm, ret);
>> -	if (ret)
>> -		goto free_exit;
>> +	if (pdev->tsm->evidence.slot)
>> +		return -EOPNOTSUPP;
>> +	if (!dsm->pending_spdm)
>> +		return -ENODATA;
>>   
>> -	streams_enable(dev_data->ide);
>> +	streams_setup(dev_data->ide, ids);
>
>
> I kinda get the appeal of not enabling IDE before accepting but in
> practice the host still has to have a knob in IOMMU to prevent a
> malicious device from DMAing T=1 trafic so accept() would trigger
> enable_dma() hook.
>

This enables IDE; it is not the TDISP RUN transition. Am I missing
something here?

>
>
>> +	ret = sev_tio_spdm_cmd(dsm, dsm->pending_spdm);
>> +	dsm->pending_spdm = 0;
>> +	if (ret)
>> +		goto err_session;
>> +	dsm->session_connected = true;
>>   
>> +	ret = streams_enable(dev_data->ide);
>> +	if (ret)
>> +		goto err_session;
>>   	ret = streams_register(dev_data->ide);
>>   	if (ret)
>> -		goto free_exit;
>> -
>> +		goto err_session;
>>   	return 0;
>>   
>> -free_exit:
>> -	sev_tio_dev_reclaim(dev_data);
>> -
>> -	streams_disable(dev_data->ide);
>> -ide_free_exit:
>> -
>> -	streams_teardown(dev_data->ide);
>> -
>> +err_session:
>> +	/* Disconnect owns cleanup after firmware or IDE setup has started. */
>> +	pdev->tsm->error = true;
>>   	return ret;
>>   }
>>   
>> @@ -339,14 +468,20 @@ static void dsm_disconnect(struct pci_dev *pdev)
>>   	struct tsm_dsm_tio *dev_data = &dsm->data;
>>   	int ret;
>>   
>> -	ret = sev_tio_dev_disconnect(dev_data, force);
>> -	ret = sev_tio_spdm_cmd(dsm, ret);
>> -	if (ret && !force) {
>> -		ret = sev_tio_dev_disconnect(dev_data, true);
>> -		sev_tio_spdm_cmd(dsm, ret);
>> +	/* A paused or failed connect needs forced firmware cleanup. */
>> +	if (dev_data->reqbuf && dev_data->respbuf) {
>> +		force |= !dsm->session_connected;
>> +		ret = sev_tio_dev_disconnect(dev_data, force);
>> +		ret = sev_tio_spdm_cmd(dsm, ret);
>> +		if (ret && !force) {
>> +			ret = sev_tio_dev_disconnect(dev_data, true);
>> +			sev_tio_spdm_cmd(dsm, ret);
>> +		}
>>   	}
>>   
>>   	sev_tio_dev_reclaim(dev_data);
>> +	dsm->session_connected = false;
>> +	dsm->pending_spdm = 0;
>>   
>>   	streams_disable(dev_data->ide);
>>   	streams_unregister(dev_data->ide);
>> @@ -357,6 +492,8 @@ static struct pci_tsm_ops sev_tsm_ops = {
>>   	.probe = dsm_probe,
>>   	.remove = dsm_remove,
>>   	.connect = dsm_connect,
>> +	.evidence_accept = dsm_evidence_accept,
>
> I saw in your branch you are ditching the connect() hook, is that the plan? Thanks,
>


Yes. In the full branch, once rust-spdm is integrated, this entire flow
moves to the SPDM accept/evidence_accept phase.

>
>
>> +	.evidence_types = BIT(PCI_TSM_EVIDENCE_TYPE_CERT0),
>>   	.disconnect = dsm_disconnect,
>>   };
>>   
>

-aneesh
