Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3192D79CF
	for <patches@lists.linux.dev>; Tue, 20 May 2025 16:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747759611; cv=none; b=rIREBsf3YUGqhbSk++BOPIzbH1y3dJbpWBnqO0/0SjDeCja4bLBPJuK9XBdzCk4uoAhGXzHd0LHhi35V0XfNTjqMfajZXZYxEw4iSwVoAvcuSqdXROJNKmw2ZkKSUKn9BxKVKuZbyADGUXaIM1fU1s+qVPfgWNs6j6KnK7rEuYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747759611; c=relaxed/simple;
	bh=eFrPZPfo5Ncq3ZF7wLia71+eXKw/J+EQEeW+BQJouJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=icjoQzPv/pO/bTbKlZ/ptfNo762A0x6KHhOyPPZU14Q2wRf1/dB/yXU7IJ+LrQHeRfosg/HGCAOVnPCbmCbmnC0kjHNv9kXS9lghfJt5CScQSSGMSQ9LJs4DZDAgZPsddI6fxDfSJnnrsfcxzkPKr2TdywogrHCsiIDyRz5hoOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fUT/BBnY; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fUT/BBnY"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-23278ce78efso9744155ad.2
        for <patches@lists.linux.dev>; Tue, 20 May 2025 09:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747759609; x=1748364409; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eFrPZPfo5Ncq3ZF7wLia71+eXKw/J+EQEeW+BQJouJA=;
        b=fUT/BBnYAUW9PsJ3Wv5l+fxQ+UMZwsEoGCUzYIe24Y3Fdivqf1v78z7IsAYoCbujNC
         ktMn2rMPDPX3JtuMfPq/5MYeqEggIa3g/YuIEEjGlQhZ9vUP0y75ZE8OqFlzja8CUzr2
         cu96ESf2QNdsngB6KjxH5JyEq/JT1vipCfbmZFD2gUYLYnUhd7jB9qfdzw+IhjF5wQHI
         AKsswcPTMf9ANOfQyZk0iyTjD5IOCD+3fNfLSR8uq04WDbEfnGUobPEWFImjS3VzCnMx
         +LeGtqbi7ECeFiWGQebvbnFGzlNiyE0T89mLH/CubLelDxPokZraaletSmqyX+Eplvyl
         DdFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747759609; x=1748364409;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eFrPZPfo5Ncq3ZF7wLia71+eXKw/J+EQEeW+BQJouJA=;
        b=axh5kmVgtlzZU9cAExwzinGOTWAcVFlXf/3CECwS0aF8MbVitmvQoUHJiSpdxifJxN
         gZu8t+oEoKOUPjDmgANIx7Y1fIGQDgmE5uvlcMxLlZtOkzEtdDWMiQK8L+U4i55Lep1j
         ICxZWSgIBnNwgcV/CPY0ZVVBRL1+wTX4mRGRXSLLDXFO6rtp+W8xnvClpoqptM8tLr5C
         CxjYKfEePPamYkb0WasrnjdmrL7wNrAFbS2EnsRznnHAUUBwJDjHfuYGU4sh1blBGtLZ
         2u0rz0CtksGlSOlDQQ4J5qgHAEr7vt8RLCRd+1aqflH1Yes6VSXzdFzolIcU23GRpyhN
         CiSw==
X-Forwarded-Encrypted: i=1; AJvYcCXTFBOc0PpTQRmL7RghZKJeRYVvIebgOF8U0UtdLVE/c1sZHi4oZ6JwWFJ+Yv1qgySE6r4ygicy@lists.linux.dev
X-Gm-Message-State: AOJu0YzhT82f37Ghn/nkpZoGfIq5381hytMjklfp9zVIPTGtOnxrYIDn
	f80gdM726NDhXALcnzvMTFbNGfnAhzyRbVdv/wIHWfoojuPZNdiZsXNXUHLqawUOwlPm/TkfX8+
	k/U1iWWuEfnsLcUH0vsG9adBSmTK0qBk=
X-Gm-Gg: ASbGncsrCLDWyo8arlxgn7oLAMDzU6/GmUPEccQgAx3UokoJKr1r6rXjyMcw4K1N/wo
	RQ9jjd2U0btr++WC7thuS/qEXXCupiQhHg4zUtgTckpnB2HffmgFDiafwiyJIx02j9hmFLzUfaq
	rP04GqrfLpFmTaXBAiNIM9whQ+5Xy4L9D0KNfYCSRdB/NZ6Zk=
X-Google-Smtp-Source: AGHT+IHl44caj0Z3alYhYLDCxu1knUqfE+ABQXqzZ+BL3rwp5RUHZ+NtBnwoggIo/FPZxb0sRDX/YvncK0AEOJk/OTM=
X-Received: by 2002:a17:902:db08:b0:223:66bb:8993 with SMTP id
 d9443c01a7336-231d45c4e39mr274977695ad.43.1747759609403; Tue, 20 May 2025
 09:46:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520125810.535475500@linuxfoundation.org> <1750dadc-5993-483d-a238-2060484ac077@gmx.de>
In-Reply-To: <1750dadc-5993-483d-a238-2060484ac077@gmx.de>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Tue, 20 May 2025 18:46:36 +0200
X-Gm-Features: AX0GCFvp7A_0EISE7yWjC-MAbJIjbPj6CegJS-lvJVlnsPnYKSlegLj2FP9XJC0
Message-ID: <CADo9pHiGtsAUquS3bPobsT+8ONXUbvUjmREKwbb0AiXLiyKCag@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/145] 6.14.8-rc1 review
To: Ronald Warsow <rwarsow@gmx.de>, Christian Heusel <christian@heusel.eu>, 
	Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

and the amdgpu thing is fixed :)

Den tis 20 maj 2025 kl 16:57 skrev Ronald Warsow <rwarsow@gmx.de>:
>
> Hi Greg
>
> no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)
>
> Thanks
>
> Tested-by: Ronald Warsow <rwarsow@gmx.de>
>
>
