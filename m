Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4039F2C1580
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 09:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752658327; cv=none; b=Xfg8S5WdtJ6pKck9NTHIVsBX2NVP//8G7WyajV3F2fjIs2hl/QguKlAnIP5OAUcrFJH+5pmuFNUWMqmGBbT59HpLPaKSCdF6tOdMiYHtW6Te+1YNghRxSD0n3vubS6xsupfVGzpl57Vax1bnowiyR5JiNgrsuNbUIzQY5/drQYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752658327; c=relaxed/simple;
	bh=KoC0Gnw4tQwX09Mh2nGi8LKThqV4C12CyHgjb/vzF98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lhJtpGScDFH3BbD7YFh1Nr8DlwlWXCFoSLMAerwF3bo7Nc/Ds0WMbGqIU6xz8UhfS9q641QI6aCwuWs9czoeI4vccX9vvGMkr7+MEl49ybRBQc0vmKXPSks4GfujJnsAcBga8Y6DiCaqbd2++EbiCh2Pp8AwKhX1OANCQaaCWjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=X9KssWxm; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="X9KssWxm"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ab39fb71dbso60395461cf.3
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 02:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1752658324; x=1753263124; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wYGQ+EFxCY8Kqn3gT5PrXpdAsZ+hUnOgnFL6azab8Q0=;
        b=X9KssWxmnXJIHDFvh+aPFtA1s7NUhkSvkTOrp5JMpERVQJ88+v9ZMilNTAjJOmLXVZ
         kInoGdAT70AdT+BGnDMqIS8sRNhARbghtFIe2azfFeJV/0WOJx9iqEkdMMZ0rf93ZZbN
         Q/RaNK/gI7XgvyhGjH44MxXff78cEtSS6ej8A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752658324; x=1753263124;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYGQ+EFxCY8Kqn3gT5PrXpdAsZ+hUnOgnFL6azab8Q0=;
        b=P491mblqV+M9Gz8t6DK85E1pQhmdd1YwPhypIunC/WrHCS7O9rZZeMMEvCqDBCcKLB
         13r5FWc90hs4/uFPYs28BpXPd42nX5VsQDCrnHUBx6PLeLClB9S42zR1r9wQ8erkBcKc
         CdvTxQHQSTbb2xfrDSrEhkEvqq1/YStSNCEVZOpc4yo2m8tG/pU8x0cTplDPGFs/1ST0
         pwry/tIeRDMTnKophPOUxYijTRDCwRDEAwSKfoQMUVofl1lMlfb0JtRDa+9qqXhFoGP1
         xOXN8qttS/qkTXKgHQAU10JSuTGvitGdwoxZ1Et3b21PVOvZBSTcjICH//ReLlysPaBr
         mfTg==
X-Forwarded-Encrypted: i=1; AJvYcCVOP7bBgb6unqPAdMZ2wbaBBgIDIDT7IvkADG/EY2y9MybCLOR72UByoaACV1A+TqZdz32VuCgn@lists.linux.dev
X-Gm-Message-State: AOJu0YwetvZkj9dNn4DaCJYEN7Q6OJFp65POSuJLk28EXZP0CvdFoRn+
	xE2wuNkgpmKQXis1Wt4y38BIYbkVYnhM404Mu3bYYXecd1fxng4mmUKm4f6DtbKqpw==
X-Gm-Gg: ASbGnctCzZUIqNqBEk6l00CMfUsAApnYYEUWJPyDJxV9qB2gzGQzw3QTdHAdfsibcz0
	6RIYQ/4UiWsl0qbKFSFv1m5cXw/wK9mAvHO8AQtxj0CCGP1We2ecft53TX/hmJB9k1a+3Ux6uKE
	nnaVj1TrQVCFfJY7xUSjvX8Nr8drUBF54K3Qn+GN46x5Hnuzj9fdGLh/K2DQMG/iLcaLSQxmOk4
	Bzu+K5pBxdxDdiDdLNYMeoI1PcYCp+4CwNk7Plb992sFb/6St+RP76afoJ6vL6ak6Yjp0exxtZk
	/gjm6jYl50DYLcpkPi90ktdbrxO7RyJXziHi2NwwX1d4SaS3zd36SNd6WK6O+vAX4si+vrIOh7o
	pZiEYfxBppg6lNhaV/RmueIhRf7Lbcywf7LbJwV2cPtmPIR53pDgL
X-Google-Smtp-Source: AGHT+IFp5F4xszFRerdbJYejB3SFipyFazjaIzmM2lu+vwPOe+RMBqGUutuRN/hMwoxSJmKwSFPD7w==
X-Received: by 2002:a05:622a:4a16:b0:4ab:63b8:32da with SMTP id d75a77b69052e-4ab90c8eb25mr35840481cf.45.1752658323928;
        Wed, 16 Jul 2025 02:32:03 -0700 (PDT)
Received: from [10.176.2.178] ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ab85620d80sm14469101cf.61.2025.07.16.02.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 02:32:03 -0700 (PDT)
Message-ID: <caaaa276-71fa-403a-9557-b8d3edadeb81@broadcom.com>
Date: Wed, 16 Jul 2025 11:32:01 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: brcmsmac: Remove const from tbl_ptr parameter in
 wlc_lcnphy_common_read_table()
To: Nathan Chancellor <nathan@kernel.org>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, llvm@lists.linux.dev,
 patches@lists.linux.dev, stable@vger.kernel.org
References: <20250715-brcmsmac-fix-uninit-const-pointer-v1-1-16e6a51a8ef4@kernel.org>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Autocrypt: addr=arend.vanspriel@broadcom.com; keydata=
 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
In-Reply-To: <20250715-brcmsmac-fix-uninit-const-pointer-v1-1-16e6a51a8ef4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/2025 4:45 AM, Nathan Chancellor wrote:
> A new warning in clang [1] complains that diq_start in
> wlc_lcnphy_tx_iqlo_cal() is passed uninitialized as a const pointer to
> wlc_lcnphy_common_read_table():
> 
>    drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:2728:13: error: variable 'diq_start' is uninitialized when passed as a const pointer argument here [-Werror,-Wuninitialized-const-pointer]
>     2728 |                                                      &diq_start, 1, 16, 69);
>          |                                                       ^~~~~~~~~
> 
> The table pointer passed to wlc_lcnphy_common_read_table() should not be
> considered constant, as wlc_phy_read_table() is ultimately going to
> update it. Remove the const qualifier from the tbl_ptr to clear up the
> warning.
> 
> Cc: stable@vger.kernel.org
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2108
> Fixes: 5b435de0d786 ("net: wireless: add brcm80211 drivers")
> Link: https://github.com/llvm/llvm-project/commit/00dacf8c22f065cb52efb14cd091d441f19b319e [1]

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>> 
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
