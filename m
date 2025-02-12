Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06F5155C96
	for <patches@lists.linux.dev>; Wed, 12 Feb 2025 01:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739324361; cv=none; b=r96VmCFgKg8V+76cW6XDOQVTnyu9NcZ95Kwmo/YCvPIl3H4TGKfk3LqXQ3LWxGXqZg1iN6EsaxjmoMdt+aOCDtSFhRUgarSiIORip/rUAtvZXrP8OqEGywFavp4jZ0GWG5JCZ0xELY8IB1z6LR8k4FQVr5vpDaVflLskXPqSFlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739324361; c=relaxed/simple;
	bh=URewmVOEYxLnlw51eEMF8Y2IyAkFHFyPALMcjDbPlrY=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=L0tnzo02Ru9Q+kJ1qVWMXUogyRGijVj4PE18cQtNltyFUlJbz4XInTXAFE3+ORBWje3OpBsfFPlqfpYEeswJWxbh1PjoRzJoIXliwYufKD6prLqdWQSsmKqtgYXPyB18k/baKD89nkxitFDdBdmJBukAF0N0e3uFWb4uw4giGXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=e3mKX7Gp; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="e3mKX7Gp"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-38dc5b8ed86so2761540f8f.1
        for <patches@lists.linux.dev>; Tue, 11 Feb 2025 17:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1739324358; x=1739929158; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:subject:references:cc:to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2L21XwELl9ZkD3g/WY6vAkkQfnuFoS5/DgWaSINoVWs=;
        b=e3mKX7GpXIE0k/mBRswKFSXstbfshaYA6pmxBECa2XoPCHlWVVMMZDr/jLwKGYeA1m
         JhaFnjMNTT25rBCfDHJdqexKdKhb+TOtL6cBP5e6AQUPH5hV+5ZP30gJUQlWmD0OVZXN
         CBblEfFE7dqDiLc3o1+IS98HKks9VdJi+L1GM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739324358; x=1739929158;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:subject:references:cc:to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2L21XwELl9ZkD3g/WY6vAkkQfnuFoS5/DgWaSINoVWs=;
        b=PZobJM5/MmSvA9C5g/Zi/MaV8qZSF/b1iQiOuns1jWGxxmiJzYqQ05BgKleUwcZhvD
         Sm00rarSzAN7OuM4Lnn8SIVbdt4Gu9GIpkmlEPjolY8yyotPk8myPml0q3vKixc+L1Cn
         ncOreSHUli2MhSpjt+E8pLN0dGfFqGt3t8c0XGisSk3cZc0lXsklhh44BR7PydhtjKl5
         vtdyBCXurCVf4vbytRzkEagYDOYeh6Uv384b/HHk5WzT2CXxfc45ifHVQmiP2FflrHtQ
         V8rtxVXkJrHG40gH5zkBElm7qYijXME8fbw2r5JjFT1gfJyGLQHTT71yFa1K0uJF6Iox
         fjMA==
X-Forwarded-Encrypted: i=1; AJvYcCU7kj2isis/v6h6tpIlND/Q8sW+ZLZ6Fa6jfTifFAUZMUkibto/WYmNIrsBG02bee+NQNJzysxb@lists.linux.dev
X-Gm-Message-State: AOJu0YwRbVnAEdgPvuAN6nSRtVdgTOE6lZrZXP3TeiD1gfBiDZR83UKr
	MHg+ZyDJCRZ2gq+IzYvcpZEeUN1nKonLODy9QBy8P3scqvIF6XsGRg4ocJrc/wA=
X-Gm-Gg: ASbGncsfDHbiCJ5YBJWpxZnhPgk9MzotbL7z0IyO4oNRDq6niugv7CG9bcE0s7hk0Oj
	HbaLYr1i7cy517A0wPqwX9Os9ox+kLVu4zRebr52BBq+eONfn9qId3+iT8+Q/lAQecVcFwqlEo8
	B25HU0WNi+J6yCFRLBKpuwQHHequXGqtZDx9UETiiWY4k3aRQLViqDyoJ+pvsJfWCxEPPgLC+0d
	DumqVtAp1C6gwVT980MiZC6ypGWMRMw6Zr92W4/MiZqXZPAiC8iw4iinzxiH+iI3SnD8go6QRoX
	mS8HctDngzru73WCeOxiTHONee/XjgCuro0CP5hYBEKE16yp9Ubop4A=
X-Google-Smtp-Source: AGHT+IF0821khXq3FaIfvnauMcjgFlPJAoX2WbYF4le/qFdsYcQiW+HnsVerFwBttHsGtjBmBE8kyw==
X-Received: by 2002:a05:6000:144e:b0:38d:e092:3d1a with SMTP id ffacd0b85a97d-38dea3c30e1mr621871f8f.6.1739324358089;
        Tue, 11 Feb 2025 17:39:18 -0800 (PST)
Received: from [192.168.1.10] (host-92-26-98-202.as13285.net. [92.26.98.202])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a053816sm4526085e9.9.2025.02.11.17.39.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2025 17:39:17 -0800 (PST)
Message-ID: <c8545ed5-b822-43a0-a347-d077bccf9d6f@citrix.com>
Date: Wed, 12 Feb 2025 01:39:16 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: tony.luck@intel.com
Cc: dave.hansen@intel.com, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, x86@kernel.org
References: <20240923173750.16874-1-tony.luck@intel.com>
Subject: Re: [PATCH] x86/cpu: Add two Intel CPU model numbers
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <20240923173750.16874-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> @@ -178,4 +180,7 @@  #define INTEL_FAM5_QUARK_X1000		0x09 /* Quark X1000 SoC */
>  #define INTEL_QUARK_X1000		IFM(5, 0x09) /* Quark X1000 SoC */
>  
> +/* Family 19 */ +#define INTEL_PANTHERCOVE_X IFM(19, 0x01) /* Diamond
> Rapids */

Is it intentional that this is not INTEL_DIAMONDRAPIDS_X like
Sappire/Emerald/Granite ?

I was going to submit a patch, but there are other inconsistencies too;
the Cores and Atoms are mostly the opposite ways around.

Atoms uses the microarchitecture codename with SoC name in the comment.

Cores (starting with SKL where they begin to diverge) use the CPU
codname with the microarchitecture name(s), which matter for hybrid as
there are multiple uarches.

I'd argue that this wants to become INTEL_DIAMONDRAPIDS_X (and CMT/DMT
to SRF/CWF), or all of SPR/EMR/GNR want to turn into GLC/RPC/RWC so
they're consistent when used together.

Thanks,

~Andrew
