Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793621482;
	b=GKwVcQ5xS4I6/L7d8RUL1aCp2JoJbEkX6X9kqyYbon8Wuh/vVERZgtfW5vJSkiudm3/n
	 vZt/ldNjZq2saIDMFFIiWzksDvdHNi+5trq15pSDTPH0j4dU8rNAZuWBodUzswMMiWb/p
	 GbNHDZjGkdtslJFJAKmh2janL8mxwQk8GcQGi8x3BHWHW4jbHNvBrVC9SWHAwIFDe1of9
	 ydklitivwFR1ohfRJ+skt4kmGI0wzsLCS0YsVtgYzpKpPxEO449FH08dST0eFwBsNIugH
	 nRMI1Ml/Duk2rDCQlM4lbkeqAViF/Rwbo4ArOLl2SzhAcScW71MwgNTNo1oD4O0NVsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793621482;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=tvTx6m5Vu+Gzk7DYvJ/RY758ujXZGYWFugqF5JgTxv8=;
	b=e6qpRHApfKSVuHzACe5ommbENfVdZqjFCD31tzEH8LvsGeCxIKeuPfKxwFaCQdD0zZL2
	 BHlKqJ2U1af3ERlk45gAV0euwgNw53pPXHk2Os2n913L5RIwjxmtzJqPLKvAMpgl6YsPF
	 liD5m9AYEjrrSFmEOh02GgzUYQAk4XUCSXb+6NmyJcn9hnunmq6cDN6VDM4Ih1pypZAOI
	 wqND4pwxubFujjLRoLTm+FjNLq8RTN/qlApWnI7yATO5yJ4XEYqy9JrtKI8gNjhQgjuqd
	 llDKdWJz72A2HNHS1vCDmcPYcdYRkAzRbkuQ5Qmi1URmDq4hPjdJUJdXXbrMIACgtQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=uHdXgAYx;
	arc=none smtp.remote-ip=209.85.167.45
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25336606A338
	for <patches@lists.linux.dev>; Mon,  2 Nov 2026 12:11:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25336606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=uHdXgAYx
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5bfbc25a76aso4281434e87.0
        for <patches@lists.linux.dev>; Mon, 02 Nov 2026 04:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793621480; x=1794226280; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tvTx6m5Vu+Gzk7DYvJ/RY758ujXZGYWFugqF5JgTxv8=;
        b=uHdXgAYxJ0I2htooxCJAeumn04f2IAoLBK36HdQCe19Xbn/yvX/bC2tRVlEEAOVeZh
         ogFSp/fsYyj3JfmyEYHOLlrlZXPi2cLqA3bsDumoB41mi1PVJuulTpwSU5pTdYX8/I7R
         A1iVSd/ZoCTPCj6JbQbnf+0suO+/kYpuDAV06MNB5wso8nIs6AjxpumUSYQ973fxeTuo
         zdkH6VH20wEFPFN5zuZxxNSFZkA4CyxbbVrWb6XmDKqsS8aYefekNJA5rEdlra6WOLw7
         S0IJLVmwGb3gmcXF2FWobnDSnG8ddiTfea45qWaR9ZBsglML6KestFMeALiQXN4gxrJf
         vx+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793621480; x=1794226280;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tvTx6m5Vu+Gzk7DYvJ/RY758ujXZGYWFugqF5JgTxv8=;
        b=G3BzmnVezY4SM4u4c+Cb/Pfpb88MAA3kJfp72xakRiGp5xcEviPHGFSU5NfOHPa028
         5POxDJlL5GRAJjaw0ERuOgPEfV16F/vRaN3ZWXLcWNJ98I2jTNeHVUSJEK7CAV03wBLA
         jirnMdnt3jRtY6F0JTixJdccnBa1zSUHEY4h0+zX+TZc1NqFQ5vRlOEhE1mKTIp9j1KK
         Q88CgjFxmElFMP289svloELXU7ffGZYOdXgQMlLCFgqNdQ0O497X/jYWP/Vfudr76y0U
         hKc76mzzWIH6uV+xp38qZnq6hBwq5ln28zbF+wR5GDz9k2uudCcuLXdioZxlgp9zr/YY
         L3QQ==
X-Forwarded-Encrypted: i=1; AKwUvBxAtdgWjQ5GP7LZ7r7a7xbY03hWwG1IxfDrnoF9qNg5IB3GTI19cYPMlIcsizlkzOSFC2GtBLLc@lists.linux.dev
X-Gm-Message-State: APuU4Z9M4U8Y6UK90oW+6yB3tAacdElV0OLKhRqz1NlMtEkpqxzn93IU
	pF83f4Z38XfHQD9jH/PrYmU+w37VrKLHUrhozl8KTngrx/ytLmZFsULW01csVWPK1UE=
X-Gm-Gg: AYBFou3pz9Jk1UBDAX+p6c8LpehhdO67tH5TM36Nltea6MW23U1HLC6S+K3VGqKiE7H
	0t2rtlBYgPjpDodKjrsEpDgSSBcvyOjDGYKix6wEjfqiii5J1Dju6irvqz4LvlTNYt0DsUN0p35
	4cl+uTseS8EstxsGLvfJWA/fRPEk7v3wRX2cHpug66gVA0SDToseapYRKKnSJMWCRdXL8/nBYJp
	GwWfVDJVuJprvq/RPYuq5DFrf8idcWpTs8I8ewFGq22o/hmONU7K68bc+LdEifuQPJg209by6uw
	L43+aGqvREHPaoQ1iC9CRs+oA1jcBMAP8FMKA4O+S5m15yf/i88B7g2VkPnuyZ1NIO1D8JgAo+X
	gpB2sSFADqDTVkgVu2G136Kx4mNog0C6p2pER5Lj1I7BN5kHfK2WjexP/5cgjXM/eYYSthKh6g4
	Pwc7lQjt+2SCZr3lmjfTRfdC5gUOPnLYS0FqsQ9eaPYayBlyhFGT1Jzlv7WySYr0ljubwtG7/qq
	pCdXS/4Fp1JuA6dmDa87L8NJAf5/tzvkswb6+IWAj4XCXAUPxqNEG59v2zREgsqxAGDnfzJ9wpV
	coYRF1r0gSgOf9Pd7AqRrnHXaP9V5VBAn6iaVbM=
X-Received: by 2002:a05:6512:3090:b0:5be:41da:5c68 with SMTP id 2adb3069b0e04-5bfd1227c1amr3752635e87.39.1793621480254;
        Mon, 02 Nov 2026 04:11:20 -0800 (PST)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe6b59dbfsm962961e87.11.2026.11.02.04.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:11:18 -0800 (PST)
Date: Mon, 2 Nov 2026 13:11:14 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, 
	linux-coco@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Jonathan Cameron <jic23@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
Subject: Re: [RFC PATCH v1 08/11] PCI/TSM: Bind CTLV attestation to connected
 and locked contexts
Message-ID: <auh9uIC0TrR9pAZR@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-9-aneesh.kumar@kernel.org>
 <auSkHORl2mg_FiOf@FV6GYCPJ69>
 <20261030153900.GM3734323@nvidia.com>
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
In-Reply-To: <20261030153900.GM3734323@nvidia.com>

Fri, Oct 30, 2026 at 04:39:00PM +0100, jgg@nvidia.com wrote:
>On Fri, Oct 30, 2026 at 03:08:52PM +0100, Jiri Pirko wrote:
>> Wed, Oct 28, 2026 at 04:26:15PM +0100, aneesh.kumar@kernel.org wrote:
>> 
>> [..]
>> 
>> > 		available authentication methods for the device.
>> > 
>> > 		When present and the tsm/ attribute directory is present, the
>> >-		authenticated attribute is an alias for the device 'connect'
>> >-		state. See the 'tsm/connect' attribute for more details.
>> >+		authenticated attribute reports the TSM name only after secure
>> >+		session and stream setup succeed, otherwise an empty string.
>> >+		Connection control uses tsm/connect and tsm/disconnect.
>> > 		This is a "link" TSM attribute, see
>> > 		Documentation/ABI/testing/sysfs-class-tsm.
>> 
>> [..]
>> 
>> > static ssize_t authenticated_show(struct device *dev,
>> > 				  struct device_attribute *attr, char *buf)
>> > {
>> >-	/*
>> >-	 * When the SPDM session established via TSM the 'authenticated' state
>> >-	 * of the device is identical to the connect state.
>> >-	 */
>> >-	return connect_show(dev, attr, buf);
>> >+	struct pci_dev *pdev = to_pci_dev(dev);
>> >+	struct pci_tsm_pf0 *pf0;
>> >+	int rc;
>> >+
>> >+	ACQUIRE(rwsem_read_intr, lock)(&pci_tsm_rwsem);
>> >+	rc = ACQUIRE_ERR(rwsem_read_intr, &lock);
>> >+	if (rc)
>> >+		return rc;
>> >+
>> >+	if (!pdev->tsm || !pdev->tsm->dsm_dev)
>> >+		return sysfs_emit(buf, "\n");
>> >+
>> >+	pf0 = to_pci_tsm_pf0(pdev->tsm);
>> >+	if (!pf0 || !pf0->stream_connected || pf0->base_tsm.error)
>> >+		return sysfs_emit(buf, "\n");
>> >+
>> >+	return sysfs_emit(buf, "%s\n", dev_name(&pdev->tsm->tsm_dev->dev));
>> > }
>> > static DEVICE_ATTR_RO(authenticated);
>> 
>> I had in mind removing this attribute alongside the staged connect
>> change and reporting authentication state through SPDM_GET.
>> 
>> This instead retains the attribute and changes when it reports the TSM
>> name. Could we settle that together with the SPDM_GET interface rather
>> than maintaining parallel authentication-state queries?
>> 
>> Jason, what do you think?
>
>I'm not keen on any of the sysfs, I'd like to understand who is
>expected to use this.
>
>If we imagine a systemd-device-accept-d kind of flow I don't see any
>need to duplicate things in attestation subsystem in sysfs..
>
>I'm not sure 'stream connected' is even right, as in my last note we
>should not consider the thing authenticated until we actually pass
>userspace EVIDENCE_ACCEPT, even if the TSM has established a SPDM
>session.

Agreed. The question if we can legally get rid of it at this point...
