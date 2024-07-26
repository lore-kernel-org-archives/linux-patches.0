Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB3428377
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 11:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721993760; cv=none; b=nNi15Aj9Q9O6MEAM4QJMuLXDsIU1oHoKBTn2hrkiA5swzp+QK7ZPa4JnPQjsqPiJtGaJ1bT0NQOCA1N1W8jSOKlz83fFgSN1Jt4adGESD6a43D4kGWgyI6YqYASMggHLM6NpP6e/sv0k/wTxWwfjnJbR00/eehuZf4ecfgp8+/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721993760; c=relaxed/simple;
	bh=TzRuI9BJXXHCTrsFK9Fk41X3bqtA/JeMDjPkBXoIO2E=;
	h=MIME-Version:In-Reply-To:Message-ID:Date:Subject:From:To:Cc:
	 Content-Type; b=kk+tznqjAgwxXvjCq2g1Y6I3qz7VuwJ743SufHzBrxOxQetxTdY+1jWksvj6Savl0mLEIz9kkrh7+XYO4OeWEvutFpQZcnhbUv2t9TwhOeFZjQYVD4FNmzXI7Fa/SeLTzTcoA/hl5LTLAEW5atvnnyO3wu3/GNDftQSh6oFWk78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eSqMm/5y; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eSqMm/5y"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4280f233115so1668735e9.2
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 04:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721993757; x=1722598557; darn=lists.linux.dev;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TzRuI9BJXXHCTrsFK9Fk41X3bqtA/JeMDjPkBXoIO2E=;
        b=eSqMm/5yuJS65qjR5+EqtdPn9Iy7FD7rwNF4zGsFxrOoqtz9G8zzQwYZzXXOe2lQ+Y
         zHYwRH3aRLsCuG31ZjoB6wc+UG7qw3G9mFQP1KSqFswLAvsU42QmsyBj/Q3EGdUtpgqY
         WTr4nCZYI1hn0RxBoXAtjbJOQCeXGstljRL9wJ9/mHDpKTH4CwcL+rZBBuhDw1ionfdi
         LcyyBl4msyOtuywhbkxNw2nTAU+ZiV0jFgXKZ31imOzTctAkd2uIKqB8yix7zNs0MH66
         jAIFQxz9YcpI25eCaiLIe40FxZqe0I9tXj5MDB9o5w8OjnDe1ObWsIAI4dUHdPoi0rFA
         LKog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721993757; x=1722598557;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TzRuI9BJXXHCTrsFK9Fk41X3bqtA/JeMDjPkBXoIO2E=;
        b=qb+ALb85/Gh8EwjzE/EoTdBhpn7rbr3YHcKcLG+7eGKUR7dgMPBO+p04xhzNMibE90
         yIz05IdopAqxZWl4Uy8FoJG9xZU1dFmUq58mnp9UpIo++vqrzZDJ91HQsMXi3noofSIh
         ZN7njePHqFVAXf7DS3T4TKE+8WO3dpXKDj+Hv+aO6mTlE1XOmoVdeZReJ9vxawSkVWPB
         Fh3jHMPDMWAkuDVZ0+cH8/hRrbqxP6Hf7wK2qt7oeO1K924E5PtaiJZO+BDykPLunZ6g
         fCpGhcRZ2EA2oRPhZ6gmOtjC0swL+YpwTt/CDrulGoL/oGVmRr568aEsoDuY394SGGqL
         pkvg==
X-Forwarded-Encrypted: i=1; AJvYcCWv+twPGxhW0uN5lk+L09FHdmZfV1RRqTxHdS/Z7tDh30TxpsZtfEhZ7kmEEWWep82JKYRXz1RFuRgH2sbJx6ST0uXrPqbnFQ==
X-Gm-Message-State: AOJu0YzPIyKwRYiyMCQwfPUwhjbyrvVcLgZw8J5lqqh1t/oyg/bUQJYh
	RDx7siIdVN2/baYlptW+je4GU3kdsn0Gn8TeMgh0fdXfWHbirSOuKaiWCSvC7cRAQ0yhrSKOEZd
	fttrF8JeXubLQ2626CyK/DP9mm3IOqtKE4pBse1A8JmWXFLVbDVDEX7iXXBbFM6H8EZ2j++sPzW
	k19pg7i2A7Oi1Ah7VNlcSKr9L2Kq4X
X-Google-Smtp-Source: AGHT+IGiadTh98VAUtpHbSHjcUWiOYFrxzuuG76Qk5r5rjKHJQHQi1GZorwkAMhX20xoSJEbEQymWR5mUT0f0xRI1jrqHk4zrUYAbq9eaGUJ3nHlVg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:600c:3d15:b0:426:4920:2851 with SMTP id
 5b1f17b1804b1-42805707cd2mr162785e9.8.1721993756707; Fri, 26 Jul 2024
 04:35:56 -0700 (PDT)
In-Reply-To: <20240726070557.506802053@linuxfoundation.org>
Message-ID: <0000000000002d1ee2061e24eaf9@google.com>
Date: Fri, 26 Jul 2024 11:35:56 +0000
Subject: Re: [PATCH 5.15 00/90] 5.15.164-rc2 review
From: ChromeOS Kernel Stable Merge <mdb.chromeos-kernel-auto-merge+noreply@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: chromeos-kernel-stable-merge@google.com, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hello,

This rc kernel passed ChromeOS CQ tests:
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/5739840/2?tab=checks

Thanks,

Tested-by: ChromeOS CQ Test <chromeos-kernel-stable-merge@google.com>
