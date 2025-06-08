Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D2B139579
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 05:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749360424; cv=none; b=lW2Vh4189+l5omLExvcNzT64hWJjnx6Wh42nm6JbGewMRyxaphcMiaa1P1RouSyC3FoOhfSoMl14/TKOjAzNlC0xGB/Ns/oC6L1UZPnxEjw8MnUXqCd0qlDSopUNF9bmUZ0mm2gHkxO7QHUyKhBw66/qKRt5/lx4RCfwmmV0/iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749360424; c=relaxed/simple;
	bh=dRrL2HB8b8HocCliNlz4XgmTphB5h47K3ni4076ycps=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=in696vVutzmkD1+tbPLIgvYaQa+4TJjX6ZoBIeqg2GTgXTYFf+d0MzO1gtn1HhgnbUo9uEXGqnkvDiUTrQLS6OwwCx+I9pfFs4R7F14eDoCmS/R6uGU5fB872gc96V8SiBtZBqCEAQYPNNigM1nBGM38c7mDGDyiAI13ANkyCK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z1Fr4tCH; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z1Fr4tCH"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-234f17910d8so32807435ad.3
        for <patches@lists.linux.dev>; Sat, 07 Jun 2025 22:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749360421; x=1749965221; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRrL2HB8b8HocCliNlz4XgmTphB5h47K3ni4076ycps=;
        b=Z1Fr4tCHlNOCDnFQZ9dgpCuZbUtF2mh80Edci2JicJ5/qj1KuViX41m6STVEi6uTCm
         i+whrsVEj8MqqXUnsu8/vCPlEqwgos3jNB6dLKkD5ROMDTDZO4anUWrIbtyD/0RJsE9W
         H2Dm3oLLNvxOsO9h7lPmqOiIZcztJ6UqQvnxGwLw6U6fJhpcx+j2KGOQiwVjW2YkRJZV
         BQD8tKFzJnbPGgaJLKUq/EHJ9A/0ml0mYpcQuWbzdyqOtgLAal7BotwL/E+XveWZ8mzs
         3Zo5Y2bxDVSeW+mrgppub8KP941TE8FTeDBwaALzvFZcvp1SBzZ0J9jKnSVG6AH8Ykb0
         +1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749360421; x=1749965221;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dRrL2HB8b8HocCliNlz4XgmTphB5h47K3ni4076ycps=;
        b=KfmOUi70iE34z3TrTT1BIB11mHzxpsr+JUiPfQnJ31qqzNq8hNd4a/vV3CiBFsspfK
         Ou6eSmeWZegpf90Z3o5knrKvVF8Q7J25y2p3H+WMaTWqFOB5EVIAUzA0CmQfxjcTrNvO
         jeFr5bW6CPbS81aS/iJeR5k7r6pMGi6vG6FXzoPpgHCrdiPAGXfwsbH619soZF6KEWH5
         XU12D3PDuBbskLmy2vZbaCv/3UvfWWjQVkNDsF7+99Bt7YK4rB0DTeVT6+X6L0eFA+sf
         92QRLHruE/W1c0hlnZoajMMRzEJRAhe+ZB+/nLVQfEcAfRAfPnrHKY6DKrb3nDOdI4C4
         eDfw==
X-Forwarded-Encrypted: i=1; AJvYcCVOQlDLTLTgq5czU/eamLC1bSbwAAPFO6PWtgUvRScXiZnJ8ehwzgYwd1GThr2ke4QzbQMYIYGX@lists.linux.dev
X-Gm-Message-State: AOJu0YzcVE+p98ycDPagam+N9JT9ZLb8oU8RVJLIqNwv0jr8XCk5rHMw
	5NlR3DYl8zTvOiyDvtdXo9wXdu8ogdrcguDMVXkIZnPst2kj5VgVFLdiLHLCopoi8jl169yeUhS
	4ILcOG92u7RWbkOI87d03UQECaoDoPRs=
X-Gm-Gg: ASbGncsRVKruRzIodHyWqxPDZCG1mAljo9602gpOTDNmznve8sIv1ckKCRJnNfgS7LJ
	yLL0YojYF5gcJxgBm/YpRd5ikZp94npN0k5/OytP+GnZ/Ic3t1SlYiCFbQg6Tvq46G8A31hIfgT
	Q1dgiToSnI1vhoqLKPhG2/tjC/nMkmOsXd2pVSegoyJIcnFuM=
X-Google-Smtp-Source: AGHT+IFH3mjameUS5DgXrXypeS0/VIDnq2gQ05i1f/2jxi72R44xM8J37QLH7gFhbv6mXFQ1B3kfJro1laNaeclXNQg=
X-Received: by 2002:a17:903:120f:b0:235:2375:7ead with SMTP id
 d9443c01a7336-23601d4c62bmr143269885ad.28.1749360421177; Sat, 07 Jun 2025
 22:27:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250607100719.711372213@linuxfoundation.org> <7fb63be6-8c3c-4f8a-8a34-9a6772c7ede5@gmx.de>
In-Reply-To: <7fb63be6-8c3c-4f8a-8a34-9a6772c7ede5@gmx.de>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Sun, 8 Jun 2025 07:26:48 +0200
X-Gm-Features: AX0GCFubASqaPghHGVYHa91dU2WRD0JBR-5fjSDX0Abh4qTl7VRZr5wDFZHECcM
Message-ID: <CADo9pHi4byk+5X2Kg0NUnwzHYzGh-Ka-AuW9eKWJ9ky5p03GJQ@mail.gmail.com>
Subject: Re: [PATCH 6.15 00/34] 6.15.2-rc1 review
To: Ronald Warsow <rwarsow@gmx.de>, f.fainelli@gmail.com, 
	Luna Jernberg <droidbittin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Luna Jernberg <droidbittin@gmail.com>

AMD Ryzen 5 5600 6-Core Processor:
https://www.inet.se/produkt/5304697/amd-ryzen-5-5600-3-5-ghz-35mb on a
https://www.gigabyte.com/Motherboard/B550-AORUS-ELITE-V2-rev-12
https://www.inet.se/produkt/1903406/gigabyte-b550-aorus-elite-v2
motherboard :)

running Arch Linux with the testing repos enabled:
https://archlinux.org/ https://archboot.com/
https://wiki.archlinux.org/title/Arch_Testing_Team

Den s=C3=B6n 8 juni 2025 kl 00:28 skrev Ronald Warsow <rwarsow@gmx.de>:
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
