Received: from mail-ed2-f11.google.com (mail-ed2-f11.google.com [74.125.228.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82AE40B0F4
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 08:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784796079; cv=none; b=CrDL+XhTbQUGDFoY/evj65FOaAS18d3D6i/bqrhEH7u0hMIRJvOTCFS4XY54dU11FeJY8cwTQyBsHVbV3HD3Amjxtr1r10nz11zs8XjMJvMUKUg5E8cKfn0QmEWN1vUlvYGwfge+aUcLnxuoydwbarxTxOsmRETNBbPP9hGxvGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784796079; c=relaxed/simple;
	bh=whGXzWRNyGUg9lALJflckiWEWTI5YxH/v3DKwvNZY+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SL/YBvsWBdPR+QG4Q4ISjwQe+CRi++ikGlT+Gqclr/z7QmDDP0ozJXFMPgBxNF41t8gkQJxYJdzAg7SmtgM4pp6ml901u5hBKWJhABsHw4+JZZgm0xDEy/hVKwxuYm1gTB/BJdjDiKsMgpx2NKNSYz3qbAnkXdwxq8PHhY5b+YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IEMyzB2g; arc=none smtp.client-ip=74.125.228.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IEMyzB2g"
Received: by mail-ed2-f11.google.com with SMTP id 4fb4d7f45d1cf-69f4b000237so247286a12.0
        for <patches@lists.linux.dev>; Thu, 23 Jul 2026 01:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784796076; x=1785400876; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9fU44YJ6f6IUeZhmcIZ8UM5Hqjq3iEIvk9gqEu2Ui2A=;
        b=IEMyzB2gASeeSmX5QjwyyEFsIZ709e1M0fony83y3wp6P4IY4V36tpIRNu35tigWBL
         4nEAPW9NzqLNK/cKEgln5KaCjf0ycVMc1aYAFQcB/lRkAm1F1W7CjUVtnnmPawvHMTCs
         vtUB9FEBli8m64T35gSV2DVO2TEhDGP0ZMAAfWcc+7dDh8Q5/JiEhfC/kUYEdXqhkicA
         YFwE7rH8t0MEMSAaPI2bJBwfU3bKqyDxDrhwBMkz7bwXvr7C43eWwLrka8X97ElaRWpt
         4TeHERf3wu/+wcLMUmaboLkv2Yu/RnBz5e2HnB1dKW5V/Opiv71fAmcsKP8yIqxLe2cY
         jIJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784796076; x=1785400876;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9fU44YJ6f6IUeZhmcIZ8UM5Hqjq3iEIvk9gqEu2Ui2A=;
        b=hYFinmVAoraeM05XeA9FZH9JRGQqXkc1deuxvV6RYSyKb2/jZK0MgbT5gA8WTY4EA/
         0da1aIQrSZ84Y7fJpdACj2NlO9ZhjRLGFGIRv5tftnp00VrPQ+i8mWafascoyJMkUiTe
         btXcXC2zmzI+tlrnQ/zYXpEaxKvGKfFFlm/QQp5DxRmjCmDt08PG/lBG8XDVtFezrZuu
         K/allxu59IWnLdWYDbWFpQjurLp+6sjox5SQZnxj4vUTAMNtQDjN7dTO0nkp82XfiSGP
         svBgJC7/p8lpulZMEsqT5nkj+gfyQS8xdB7jnyF8OPymJbf+euS+48P5Z3DavNQOVCRD
         9XvA==
X-Forwarded-Encrypted: i=1; AHgh+Roolnwwy6fOsbuT4f6vjI1YXEf6dhmIljdvjFh0GTO9jW3Ol4ifsw4iLG1cLBkuGGGrCP28AEup@lists.linux.dev
X-Gm-Message-State: AOJu0YzBmlo+NXwjbVZ2NvdQhLmWwb82iscv2bQ7uidBMkssltQP0UQt
	BOkcthVv5AiI6hZlaRhDxnLFQ9ksViLLXOEuwZ9rIjbpvxzaB20t6CzwzxpqWL2d94E=
X-Gm-Gg: AR+sD13GOuKopVOFksSeeZVjOvu7z1Xl4YFqUP9WHASkPX9TAHAfdTf3gTuIo+cW2x5
	O5Ckw35SzH6f7QarPiKpr04TNWGYBUEsBPjPY5WJ2WWEydTl3ityxQcUk7niKz2HkqK2s4FxFw+
	DkbU88RwqWBABXfD218u4fChv/b9iH+6x9eJQNYGuD0ErBgZd4GXzvRCc+jBdDfV0JS8a3oUXL1
	ttp02WCEe0sWENW8LZkJOn0i436byaA9vlAOTQvleftzmdEXfAOBqUWFmlFCZNyFBXS1pE3g3oY
	IT2a49jJ8wcIxLLbkiZ0YMVU8NKPsKoT+uHHtVh/gc4e2xYxdydSIuxujOtiyCWAAUtx4gAOhGb
	r0vAvGfiZg7l9rP07EpJV93j9l+xHXaopQMv4yL21zKLvhLCMrJMQOXQ+FnZkIgBoBNFJSi8l49
	TBhgP2UaP6mliOia6Rc2xs1HUC++LAMw==
X-Received: by 2002:a17:907:7b97:b0:c19:8408:5b54 with SMTP id a640c23a62f3a-c1c509e2830mr99412466b.60.1784796074695;
        Thu, 23 Jul 2026 01:41:14 -0700 (PDT)
Received: from u94a (27-53-97-40.adsl.fetnet.net. [27.53.97.40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f2e6203sm30558485ad.44.2026.07.23.01.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 01:41:13 -0700 (PDT)
Date: Thu, 23 Jul 2026 16:41:05 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 0000/1202] 6.12.97-rc2 review
Message-ID: <amHTSIFxcb48ADsa@u94a>
References: <20260722142834.868902312@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722142834.868902312@linuxfoundation.org>

On Wed, Jul 22, 2026 at 04:31:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.97 release.
> There are 1202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jul 2026 14:26:57 +0000.
> Anything received after that time might be too late.

BPF selftests compilation is currently broken. But with [1] applied it
will build, with test_progs, test_progs-no_alu32, test_progs-cpuv4,
test_maps, test_verifier in BPF selftests all passes[2] on x86_64 and
aarch64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://lore.kernel.org/stable/20260723071334.39630-1-shung-hsi.yu@suse.com/
2: https://github.com/kernel-patches/linux-stable/actions/runs/29986297264

[...]
