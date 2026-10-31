Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793418448;
	b=Y4jgYy8OyYb/wWa84PRZOBD+PHRupct4mIk/k483pgbPTbnxHtk0uKo4s2qTIBCEhIyL
	 5B3H/gpFIxtDH1CVimW0Po5KOEv2/w4/7RtvBqY2Mz8PzmNd6m00KYPeWBokvZfZ06aHk
	 8kgvmsYXMz2uBHg+qEP8X4vhxOO6XxrZURpZIweAz8qLUyzk6AzkEsJYuAiSNPAs0zAkS
	 n88v4/6esVWN1pu3naXvDqe6B428Wd76CgUWb8p3y7XLkUJoSK59iloelLe0Zb8287lQZ
	 bLGmBYdByO6o41fN3vg33qyv2umpK3fzNZm4g2BePDhVGwGPU6HRhk0V6a+wYQXQf+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793418448;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=lAyFehja7OD0VUj3jcp5uuBLtC+WD4jEdKJehzZg+yE=;
	b=R/5CWHmr4kVp1HZP+hTiMVjwxLftyHgH3u4pqBAFR85VeJTGye+mqXcEn7BoADgeOhK+
	 K3ilpPjVwAirDAFhFGVi8yb3IuI4eLTlbMg2MJNVxXZw/Ay2BqKj1JGqgKMb0ggURGQtg
	 /RynfKqOZ10N2pg6o98XzmTUfklkaPzLSiUSQ+WyHlFYpM+umYP4dWFPQ2qsLeRpOqW3/
	 A9DUBq2Td5ZD2/Odlg+DQk9l/Ee8kAkYSmBsBGwUTf1lV0yjsZJ5GkSkSEsNiCUf1gDK8
	 IpIIfQZonPdy9/1T2hr88VRsM5Q1Mci2yg7lv353B813ERYRnUDeRCIv1sM83cqrLfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H5orrxw3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821DF606A31A;
	Sat, 31 Oct 2026 03:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H5orrxw3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8511F000C1;
	Sat, 31 Oct 2026 03:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793418448;
	bh=lAyFehja7OD0VUj3jcp5uuBLtC+WD4jEdKJehzZg+yE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=H5orrxw3pLs6YCFvL5Y31Rg+6dF3jR3nw5RoZ1qgUlK/djyvjIiZcjk+Dx/lkZuDs
	 cYcKA8bGVpqP/Xt46y2mI4gf57jGHGJexmBA2y8Wcgh/Pk1XYpsKk/bHL0B5gYUum2
	 ocXZLuvG8WODhP/EOEIMDoXDNvo76zJaLtvKtQRj7VIsrXQYwPOtQs/JOYq4ZW5l28
	 jlz9qWuG9SyE6zV1B07c/6lqVzPPQGs4Vcj22IIqpoYY80OsIs3lyIrjwa+j6z/nx5
	 61pqQ3/l26bshsS5WlN8cIWgJP4gIYidRsoMvnYa2Nrd1qLqRyIKmzS1XBi9uOoukD
	 0V09SNtNHpgUQ==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>, "Reshetova,
	Elena" <elena.reshetova@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian,
	Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
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
In-Reply-To: <20261030131543.GH3734323@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com>
Date: Sat, 31 Oct 2026 09:17:17 +0530
Message-ID: <yq5apkwqa5ve.fsf@kernel.org>
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

> On Fri, Oct 30, 2026 at 09:58:03AM +0000, Reshetova, Elena wrote:
>> > > It can't defer the session. The TDX Module runs the whole SPDM
>> > > session setup inside TDH.SPDM.CONNECT, and the host relays its DOE
>> > > messages without interpreting them, so there is no defined point to
>> > > stop after the certificates. The chains come back in the device info
>> > > only once TDH.SPDM.CONNECT completes (TDX Connect ABI Reference Spec
>> > > 2.1 v0.66, 4.2.20.1).
>> > 
>> > Yeah, its fine. TDX will have to do what Aneesh proposed for ARM, and
>> > use use the Rust SPDM Driver to operate DOE prior to calling
>> > TDH.SPDM.CONNECT. This will allow discovering what is in the slots and
>> > passing that information to userspace.
>> 
>> I am somewhat confused by this. 
>> 
>> 1. You are saying that prior to establishing a
>> secure SPDM session, you will use unsecure DOE mechanism to discover
>> available cert chains. Here you have to take into account that anything you
>> get at this step is not trusted. A malicious device could send you any cert
>> chains from another legitimate device.
>
> I poked at this with AI for a while.. While nothing about SPDM slots seems
> particularly clean it can be made to work. It looks like 1.4 improves
> things meaningfully.
>
>> 2. Next, you will choose a cert slot to be used for SPDM authentication and
>> secure session establishment (slot 0 initially in this patch) and allow
>> everything to happen.
>
> Yep
>
>> Now, who guarantees that a cert chain that you saw
>> at step 1 for the selected slot is the same that is going to be used
>> in actual SPDM connection? Who is verifying/ensuring this?
>> Kernel? Userspace? 
>
> Not sure, it would make sense if the kernel can do some of this with
> rustspdm, but there are alot of details here that I can't guess what
> is best.
>
> AI tells me there are a couple of reasonable ways to implement slot
> selection and avoid downgrade attacks:
>
> 1) With 1.4 match GET_DIGESTS and MULTI_KEY_CONN_RSP=true
>    1) Do via RustSPDM:
>         GET_DIGESTS / DIGESTS
>         GET_CERTIFICATE / CERTIFICATE
>    2) Userspace selects slots
>    3) TSM module does startup and also issues 'GET_DIGESTS' as part of
>       the signed transcript
>    4) Confirm that the digests from #1 match the digests from #2 in
>       the TSM transcript.
>

I am currently doing something similar to the above.

https://git.gitlab.arm.com/linux-arm/linux-cca/-/commit/0657d167aee1ba43dd2765d99b5e3244b83c6ea6


-aneesh
