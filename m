Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CF23ECBE7
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 13:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770385991; cv=pass; b=dx5CoJ+II82nK51ICDl/4aGzS6hbPVW3XvqFq0AGW9QbzqZXAO4JIEJo2sHYHLbMxtQUEbMNANVfYEYjf+u1bdq0KnrIyWmbK5d1ruvBo9Wq5v9Uv19pEHHRMOLk7lmtI1BGyfs2YoMyDYlC/phdnB/1alxIh72IKQpNdUfgISc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770385991; c=relaxed/simple;
	bh=xPmqZXtDaeZy1l7nPx4Li+ZJLcAZgcgfRCXJGOO8cs8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WQ/HWJ5DV2XNHgRuWupjZJjZK3awckWs0IsPECJqnewFvTIIoecxGwoSeZXFDsmannuPag0vltEfrj7PkVD/N8azVcqjdp4+OH7L5AQnFSEWq8UO2AYoGNW4Q7QfjUM8mdutd4rV96VchRz9P30EGFrIX5W1wYHpq89XaYot8so=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b=v+u5ei9q; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20230601.gappssmtp.com header.i=@rajagiritech-edu-in.20230601.gappssmtp.com header.b="v+u5ei9q"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b884d5c787bso125665266b.0
        for <patches@lists.linux.dev>; Fri, 06 Feb 2026 05:53:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770385989; cv=none;
        d=google.com; s=arc-20240605;
        b=hDy7FYHm4U1G6BhOJRy0AuH0S0t2dWDCYoV1eCjBgn+XI7HbHysXy8bmEPwdmvd/Kg
         hXu6dlKlhUG6WeSrI8ZZujvlBfTgUgx9U3tmsSJjH4LJcMuQTDz93NxOmRoQXuhoNFkk
         dHjtg/4RgPHJJgV+Lh2kG/jQZ42T5o6gXBZZU/ZB7YkuMj82qE2Cr7MRv+/7D0ueMOUD
         4njDfcPQ5QedjNUseCG7+yXBF/Q08TSTHdt8/RsHY/PFXpPNhmy0jtXn6Oolt4zvA+OY
         Paf65vyfp4xA9SAqo24NdZ7pCQAWhvOYnHJw2hspsiJxgi8ckmvi/G8MdxprjBKlyLbb
         wmEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SA4i154NvMRBgrttmSXsePypeEvh1Nz55QBHELzuvgg=;
        fh=gX3fE9AYfrzwYbRyNefse9TkmpVthDSmJfV/qRzng5A=;
        b=ThtnA6ooyPmY7fRMSabJglRwr2Fd82Dmqp0Nis6vJVWjz/ysrE7PST3W9na5s3sqlw
         j6GhO9LHXwMkAQYDB5BmaKCjK0QwXJuAmq2CpZO1fL8ce/o4h/B+vN5TbZTK37lE5Lkg
         kdtgH2DPZrBxcMzV34Mhf2+G/1wPqq1A8ASRY4yvAf0JOKbvQaj6Zt4f11Agws1poPAr
         MLdEx1dtJTFNqEJcyGbi3eenqYqMXdD4LlDwGjXuzg72phAzwudSPl1Dk8OYxsWRPbA7
         zhE768fWuUdncZ57RVfpNFFHul8Vns1UUPAOKJckJ6R4TU6OjyaJyXGeFwe1Edn/Q9yE
         FpXw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20230601.gappssmtp.com; s=20230601; t=1770385989; x=1770990789; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SA4i154NvMRBgrttmSXsePypeEvh1Nz55QBHELzuvgg=;
        b=v+u5ei9q/xqQ+mDQ5r9wDR2rQcg+S2jsenfac6sYCmbAzkv7hipGjgGQTfYWcGhHrD
         S26QdFVkr5KG7NNMwOWTe14vpbnSidcvLKElYpP95P+CDkr7lJodZrtCbjJ4TtPXuddh
         IDZcgca5LIDq0gHhe5Mpnfv0lVeYBkB6faPE/dWRb8ENP71ZugqKOmeJYGmgT+CXMLif
         N0k0zzqIboErN1LAIv6hvkH0EgQU+LsCvCSSyMOPLKG+PFhM7bWdkf71qkK8TtUSl78X
         v510LFOKaCMRqCsEjgFaXYcJdtyXHg6Ura7uY0AyXLp763tVrBtUBtYNXdqbmd3PEO4n
         WVuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770385989; x=1770990789;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SA4i154NvMRBgrttmSXsePypeEvh1Nz55QBHELzuvgg=;
        b=kwftsNujqp4cDmHDEovXWV83idOJw+qtueo+tHe4MGgznBTCsAGI+4mKHGNloXLAqU
         q+Nlk/WyASsGRQ3C2sGKPWPuqfJozrH2kEIYLsRvsL7/xV8rdqLoQc5PPSrYQ20Tljq+
         oarRhPQ9+5apvyfmDJOVn9dpiQWMsAqc1ehHHPyUIKlqWQerqCDxfSFaODFstZxR/edi
         BAI4Yquvcv28HI82h/+cccUjkG9RICbSQmeEg17U8jNizpA7QBloiZCRg8peQIC0qaEq
         M8vrqH07FN62fJorhiVIe8jN1vcvSMDFjYuGV9RYIEkb4TLN7X+n5SLuBIqzaoJK4oIw
         X8kA==
X-Forwarded-Encrypted: i=1; AJvYcCXP2bNrQlqKG+5tR9RZBfaPSpbcOIAeKGcjvOCpYOsPUE9ep2eYayJRRjEdKjtisuMt+r9ckzhS@lists.linux.dev
X-Gm-Message-State: AOJu0YzN+aCrBPUaJUJFaNbbn+B9etA7N6YTx6G3xHvvkv/0S2bQQDpf
	T/cmcfJvoSQCBy7jl5T2YghPORApYrm0+43V9ev+qdk2jxC3tYvaW/iPXBmKwcwzKzPg4Ckst8U
	XCYmlbHKSIxoRty5rMc8KqjcbVL7eolH+1170Y+COwA==
X-Gm-Gg: AZuq6aK2+OU9NzkwDq2UGa8DOj6g22wx+2bFxXn+qyOP4mzPJJkfhBBQYvCLPVbmmB8
	ONivcGY0tJ6FxxGR0/8azd390maWVU61IlQ3gWv8GqBtwF0P1sCRYEV9BnPL4qRrZ3GOtLoNcDJ
	+h7c05unXlp+AHdF72WDVxli3+tU2ubVEs/qno92jn5hFuFheVxZEVsu9Tg5kXKce7JOTteOwN1
	72N5KHmALdSPCcB9pCahF3JhD2YDYxxpy2tjdD30oEtK4EFHC44YcLvL0GTwH5pUd3tgZ+b
X-Received: by 2002:a17:906:fe02:b0:b8e:3d49:25db with SMTP id
 a640c23a62f3a-b8edf3ef349mr161838766b.54.1770385988903; Fri, 06 Feb 2026
 05:53:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260204143851.857060534@linuxfoundation.org> <CAG=yYwnSJCp6W6+0MGG_aaj+Ao7Qhiza0FKvrP-4wf6f9x1SQQ@mail.gmail.com>
 <2026020601-persecute-avenging-f539@gregkh> <CAG=yYwmqwb-v-31bk5sXcBGtTQ3JGgH4Kse0nWAtbX5f01764A@mail.gmail.com>
 <2026020652-quarry-clench-2fd8@gregkh>
In-Reply-To: <2026020652-quarry-clench-2fd8@gregkh>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Fri, 6 Feb 2026 19:22:32 +0530
X-Gm-Features: AZwV_QjQQIAZjkHETPzdJnQsi4ToG4FQet8_ZVQlHhpyUdg-4_JuTjRFeG1QdFw
Message-ID: <CAG=yYwmHBDLuUzGODNFjWmgRi7hOkc3-JLRwf0ayf0+7TcagTg@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

>
> So it works now?
>
> I'm confused,
anyway the build works well
thanks related


Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

--
software engineer
rajagiri school of engineering and technology


-- 
software engineer
rajagiri school of engineering and technology
