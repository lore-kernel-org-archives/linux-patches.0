Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793980435;
	b=mHV+JRgC4MA4zEmon7YqqMmZ9f3ZaEmgc4o1EYseBxinRIyKq9smx5GawlL6GbHj8PfN
	 As5tI7fKd0q5GaMfKdBWQwIbRGCewyRJmTNX4GqFthcwXEzXB7hHAb6fF7itsRzAJ+MSE
	 4l3J0ZbartsC9FGftYN0TzyZlj9Ef/VFE71M7zNvxhpXdTnE5U/VmIwrdfme2Rz8gp2R7
	 RoF8QLnzsp8pqZb/vpx4iMYSU/bwWlS0pS3PjYhQq1AgghW7LfXihM5yjh0HfGIL5Sa18
	 h23IL0urOU+zhxxa6qhnyfnCDqngzblKLc08DOi8ZNRjRRAlE3OFFV790vGw2EiJsEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793980435;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=Y0mGGhJc8VUTY1TBpIy6YE9cjB2CiWx5oRfzsUl8w78=;
	b=h7AtQnUfdEV24L9u4CI0GD02l+3lV2CsK2JRp4OfUI+zeuUDelhGEtXJgvxxCvEBQjEb
	 Q5LXl9+o4okRToK0P0t7LMeWpebWebF4fgEamoAg8WHEvppS2X7suShEkAcPaUzP6s0bD
	 cJpQ6ZPmj60CcvoUTMiimrIlrDMicIUK032dKNAxfUTHBcC1dw66Cnr2a/7PDOgMJ+caq
	 s/LUhYEnL9HwFQu3nMb2ZFQ4qqszWGisBdr3PK4gSPZF+p2w3Debgwq0YzpsXERwEhP5r
	 UL+tZipuQETxLoVstnWgXxsjQ60eMKVWfgU2c3X+mfBxIm7my9mDgw+v4T1tM+Y6JGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cwv8IqBc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9C1606A32C;
	Fri,  6 Nov 2026 15:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cwv8IqBc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BB11F0089F;
	Fri,  6 Nov 2026 15:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793980434;
	bh=Y0mGGhJc8VUTY1TBpIy6YE9cjB2CiWx5oRfzsUl8w78=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Cwv8IqBcwnQSgaSXC89A7jOJRg7DAD/WtVK7MJN72ZnHJ87oAIoT8mtSWB/ifIsxH
	 1wss+z1Z9QLjeN5lwqlG6uLTMDET9+DoeX9hzOHaN1PuVT+6+aL/IktDm6lOmhYipl
	 Fx/kpXiLw83fh3YGM2eVamImPHUI7rByqfdFbpAGMHYw4SMdZxdmaCAiaifui7mQeZ
	 f+UTj0xon9HySQMH3YWKBE1020JJjzuKW/uPELtil2i45qbLzUbrfcTWJ2e0DSy/xu
	 xPr+YOE1BJ6LhbPCbXKiyw0VHm5a25FBBlFpaUAqP9hAhENhFgG4LfAQoaYwS4hWIv
	 5p+Ul7YEQ7cDQ==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian,
	Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>, "Edgecombe,
	Rick P" <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot
 zero and establish streams after acceptance
In-Reply-To: <DS4PPFA84FA90FC3969F2B8388087CDDF67E7762@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com> <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com> <yq5ay0b6pdu6.fsf@kernel.org>
 <DS4PPFA84FA90FC3969F2B8388087CDDF67E7762@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
Date: Fri, 06 Nov 2026 21:23:44 +0530
Message-ID: <yq5aeccyot13.fsf@kernel.org>
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

"Reshetova, Elena" <elena.reshetova@intel.com> writes:

>> Jason Gunthorpe <jgg@nvidia.com> writes:
>> 
>> > On Tue, Nov 03, 2026 at 12:01:43PM +0000, Reshetova, Elena wrote:
>> >
>> > We will need some multi-step sequence from the uABI perspective:
>> >
>> > 1) CTLV command START CONNECT:
>> >     TSM does:
>> >      GET_VERSION / VERSION                          (VCA: Version)
>> >      GET_CAPABILITIES / CAPABILITIES                (VCA: Capabilities)
>> >      NEGOTIATE_ALGORITHMS / ALGORITHMS              (VCA: Algorithms)
>> >      GET_DIGESTS / DIGESTS
>> >
>> > 2) CTLV commands:
>> >     query certificates. TSM will issue on demand:
>> >      GET_CERTIFICATE / CERTIFICATE                  (every slot in the slot mask, all
>> chunks)
>> >     query VCA items
>> >
>> > 3) CTLV commands:
>> >    FINISH CONNECT with slot:
>> >     TSM for 1.2 does:
>> >      CHALLENGE(slot 0, fresh nonce) / CHALLENGE_AUTH
>> >      KEY_EXCHANGE(slot S) / KEY_EXCHANGE_RSP       (clear text)
>> >      FINISH / FINISH_RSP                           (in session, opaque to host)
>> >     Or for 1.3 multi-key does:
>> >      KEY_EXCHANGE(slot S) / KEY_EXCHANGE_RSP       (now includes DIGESTS
>> and CERTIFICATE)
>> >      FINISH / FINISH_RSP                           (in session, opaque to host)
>> >
>> 
>> 
>> Does this split require us to guarantee that no GET_VERSION can be
>> issued in between? 
>
> Yes, in my opinion TSM must enforce it because as you said, GET_VERSION
> resets everything.
>

How can TSM enforce this? Another subsystem could issue GET_VERSION
through the DOE mailbox. IIUC, TSM would only detect a transcript
mismatch when KEY_EXCHANGE_RSP validation fails. Is that correct?

>
>> Another GET_VERSION in the same requester context
>> between START CONNECT and FINISH CONNECT would reset the responder's
>> negotiated state and transcript, right?
>> 
>> If so, can we avoid this split and always use RustSPDM, with or without
>> multi-key support?
>> 
>> Something like:
>> Kc: public key used to verify CHALLENGE_AUTH from slot C.
>> Ks: public key selected for session establishment by user using slot S.
>> C and S may be different slots.
>> 
>> Host / RustSPDM:
>>     VCA -> GET_DIGESTS -> fetch certificate chains
>>     CHALLENGE(C) -> retain the messages and CHALLENGE_AUTH signature
>>     Stop communicating with the device.
>
> GET_DIGESTS only gets you digests, you still need GET_CERTIFICATES
> to actually fetch certs.
>

yes that is correct.

>
>> 
>> Host / userspace:
>>     Examine the discovery results.
>>     Select slot S and validate its certificate chain/key Ks.
>> 
>> Host -> RMM/firmware:
>>         Supply:
>>           - C and Kc, S and Ks
>>           - Algorithms
>> 
>>     Fresh GET_VERSION -> CAPABILITIES -> ALGORITHMS
>
> How do you propose to deal with the fact that here TSM
> may agree with a device on different params than rustSPDM
> above?
>

I suppose we would need to pass all of those parameters for the host ->
RMM/firmware interaction. I had assumed that the algorithms were the only
negotiated parameters needed for SPDM session establishment. Would validating
Kc and Ks require passing additional details from the RustSPDM exchange to the
firmware?

>
>
>>     GET_DIGESTS immediately after VCA
>>     GET_CERTIFICATE(C), GET_CERTIFICATE(S)
>>     Check that Kc is the leaf public key in chain C. // Can the slot number change
>> by now ?
>
> In addition to VCA influencing the content of the slots, 
> a device could have a FW upgrade in between rustSPDM
> step and this step and this could change the content of
> the slots. 
> But if you fully verify the actual cert chain and key itself
> you can reject such cases. So your way is also doable with
> additional checks, but I am worried about the problem to 
> agree on the same VCA.
>

My main question is whether we should avoid splitting the context and
relying on the host not to disrupt the sequence. I wonder whether that
would be a poor API design and whether we can avoid it. Is that a goal
we should pursue?

-aneesh
