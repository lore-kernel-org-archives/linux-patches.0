Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793980426;
	b=uiDXaA6iwmm61d4FktIu44SVSBckJ/XKBBHxnEm03uZ49k2tFN6Km+r+UeCOi7E01JhE
	 GOGxWzweWrkA0rfjw2RmUykldSn88iV0AsQaDNR/uc/lRzqFY1U3N/N9hh8me2gBcFa2x
	 CdPUliFkMukNYr6rT3jTJFcKhKIGwI5zZ0dyCLJ5zL3nqo8gtImU04LFU04vfqvI1+pnu
	 L9WMvXI1CAVQBmebnfnF+NJLhMcjoVdl0V+LXTOv5w+y9jvti6MmQsvA09OzRl1O3Zaxt
	 BhUpPOV5o/LuDy/7HaDS+jH4DLhki3HfbMJ+3+TvzlkTv7AWggN4StHf7HdIiJPIlQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793980426;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=dps5WF/IggJnTVL83uvHqseMY55YrjJcbUdz7oKiv34=;
	b=CSqekiDT+a6Z5cWXdXxh38c3ETX2yGPsFKRPIY+ZU1cTg/H2QDaJWU3dthTzhOSIuMjR
	 GrCRYRSI8Q6M9PJLcZoJh/L1gAR4WC6bckUdJ/qlaPNsjOXxAlLWOH/wU+arsv7HPMWuX
	 IXJ0o4Y5VBgEVdYAdt20Vs6ddzN2Y8tNwccXbCqy98PyRPT5auVuleTbFE7CSbgBHMTsX
	 r5vhEE/AK2BZyODfYZm57T/WqjU7+Dvo4vLSSwfB3nvP0gqCUhkFjc4eWitVpWgM3nqQw
	 eAR6KMnnHbM2t0uQ4/B9Otf+CXlZaoLI16DnJEz3lCIS/MPuNOG4SoaJFj3mYD8qVgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IyAP+gyF;
	arc=none smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341B4606A32C;
	Fri,  6 Nov 2026 15:53:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 341B4606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IyAP+gyF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793980423; x=1825516423;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=wUA0ox4t+zKVoXv+1VmNcEZr7YSip6He9swFvtvlQek=;
  b=IyAP+gyFLoUV1NIsruh5vdj2fP9sOQ4117fEBG/5PNolfrvYGEm7tE4C
   +ogTReWyFrmZAanQfsNNBu1aizNqELoLcy5XaHW98WCw/zUW6VwdbosNJ
   GpLGBHYs9putOvHoFEBdG3kBduTbtkqMwKPtafogNkLIcof8q+v2DyINp
   Mq6//0zibt/T9IgexfNhasKjRw2bwZpgfVkRh0Wm0Q9E/7sgty7JCElM8
   YfxIGybd6D17BN9xMTQi4bank2skrue0+eCuXWNke3j8haYKo5WYCjnAX
   J7gZOfI2aFmMwt7MV7iVXh+1Bx/4xYFYW2stVjTS/op93MIdjleNx3WX+
   g==;
X-CSE-ConnectionGUID: XFt7AXztRpqqhHqClUINug==
X-CSE-MsgGUID: 95MbPVZkQUWFMe7m3SuSZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11958"; a="2683812"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2683812"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 07:53:42 -0800
X-CSE-ConnectionGUID: rhJFmAhWR1u7ASOouCnfcA==
X-CSE-MsgGUID: kQcAXhHbS82z7IGTdkTmeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7337200"
Received: from smithj1-mobl2.amr.corp.intel.com (HELO [10.125.110.174]) ([10.125.110.174])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 07:53:41 -0800
Message-ID: <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
Date: Fri, 6 Nov 2026 08:53:39 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
From: Dave Jiang <dave.jiang@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>,
 "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
 Alexey Kardashevskiy <aik@amd.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Jonathan Cameron <jic23@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com> <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com> <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
Content-Language: en-US
In-Reply-To: <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/4/26 9:54 AM, Dave Jiang wrote:
> 
> 
> On 11/4/26 6:41 AM, Jason Gunthorpe wrote:
> <--snip-->
> 
>> Is there a PDF for TDX's SPDM flow someplace? I will try to draft a
>> more complete document
> 
> TDX connect architecture spec
> https://cdrdv2-public.intel.com/862706/Intel%20TDX%20Connect%20EAS%20354629%20004.pdf
> 2.7.5 Figure 2.6
> 
> TDX connect TEE-IO device guide
> https://cdrdv2-public.intel.com/861654/whitepaper-tee-io-device-guide-v0-7-0.pdf
> Appendix B.1.1 Table B-1

I generated a diagram that hopefully better reflects Option A with TDX better than the current public documentations:

Option (a) on TDX, with the current TDX Connect ABI: slot 0 only, no TDX
change. Numbers in the left margin point to the notes below.

  ---->   call                 <- - -   return
  <---->  SPDM request and response in clear text, relayed by the host
  <====>  the same, inside the SPDM session

 Userspace           Host kernel             TDX Module                 Device
 (systemd,            (PCI/TSM,                 (TSM)                    (DSM)
 verifier)            tdx-host)
     |                    |                       |                        |
=== sysfs connect ==========================================================
     |                    |                       |                        |
(1)  | connect            |                       |                        |
     |------------------->|                       |                        |
     |                    |                       |                        |
=== Step 1: START CONNECT ==================================================
     |                    |                       |                        |
     | START CONNECT      |                       |                        |
     |------------------->|                       |                        |
     |                    |                       |                        |
     | 0 (no-op)          |                       |                        |
     |<- - - - - - - - - -|                       |                        |
     |                    |                       |                        |
=== Step 2: query certificates, query VCA items ============================
     |                    |                       |                        |
     | query certificates |                       |                        |
     |------------------->|                       |                        |
     |                    |                       |                        |
     | -EOPNOTSUPP        |                       |                        |
     |<- - - - - - - - - -|                       |                        |
     |                    |                       |                        |
=== Step 3: FINISH CONNECT with slot S =====================================
     |                    |                       |                        |
     | FINISH CONNECT(S)  |                       |                        |
     |------------------->|                       |                        |
     |                    |                       |                        |
     | if S != 0:         |                       |                        |
(2)  | refused            |                       |                        |
     |<- - - - - - - - - -|                       |                        |
     |                    |                       |                        |
     | if S == 0:         |                       |                        |
(3)  |                    | TDH.SPDM.CONNECT      |                        |
     |                    |---------------------->|                        |
     |                    |                       |                        |
(4)  |                    |                       | GET_VERSION            |
     |                    |                       |<---------------------->|
     |                    |                       | GET_CAPABILITIES       |
     |                    |                       |<---------------------->|
     |                    |                       | NEGOTIATE_ALGORITHMS   |
     |                    |                       |<---------------------->|
     |                    |                       | GET_CERTIFICATE slot 0 |
     |                    |                       |<---------------------->|
(5)  |                    |                       | KEY_EXCHANGE slot 0    |
     |                    |                       |<---------------------->|
     |                    |                       | FINISH                 |
     |                    |                       |<======================>|
     |                    |                       | GET_MEASUREMENTS       |
     |                    |                       |<======================>|
     |                    |                       | GET_TDISP_VERSION      |
     |                    |                       |<======================>|
     |                    |                       | GET_TDISP_CAPABILITIES |
     |                    |                       |<======================>|
     |                    |                       |                        |
(6)  |                    | device info           |                        |
     |                    |<- - - - - - - - - - - |                        |
     |                    |                       |                        |
     | 0                  |                       |                        |
     |<- - - - - - - - - -|                       |                        |
     |                    |                       |                        |
=== Step 4: query certificates, query final transcript items ===============
     |                    |                       |                        |
     | query certificates |                       |                        |
     |------------------->|                       |                        |
     |                    |                       |                        |
     | slot 0's chain     |                       |                        |
     |<- - - - - - - - - -|                       |                        |
     |                    |                       |                        |
     | query transcript   |                       |                        |
     |------------------->|                       |                        |
     |                    |                       |                        |
(6)  | device info        |                       |                        |
     |<- - - - - - - - - -|                       |                        |
     |                    |                       |                        |
     .--- optional: fresh measurements for a caller's nonce ---------------.
     |                    |                       |                        |
     | nonce              |                       |                        |
     |------------------->|                       |                        |
     |                    |                       |                        |
(7)  |                    | TDH.SPDM.MNG(nonce)   |                        |
     |                    |---------------------->|                        |
     |                    |                       |                        |
     |                    |                       | GET_CERTIFICATE        |
     |                    |                       |<======================>|
     |                    |                       | GET_MEASUREMENTS       |
     |                    |                       |<======================>|
     |                    |                       |                        |
     |                    | new device info       |                        |
     |                    |<- - - - - - - - - - - |                        |
     |                    |                       |                        |
     | one-shot result    |                       |                        |
     |<- - - - - - - - - -|                       |                        |
     |                    |                       |                        |
     '---------------------------------------------------------------------'
     |                    |                       |                        |
=== Step 5: ACCEPT (host) ==================================================
     |                    |                       |                        |
     | ACCEPT             |                       |                        |
     |------------------->|                       |                        |
     |                    |                       |                        |
(8)  |                    | TDH.IDE.STREAM.*      |                        |
     |                    |---------------------->|                        |
     |                    |                       |                        |
     |                    |                       | IDE_KM key programming |
     |                    |                       |<======================>|

Notes:
(1) Creates the attestation endpoint only; no TSM call.
(2) TDH.SPDM.CONNECT has no KEY_EXCHANGE slot input.
    CERTIFICATE_SLOT_MASK, the only slot field in SPDM_CONFIG_INFO_T, is
    the "Device certificate request slot mask" [ABI 3.3.2.2]: it picks
    which chains to read, not the slot. So userspace can't enumerate
    slots by repeating step 3.
(3) TDH.SPDM.CREATE runs first. The kernel sets CERTIFICATE_SLOT_MASK to
    0x01, so the TSM reads only slot 0's chain. It could also read slots
    1-7 inside the session [GUIDE B.1.1, Table B-1], but no signature
    would cover them: KEY_EXCHANGE hashes only the chain of the slot it
    names [SPDM 10.18.1]. So (a) doesn't report them.
(4) The host relays each message over DOE [ABI 3.3.3, 4.2.20]. No
    GET_DIGESTS and no CHALLENGE [ARCH 2.7.5, Figure 2.6]. The guide's
    session setup example also reads slot 0's chain before KEY_EXCHANGE
    [GUIDE B.1.1, Table B-1].
(5) The TSM verifies the KEY_EXCHANGE_RSP signature [SPDM para 630]. The
    host trusts that check, so it keeps no KEY_EXCHANGE messages.
(6) SPDM_DEVICE_ATTESTATION_INFO_T [ABI 3.3.2.4]: SPDM and TDISP
    capabilities, TDISP version, the requested chains, and MEASUREMENT.
    MEASUREMENT is the signed SPDM measurement log, Concatenate(VCA,
    GET_MEASUREMENTS_REQUEST1, MEASUREMENTS_RESPONSE1, ...,
    GET_MEASUREMENTS_REQUESTn, MEASUREMENTS_RESPONSEn) [SPDM 10.12.3].
    The last MEASUREMENTS carries the signature. The TDX Module keeps
    the info's digest. The kernel keeps the info as immutable startup
    data.
(7) DEV_INFO_RECOLLECTION puts the caller's nonce in GET_MEASUREMENTS
    [ABI 3.3.2.3], and the TSM reads the chains again
    [GUIDE B.1.5, Table B-5]. The device signs the new measurement log,
    nonce included [SPDM 10.12.3]. That signature is what protects the
    new measurements. The verifier must check it with the leaf key of
    slot 0, the slot KEY_EXCHANGE used, and must find its nonce in the
    log to know the result is fresh. The kernel hands the result over
    once and doesn't store it.
(8) TDH.IDE.STREAM.CREATE, then TDH.IDE.STREAM.KM. IDE setup moves from
    connect to ACCEPT.

Sources:
  [ABI]    TDX Connect ABI Reference Specification 2.1 V0.66
           https://cdrdv2.intel.com/v1/dl/getContent/858625
  [ARCH]   Intel TDX Connect Architecture Specification, 354629-003
           https://cdrdv2.intel.com/v1/dl/getContent/773614
  [GUIDE]  Intel TDX Connect TEE-IO Device Guide, 354272-002
           https://cdrdv2.intel.com/v1/dl/getContent/772642
  [SPDM]   DMTF DSP0274 1.4.1

