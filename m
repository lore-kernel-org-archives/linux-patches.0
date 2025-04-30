Received: from mail-ej1-f66.google.com (mail-ej1-f66.google.com [209.85.218.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F8319F135
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 02:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745981997; cv=none; b=mDARa8hBGFtAB8IHzggv1HlCSCoxIdXM9PZwuduOq8Im6+ywV01F6rhj90lhAeEmPXpvUHiicyDy3Y96xJijeOY3476AvUp9d0qUyHlxd7FRm/BUripg26ryE20US2vNjHLdQTspe7bUOznU3WRKh6a/Whp+wiii7XO+ciiyalc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745981997; c=relaxed/simple;
	bh=GHQkc3FXloqlNAuYTzeb0ZL6MOxgugaK43eAMibLWeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FclIcn7k2mAXwINTpmt3xeHYFi+H5G+BzUgWgN67h2M4S3HQHFSxpHWlqluA3MvX8K8QNKspl7ovd9zW1o+OlaSMpcerKHQbHqxsv+OPpYW1jexoaJjd4ARTzPR8KR0Ky+/v71P2hmlhWe/bSix+UlAvm2rd0ZdGJoMZK19KaDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UB71FYll; arc=none smtp.client-ip=209.85.218.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UB71FYll"
Received: by mail-ej1-f66.google.com with SMTP id a640c23a62f3a-ac2dfdf3c38so1173551866b.3
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 19:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745981994; x=1746586794; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pG6I5vWSFedJSkBxsNAzdBugXyUbw1kRyptLvd0MY2k=;
        b=UB71FYllXWtcmCf8WoIKdeyXLCHbE1LmG461cdRSPiC0gTkJ9gaDhn4bhB97HlQMM7
         hbYPLXXaOi4u68SX5NpR+4QR54Ql1YZe+5uWQSCKTAg4M+xk9B5wuiB+hs7PBgOjofoZ
         OgnBUwkUKthDmiDPHK7/P92AOVDChxXNQlEHffl8QTN6BZIrG0jBmT+NKi81zNLqB5DC
         IPC+SJ2d6MXNZFZvAPZgv2yjUn7SprgG8kiUwNzKXdEC97pSpWLXrJtPrM2D457U/D6M
         dmV+YPxshDSZ6u/PN2L4QjYPsvk96qiy5UVn9n2AOA0TzncoiQ2+cuQh4mt3HZrob2sf
         FcDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745981994; x=1746586794;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pG6I5vWSFedJSkBxsNAzdBugXyUbw1kRyptLvd0MY2k=;
        b=UKnO0hFYZc11rXkppnxLst1+fY5N/cN3y7sC3BxL+1vSR9s9hgFjftr3E5R6Kx9u3O
         Qu+j7rhn4+0Vo1+Cj3XH8zHfSvkV+8Wi/L4DuWHI4lThE8DSzsVlMWJhELzwP/zGc3JC
         dWwl/muzFw7VNN2cAHKbQjHHJfjUCC8zqYIJcaqhMPWGt/WnhuZob6zHungDGYw++OAC
         nQhJ96SOAQ3CU4gCo+vt0jDOw1LDFdJP9bGvTN+6Rz8TsedpqH/6pxBzO3EIJ49FaXbK
         /rr+A83GZcMdD2q523RChxfScP0Pp/7gpDCslbJ5Jh2Wal8C69Q14djU59G++4Cq2G6t
         hvag==
X-Forwarded-Encrypted: i=1; AJvYcCUKbrpWKvlNBHVyq8pCLNf8qr92qhCl3LlM1Gxc3XDJiZcR5Tti6ctgTIUaSpI996HK/lwE55u/@lists.linux.dev
X-Gm-Message-State: AOJu0YyWKtT5v08IUuYKliHCx4841y7JCqmjF13tfh4X8GvEFh8qsDVv
	hEB5nA8uN1rlpcmSbVSyA8NA+ZQ5KNC2qaK06rqfLRiafGwyRlPQFA3NzQaGtG4=
X-Gm-Gg: ASbGncuv7f1UCZaAYaZ6qySCiC2wf7Z2vmtvFufy/5W3ZSG948K5XOXBtoUST1Rd0f1
	UWfSwIYgLC3pU8xZlVCToDri6hA/RsYWp5Gy5FiEShlqjcPhyeeNt53yyM5JagacJ5jEviD3gKP
	2ZMyUWKfeu71yGif02L7NazsakzIBzH1h7FOesgoXwiiOrkGCZjbJZWmZKxNnsGjcmM9SECuC2V
	04C7JoJuZWG6Pl4c9x5Bz23nbHuiNSlD6P+dodpOsG/ZqBd1XaE4KqHk7OE/l4Cj9WWPIGWZ7+j
	kjxoJviA1v/aC4QmzX9lVy7MWLXfhG+JGAc4fIEAfh8V8mymX9M/4j2UGeTk7AALRQ==
X-Google-Smtp-Source: AGHT+IH2cNTkQBzyqfuqh97tDzMgDA/fmKHw+4HpNwa25q5IavYcAeKgdHYsqOCmKNZQVXcjThwZng==
X-Received: by 2002:a17:907:3f1f:b0:acb:4de7:14d8 with SMTP id a640c23a62f3a-acee21a69b6mr84838666b.14.1745981994039;
        Tue, 29 Apr 2025 19:59:54 -0700 (PDT)
Received: from u94a (27-240-163-208.adsl.fetnet.net. [27.240.163.208])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6edb1580sm875529266b.175.2025.04.29.19.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 19:59:53 -0700 (PDT)
Date: Wed, 30 Apr 2025 10:59:40 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 000/280] 6.12.26-rc1 review
Message-ID: <dbif2hqcfe6oz2zziy5e2anzdvi7swbrb3xqcmdxobmj3fczrn@le5rlwynle6y>
References: <20250429161115.008747050@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>

On Tue, Apr 29, 2025 at 06:39:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.26 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes (with 82303a059aab
cherry-picked from bpf tree to deal with sockmap_ktls failure, it will
be sent to stable once it made its way to Linus' tree).

Link: https://github.com/shunghsiyu/libbpf/actions/runs/14738691393/job/41371100896
Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

...
