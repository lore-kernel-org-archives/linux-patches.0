Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5CA7260B
	for <patches@lists.linux.dev>; Thu, 15 May 2025 13:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747315919; cv=none; b=Xu9oeE91N+IF8RGtW9znNUNmQAIIAkJ5FOpot7JnQIujKJEe4xpHytVbYaSzGXEGnzuPt3b0wZQqzOb+kPMMExhTSR1iPaJ3OK6/jCGLfilkbYSUJF8+e+LtPsngry15FZfghqFgLq/u/q/Qqyj8uDZQr2ltGNnUpPn6ucBlS1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747315919; c=relaxed/simple;
	bh=Y8GGo2AMVQLbxKDyPRfMjRfAQBjFC7gN/PCZcDvLNIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nZMfW4WdtFC44jSgQq6S/zAx1VrOK1ZjEl+Ar1VE4Gshcp/scls7Cj0BJxAx5RJ2gaHBLq9zAJDa0/XuwxH0bsdehMxh0bOog9Sss5oAH7/IS2qMTzt91e8KL2bacckjrc6BtrsvTwJmq/zIXj4m5dhSV6qkKA+GzcKfCKp/xlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=c6cJpU6f; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="c6cJpU6f"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7c5568355ffso76931885a.0
        for <patches@lists.linux.dev>; Thu, 15 May 2025 06:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1747315916; x=1747920716; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=idQ7sd0YlO6Ua6mQ5kuc0PUAbrEds8+KAPjDg8rCdTM=;
        b=c6cJpU6fCC6tWI2z7Nv2kFLUo0Ljm/2ZMwEA8OXrZjtJDM+yY3OZXWd2zs71oVxTsC
         RW9AlhxbKqpGk/DB055hBpI74ljT0xZ/l/aL2qdh8OJjVehPOlC163MikA5ROZnY/Pno
         gzI6hA7F+ZLTR1RZaSgZ9RwXIBI3rAfESj2JraenDpqwvW6E6koY7GnEucPkjh46XBgV
         vX60Rxbhray9oR9UWmEbec+DlrIN7rJghdgx9MOSOzFmEVYKv31BPlzYwRc9ktI0O/Ii
         hUAXfNYSjQnXazicbXdIpyE0fDHtlsFYIROoOk4Q47lEgBXC7Zi8z6Agrcw3H37ZRryp
         W8bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747315916; x=1747920716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=idQ7sd0YlO6Ua6mQ5kuc0PUAbrEds8+KAPjDg8rCdTM=;
        b=IgX9gUnEHD6mAL7v/ACwJ7QPstQ91s1T2kYd18g5CWd2BGkPbYlN+cYsVRTfWlYcwp
         hqWvWAAJQhCd1PkKvdY1hm8aVA+XosafRJn5bvJyRUWwAfUvJmyq8UoDRDjtNwXqQjcr
         SZXnPtPSbTz4e1FZ9R3cRh7oWNGWIGwkpBnr/3YTr2EbrGwzsI0wJFy6y2z8o7H47Fmg
         9tHKJWUmh+F+yFRyxd+F8lWp7zaAl/7KaUJRZ2zMoDSqjLinnKIM+EpIP9JA+m91v/LD
         pUaxrapE3wQxeXwIBikEsidf04pfexzk1QFK3aUlrUCSyFQTe87n4K940F5YLtk0/PLW
         kGdg==
X-Forwarded-Encrypted: i=1; AJvYcCVVjNRBweUmHybZ8ndApvpnvECNdmYsx9ivme8ziLMaZbt5AEhVqMfTTgbrtrBeltDPxl2bCpWk@lists.linux.dev
X-Gm-Message-State: AOJu0YzJ2HTQPJsbrRTCP3Ub6V7pO7yMIxpe8vWz3Lzl9BiMOZwgexJN
	dS2k5ZcAOj99hWxwsiOCe7ttapoLCFA2KcrmF8K5GR73wcqXBZqsXHxWYdM8dGqaHISgDrMZ45q
	sYZFMYhXNNC+BdrVEJgiSXYKcm9qvXkNG32hi8A==
X-Gm-Gg: ASbGnct4pL9m1A1EkZ7zx+RZeQgDBeXnn03CmIGeLzp7qy7uwohzdEDeElmYVtze+eE
	rJBXOjxM1R9A0sAX+RAKvnRVveAHHqApDZeqjRWxtpCMoA0yODlivCRhBq7stUigdxTrKu5/J+G
	T4Q69xPgcaW1YgTqi8uLsRZoN9vLPtaHkx
X-Google-Smtp-Source: AGHT+IFftrViizvwzo527CdaZ+aGd3PB2+/eA4itoniQfclfljSm+WYpnBXwFNoTgGMvKSyjqiFv6xwETd/kIumJRy0=
X-Received: by 2002:a05:620a:2445:b0:7c7:b4ba:ebf9 with SMTP id
 af79cd13be357-7cd287e16bemr972802585a.22.1747315915661; Thu, 15 May 2025
 06:31:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250514125624.330060065@linuxfoundation.org>
In-Reply-To: <20250514125624.330060065@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Thu, 15 May 2025 09:31:44 -0400
X-Gm-Features: AX0GCFt_T4qmlAP_NoDOQdZAbnEbFphd6WaqCYxvy8tpdv3fkVAu8JdgYSY-VoQ
Message-ID: <CAOBMUvhtrfhJ7s2s6nL3dSoq2a3YwrHV60eRQ5e4si6Qhu3tdA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/184] 6.12.29-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2025 at 9:06=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.29 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.29-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
