Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794589937;
	b=3bXMEsuKRPWC73idnhE2sPx9PFH6egO+Uo9cBup5wnCOzru7o9I397SgC+ytmJeW8UTT
	 8iaFNeghE1PGVPcxCwh9X11S5guHLpdQVbeOGRJX0THzJ0pY0wWngFwnT+OARhWmgibWF
	 QOaInryskrUO87kx52TgV3GRZstlD6v2CMUFrfUvhhOt0eYCt80mJhFyBW4ERjB1l6Q/6
	 Vi3///p5zdbxyJdUPz5cABvipAvk2C36oEk5sq/Bemf5SyWAmTzOVucemofEA4ogRPC5l
	 rcdCBJG6v7NhszEH6oJdaibKMe9GyjiDOVNUDk/rQzMHAGYbEa9Jc7wK9DS4Hgbvs6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794589937;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=EghNJb/w9KWddSZy7Eooq4G2yL9GJh+Li1g9aAPh8jM=;
	b=s1P+93bNYHhJo6wQdjiFvS7nYI8meRG+LZqjxmveETary8Brhcm88MYxmvrHFCj+c76L
	 91u0aJgciEPh/hDqszXm0BL9E7WGnhhJtxiCHsL1zZVkoNVk0VxSEm+3PrliRn9yBikFG
	 v/+NpzbXmncz/e1JZv9YIDkbPAMzCe/6CWIKnQjc2UA44gWuLJHRUw8SOS/kgywDUVQ+l
	 vfJx6e/geBEPtpV+99p68ONQiQwHYh0JNxkeuOegqovnGpwtgH6JLCOzJ8Dvi+zUJb8kq
	 SH/7+JOQ5ljfqE+76NC+CFmVgHAHqb25B1/DKvYgXuZ7FgyIhhVESAlpNyITAFpw0aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="bc/Um4gm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65295606A32E;
	Fri, 13 Nov 2026 17:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bc/Um4gm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99DA1F000C4;
	Fri, 13 Nov 2026 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794589937;
	bh=EghNJb/w9KWddSZy7Eooq4G2yL9GJh+Li1g9aAPh8jM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=bc/Um4gmQW17Efk2IOy6bhr5SWExvPOQT5E4rFqMTXlNzbhU60XOr12Oc3Ybx4EOF
	 WUKTV++vluSqN7Wh43GwwSu5LJeYIRYT/kWVIDhW7zbyYb4OPtMPC/ir9bcY4WOEmP
	 LuYa/bdu+VQoJhvhAIRpbHxVhvg71pUn0kRoXr9H1VGIGOoAMSBjqK0IQkmxDftqpx
	 6Pnb+XZLK2fcQDlcwpL6tysHQ4zi4JLCqRTJRcClU0KXzLoqNQE49SrkS5lV2DU0Xt
	 pEMIf+RbhrehHvdrGcc9kXN3yWNv52Qip62S2T8e1ZYCyQy7C4GZE008PRuPmaKXRU
	 gYTRVA1iIy8jg==
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
Date: Fri, 13 Nov 2026 22:42:06 +0530
Message-ID: <yq5a33t4mza1.fsf@kernel.org>
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

 [ ... 96 lines skipped ... ] 

> We really want the certificates to be loaded at the start before doing
> key_exchange. That is when they are most useful.
>
> So when we fix this for 1.3 the opt in should trigger a transcript'd
> GET_DIGEST in plain text and certificate collection from all the slots
> in plain text.
>
> 1.3 will sign GET_DIGESTS during KEY_EXCHANGE
> 1.2 RMM could issue CHALLENGE if the device supports it right before
>     KEY_EXCHANGE and transcript it
> 1.2 RMM could issue GET_DIGESTS inside the session and fail if != to
>     the plaintext
>


So the combined flow would be:

Host                             RMM                              Device
|                                 |                                  |
| RMI_PDEV_CREATE(new-flow opt-in)|                                  |
|-------------------------------->|                                  |
|                                 | GET_VERSION / VERSION            |
|                                 | GET_CAPABILITIES / CAPABILITIES  |
|                                 | NEGOTIATE_ALGORITHMS / ALGORITHMS|
|                                 |<-------------------------------->|
| Cache individual VCA messages   |                                  |
|<--------------------------------|                                  |
|                                 |                                  |
|                                 | GET_DIGESTS / DIGESTS [plaintext]|
|                                 |<-------------------------------->|
| Cache discovery transcript      | Retain original slot mask        |
|<--------------------------------| and per-slot chain digests       |
|                                 |                                  |
|                                 | For each populated slot:         |
|                                 | GET_CERTIFICATE / CERTIFICATE    |
|                                 |<-------------------------------->|
| Cache complete chains by slot   |                                  |
|<--------------------------------|                                  |
|                                 |                                  |
|                      Pause: PDEV_NEEDS_KEY                         |
|                                 |                                  |
| Validate candidate certificate  |                                  |
| paths against userspace policy. |                                  |
| Select slot S and extract key S.|                                  |
| Discovery remains provisional.  |                                  |
|                                 |                                  |
| RMI_PDEV_SET_PUBKEY             |                                  |
| (slot S, key S, chain hash S)   |                                  |
|-------------------------------->|                                  |
|                                 |                                  |
|                    IF SPDM 1.2 AND CHALLENGE supported             |
|                                 |                                  |
|                                 | CHALLENGE(slot S, fresh nonce)   |
|                                 |--------------------------------->|
|                                 | CHALLENGE_AUTH                   |
|                                 |<---------------------------------|
|                                 | Verify signature using key S.    |
|                                 | Authenticates earlier DIGESTS.   |
| Cache challenge transcript      |                                  |
|<--------------------------------|                                  |
|                                 |                                  |
|                    END IF                                          |
|                                 |                                  |
|                                 | KEY_EXCHANGE(slot S)             |
|                                 |--------------------------------->|
|                                 | KEY_EXCHANGE_RSP                 |
|                                 |<---------------------------------|
|                                 | Verify signature using key S.    |
|                                 |                                  |
|                    IF SPDM 1.3 multikey negotiated                 |
|                                 |                                  |
|                                 | Signature covers earlier DIGESTS.|
|                                 | Authenticate retained inventory. |
|                                 |                                  |
|                    END IF                                          |
|                                 |                                  |
| Cache key-exchange transcript   |                                  |
|<--------------------------------|                                  |
|                                 | FINISH / FINISH_RSP              |
|                                 |<-------------------------------->|
|                                 | Session established.             |
|                                 |                                  |
|                    IF SPDM 1.2 AND CHALLENGE unavailable           |
|                                 |                                  |
|                                 | GET_DIGESTS / DIGESTS [secure]   |
| Relay ciphertext                |<-------------------------------->|
|                                 | Compare authenticated slot mask  |
|                                 | and every digest with original   |
|                                 | plaintext discovery.             |
|                                 |                                  |
|                                 | Mismatch: fail setup.            |
|                                 | Match: authenticate inventory.   |
|                                 |                                  |
|                    END IF                                          |
|                                 |                                  |
|                                 | Check collected chains against   |
|                                 | authenticated per-slot digests.  |
|                                 |                                  |
|                            PDEV_READY                              |

BTW, all these proposals require RMM changes. As I requested in my previous
email, it would be useful to describe what this would look like without a
firmware change.

-aneesh
