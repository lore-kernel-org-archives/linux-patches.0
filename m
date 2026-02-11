Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314EE1EB19B
	for <patches@lists.linux.dev>; Wed, 11 Feb 2026 11:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770807691; cv=pass; b=HFNmDB/PKjkwQtGKHsYBVJEk9a3XbcgMucl6mveWI+kGvOdLTM8v9pxm5gXr7BwfnD52YgKeNUlkC4kZLyM+rdM3+Jo5BN2z9VDXMzju58d9bXoxmK45p3qQm4yRYK9b30Fd25hjy1m+FVg6ow7Gn+I5rFLpHBYbSkl0VBKD930=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770807691; c=relaxed/simple;
	bh=JqiUcrVPEGkczAnmhnow0+C7TtDnYzm3KGJtLkBlmy0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dmb6R9F4YS8Jvr5W+NxCHeXZo4bqRW1se4ImbzDITXwuzZmOmkAGZugtOX25N7ZYaxtFsEAG+8ChSqOdAIbM7T8mYPVdBH6qYI7KE4Kn/xgUaBe2A57Coz8usEh6QrLlYIzsnZ7/TTMA+2YtgQhQ37tDj0zWZnrzvwGFksNAEV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=Wt5sjTf1; arc=pass smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="Wt5sjTf1"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b884d5c787bso837792466b.0
        for <patches@lists.linux.dev>; Wed, 11 Feb 2026 03:01:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770807688; cv=none;
        d=google.com; s=arc-20240605;
        b=aiQsIqL2iSBTSoHGEt30BGy1H7OA3lM64w1CAOVDeEMiwngdQqdNvbZDDK0mVPrQDW
         j1uvqA95j2e8IH3CqiI1yU2L92wJ2I/hje9FmdaecgFxl7pCp7RqlsQPTYRJuOzpMSLG
         taC4xkJZ5w6rnZKJElk7qft6T3zR9NUVYwWLpnULV/5kEhacXh/BMSoYzisXCiOdeIv0
         GO4S+80VV+E89NUsgnil4bH2za2QeWedXwODpgRfVqpKs738UW1dLwEoTyTWtLTnic9P
         s2ZZKv+Y5P07V1/UH7sPc97YfVpy11TGeXg4/MNR4j7nk3YUHqKvRsnn8jLyubGjkrp0
         1xtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=hpqk6MgcyXhDEIdxeR/kAmmG0DQRv4pU5g7p+4Hd3Bc=;
        fh=RDflecby8FoBNOmZ0q+V+lsw8gPE639ns9KCPijAhpA=;
        b=HU99YB3Uuhdg/bcdOQi9ZvPL0QqqQQM+xjdzkDdVxwJkYr4BGiUpgKq+dEs5fuTZ89
         wKml/Xrl93HXV0oASQGFrZX7zbDOPdpFASvNxpv2aifeXsXDFwOSAcgLjN2HV68pMSiv
         qFSooUaYgTFiD6iLoEkk+P5YtVl87vvnw1LxmBfFAwUEMZy5vBfoonWgLrCL3NM7zMJg
         6gpT5aPaTX6tskjFqkvwxCj9g9+v5Ivodeusj+VUFlY/3pOmbjAvRZTWzwiY3b8ZY1v+
         /rcEBxZ3clMavZC+UYymT7kJcp8VuoOLDTcdlWbKrv77sDA93uGabz9NLWWip1ANJeWf
         845g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1770807688; x=1771412488; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hpqk6MgcyXhDEIdxeR/kAmmG0DQRv4pU5g7p+4Hd3Bc=;
        b=Wt5sjTf1NesJyB0gFuiy3lfM66tQYjP65ZkWnG8Nxak8ZT+jFGuFr6rQhIJoNK7d7P
         BPWVObfOhr2xtOsHvf1VYZikpT91ZIQQzWDaeyJERD+jbzpiAWN8h4swhZFr8payQBJQ
         NaeOXSoFhgqk/S63IqlnBkhxZI50BpH2BiyRgg+dz1EJpQfn/Q+LVXUn0poW80x9Xg/3
         xioSGd0MUhVHbIm0RhYxJLWnFjYFEsBqP7OBZixgMRkORrU93RkimhqQrn7HcC5sLGBm
         4ApLplAT2uENJp62V2jrlNPbKeNwnz60gGDQdST19B9gLxoVy2KMau4CDlC66tpc6z/Z
         QmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770807688; x=1771412488;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hpqk6MgcyXhDEIdxeR/kAmmG0DQRv4pU5g7p+4Hd3Bc=;
        b=OFuU+FbnD8QjFi+cTPQI+ZzGa1EQvjFFT5ZrRIHaVZGo8D+x2UdraE47HRkCGoZJu0
         mxWQr+yM8haFBwAxggG/UDS0XuWgoP1TWqqxjmYz1kpc6d02z9Xh0AxWlC0kR1E2BFxj
         g9voMosBCnXi02B4cJS/2nicCGLA2OHxrVqej1Sf2CH0+u7FCyjbzPpbcdQLEaGqiKpB
         mkeNWWSBAFzS4zXmeTLdNLIJUqvUm5Mt6Zic/HUY/Y+5jRe4va6BzlygWTuErXZG/SnR
         0OkWNMoldxofmMc3H4L+raDUAYeoKa5nV3QWtm5393QMEHl1DaH6Y1rts79/7yq/soOl
         6kYg==
X-Forwarded-Encrypted: i=1; AJvYcCUjBrzDMgUOaWhdjngP29hdm0FAWbXbAJWfsdp3XEDSPSkdljhFHYVPz5gQ1v37YL+tlCdg6swO@lists.linux.dev
X-Gm-Message-State: AOJu0Yx69edtui1giK1qXrJyWUqwx0R0u5DEwu1YpQCzM7tUNS+rBchT
	MY2tt4eh/p60Jv916lX+hENRcb1CCmEpvNgqbI13mg/SiYneLJR3AItPBRXhNK8b7mTLwBf+Q/v
	+hu4lbPOFjG0LG9gnEIbL9M52o6hwdAuQPFut5SQF+Q==
X-Gm-Gg: AZuq6aK70MiOuPC4cj637yxc1e/NlEFqHsfR2jrHa5WwZL4MtRzIA2HtOrom6DKAVbg
	mR8mNcE+VYIJ47kWLmRfFjBn2TxYcNMt/vowXQgEBYIomTvTjf7jqMme21r2rWwGm7cJDg6FYlA
	Rxb2hocc0dJDKp3D8eg5V5DDHCD7i/zCbqOowaw+Q8nOVbtE7g3tA2OGBGy6P3TP7U3n8H+lady
	/md5nvRvzsAXVuXueKnLVQPjiGHCGMOWyaTR+VnpZTgNpBuyN/Jxl3Dt7xU+7kQ4OZWLCY94/0z
	nMaBMNq2aNq09CLSEc4u/LkMVlLmAHYW7JMHh/EDbHw4YyKYjcVMfB/yTuBmVZJZFzorYg==
X-Received: by 2002:a17:907:960d:b0:b87:1ffc:bf9b with SMTP id
 a640c23a62f3a-b8f6a92e0a2mr140228866b.3.1770807686630; Wed, 11 Feb 2026
 03:01:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260209142256.797267956@linuxfoundation.org>
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Wed, 11 Feb 2026 16:30:49 +0530
X-Gm-Features: AZwV_QgxbucpjA5xwrXpf26rYuNL_OjL7Eks33hmsL091RZWXIRatSzNicJabwI
Message-ID: <CAG=yYwmEqd0+s=W=VLeKckOsvg8-VukTDzGNMMMr_L7VGNu9Vw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/41] 5.10.250-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 hello,

dmesg stuff...
-----------------err-------------------------
$sudo dmesg -l err
[   10.122028] snd_pci_acp3x 0000:04:00.5: Invalid ACP audio mode : 1
$
------------------err------------------------


Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology
