Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617527;
	b=drQyZayhfq1j3g+LIBILqyDwI9kTgcSaABlk6g90CDLWRu53gAKfUyj58ICu9/1KcxRz
	 46kQmVMW/o65GpQD2E1bv9/jy1E/ugXnPdFLJNJ9avLZGkg1w3kz9VkAVxGNe9Od130O8
	 MHE2yGO5dWTkkeL7JzUrgAxUX1VrL4BE7v2HHSOWh75i3imEkVd+qfV/x0fvYWGiS4ksV
	 iR9aOXL7D1pEgo2PNLZZdWG2D32nCNFFqALDMZ0oNy6i4li+6t1L1fLRgiNbls7Tt450A
	 WYJXa9dCd1bCNB9JvSiUIGoyAQWF9xZkqp6Ily8W2sYls+6tiHoGBH7WCjn1L605EUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617527;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=dCtVGEXy/TUgxCZ9qLhPI3rUEmqk4eMQKQPU17VUyZ0=;
	b=U/CL5x+8kXUmOtWd374g6Ob4fDXsQdt9YGw5gly7B1HeYQulH2ZFIl0PbYNM+ZcvVr5y
	 TmZsLxwQhfjEdkqWf7uABPj5H8cSqshH+wSNt4krmmGMDRPylU0fVCIdq5fd2BCkm1z1Y
	 +YL75FREI9s1oNr0XS+IlkTvFYwECmIeCmnjcvtsOVFLQeyiwOO+Y109s0kKZqiq7DAYP
	 lxcwBRNkTR8y1G9kIQxWDs5281eWPgkkPSE+wrLhhFx4gJbmzh/K7SeBbE+ZC467kjEdt
	 kby95z84w5UF2WLQzR2ARb24KVyp9UnxPw2+Xn3kumW0RJmZ7Wx7gBW2t/Ehnz2SzCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b="Ef/me8xz";
	arc=none smtp.remote-ip=209.85.222.50
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F93606A32C
	for <patches@lists.linux.dev>; Wed, 25 Nov 2026 14:38:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54F93606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Ef/me8xz
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-98c7798ce74so1629635241.1
        for <patches@lists.linux.dev>; Wed, 25 Nov 2026 06:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795617526; x=1796222326; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dCtVGEXy/TUgxCZ9qLhPI3rUEmqk4eMQKQPU17VUyZ0=;
        b=Ef/me8xz4f56k95vG/I1VgHqJFLRI9TmsTgvV7BXRI9xAowekSDWXzmrpjFSSceQ38
         ZMRgrUj0Q0ujWsdyl5K3T28rrrD0nMcI0NhrpQ7gWkSHRkzFDVQk+EQXLLmTYuuRmDdf
         qkc5i+X9HdDPUSBA/fZ4FU63+ZC4XPHEYxyIo2WlmD3ZU5j7/VX17XabD/usqzt5m1Rz
         YAYBAXF78zxJO67qF9nUiScLzEnpww9E1a/xJcxoVMpqRqwSoYvKhb4rrTlg04o9BlBv
         mQ8QFyNjw3AD/qB7Ci+JGG2t8hJThjX5CeAf+OjZ8J9KdV9iYGsa3fa8jvZjXQ07fmyn
         Nz2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795617526; x=1796222326;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dCtVGEXy/TUgxCZ9qLhPI3rUEmqk4eMQKQPU17VUyZ0=;
        b=OZPEBgvy77pWon6o/3Yxgppi6m39FFJRa8lvQ1sSXOoPeatHGdQrF7VvrRhtQTDpVB
         hkmm+6pTwYIPnZ/4X6PdCiq0QIpRuUhaJKTwqjvrkMbG2fqnpGefzFk1hacm4vVNs++d
         aQf27nhp4xNMSt6Ew1hEQx5h1GtJz1MxXZHFmIlskXgsfiUANXGQGdHAX2P4XRKyMSM/
         zd56jIuNivvDUN13JWj6dbh55uy87lwX1iEhyCwZlXyyOpapYqI2/4c0yMyjveqo7h3Q
         CekRiqtF691TFlU2D8m2sfe6FKAX8roa7Es0jswgeJEeDC6rZyOPJ+EWfW4RVpzhcCNk
         SwCQ==
X-Forwarded-Encrypted: i=1; AL+hErEiMQ1ACcBx210WpwHbiO5KEdVyNBUHW4SxUAXHYhuuCPIAMH+SUaz1xt2UfZGulyrKV1H+TDxT@lists.linux.dev
X-Gm-Message-State: APuU4Z/JPDjVJAFZFA0samnYqo/KWfinDEsnMSMtdreMKi7pc9dr8USO
	/I/4pF9NbpgbjfoqUYi5rWO+knQP+Qd5N8vwVq3wPwrojuZ5gFNxRm+RoY+SSSRV7zE=
X-Gm-Gg: AZFdTZfp3EDLWssfKpSZmeSyWL/jZuPiz1+GBq1Pn4PwyJRE43oFdJp75MvPNyp4rm/
	4JhU8eJx9PVAiOF+kerRj7/FHz7sLvRjepKWwQUJDfpTSSXKdlYKnTUN/LdTRdRvfWTipUT/bS2
	HHLB4Iej0CHg2CuIpsXiqPJzU/zklElxivWroFmPC/bPsZwZrLFGg/a3MiHFS7dm8nmKBw9ZvoR
	Y1208xzVVKFltkP7vEBpG+pxhl4UzLTEUyUpn2Uc4VbhmPLXpq1NFjcE7NaxEkuhMlpUTJR/lA6
	lwbk6/mOyA1dL/RB31Vhl+vZCHvtl30GaABIsvL88S8HPsHatDp+KEG0kJFnRr/gsOAS5Bg0C7O
	gJ0wV8MRlrLfHOYfWT13I+8riQlK6OljFx3iQwifT+VAUinKfRD/u6tkq4Xnq0GskWWrC96FXpm
	u4EGMh018iUeIAM7WfHhQmLctPreRm6vqvOuiujoGAoyt4oSVKOoN5gqkDGBLOEyhI5uf7pAtlq
	dL+mF5vs287mw1FV/yvOTF6uiDI9rQ64hxi5RDYfgplEYfQ13LDEWDAUEO7RaehLqPmmf9T5XJC
	C2iNvg==
X-Received: by 2002:a05:6122:1816:b0:5ec:4112:6839 with SMTP id 71dfb90a1353d-5ee8af18034mr9201283e0c.15.1795617526133;
        Wed, 25 Nov 2026 06:38:46 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349d383asm163086316d6.22.2026.11.25.06.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 06:38:45 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWE8z-00000001lnK-03Mz;
	Wed, 25 Nov 2026 10:38:45 -0400
Date: Wed, 25 Nov 2026 10:38:45 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
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
	Lukas Wunner <lukas@wunner.de>, Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	driver-core@lists.linux.dev, linux-pci@vger.kernel.org,
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 05/10] PCI/TSM: Add association locking helpers for
 evidence acceptance
Message-ID: <20261125143845.GG246011@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-6-aneesh.kumar@kernel.org>
 <20261123153507.GH179082@ziepe.ca>
 <yq5ald6h9r1g.fsf@kernel.org>
 <yq5aa4mx9nsj.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5aa4mx9nsj.fsf@kernel.org>

On Wed, Nov 25, 2026 at 04:32:36PM +0530, Aneesh Kumar K.V wrote:
> Even then, wouldn't we still need pci_tsm_trylock_association() at
> spdm-start? Once spdm-start completes, we can ensure that the
> association remains stable until spdm-end, but that still does not
> eliminate the need for this API, does it?

If you have a valid attestation device for the TSM then the TSM is
guarenteed to be alive.

That is the invariant we need to create to have a sensible subsystem.

The session cookie, combined with a revoked/disassociated attestation
FD guarentees that userspace cannot be confused by a TSM host
plug/unplug. It will simply see the attestation FD it has open stop
working entirely.

Jason
