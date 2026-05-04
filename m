Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20BF2F746D
	for <patches@lists.linux.dev>; Mon,  4 May 2026 23:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777936370; cv=none; b=Llsej4UOLtfsh8fOI0vxPnLkizgWJfO2QXt253DbkHFNsxmJRibD5UNpl0eR4+RclwFm7UPA1BgAuxsfzaqNY3OyUYD34dOCGV2DLsfajeFe4xZ3DCGeuO8T5kx81cf970GG2fvIuRtLDxnD/1zLM+tGDiVxpcM6SKoGn32hPaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777936370; c=relaxed/simple;
	bh=51YSDVpCM4joz7DXQSMRp69btRBFH1OAF2Z+FuTebAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=glX4M/vcSTO56zoyA+kAKrHCu1DKx7cYOPmsu7rt4nmtOFMCISgQhcx1oVDVwcVDRJFmkseivFAskegEnEk92/k145WNp67+kU0tCaYf/+s7ZwaMd0kgLtxiE/XVHeAEfI3Tf3HQ7mPAoRC6dnXnpGV2zs4LLleDfOC8kdMnPls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SK0idDZv; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SK0idDZv"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7de7dc85b74so4252093a34.2
        for <patches@lists.linux.dev>; Mon, 04 May 2026 16:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1777936368; x=1778541168; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AruTxQ0hr+9q/sh48aA4uF5Lj1SVXlCYuVqwgatGHzU=;
        b=SK0idDZvrOLSmmsgfCpNuL3Ko3cuN+aSlFqbglOHoaBUW9/9i7QqocjFuDcwz6/KJM
         JWHgj+RbLrLjOt9KMk3gEZgu4NEmFsq5ZCXd9R8yaVXJZEWe1+4InkOeqdy4SRzG3PRr
         p9L//TfE2kXhm0Ye9O/myrjPVBOM6BRNlYfnc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777936368; x=1778541168;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AruTxQ0hr+9q/sh48aA4uF5Lj1SVXlCYuVqwgatGHzU=;
        b=EJeo1aPMF4Hf8xWwg+5oIpOYwD4mR8p3Cw5v6AaqvGR771gITgl/xPcTZ26oC08XW5
         FknZsBRk3N5OlvL0DuWrYX97J0bM1tU+o3Z+iX/e+ovoRRXraZ7fGCCFSVKE1RuseIjy
         3t3XbW52M/W0l+0OGvj8Tt+6hp0ZoI17dZIjnWkU+7h6RctBET4t32OOtkOA0t4NHn9w
         4oiMn5w5NmX0Zq/Hjyr5BFe+xlZAasE+2jusbPrw0/V+ldbVYGUcifDECsQ46p1xDLYX
         5FmtdNt4OG4ZB+kaBBLyiYBclclNibWy54OI32I1d7uR+ev6dCCV1IpolBY14Tb5Y3EH
         NymQ==
X-Forwarded-Encrypted: i=1; AFNElJ8N2foXfYL6XEs2OwQInEWdA8Yz/YeOr1crRTHzxsF0ab8T7ahCPlhDME+aIeGgJvdxAyVBsZCG@lists.linux.dev
X-Gm-Message-State: AOJu0YwfJ5c88mlMdN9Yy4gX6jI1TazrB7pVnf1GPQsTQkjCXda2nNcU
	pEYbBJaB/APujmSc5fvT5HplmE9LTkkIU4fcD+LD/+VMOyQ2slKoZZFhwdCkERFzK8s=
X-Gm-Gg: AeBDieuh5HslrMkm5HzWCoE5NV8XZLL7Dl5bdv6Hta+h5GiH9bEKI98Bbww5hkhtD/y
	dhUrgfzyxCV5XgareCfDVt8QSw2Z39seJYKtCgNebdEOkzSQ3tUOT7PvTfm1DNUDoCsKlOGDoW6
	gpunZT5w9Hb9pNcxzTPyp4t0kwZQy9Mhjlm74XEygHygqldtqqaya87/iQBLcTrkyMRbv9MZuh0
	hIWP2Sszilw2AZh/j+DUPe0v2N3r/G4J0C2I3UvzfTukG6vD5WkAGVaI1W9+dm5hagE3Av5/4VX
	SK86v9ArENKc3BCt/p9rDEI6Ik4BWScUdOdmNGVEXqGTNXU1y+s9+nBmLVWCdH82D9sdVeRwZtJ
	bDrq5xg6vMpr5PZOLihPNUAKU7eJ7voBQZwJoRUZbECNOj2nS1tzN/kngn5foDOHm43K7r+b0Z7
	JoLvmoAQrtB66w+T51w7enFXemWKN/3XlZTbrnUN+rFg==
X-Received: by 2002:a05:6830:6401:b0:7d7:f13a:761c with SMTP id 46e09a7af769-7dee14371b8mr6223816a34.23.1777936367846;
        Mon, 04 May 2026 16:12:47 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7deca7a902asm9073293a34.5.2026.05.04.16.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 16:12:47 -0700 (PDT)
Message-ID: <4e9175ca-1b1c-40ba-83de-f9ca8c9c9a28@linuxfoundation.org>
Date: Mon, 4 May 2026 17:12:45 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/10] selftests/resctrl: Fixes and improvements
 focused on Intel platforms
To: Reinette Chatre <reinette.chatre@intel.com>, shuah@kernel.org,
 Dave.Martin@arm.com, james.morse@arm.com, tony.luck@intel.com,
 babu.moger@amd.com, ilpo.jarvinen@linux.intel.com
Cc: fenghuay@nvidia.com, peternewman@google.com, zide.chen@intel.com,
 dapeng1.mi@linux.intel.com, ben.horgan@arm.com, yu.c.chen@intel.com,
 jason.zeng@intel.com, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1775266384.git.reinette.chatre@intel.com>
 <2598acd3-542f-4c90-b46d-dc64c6cdc700@intel.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <2598acd3-542f-4c90-b46d-dc64c6cdc700@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/26 16:57, Reinette Chatre wrote:
> Hi Shuah,
> 
> I confirmed that this series continues to apply cleanly to current HEAD [1] of the
> kselftest repo's "next" branch.
> Could you please consider this series for inclusion?
> 

Quick note to say I will apply these to kselftest next for 7.2

thanks,
-- Shuah
