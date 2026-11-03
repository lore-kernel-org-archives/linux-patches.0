Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723512;
	b=voRp6bssvDIsFFkwQ0eV02AC8ARtmfSuR+yLM50/r9+gvUMCZrx+QYDC0uhFPNSGMBcd
	 8UC/qWpo3AJYWF4Uv1EN0E9KOgv5Hi31WzkLCkPyXbNqiAJUV1HOJSg9i9B5LoQc6dMB2
	 vjHOYilyO659LSpRXji5bomuimOxIS2+dZLbNjE7md2H9CK48bkGLp0i4xTfy3LSU+p/3
	 ipGpLIdmUVVbwbF5MaV9mwYJt2/X+5s0OQx68uWrSHGKkJXVyhhiatYBmzy6GbYhdi0/t
	 7sF/BbEl1LRiZafN5038u+0n0mhYXFVXpGtzN84jcar5SB6E8w4fWCg3sNBcm8RXcTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723512;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=5X5K4S9Le2SUtPzNeMo80Opl9ivIiYSoizlfARAaduA=;
	b=5hrhV1qEfICuJ1/SeB51HICLUDAAoDE7FGfrvTLQWmHcwQF19pWmD/EkTQlNmSqZgV9I
	 t51Ae8EMSCbq+n6Z0JHZOVHiylVzaPk8aA7cXBDVOvIFVsmseif5wjfi9P6fZREdFwidF
	 Oo/diy/5pge2xWMi31SiIxNC1lm0WNN1GLghYOfv86UM3r78oMlwZ+eiBpPQP2Wt2BwE3
	 x9AzpZP/1GhCV9ojAjF/Az8IDb5qg/HhNmFwU9ZqAKz26P7KlhKCZlYwMrPJuiJfRWOnT
	 wXcJqhu/ZsXKy62kiU2F9l1HIL464j2iUE5XihPF5oRTJAmZHE26Tv1k/SYNxrtJ02w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oa9h1tNq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441D6606A324;
	Tue,  3 Nov 2026 16:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oa9h1tNq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0103F1F000C1;
	Tue,  3 Nov 2026 16:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723512;
	bh=5X5K4S9Le2SUtPzNeMo80Opl9ivIiYSoizlfARAaduA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=oa9h1tNqOJdoSSkkZrvUB35q9AJtZ5mZBhWFPyzGVxAoz0GqoeyhnY3HAmHHEkEsI
	 cyAxkzA2vwbLyWAt+8PXamJyqVUxUbE9wIWRbkbMAGGNXGoq3z11sgEsilbPmGFik7
	 ciIY8547yuaT3mkdxNEiQ/ZbzpAG7jtM27oRW2M8L5tHToU3OOfwaQEjpmGtZCsfEb
	 IDMdn3eUjITzQmRImwreQrLOlI6qsUqbi8mxq9tl4k8B00QOb3N09zCxjNhVkY4xdL
	 a5w4MO2q2V4D2JB0sq13dPHnXdb3OwC4YkpvPl8/8Zhj/Ov+yYGRNl80fqwByuNXuW
	 /RV9+mgFM/1DA==
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
In-Reply-To: <20261102172640.GB274202@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com> <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
Date: Tue, 03 Nov 2026 22:01:41 +0530
Message-ID: <yq5a4idx6fma.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Jason Gunthorpe <jgg@nvidia.com> writes:

> On Mon, Nov 02, 2026 at 10:11:44AM +0000, Reshetova, Elena wrote:
>> > > AI tells me there are a couple of reasonable ways to implement slot
>> > > selection and avoid downgrade attacks:
>> > >
>> > > 1) With 1.4 match GET_DIGESTS and MULTI_KEY_CONN_RSP=3Dtrue
>> > >    1) Do via RustSPDM:
>> > >         GET_DIGESTS / DIGESTS
>> > >         GET_CERTIFICATE / CERTIFICATE
>> > >    2) Userspace selects slots
>> > >    3) TSM module does startup and also issues 'GET_DIGESTS' as part =
of
>> > >       the signed transcript
>> > >    4) Confirm that the digests from #1 match the digests from #2 in
>> > >       the TSM transcript.
>> > >
>> >=20
>> > I am currently doing something similar to the above.
>> >=20
>> > https://git.gitlab.arm.com/linux-arm/linux-cca/-
>> > /commit/0657d167aee1ba43dd2765d99b5e3244b83c6ea6
>>=20
>> If I understand this correctly, this is not quite the option 1 that
>> Jason proposed above. You dont use GET_DIGESTS and I dont see
>> a binding between cert chain discovered prior to TSM SPDM
>> session and the one during the TSM SPDM session.=20
>> Or am I misunderstanding it?=20
>
> Right..
>
> I have poked at this alot more and it seems a bit different than I
> originally was told, especially if we narrow it to RMM only.
>

Wouldn't comparing the selected certificate chains, together with
successful RMM session establishment, be sufficient to bind the selected
chain?

IIUC RMM first retrieves the chain before establishing a secure session.
We compare that chain with the one retrieved through Rust SPDM, then
supply its leaf public key through SET_PUBKEY. RMM subsequently verifies
the KEY_EXCHANGE_RSP signature using that key, with the selected
certificate-chain hash included in the signed transcript.

The certificate chain comparison alone does not prove possession of the
private key, but the subsequent key exchange should provide that proof
right? A device returning another device=E2=80=99s certificate chain would
therefore pass the comparison but fail session establishment unless it
could authenticate using that key.

I haven't read the rest of your email yet. I need to review it and
compare the SPDM versions you cited before making any changes.

-aneesh
