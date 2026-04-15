Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD5E3264D9
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 03:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776224956; cv=none; b=ol2ZxxYJHUgiV5OMyGcw9sEvcaARwNet/2t5mBSE19R5aHIJRDXCiL0dRpXmnSmQkovcU9NLuqSCrIqbvMl7ANswE6Mt2xEb0KfC0oBeR/TABiVFfTyEHqLgMWUmbXwGRVz50NoHE/TriZYZYnCRGtFwIRud1hM6iyrOZsATZGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776224956; c=relaxed/simple;
	bh=HH2eYt96ABd5SlkhhFODqiVgM3AzBZvbWxT+AkFnToI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DiQqiniDjfFgkq4k86GHuGaXOHuhtj1J/B98l1RjWw0KILkcnnUO+FhaAngZAJS7HN7Y+tfA9rI9KVs+5YoggZo4wEuCgY3XnYbk59mxPlia9xkErEsJ8WkSI8edbOFe9eCgMBul+POR3c1wFwhONU5bXYfHcsc8gA55jF85SCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F6Xp1K7B; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F6Xp1K7B"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-483487335c2so69147765e9.2
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 20:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776224950; x=1776829750; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R5JWuYIAJ3F3ysqDV+gpo5wAXbYBTGhZvMiJLrtFpXA=;
        b=F6Xp1K7BUCNbrSgadu9HwfJlEQZmozqThaFcFZGhsL3Ec2GSjDs8RY33V2Z+EgXiqa
         8ZV37SVcZ+pZlBrpIx6aHP5DJTlifJM92nSvUl4p4Z3xhw+shAmcf46qzkKtAV1UiKHr
         ZyaC/Qke6+M+YuCouccP3+dqQtRN2iv2mA+zEw+5lDe5gJFB8qVt2YqztK2YNRe5j7SB
         DVDGuZ23n5a2tv4HQo1uEnk27kjab+89cN+M62KQxfE9xFvDhX0TR6zRzMbkCGogBKJL
         IyKShC7TfcVWL5LxiQOqA/NKpHKYc7f6zaCzx33TP0ajtpWwed33v2B02YDHH8bj7Wz/
         ukcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776224950; x=1776829750;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R5JWuYIAJ3F3ysqDV+gpo5wAXbYBTGhZvMiJLrtFpXA=;
        b=BfruLj7je3s7X4ZIfO+2x3qBCNvJIfm4gw7/2LG72KPxpMsnvoGEcN5mFfHfqMZeNc
         BI1l0jMb4cUO0J0wGe4VVj4or65ETCZ9lZoqcrsglcaNO5D/UbWAb7y/ufgQMc7qzLP5
         kD56ozD+HaC2KAmNfVQMFOTck0pWgnsF/dZGQuk0LdVAzryvkVoj+SA+OEbiaXJ44dXK
         c4HpHrfUSmBQfVboTcsMGeHR4/oj13yT8KQMRmsbXjSDUJw1kDu0QBsqm97YvlAKG7pJ
         UtHDZ1XaPJ7CTmkMeR5nHZBFWvLtBGBlAErIjDOPP7rOL2/Ec6PqFBiKdiHuk5iKWgMc
         XVrw==
X-Forwarded-Encrypted: i=1; AFNElJ/RzqQfH79co2By0gSzsg9k9OvDAwF5LDY6LigaRVAq5sEnNPLT3kpWOHed2UCDaH0mL4lCf4Ek@lists.linux.dev
X-Gm-Message-State: AOJu0YwIH8+Kile+itb15n547XydONFCc5A6ymhdT/XrrMXII/6To9ii
	6OFGd3hjIVeCo7tdCmyT9wlCyeRog80Bo2zPOebFmzwAbsbF8USFNgw3hXcBERsmhPY=
X-Gm-Gg: AeBDieumG1LrhJZ29qLr+hk6k4LSPCZpQPR0VdtfiN3dmqvXnsocfqx39N/zneVyqrw
	fSQmLD7We4TzSNy8bJkmNkAq/4KTLG54YSAgbxyC4gS0BEXK3PEv9nbgQESGjxJd7/EBLYOi8WU
	95IJRo9/kve1fIbnjga3J5n1XD25nKsWqn3JDsAAXKPW7YDyI0TuKgheWHaY6K6g1/ban+xRENC
	jv9/uhN4sFIOj7QrnH9+JDadVnxGy88VgDDGttBNk113iSMv/K6kkBoo8X/jv1/PgmQq9FrOtZR
	+gMpnQ/lPlNE9abnyGmaX4dQzI/LBW7lTC1RepEobMaD2mIWqvvq38Fy0WFhIwbt3h90Vo83oav
	mQlZ+DgrF2/qol0sZih7yigpy8rbzlgG29yTI/cEpgld4WyJNqIzSfvKQhj1tKffUNWNfRVqsDA
	3dYNpU07sWRRGsbX+tLPQJlz0YCgHM/q6MNXr8rtNdVaAcCpgqwxk=
X-Received: by 2002:a05:600c:8207:b0:488:7a24:9ddf with SMTP id 5b1f17b1804b1-488d688dd31mr264696795e9.28.1776224949959;
        Tue, 14 Apr 2026 20:49:09 -0700 (PDT)
Received: from u94a (27-51-0-223.adsl.fetnet.net. [27.51.0.223])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2de8eb8443csm925237eec.14.2026.04.14.20.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 20:49:08 -0700 (PDT)
Date: Wed, 15 Apr 2026 11:49:00 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 00/70] 6.12.82-rc1 review
Message-ID: <2ytuw6l77ocy3vefh22hbmugamwlmle4aueyzwkukuhywh6eje@nc6hf2ugu4ny>
References: <20260413155728.181580293@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>

On Mon, Apr 13, 2026 at 05:59:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.82 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.

test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps,
test_verifier in BPF selftests all passes[1] on x86_64.

Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>

1: https://github.com/shunghsiyu/libbpf/actions/runs/24418242274/job/71333106755

[...]
