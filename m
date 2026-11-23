Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795447660;
	b=IcM9F8lwnjG9uBVkKwSKk/OuM3/I/yKRN/V9iHEU97oIR6gzNEmIsX5Ozw+xaIpFcZvM
	 4htmik5pA+UCNFgV4Mu0H+tWmAkySViHHok1A4F3j2HK0m1t81Q2OVBi4wXIcvhOGqNrp
	 BAAtvV3QPt3v1bfCYlXAPWF0olGW2o0bVe/Pz1JYSGKlih1Yd5DCJ+znCBNsT6Ki0if93
	 bu5MIFgWQNWIgtoCL8GIKRfhoqOMzYdS6PTABP1VE2ymhkjDDGkFLcry3iBbbH/6YXaMg
	 McmkENrlZDVC/oNRuhNVOB5AIL0XA1nQi79HPcfWbiep93fS9rgIsfwK26bWwx73FGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447660;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=rWLsIhN+kxPGKJoMsbdqyApLe79fwWP1AaQIjJntY6g=;
	b=3u2AqZxK2FEKRwRLDnDqcqaNYG5WJm+nsnZi1nMwnInMH9YW00t9HBvjEXLeqKqd3Qpl
	 +HOUBzdPAE/e/CHTbnzQ+OQTyNAl1pHhj4QV3IgH9Zlo2mPlhW/RRGM21ETWNoVdIr6YV
	 SgEHzoLz56BlIyTk5sPlpF//1KLwTso12I6VFuEkYZv0uKbqk3+O9XreydeYbow3HELNn
	 u1l/nq2Sk5Ftcawxg4NXJs6Om+J7gGQPLtz5FNe8eHNE02s/fpE7AkH3I3QnKSy+k7VVg
	 gs/mb8ub6iZYF3DU/55fwHNJGj3jkv4v1tmUSXbCbb/5/MUrpoSX+h/bI24OUDHrZwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=OFB9sTMd;
	arc=none smtp.remote-ip=209.85.160.178
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FAC606A327
	for <patches@lists.linux.dev>; Mon, 23 Nov 2026 15:27:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76FAC606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=OFB9sTMd
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-55d360ca878so31377571cf.2
        for <patches@lists.linux.dev>; Mon, 23 Nov 2026 07:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795447659; x=1796052459; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rWLsIhN+kxPGKJoMsbdqyApLe79fwWP1AaQIjJntY6g=;
        b=OFB9sTMdH8qL8kf+A5/ssPkVj4I6zD1lpDcHgEsYuApY2/1oH7AF4/w+xJ36Ngrrr+
         YMpAVORFCybBL/RQ1HSR/7FpI0Ex7yokNfpFScR+Up8ujZ/3Uco3pRQB18ktxHrRcJam
         C72HRS0RLeTemhDR5Jf6hIG0fUqe2G9Qoz81Zm14sOz+pG+j4wpY1CYHztXElRm3A2/D
         1kVkja3DPFsLe9BO1T6q2pBzVD0ht0EQBi2i3vulX5JEfT3D83p99D2YIeNAIl2aobiO
         lPz8TDu8fcrSIvHLpFcNOfBhu7DKIlWYCZjWbzKlWMhYO067x4GQ2RH2ons5vosFPexk
         Shrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795447659; x=1796052459;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rWLsIhN+kxPGKJoMsbdqyApLe79fwWP1AaQIjJntY6g=;
        b=pGLmvVNYTkx9CiZEzTPeRBQRix2lXdBCnrE17PwG3kAoz47SoLfy4t/P600MfMAUm6
         u/RGZrDdWcgNV9FvAyKJiuTjwVWyVRZr9wCRn/YMwuqjKVl2ctpKGW6i0WsgMSS4tlAB
         rNUZLg6s2hnQ/RKCbM5qGjU5Cv4V1HLiQ2jdT0uCa3J1ZdfHzTFCPXO5tcjC/NVJ2/UN
         CnUt2ATHr04nPggMvc83NA3HVslsQVM173U412T/IPIushmk/JQrbOd1P+WFzHq3728V
         ONeuZUAULyF4/ooiPTrQu/188MNFSN9APtA7y91HNvgY2+nmx/GGX4KiUTvvLWmnxizL
         Bi4w==
X-Forwarded-Encrypted: i=1; AL+hErHUHzHoCqn+5E+zarVyxrkEeUZos1iI262faT8dPhP0EFlrWshmvIkk4BAJ+MCmtkHDqvwb+KKs@lists.linux.dev
X-Gm-Message-State: APuU4Z8Gi/8c1PvAWfFJKJp1bH17n2TMPDGoUriFhh1RdYgsGP9t9wSq
	Kn+9dCiJwbgBokVnXYMGe0Ia8WdGNcCsa6ZN7aiO0IV/HVyC5/Tv1eRC+XN6Nn5sIxk=
X-Gm-Gg: AZFdTZcQIetRGqtyluZwwg+Wd502ifENsxdmUZU6NI0h033Mw34YC4ZlgvHdbrySeDK
	3aLEZf5WojKJUuMB3WmXbmlKwjnMDF/8TCZpJVz+i4cZUkr4VGM1fAd21ff+nNbQgs5ardZJsYr
	4SF29ItzkXl88iGH1PtBn4RfNkwaGDvMZLYmmXtis9tQUEWZ0IPLJwOQKW7/dXV45tAZ/T3kjbA
	6xKiZ4baytcH+IRyvIv90MxxXL7vf4ZgSGI419p9Hz2WigxsskkyACV+J/Qwwtx93xUHgpkrYpc
	3bg3CA4fN6Eeu0m0UlS/KcDI7UGE+GUDPgQsvpbDXZeBawmKXBKkTd+TGLGIemAXZPIyja1rrqd
	I5sOIpySQHJ00SX2wwAAFQkKZ5W28dF2HY8Pzz1gtPZAyBJVcr/YaOjm8iML2UwmkuTi0xX2HRZ
	RVhbMqcF6R8t1PxUlV15sHUABa5gWH2NQ0JFANGT689Zpq+39+E4NISWDEj0sLa6XGCb1crVyFL
	/HNIxB+rWvfm/qNW7a/DQzed+ZQLhDTKbj9US7mpB43wjPRauHbHMxRXyO+HFQ/5Q+n0EFA0THC
	jVV+NILhm0rNgK7R0a/9WCF2bGkiU73iaL/gmCPF1oq4ILVDXE6T4XamFeSOtBKdsClt7srMRgi
	Hc8w=
X-Received: by 2002:a05:622a:1a8e:b0:535:2794:851c with SMTP id d75a77b69052e-55d76ac54famr221466701cf.39.1795447659366;
        Mon, 23 Nov 2026 07:27:39 -0800 (PST)
Received: from ziepe.ca (stjhnbsu6iw-159-2-142-59.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.142.59])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d7882bf70sm102842001cf.11.2026.11.23.07.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 07:27:38 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVVxC-00000000sQR-1ESr;
	Mon, 23 Nov 2026 11:27:38 -0400
Date: Mon, 23 Nov 2026 11:27:38 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
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
Subject: Re: [PATCH v1 08/10] PCI/TSM: Add sysfs lock and unlock for
 guest-assigned devices
Message-ID: <20261123152738.GF179082@ziepe.ca>
References: <20261123083337.2731019-1-aneesh.kumar@kernel.org>
 <20261123083337.2731019-9-aneesh.kumar@kernel.org>
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
In-Reply-To: <20261123083337.2731019-9-aneesh.kumar@kernel.org>

On Mon, Nov 23, 2026 at 02:03:35PM +0530, Aneesh Kumar K.V (Arm) wrote:
> A confidential guest needs to lock a PCI device before collecting and
> verifying evidence about it. Userspace also needs a way to unlock the
> device after use or when verification fails.
> 
> Add tsm/lock and tsm/unlock sysfs attributes for TSM drivers
> implementing devsec_ops. Writing a TSM device name to tsm/lock calls its
> lock callback. Unlock calls the matching driver's unlock callback

I thought we agreed not to do this in sysfs as we worked through the
SPDM stuff?

LOCKED should be the 'start SPDM' action in the guest
RUN should be the 'accept SPDM' action in the guest

And though we didn't talk about it there is likely some 'destroy SPDM'
action that is UNLOCK and UNRUN.

Jason
