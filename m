Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476275;
	b=z0fb37j3uIrI2WQ0Daenp3Xs6jXGsUzW6bsTnHToRD3zCuO2fYLVYriWKGza3HLD10fi
	 pcTMg+Z7kTWsaQTIfZUruRmqgzSxQKT2oEIbb/7J6HLvwnE+P+d2adOyXqZXYM3uxGLMS
	 Qur87RrRWpggpQKacP59o+OC5KuAq3v/qwJKD4B1kOi89x1VP1gzEn/UobtkiIa70AX1c
	 HaENFOXybbfv71C78a52M0qRaktYr3J2SF7bg3lG0MEZCyMO8SW0Ae7pfDGPzh1lPIW7k
	 EcBBiCHSr+s9IP+NtHITQJDRzrgh6RMLUzQupzJDc6BqXbdMiE3e+3l8kyL2KFUVFNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476275;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=wxRCE/LxPKOqv1o6tdSJqmKO1PZhC9s43hWGJ13wQD8=;
	b=mPoIFVF+0v75C9vj8YstCZaLexqXQqAOKARSCLwL6E0DKSgG/b0OYFUia8++bvWa9UMx
	 t4OWJh5vuYc4AkrdUbAsrHC8+0KzU2sS0Sv9+47AKm8pjbd1d7OKlKmv2gbAw0cucHUNF
	 NWRFbuO9QhtnxlMDbCbMDrgjNLFvp6e3xr55sBiFolyoFUG1oB+ej2W4viqjgVStlxcLJ
	 1c+sIp6+r4+/BEJW6Bwh11Chxl8v1wJjIX51t55WId0htKMxb6tCwp5U9mjdhfWNKRJUD
	 cYCRTmYh/3QDp/6z4YdSXcVVH7mJhJNxaVcr0jVNZaVGKQ763B/oTAyWkv9MpeugMtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ZohskrI/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B537606A321;
	Thu, 12 Nov 2026 09:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZohskrI/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F365E1F00A05;
	Thu, 12 Nov 2026 09:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794476274;
	bh=wxRCE/LxPKOqv1o6tdSJqmKO1PZhC9s43hWGJ13wQD8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ZohskrI/RQHQ3nr7RVll07GwmQqVVIdjCSuQyixKhz4IWTWjo9IyYMg7JF0BpBzBD
	 oZR0tDxPhgWgQ9OnT4Rwe2pRWYUISHgnuBICZNmn6GWPsaQj4+UGg5QPS0tc8UReOM
	 7T5PEFFT1BtMAl7f5vZzFxbvtCOLm/HFbIFllJtzEC8BxnZq/KW3mIEYOY3/8O+6gj
	 n7lfoynPM64P9ZsR+OaIa6PyGk07bB6aR25zTYMojFdcbxHpUwSiFjpt9EHMmTrxky
	 Ue3SklGO4UCYjS6jm7Vwm2JT3KL0tiVuV9mM68SRQjdMOqXI/z3yNXEROztqCxcQKE
	 y1p7bfZrHcnWA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
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
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot
 zero and establish streams after acceptance
In-Reply-To: <20261106193018.GK770409@nvidia.com>
References: <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
Date: Thu, 12 Nov 2026 15:07:43 +0530
Message-ID: <yq5a5wy2qtjs.fsf@kernel.org>
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

Jason Gunthorpe <jgg@nvidia.com> writes:

> On Fri, Nov 06, 2026 at 08:53:39AM -0700, Dave Jiang wrote:
>> 
>> 
>> On 11/4/26 9:54 AM, Dave Jiang wrote:
>> > 
>> > 
>> > On 11/4/26 6:41 AM, Jason Gunthorpe wrote:

 [ ... 13 lines skipped ... ] 

>> I generated a diagram that hopefully better reflects Option A with TDX better than the current public documentations:
>> 
>> Option (a) on TDX, with the current TDX Connect ABI: slot 0 only, no TDX
>> change. Numbers in the left margin point to the notes below.
>> 
>>   ---->   call                 <- - -   return
>>   <---->  SPDM request and response in clear text, relayed by the host
>>   <====>  the same, inside the SPDM session
>
> It looks OK, thanks.
>
> I have a few thoughts
>
> 1) I would very much like it if the core SPDM code in the kernel
>    can snoop the DOE messages from the TSM. If we do this then the
>    kernel can directly capture the full transcript:
>
>> (4)  |                    |                       | GET_VERSION            |
>>      |                    |                       |<---------------------->|
>>      |                    |                       | GET_CAPABILITIES       |
>>      |                    |                       |<---------------------->|
>>      |                    |                       | NEGOTIATE_ALGORITHMS   |
>>      |                    |                       |<---------------------->|
>>      |                    |                       | GET_CERTIFICATE slot 0 |
>>      |                    |                       |<---------------------->|
>> (5)  |                    |                       | KEY_EXCHANGE slot 0    |
>
> With perfect consistency on all vendors.
>
> Further, it will also be able to capture the GET_CERTIFICATE during
> the preamble so again we get greater consistency for everyone.
>
> I'm very interested in this because it frees the uABI from any
> variation in choices the TSM may have made. I have the full perfect
> transcript in the kernel and I will ALWAYS present the same uABI to
> userspace regardless what the TSM offers.
>
> Like a whole bunch of TSM FW API just to do this:

Can you help me understand why we need to snoop the DOE messages? IIUC,
the earlier proposal for 1.2 was to use Rust SPDM to perform the
following:

GET_VERSION
GET_CAPABILITIES
NEGOTIATE_ALGORITHMS
GET_DIGESTS
GET_CERTIFICATE for all slots in the slot_mask returned by GET_DIGESTS
CHALLENGE using the slot 0 key (At this point, we can also verify that
we received the certificates for all slots supported by the device.)

The host then select a slot and use it to establish the IDE connection?
(For intel we can only select slot 0 here?)

What does snooping provide in this context?

-aneesh



