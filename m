Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA95A1C2AD
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 11:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="Tly0eZsW"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3b2b1ad7ee6so1777889b6e.2
        for <patches@lists.linux.dev>; Mon, 16 Oct 2023 04:40:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697456408; x=1698061208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tE3/kt7VPkaFdquQYklg8hmYnVUnseOhnUoih4hEER0=;
        b=MROwgsnADOEM7/Tq/Uu2eioBYbcLmZZv5eXRbxfZeF5PKqrVv+CdtQml0ekcDNJlQ0
         dr1+kGZGL//9NBXUiRQaI+ilg6ic3bNkO0SpqAdsjDUfs8ymj7Rk2L4z9pnAV8o3j7K8
         Pw9Cn7jaZtilQOjFJYkEa8VdqKeCNO0Kpz6MZUjuunZlcuI1ATHpv8tbfyF9ApU+wlCb
         xELfW3/XA9cm6ZyCIGMZIy6ptrQRBVTtx0PgJrsqrH6Pb9LfPLCmf6jCKJqvsAubC2lu
         jAmg1U17+YbKio+jAo/M5cLe9Svn8UkJPRkvt5/hHWgtp5pJpUC/9xWa8Voovx7JyDUk
         s1Lw==
X-Gm-Message-State: AOJu0Yw+5c/oGJejsL5ps1/NLEGjQKIcQCgwX9yXbMuQOfXpbhxkxaVX
	8FTCJVpz3mNuY7DA50BdgA4=
X-Google-Smtp-Source: AGHT+IHxDYPzvNS3lWU1QsDc586Js06uUe+5oigcPknJIMbnR2FqVnBRnij03C711FQbvHhcLy3Xug==
X-Received: by 2002:a05:6808:1582:b0:3af:7db8:21ad with SMTP id t2-20020a056808158200b003af7db821admr43196719oiw.33.1697456408615;
        Mon, 16 Oct 2023 04:40:08 -0700 (PDT)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id f18-20020aa79d92000000b006bc3e8f58besm3726935pfq.56.2023.10.16.04.40.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 04:40:08 -0700 (PDT)
Date: Mon, 16 Oct 2023 08:40:00 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1697456403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tE3/kt7VPkaFdquQYklg8hmYnVUnseOhnUoih4hEER0=;
	b=Tly0eZsWl0PYDKWvqPHKOAbv1/wJr0yDXEHYhkZ22t59XEtf39mUTX2rsE3I8NMi/l8Imm
	DxJB6uyPhef6JqSNZkl2HldM1Pc0VLw9mdmCFqUjI7PLcHw9RmuN6szKNdpLAlHzbK+SlR
	k6fNy9Q1OOmMHt13hU4tozESfZFEfYt1SuaivIwbZ8IRu68vUvoDVxB3FaEqZVNy1vhEJk
	OjWnBbKUsoyps9G66fCr+VsusMr4lBdsvuOSVBA4nZMjKzCrzd4jwosP9ZCYr8y/wFctcG
	OWKN6CpEfRsmrYu6+0uzOpVfIEXeeTQmzVpYx5BEth+yddX/k7RiYRU+0Xe+Pw==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/131] 6.1.59-rc1 review
Message-ID: <pocozopagkwaphxqyupnpuntzxsb47ws6s7nzmawhnqa5brzph@ku2y2aucxs3l>
References: <20231016084000.050926073@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>

On 23/10/16 10:39AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.59 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Oct 2023 08:39:40 +0000.
> Anything received after that time might be too late.

No regressions on my system:

08:35:39 rbmarliere@debian ~
$ dmesg -lerr
08:35:42 rbmarliere@debian ~
$ uname -a
Linux debian 6.1.59-rc1+ #1 SMP PREEMPT_DYNAMIC Mon Oct 16 07:46:20 -03 2023 x86_64 GNU/Linux

1 build warning:
vmlinux.o: warning: objtool: set_ftrace_ops_ro+0x23: relocation to !ENDBR: kexec_mark_crashkres+0xe7


Tested-by: Ricardo B. Marliere <ricardo@marliere.net>
