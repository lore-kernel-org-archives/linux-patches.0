Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795665536;
	b=d14NV4s+AHyyr/k9H+oIR0rUu0iJ7yBXRvutfannxaXRkC3u/lMDhL8meMvgOXe4Qju9
	 lGmyMOHRJhgGl4I2nnp9AaAFBlOmw1Ab88IL92ZqVlfrPp91tdauUB3flfk5eAPK4Macx
	 j5cIZnAIZfljPY5uD7nSXETYmsKGmROYsn0i/YHdDXba4aG8W3AfIQcaRdJ2Vwf5Y1jdC
	 GkG4tN/qzLJpYz6Aq5bUC1LO5naLQv/wacjU30HN3qo6RdTbXI5q5NVZrayXnf5BhrktG
	 W1C5DZviAIMr6US95lwGOB8dwT1kLmnzbQSO67eQMpZXGH5ecCiNHAFTMj9wEDW0o5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795665536;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=JukNCv19tRLo1eRg8w/7wwr8tQYsc+7QS+KjL2U2X3g=;
	b=ud0nW31Oast40g7ikRWQnB6H2QkAhF+lDdA/DDDBiFjK/3GxYt2Fv77WfLpCiioCH4+v
	 YnISOnanAX9WK78aAURYIcAXDdEm9Mtau5hfxYS494RbOnPBJhsORl9CpdLG1FwW585+s
	 vUIZoXoxwRr21RlQwJMn3FwrGtaL0RBmvF/o7l5I+Jq7bzvg1icv59gVCtq71LV4C+yVR
	 41ySv4fYEn07kJbyoROm9EH2CenHuGoiivUtBmu+ppcalA9JjQJ/EFtLKQGvR36z+JTDW
	 y+ZsCng0KUZB3y0rMp3SUyGyBpgFK6o3VimJ7+AkLyD7VOCaGnojILklifLDwWTBBjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pOugJy0G;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB82606A31E
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 03:58:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AB82606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pOugJy0G
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-38692f62b22so8088120eec.0
        for <patches@lists.linux.dev>; Wed, 25 Nov 2026 19:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795665535; x=1796270335; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JukNCv19tRLo1eRg8w/7wwr8tQYsc+7QS+KjL2U2X3g=;
        b=pOugJy0G90ZPSPoEHtXskJJd5UVDNujsdiYf0a+UG5/RTdf4DqdrrYZfLmFHUN8cKJ
         dm11IUiQ10Sh++2bYIQ2/t2vfOT0UWrX+U98AFGbgkWK+Tk4+JzEekfRoPrFy696XvLd
         eCA9YQGEOXaeUVpj9orQn3XtZXqlAMfO+QBhadN475Ebuq5hbi5XgwnOjSXXCBFzPH17
         uPIAYb0AB2SmHaJ3bUZP994I3EKk0y+DSmzBy66kY7omCfAdTf8X+NaIeXgSjW36Kdbx
         reekMXJkmC4flV65iSc4pZmqQr7Z8k5ENOa3nQOCbVdsV8ckjufNoCcogQ/aCQcBhNeX
         vpew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795665535; x=1796270335;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JukNCv19tRLo1eRg8w/7wwr8tQYsc+7QS+KjL2U2X3g=;
        b=WdltvFjPMTtp4PSdDEuNovI40fyWkR6FXyVWFXF8aiczfCJI/8nBqCpjKBLg/XXXCY
         yVMMgjZ+ZnZYcHaL2Aq6FY3BeYPPmJUAOYwLd0Kgw5JTQ6GthIfNTEetMmC4BVkNmlt9
         VQ7c4wB9/30JbD+iextv3WGxlQlXzamiRlpJxpYvxoZz/Dmk4+msIPJ4p6Yy7ZGDFK/E
         uzHELnJXXBED2XY6DMzb3hl/DINR7sLXWyktzLVRQXDZoew5rCxpwTWFag2iukadset7
         GTeiW0KzP1whJaDZSXNpMXOFREBSWF6h7oFng1nBnZh2edEpKI4amTwd9tGKp52baZ0r
         WZYg==
X-Gm-Message-State: APuU4Z+ceIwBxdLS3Lu9OegUHeCmcA/z3LiITQ63thDfPjUAxTx3dLbi
	I15JtgJw0dXeumrjPECwEMMMDgNQi3H/NoRaF8VOUUmxBne2+aUDlzPR
X-Gm-Gg: AZFdTZcKcLaiyVCw76CiZkHVxoP1z/ht7Ra/UlXlmUIMhkuh5S/DgpZs5iSHEG231xs
	egZY9ilV69CtvqOtGqvfGyuCLtLw18JOk0rT6iXKkTWM0TnDpzUjt5sdANAPFpxufaia9q3NQKc
	pEGxGDLjuavPVs/ALWvzjk2tp8kwJ09zZqz2hCCh+qlOAR2B2tN95zysQgzjRaBteJwEJzmicIE
	F8E/O1tbx5oARlgY7DUsv8+L1MgNU5qDKq27tsWjhp9UAZX2v227q9S8Ae2yMP2xJnzolEHRAV7
	t518RYMeCgg+YWKiBciWP3k+wkuQdyc7JysNKHIzUPpj22hgUfN3A9T6NQ6T+Pwttbz3v6C1rl1
	qbD7TAAHZmP0wb11AS2a+4XBiUjsxvQKvD5E9oV2zIVxL1Hll8ot/eVWImb3Op7j2uKxu7CT17d
	JPN1tT8mLnSjY6tbfxtv/GX14Ruo9jd96tXPzqtWzZNDXaogMVP9Qa0KL62qUTNNI2cDyrpGE1v
	lsYZ2gk7Jx0gu+ugTRsdEloWzFfwiQjSDft1KVvXxe/5WOWDwR2b3K6LPKcjyZZoLA+qjHpj1hB
	N191MYmngcSYap4+z0A/sHG+7MeaPIKstRmrP1r7rmGRJeFuK3Py6lVa7hf02K6Su1PWaOr4WAN
	B
X-Received: by 2002:a05:7300:1899:b0:386:b6e2:9fa1 with SMTP id 5a478bee46e88-386b6e2a02fmr14756733eec.34.1795665535054;
        Wed, 25 Nov 2026 19:58:55 -0800 (PST)
Received: from [192.168.10.3] (ip70-187-214-22.oc.oc.cox.net. [70.187.214.22])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-386b1965c02sm27050486eec.27.2026.11.25.19.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 19:58:53 -0800 (PST)
Message-ID: <57b6b3b2-a7af-4b8f-999b-9e646ca7fab0@gmail.com>
Date: Wed, 25 Nov 2026 19:58:54 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/816] 6.12.120-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261125143849.205329330@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/25/2026 6:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.120 release.
> There are 816 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Nov 2026 14:37:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.120-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

