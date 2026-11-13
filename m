Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794560110;
	b=4Lu+Iwyvq8X/X6nyQ72nuQrvcprSwxHaa4vsz3LZScWbm//oxF8BTSI6cjsmc0GvLjVs
	 SGzqY6oV9ZPwQvxHJWyWRtl3ODRnvPgvBRFz7sU2jn+DBXIKfAyZ11NYFEgMcbmzdYpLh
	 1FsyyEtpR7Td/b9URn91jOZHj+130/42IYt2qRxb32fDmHN6z4jzh44mVlGt0DIEGLLXR
	 eMvGRYz6sVHZREDK079x0LOTzrI/Bz1f0hoBvmgVYDzrM6+WxgbnSvGC+EeQ4vGpO0SlH
	 xiV0fQb+hiBNth5eTVPxrZ2T61bmnoQiJzSNm/GFRWBcxK2AnzXmZWUkCTowwWLxhYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794560110;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=eJ31T/Lr5TEyidApeRQUGzQiBzD9JD228sfEvM4u9sg=;
	b=zY3axuU5gDGDXo2F70NVYq8rhMxQQ2Xwdn1U9sIcpAvYjbG4659+E6M3HBQ7hNlZQyhk
	 RYX0bpHL7tbfReZc+NwdFxz94wX8t8UMOGSQNvXTHHu7WOrhMtS5l/s4TRck6mmizVaNn
	 SPefbxMKxXRmudpz0cX9yZxCLT0lMj+oHY8GLKi3RDRzQSwQXkRnEj9UvlJj8lj+BFKpn
	 AhEe1p2GvGjPekYM13+ekeTqyyrz6wTajjPf53TZrpuTfT51WWpksw/4PEGueu9IOBopN
	 HOEeTrGnkXDl0aqnBcx7X+zqi3Bxf9+ZDPR8h9U//DLAuO/gw5j8vKzw3gy09oysOVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DkCVkZSA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E8C606A31C;
	Fri, 13 Nov 2026 08:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DkCVkZSA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD011F000C4;
	Fri, 13 Nov 2026 08:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794560110;
	bh=eJ31T/Lr5TEyidApeRQUGzQiBzD9JD228sfEvM4u9sg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=DkCVkZSAoCpscFh6hXJ9lMZ4AtmBK4/3KrjesL144ZQswE32c9zsfPxnN51GYNbnO
	 X8n/lnuIfuxfmRNqTIMpvyOBpZYKMMoKdwFaTxWIh4Fe0SprNnwoU+n25BrtlORCcy
	 h69sqaegkmWGSbH7nCZnVTau+ED+6WEYxO8G5rqPLHf4yUMTtnuhXb2Krj5C3BUSJ3
	 RPcJbKr5/6yNx7tGoBK4ZMI8TIAnHG+zZD6WaYDDDQw3CL1QAa60lz0hk/oMVz1PKD
	 GVGOje7+zRhIBFSCKuBNcf0jD4JFy1AI+Js0jBi63gYhF8LXKHWSJVuzVULjK2kMfU
	 00dkafaMbPT2Q==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Dave Jiang <dave.jiang@intel.com>, "Reshetova,
	Elena" <elena.reshetova@intel.com>,
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
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alistair <alistair23@gmail.com>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot
 zero and establish streams after acceptance
In-Reply-To: <20261112145254.GL738765@nvidia.com>
References: <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com> <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
Date: Fri, 13 Nov 2026 14:24:59 +0530
Message-ID: <yq5abj7tm7q4.fsf@kernel.org>
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

> On Thu, Nov 12, 2026 at 03:07:43PM +0530, Aneesh Kumar K.V wrote:
>> > Like a whole bunch of TSM FW API just to do this:

 [ ... 38 lines skipped ... ] 

>
> Capturing the transcript makes everything 100% perfectly consistent
> for everyone. Userspace sees *the transcript* as defined by SPDM not
> some mangled, truncated or processed version that the TSM decides to
> provide.
>
> Userspace gets to see KEY_EXCHANGE which means the verifier can prove
> the certificate binding, this is the ONLY way to let the verifier do
> this proof if it wants.
>

To clarify, is this only needed if the verifier wants to perform an
independent verification? The RMM already verifies KEY_EXCHANGE_RSP, and
we trust the RMM.

>
> Further with capture we have a nice primitive to pause and do slot
> selection before going to KEY_EXCHANGE. If we know the kernel has
> capture then the ideal FW design for 1.3 multikey is much simpler and
> clearer (more like ARM).
>
> Also, ARM decided to do capture already, but directed by the TSM.  I
> think it is the right and best idea, they just made the implementation
> too narrowly specific. eg it doesn't split up VCA, it doesn't capture
> 100% of everything to get KEY_EXCHANGE, etc. Trivial to fix while
> upgrading to support 1.3
>

So, not everyone needs DOE snooping? Architectures without a
firmware-directed capture mechanism can use DOE snooping to collect the
required data on the host. Would the flow for SPDM 1.2 look like the
following?

Host                              RMM                              Device
|                                 |                                  |
| RMI_PDEV_CREATE(slot 0)         |                                  |
|-------------------------------->|                                  |
|                                 |                                  |
| RMI_PDEV_COMMUNICATE loop       |                                  |
|-------------------------------->|                                  |
|                                 | GET_VERSION / VERSION            |
|                                 |<-------------------------------->|
|                                 | GET_CAPABILITIES / CAPABILITIES  |
|                                 |<-------------------------------->|
|                                 | NEGOTIATE_ALGORITHMS / ALGORITHMS|
|                                 |<-------------------------------->|
| Cache VCA exported by RMM       |                                  |
|<--------------------------------|                                  |
|                                 |                                  |
|                                 | GET_CERTIFICATE(slot 0) /        |
|                                 | CERTIFICATE response chunks      |
|                                 |<-------------------------------->|
| Cache chain exported by RMM     |                                  |
|<--------------------------------|                                  |
|                                 |                                  |
|                         PDEV_NEEDS_KEY                             |
|                                 |                                  |
| Extract slot 0's leaf key       |                                  |
| RMI_PDEV_SET_PUBKEY(key 0)      |                                  |
|-------------------------------->|                                  |
|                                 |                                  |
| RMI_PDEV_COMMUNICATE loop       | KEY_EXCHANGE(slot 0)             |
|-------------------------------->|--------------------------------->|
|                                 | KEY_EXCHANGE_RSP                 |
|                                 |<---------------------------------|
|                                 | Verify response signature        |
|                                 |                                  |
| NEW: cache complete             |                                  |
| KEY_EXCHANGE request and        |                                  |
| KEY_EXCHANGE_RSP, with signature|                                  |
|<--------------------------------|                                  |
|                                 |                                  |
|                                 | FINISH / FINISH_RSP              |
| Relay                           |<-------------------------------->|
|                                 |                                  |
|                         PDEV_READY                                 |
|                                 |                                  |
| NEW: request slot discovery     |                                  |
|-------------------------------->| GET_DIGESTS / DIGESTS [secure]   |
| Relay ciphertext                |<-------------------------------->|
| Receive RMM-exported slot info  |                                  |
|<--------------------------------|                                  |
|                                 |                                  |
| NEW: request certificate slot 1 |                                  |
|-------------------------------->| GET_CERTIFICATE / CERTIFICATE    |
| Relay ciphertext                | [secure session]                 |
|                                 |<-------------------------------->|
| Cache RMM-exported chain 1      | Retain reference chain digest    |
|<--------------------------------|                                  |
|                                 |                                  |

That is, we can use the existing RMI_PDEV_COMMUNICATE-based host caching
to obtain this data, while issuing GET_DIGESTS and GET_CERTIFICATE for
the selected slot over the secure session established by the RMM? (these
blobs will be returned from RMM with req_send = 0 and req_cache = 1)

If GET_DIGESTS and GET_CERTIFICATE(selected slot) are issued after the
secure session is established, DOE snooping cannot capture their
plaintext responses. I am therefore still unclear how the DOE snooping
design handles this data.

In the end, the host has the certificate chain for slot 0, which was
used to establish the secure SPDM session, and the certificate chain for
the selected slot, which was fetched over that trusted session. The RMM
also returns the chain digests. The host can compare the leaf keys for
slot 0 and the selected slot, and can be sure that it received all
supported slots because the slot information was obtained over the
secure SPDM session.

If the verifier wants to independently verify the session in addition to
the verification already performed by the RMM, it can do so because it
has the VCA, the slot 0 certificate chain, and the
KEY_EXCHANGE/KEY_EXCHANGE_RSP transcript. This independent verification
is optional?

BTW, this proposal does require RMM changes. I have also omitted SPDM
1.3 multi-key support from this diagram because it will be easier to
follow once the SPDM 1.2 flow is clear.

-aneesh
