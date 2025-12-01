Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0206D27E7EC
	for <patches@lists.linux.dev>; Mon,  1 Dec 2025 22:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764626769; cv=none; b=XuM8ZhFOaD81yDDZJCWfTl996FNRksyQQNEo9tlz/LkXMNc9I9mSEzntwFxjN+3jmi8yKcD1EPsh04aUYAfGUP0uCdfc4VQ0DcS4OG5XpKjU/YPpDSBVbyYa8QZpOILz6q4hU2EEocjYPGXGs3OCKmG/Jsv/Pd9qLz2esF+yruI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764626769; c=relaxed/simple;
	bh=PhlOhLyfjRLagW4BXKVTnsDRNJQb6Rj2gXsVklMw9R0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vw4dhHFymQ2JnuZCTnzDvsRzf6MAV/p4IFLlI8h+1E/V03azoUZGh6VAzl4U09iD7MoF/6m5pX0wa2W5+Q34C7wfCsBbjFiHJA8hf2nUKGpYXsfgZXSJm8mzwlmtmeZrDHcg0Oz9oSp1USpdsDry6gI7xPU4MQMMcTOsmRTLo7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=mpftyQ8N; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="mpftyQ8N"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b2a4b6876fso649992685a.3
        for <patches@lists.linux.dev>; Mon, 01 Dec 2025 14:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1764626767; x=1765231567; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tq+3DtRJU8JZNsuocRWKSJHQAwFBLxgASdFB4JZhVQ0=;
        b=mpftyQ8Nj8AGRCFOQdOLuwFNYlsWS+9v68c/L9ri2IxN5n5MXv+bFrDjOTuUhjoHFO
         Mu5XsA4r3TmhsWPhcdLgGDg30SIE0ObhQvNE4wGnpwam2U0vv6Yvw9XtvLf9wMKye846
         VKS7LebNfla1q28icdPcQ+u0DTFumTkANk+Bbf/pF6kA+cIWhtuDOAkUsrtrSNcNtJMn
         zbWhlEefNQUqp4DsQKhEi5AjYnryRF4BMgWC391u/l6patUFnDZ/1713UBpwMNCfyDgW
         h/K0YkyVZS4V158l2vgxwpcjs39wmMw4MkSD+zqkIwNAVfUir3PZ4evvBmIQRuacZlgd
         pFuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764626767; x=1765231567;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tq+3DtRJU8JZNsuocRWKSJHQAwFBLxgASdFB4JZhVQ0=;
        b=jgTlbCAOMdWWHZu5SUcq3q6xcbfoYgxngl+NsHPFrRrcMRyd8IEBm/lwhYIb09QNvd
         c8iEvmVm3stMXXf29vkD2qgcYwIKd1Zp13CZAXWYNzCHsX4AGE4VkBBleJGg6q1qdyPe
         sIxomNcXPZfMcDsBwSaadFazgXEpuCrMWVc+nF5AwJ7dnUimns0hGwLFvFmjETMPe7+A
         Ft4Q0a6fcMNFIPAdjUp3mL7EUSqOikGZs6mBbSsBnLkd6QInW9Y0oPN9ddkJZ4xm+Fcj
         s9IueRoSnjFRbbBLih3M2V/rvqDKSZshACc+7DmaUGKEYISjwY4KXc9b9xY0t8X5jL6X
         yLKw==
X-Forwarded-Encrypted: i=1; AJvYcCXSP2WwIOv3yxUKPSIODV4cxv5PYXwqllM/+Cs11bd6iJiZjB9cNaQISscGWSaG0m0C/wDGS2Wr@lists.linux.dev
X-Gm-Message-State: AOJu0Yxq1tmKG1SLw14/Q0AwrlRnZQUM0APy0za52oYVrd5czqtEBTnL
	COVzX02LLmdV726XemZh5PeFwNLq16bgBFSjZgWOadLslVqThdgUbF5uUgiN5S6kw/rVkYGDvUz
	+v6y2t0cBgUvSqLuGYf0ztXLN2/3EN2NCgKpfQe6I6Uirl8WlK4P5iw==
X-Gm-Gg: ASbGnct7Ys+tzapXP0gOj2wYzU2IqeiAlw9W4zJcXZJwlY2p6uX4KGb0yeTl2ZHuJ0o
	yCh3cGmXYmeDuXR1mxAMAHQSilMePskM6I8mmdymInmE2W2DrSYwgolYkawyf7ebtKqDNSqIX8Z
	718hNrl4K7tBd4VPdojIz5LmGknPnBPzqOdFJmLvpJS7Vk/MKcsyuASjTFP0ClIKjjqnrokk323
	pO+GzsfGwYHDuUIqXf8vLa0uudPvp2XBJ8gKShDvd/iBzf15nC6fduNutZW/MKw2chnfX+dnd4P
	/NNtiCLQIzjnU7andnlGxTX8xzT0JZhKa3sdH/SJnvsMKv+jqblpyC5CviuCRU2vWpnJKoOfivV
	B2ch4MBkCLU6QhEPOaMMYxc4WzVzqHRZauACpc7zCKkQj5z60EJZqJBcAdGeBtKFYEZU6KDAkDC
	PPcWdLm6faoMcNcYRuM+fCVUdZqcUfdg==
X-Google-Smtp-Source: AGHT+IH73AqnKniaCHTQwgGUaYfB3pi27DJFpyvJ7J2eAiS3iZy3BhYYAdbLduoOOICwt61XH1VPLw==
X-Received: by 2002:a05:620a:3194:b0:8b2:ef2d:f74b with SMTP id af79cd13be357-8b33d22acb9mr5049545485a.29.1764626766477;
        Mon, 01 Dec 2025 14:06:06 -0800 (PST)
Received: from sladewatkins.com ([174.97.1.113])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b529994c8fsm949986385a.6.2025.12.01.14.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 14:06:05 -0800 (PST)
Date: Mon, 1 Dec 2025 17:06:02 -0500
From: Slade Watkins <sr@sladewatkins.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 5.4 000/187] 5.4.302-rc1 review
Message-ID: <aS4RSgGIv-136I51@sladewatkins.com>
References: <20251201112241.242614045@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
X-SW-RGPM-AntispamServ: glowwhale.rogueportmedia.com
X-SW-RGPM-AntispamVer: Reporting (SpamAssassin 4.0.1-sladew)

On Mon, Dec 01, 2025 at 12:21:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.302 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Dec 2025 11:22:11 +0000.
> Anything received after that time might be too late.

5.4.302-rc1 built and run on x86_64 test system. No errors or regressions.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade

