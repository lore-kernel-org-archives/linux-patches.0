Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795595190;
	b=ETleTWbVziQxpJglHxGy7XdJ7ZBJmCGEFQhMd1xBc1e9gOTq3zLD/2zi0KGVQ0LJQmIR
	 TkeEDbxIGfJaO9yqcLlMQWiAgLHq1IwmBrCYuk7tEzKBmBMqw8VRt2eA+vEYioKe8Jo3x
	 6xX8hnzBYWEC2a7eY98SN7b5UNeIHsAlCI+8IvG/adPRhlLwDPBJSDQ4P6a4gRTczIiQz
	 9+kFdArGCYuBSJnjgjxAgTKmZVazuR02IYGDaAtHer7dG0Ur1AntGh343O9/oPpO6WrX3
	 cBzcAvi3/oOVzoyT4Nq7xxKAvzhnmWPxGpUv96rUq2BLNlOHB5QGOoLIxsyWenEjfGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795595190;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=z25kJ4FBMK5qzgMJtEFvyroUtnrXLdy9PC6e2Xs/1eo=;
	b=mcQXqG4o0vxludNZxu0D/kNWCTprCE1CyflI2DK+q9RHt/4gUus81ndpodcKE/XnATFu
	 VJ34Y+uFiTi0gpyQkcnEwtV3W3ACna4oLLf50ByP0c4gGZNKOth5cut+zULob0RCelxsh
	 E+ctp2gCpTvjXjn10+YnVJMDKw3PyXvb0AcGS2tbSSUY9CLPRa3kCv5YNmN4y3g992PhJ
	 ZzeyFzhpURSqQFQoEIf9vFoQwynNp26haqX8D84gMpLYmmZ1RIbbgYLMFoMahPQneARob
	 H+kJ2Pmc+eFcbvj3iRAEaVujz15LKo1+TUFbJ8vNbkJh/WVY+fvB/D47Sez9nLtz/LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=COScI41n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D117606A31E;
	Wed, 25 Nov 2026 08:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=COScI41n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709511F000C0;
	Wed, 25 Nov 2026 08:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795595189;
	bh=z25kJ4FBMK5qzgMJtEFvyroUtnrXLdy9PC6e2Xs/1eo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=COScI41n3yP72NaN1Wp0uSC+5LpQgVCU450FGsgHkd0+EH8pzsaw6bi2hZ/PIJwFX
	 pfFXzwrVS2PeUjPzMjUQFZLWLxGkLvjI2iX9Ydj1P6sxj7H7dCclzwyDuShtLeySx0
	 MW3Pc/ipcvQuu2NHb1ruHDY3ekdnS2ZQ+O8J5EYeVpp57Z2zXktOmDBLofPqeKsXjQ
	 YKYgWXSfGpQ6B3UN4jC7kVIc3lEQkGcuwc29fAxz1LkJcNniZTD1GveZJzKzwS6Jl+
	 gurecp6opaj3t+5oPc9qA8IQVySrWOIH/yx+iKEut7pTnfMbwBZUVFTa99fob4EWZa
	 BSkezk+KaevpA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-coco@lists.linux.dev, Dan Williams <djbw@kernel.org>,
	Leon Romanovsky <leon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 02/10] coco: tsm: Register the TSM class before
 device drivers
In-Reply-To: <20261123152903.GG179082@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-3-aneesh.kumar@kernel.org>
 <20261123152903.GG179082@ziepe.ca>
Date: Wed, 25 Nov 2026 13:56:19 +0530
Message-ID: <yq5awlq19v10.fsf@kernel.org>
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

Jason Gunthorpe <jgg@ziepe.ca> writes:

> On Mon, Nov 23, 2026 at 02:03:29PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> Register the built-in TSM class with subsys_initcall() so it exists
>> before a platform TSM driver probes, independently of object link order.
>> CONFIG_TSM is boolean; remove the unused module exit path.
>
> Why isn't it modular? This is going to force alot of stuff to be
> non-modular.

tsm-core.c contains only a small number of helpers. Most of the tsm
implementation is in pci/tsm.c, and even that codebase is not large.

This differs from the architecture-specific backends, such as
arm-cca-host and arm-cca-guest, which can be built as modules.

-aneesh
