Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794587898;
	b=iUy43IO9CU7iJ+fkEl6Y5P/AKjbJ/6k8jeN6fPpqEAtJveMpj12uv5hKajk4wqlZCiDI
	 9qOMeFHtqY5dumkNKKnuqbTGqFRy136OVrm8eHy6r4a2zBzlKLwc7YlBARe1WWoHkjSGG
	 fs1739lp/ZxJiJrX+qd9H/NGULSR6s2NzbPGxUqIecqQX2FXn1eJxo8i7OVF4rkS9L3MU
	 5fIZNexrnw0vZvxTgkHczgOIsDK75G6s14UAinPw2QjZV9hE7g7X4CLgcnGiMtW5qI+ul
	 yWjxS7HHoCX1PvewfryidBPmuPEd9WCEkfeAIlQGzd0Q4IqlFPDMCmpoDVyoN9rzE3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794587898;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=ECa4v0ymAEdrf36TMzDEI0AgHj/I0QXy3tVu9aZBtW4=;
	b=ueqOeRtdb/5ye0aR0mC87y389TskUmtVekbrxCycpI49Fe3uX14qwaFOBP7aCKpjtg0e
	 gQkKcpPHf4I2FpMYZ6k/xz9AhWZgkxuXugXCTBUXG1kfzFnuQQ56SAor9a3l5vzJevf3W
	 PGX9TRpvttk6yR9aJhAeCNIxBherTVDprgnqzFPodz9KjlY5djPIToRYrIrsyY9tZsQfN
	 tmosa1XmChtO3Rgweti/zXA7tIY1VZU0nunICq2QIcTEa4vrU6nC8s2K8+a+kGWJEyqLM
	 IKptNrouy1HhWIynJMTWnx+8WFI5Xk2iQDxLzWq7vy11gSau6dvOMM10r5mDLEzQQjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="iX1d2mZ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1BD606A330;
	Fri, 13 Nov 2026 16:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iX1d2mZ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9676D1F000C4;
	Fri, 13 Nov 2026 16:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794587898;
	bh=ECa4v0ymAEdrf36TMzDEI0AgHj/I0QXy3tVu9aZBtW4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=iX1d2mZ/T9JW07gRBi0bTpYJ8ny9oV2nJWyeH963h9j69ap/dzU+NeIqvOaCYedLN
	 5BQ41dZBFRz1xHpduw41bnWTcUiHT7Orm2jIT0cqqIamj8dOavABVdTKw+A3JAt5Md
	 pbf/IJfJIMPCuuyxeHZNMQsON8HDW2+6gqxSkoN4zeckmDZRwzbWxN76UpiG4kk6/S
	 m74W6qYKPIc0wn0W19SsFA3npGAfclNaOC9NtWS4mEfZy4puIs7Cv1hEHM9T9MaxK5
	 4tM+wXqbHwdhubDy2mefcKnDT5dbe4Y4mIDVJ8aEtg6w44+wOA1zRj7qW+QRR9qXjD
	 YZ7IKjSF87A1g==
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
In-Reply-To: <20261113145249.GA3706007@nvidia.com>
References: <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com> <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com> <yq5abj7tm7q4.fsf@kernel.org>
 <20261113145249.GA3706007@nvidia.com>
Date: Fri, 13 Nov 2026 22:08:06 +0530
Message-ID: <yq5a5wy0n0up.fsf@kernel.org>
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

> On Fri, Nov 13, 2026 at 02:24:59PM +0530, Aneesh Kumar K.V wrote:
>> Jason Gunthorpe <jgg@nvidia.com> writes:
>> 
>> > On Thu, Nov 12, 2026 at 03:07:43PM +0530, Aneesh Kumar K.V wrote:

 [ ... 153 lines skipped ... ] 

> IMHO, leave everything alone as is today. We can make it work well
> enough as is.
>
> Make a ECN for a 1.3 opt in broadly like the above that fits better
> into how I sketched the kernel uAPI. Do this once we all agree to the
> new uAPI. The kernel will always try to use this new mode if RMM
> supports it and userspace gets a better 1.3 experiance.
>

This would be the below sequence right?


Host                              RMM                              Device
|                                 |                                  |
| RMI_PDEV_CREATE(No slot)        |                                  |
| NEW: enable multikey flow       |                                  |
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
|              Require MULTI_KEY_CONN_RSP = true                     |
|                                 |                                  |
|                                 | GET_DIGESTS / DIGESTS            |
|                                 |<-------------------------------->|
| NEW: cache complete discovery   | Retain DIGESTS in signing        |
| messages exported by RMM        | transcript                       |
|<--------------------------------|                                  |
|                                 |                                  |
| NEW: request certificate slot 0 |                                  |
|-------------------------------->|                                  |
| RMI_PDEV_COMMUNICATE loop       | GET_CERTIFICATE(slot 0) /        |
|-------------------------------->| CERTIFICATE response chunks      |
|                                 |<-------------------------------->|
| Cache chain exported by RMM     | Check against slot 0's digest    |
|<--------------------------------|                                  |
|                                 |                                  |
| NEW: request certificate slot 1 |                                  |
|-------------------------------->|                                  |
| RMI_PDEV_COMMUNICATE loop       | GET_CERTIFICATE(slot 1) /        |
|-------------------------------->| CERTIFICATE response chunks      |
|                                 |<-------------------------------->|
| Cache chain exported by RMM     | Check against slot 1's digest    |
|<--------------------------------|                                  |
|                                 |                                  |
|             Discovery complete; waiting for public key             |
|             Chains and DIGESTS are good                            |
|                                 |                                  |
| Extract slot S's leaf key       |                                  |
| RMI_PDEV_SET_PUBKEY(key S)      |                                  |
|-------------------------------->|                                  |
|                                 |                                  |
| RMI_PDEV_COMMUNICATE loop       | KEY_EXCHANGE(slot S)             |
|-------------------------------->|--------------------------------->|
|                                 | KEY_EXCHANGE_RSP                 |
|                                 |<---------------------------------|
|                                 | Verify signature using key S     |
|                                 | over:                            |
|                                 |   VCA                            |
|                                 |   DIGESTS                        |
|                                 |   slot S's chain hash            |
|                                 |   key-exchange messages          |
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
|                  Secure session established                        |
|                                 |                                  |
|                                 |                                  |

-aneesh
