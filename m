Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793953467;
	b=x4ApWDhuQXcroSFmI3u+wJMZ0P7ThfehDM1IXzuSeUjS8CRl6rOVLbvUi7rhmyqOnesQ
	 PSxFpq4jUzYELdHslgLDZDcWscBIoQwdQckWnjAZTX28fGMxDbCVF7Ki0Zy+CvbosE/wi
	 oxZfuoHUqylnGq5LqFrI2lv9Kcv5mTGQWMR2QQ8wY/dZrNIS0m9FQAs3aGXIu9GlY/JPq
	 RxdFzhvptQfD6iGMhMW2F5ExxLjqlBeON1/8zcjIcDEkBguWW623NjfQzE80lRI+gy/Q/
	 6p/X0T/8yZD5qletr5+IFWqDK8xouQ6j0ZZQoTIpFbqnfi6qviTavO45sEfYDKfjnvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793953467;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=JNN9fSulUqv+ZWRT5ZOWUQqvJRbmjv9przFDvv5FnSA=;
	b=B3lg47N4kFFzW7pPPa6EBFccEj1IKpwKH+p00qLKiVDBLdi8j+UWdNPjKj4CjSCHt7HK
	 qTr4FjF7PFl8EUR1QXF56ET6DI7g9GDmQJ+pPqfedn/GOq9T1sVJp0uExZzkxy7IC0/t4
	 3YtqYGWiR2t3SgmXWT3B1/qM6k+hu7Sncf6q9W2rdqPm0m61dHkAB/DDeE0Vu0xoKTMZo
	 dsvAgLovq0EQj+YVTSgww4C/B4aCp/O4GJ2mXNivUSDrgEx4LnHvZYtnuVDE93FyJzWJh
	 WHQ/9do0uM0CjH83QzjH6TspfjD6Lj+CLG8FOLOCB9qZjYLG8D5a+Kbx96/qMTwMP+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGSwu+AT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABACC606A326;
	Fri,  6 Nov 2026 08:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGSwu+AT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FF61F0089F;
	Fri,  6 Nov 2026 08:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793953466;
	bh=JNN9fSulUqv+ZWRT5ZOWUQqvJRbmjv9przFDvv5FnSA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=JGSwu+AT80CV/HMl70hUGZrcOqgaDiIvhuYIBIyztIprWzJKhN3wRAqAocVThxyW7
	 Vn7aLAq4uc2IaQKkrZZMbzutoGHl5C5VYOoAFx6ljaLf6dhlXCYcyuBR9A1G5HYVIZ
	 I/79sUSXsTxjD6ynb78x9OSjlw8iZR+aOof8OaHaN6JX0JmxlYg6h8H9VYLIRSXJmg
	 h9UmuKPfcsihs4e5KVY/1ZEe0JZ793dBzwMXv+V8l9dRwQ7Bw3Iin49abJsQVodX62
	 9ZAsFsSab8PgPoP6rTEhpJxUIl9Ekjn3vxYCA4RQBHC5olfrlOOMUpyfmcJt/xewvE
	 LnKzZYgdLR3Iw==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>, "Reshetova,
	Elena" <elena.reshetova@intel.com>
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
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot
 zero and establish streams after acceptance
In-Reply-To: <20261103151643.GI274202@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com> <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com>
Date: Fri, 06 Nov 2026 13:54:17 +0530
Message-ID: <yq5ay0b6pdu6.fsf@kernel.org>
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

> On Tue, Nov 03, 2026 at 12:01:43PM +0000, Reshetova, Elena wrote:
>
> We will need some multi-step sequence from the uABI perspective:
>
> 1) CTLV command START CONNECT:
>     TSM does:
>      GET_VERSION / VERSION                          (VCA: Version)
>      GET_CAPABILITIES / CAPABILITIES                (VCA: Capabilities)
>      NEGOTIATE_ALGORITHMS / ALGORITHMS              (VCA: Algorithms)
>      GET_DIGESTS / DIGESTS
>
> 2) CTLV commands:
>     query certificates. TSM will issue on demand:
>      GET_CERTIFICATE / CERTIFICATE                  (every slot in the slot mask, all chunks)
>     query VCA items
>
> 3) CTLV commands:
>    FINISH CONNECT with slot:
>     TSM for 1.2 does:
>      CHALLENGE(slot 0, fresh nonce) / CHALLENGE_AUTH
>      KEY_EXCHANGE(slot S) / KEY_EXCHANGE_RSP       (clear text)
>      FINISH / FINISH_RSP                           (in session, opaque to host)
>     Or for 1.3 multi-key does:
>      KEY_EXCHANGE(slot S) / KEY_EXCHANGE_RSP       (now includes DIGESTS and CERTIFICATE)
>      FINISH / FINISH_RSP                           (in session, opaque to host)
>


Does this split require us to guarantee that no GET_VERSION can be
issued in between? Another GET_VERSION in the same requester context
between START CONNECT and FINISH CONNECT would reset the responder's
negotiated state and transcript, right?
 
If so, can we avoid this split and always use RustSPDM, with or without
multi-key support?

Something like:
Kc: public key used to verify CHALLENGE_AUTH from slot C.
Ks: public key selected for session establishment by user using slot S.
C and S may be different slots.

Host / RustSPDM:
    VCA -> GET_DIGESTS -> fetch certificate chains
    CHALLENGE(C) -> retain the messages and CHALLENGE_AUTH signature
    Stop communicating with the device.

Host / userspace:
    Examine the discovery results.
    Select slot S and validate its certificate chain/key Ks.

Host -> RMM/firmware:
        Supply:
          - C and Kc, S and Ks
          - Algorithms

    Fresh GET_VERSION -> CAPABILITIES -> ALGORITHMS
    GET_DIGESTS immediately after VCA
    GET_CERTIFICATE(C), GET_CERTIFICATE(S)
    Check that Kc is the leaf public key in chain C. // Can the slot number change by now ?
    // Do we need rust spdm challenge auth response here? 

Is it possible to validate Kc and Ks in the step above?

-aneesh


