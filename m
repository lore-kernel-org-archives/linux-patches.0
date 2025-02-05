Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E322116F9
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 22:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738794475; cv=none; b=VBdw8XwHSfYAohQ64rhJwWnozTcBt/SL8R0bHk2l/uJN9lF9/oI0HvFO6pF0Ay3Ss+IdxQPG751kutDtvxR1wpAamjm9I4Y3QzdACaP+oiZy5dj/bCPEuXgMGhslxZhIyEIrVGK/OSdn7/qVARpzfQBkrCE78C6hWHSj+XC7rhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738794475; c=relaxed/simple;
	bh=pSWdJfsGucLJrkPUak/tsgAKtAAYG6o3qzLy1voR79A=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rTiuy2IYSha/ore+RAIY+SsSpr6ONqvriUbnU8t3tHv8KUZ68i1CMHUxWuIRo4rsAzUkA+JeS6ZjiYl1PlL7/wUkxOHGkhGq8C1Ei8vIRMn4q22hAltKkMefHhPJQpqK+hxwCuik4ZpdIB5J9Y3LdoANh8QI08NzF0PpCQcllKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QOXCAm93; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOXCAm93"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-436326dcb1cso1764825e9.0
        for <patches@lists.linux.dev>; Wed, 05 Feb 2025 14:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738794472; x=1739399272; darn=lists.linux.dev;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/jz3bxW9BJxlgFXoPDwnr99kbYeKD++5c/1vTuaoPOo=;
        b=QOXCAm93lLMHqmzckLUN1Impf1Sst7EvwydsUNT03Jnyb0ABnU3ln+fXVH81piQZCm
         sHgntUe4mpWDvE3uiOlyd1ox4FcrvIsNSiDl6uMobGpfggpdOnFVOS1c3obnxuIemn1N
         RNq0ZsNvz063aFZvN8n9fh3ynehkaGVn8H5nohD53IIZQUvwJ252H7Aqiw9OKh87hWJ/
         TPu3xLCJeIq1e79Zm+OvbeftrgMUOr9efTLlsQ7Of8lS7J1arNnbds3bUvujnJWeCpZu
         ZVxaJKwve0CPfFtA4C06hzS59OhRg7RpgnfvHr36KtPgaeIvPgSmisZv19mw1y9MBw1c
         pDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738794472; x=1739399272;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/jz3bxW9BJxlgFXoPDwnr99kbYeKD++5c/1vTuaoPOo=;
        b=YgWwV/PzuwVCT4wSnBq7ewuANT4FQupdHaCRxAx7Wmh87gkDm/mppqhviz1B0cGqHv
         tpfvv/PCiBY4YGfptFyV4fXub9MhIsrnn2UlmYJvNxie0uUVt4WIAjjqrS5KyPdsS1uk
         iE3xqYS5m+hUOhWKoH886V+IfzkcvDNsU/wMCXDvybksjUCyfnf7LdR6y9Z7yb8F0TfB
         cWPuEvOIhwyYXx3S0IbCG1elp1FXXHK0Q3qw5jGZW5ji+F99fsesXSG7Chlr4OieRThY
         O+/BMxy2/YbJtWBEkQrpMKVRdXzk0TbX5RHsADePMYGbAig3hVfIixGIJevq5rzR9Jly
         qbTA==
X-Gm-Message-State: AOJu0Yykp8AB1SQJS6FJOvrzF5+CH61x9KyTydYnwOtVxP2smjQmJ0ur
	oPZRcpOYrHa0XfY9vBDh1fyTrcGLjFWxgLWDnWF8jQsk3I6wHfQw
X-Gm-Gg: ASbGncvcMYZ+BjQQZ0cj0UAyqMdM1aAhw0/7ZJhZgQe6P4clqlY6t/L2BVcGsuyO9a5
	BFmpaPRGomva0zzsVS8smYTCCU4s6BDkBJMquDoHMWWIIQmE5Z45Bygh2jNOvmamGOX1AbwkUtv
	FKw3k3fjaPRoorgaKz0sJje67G2Se/MEAC8l8t5tf2hQR9xJ0m8DzLNxNGUNDxH/jwCTqp+G5Y1
	Qi5MUaWQkmaa+4CCJPULgqPqpVSNirU8QFFgPQq90fGIv/kcwcejg8ss7SsXq9/JiOn4TIpgftf
	jqgEHuReP/TajiPi4MEQo7j2YgMtCyRsCg55/JM2XTCCcOB8hqlSOqW7hkCd1qYrlwnHm1aQHzo
	0AMM=
X-Google-Smtp-Source: AGHT+IFE/wqlYndQ+PU7WjTI1oW32KSRvjgI26rYJ+IoMXU3VDeO11XsmHYCaaQgYogi7VLFtsM7VA==
X-Received: by 2002:a05:600c:1f83:b0:434:fafe:edb with SMTP id 5b1f17b1804b1-4390d561071mr34930965e9.24.1738794471857;
        Wed, 05 Feb 2025 14:27:51 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390db11264sm33703465e9.35.2025.02.05.14.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2025 14:27:51 -0800 (PST)
Subject: Re: [PATCH 6.12 502/590] net: ethtool: only allow set_rxnfc with rss
 + ring_cookie if driver opts in
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Martin Habets <habetsm.xilinx@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20250205134455.220373560@linuxfoundation.org>
 <20250205134514.474132731@linuxfoundation.org>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <2614b0ce-0b34-03e3-3744-0b91fdd0a32b@gmail.com>
Date: Wed, 5 Feb 2025 22:27:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250205134514.474132731@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit

On 05/02/2025 13:44, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> [ Upstream commit 9e43ad7a1edef268acac603e1975c8f50a20d02f ]
> 
> Ethtool ntuple filters with FLOW_RSS were originally defined as adding
>  the base queue ID (ring_cookie) to the value from the indirection table,
>  so that the same table could distribute over more than one set of queues
>  when used by different filters.
> However, some drivers / hardware ignore the ring_cookie, and simply use
>  the indirection table entries as queue IDs directly.  Thus, for drivers
>  which have not opted in by setting ethtool_ops.cap_rss_rxnfc_adds to
>  declare that they support the original (addition) semantics, reject in
>  ethtool_set_rxnfc any filter which combines FLOW_RSS and a nonzero ring.
> (For a ring_cookie of zero, both behaviours are equivalent.)
> Set the cap bit in sfc, as it is known to support this feature.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>
> Link: https://patch.msgid.link/cc3da0844083b0e301a33092a6299e4042b65221.1731499022.git.ecree.xilinx@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Stable-dep-of: 4f5a52adeb1a ("ethtool: Fix set RXNFC command with symmetric RSS hash")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

If you're taking this you probably also want the very recent
2b91cc1214b1 ("ethtool: ntuple: fix rss + ring_cookie check")
which fixes a bug in this patch.
