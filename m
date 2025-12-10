Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AD81C6FF5
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 20:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765397565; cv=none; b=T3+aXq9KRV+rRLbCG6zTh9u4a8JQYaZpVBqTPu/utt/s6o4nwHH+pXJaEy183Vz+9nux5ic4lj+l7U6iTOcc2dA4GprwGu0oO+pzl43c8B7pRDh8Cb0u9Cq5D28QWNM2YITECBsSUvhx5ozjqHK9yeAsm1Xlv6oLDERRorxye/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765397565; c=relaxed/simple;
	bh=/vqf8B3VOiHUz8HK91xOa+WuYkkvvl0yRf7Mp0HlYMw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c6dL7Q4pnWPi/EvOO+ZgFREcqkRk3Tx9BhVu45hZB4WXGUGROL1qHU0CSu4bPuny1RF2A07vJYb+VaRINEXML95bkzV9LQyw0bQMgsErydhC4h5tqt3jHgRQOnNBEJiNihfEQLyCfvAOhJwQT0qcQwGWZYsOE5PYShCB6AXjOKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=N0DO/L7O; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="N0DO/L7O"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4f1ab2ea5c1so2031111cf.3
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 12:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1765397562; x=1766002362; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IX7xdu9y9mJPk8s588MHVub57pdeM7pGfuNwpdBj3Ls=;
        b=N0DO/L7OUwKfzjSg/byFEqMGHBGwh1Id7wORoOH+l6nnwhXNmrWfoyy/4X/IY+sSAF
         HAcSCw13rvCC+PJnDPZYpkYZ+PviMaWanmTvFkdlYzo2S4BQJjhWas7qDQnenM8gNPJK
         PPo/h1kAzmEBMV/YARs0qAcQ98MdL9Zz+KtT3e1FbmvufBNfZPDvlPCAFru7AmBSXN46
         dYSMHRp7oxsCy+lY5jFahiWq+sRkpVxZindnkbW9o2nbzA+HlQwmshmWdxPw8La+S2Te
         Oeg2qvanSfoErUgcU9y8uXViVszbEQrt5lUJRy2zAEZPRP/M0SNhvpU/nePND5zu5Y5H
         z7Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765397562; x=1766002362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IX7xdu9y9mJPk8s588MHVub57pdeM7pGfuNwpdBj3Ls=;
        b=ZhblpaSMKKwXpoTvRXg8IqewoSPrZt/00L/9m5sqn60c8ITZjQ/VBwVHP45Ce+o8qk
         E3njh+andgK3Vuq/i7PrQJNdbPi72Mvz84HYmf+1q8GHGLy63o30titqm/nKrUQrugj5
         2+ZZF28cpPhZgcNh9Rorloe748H9puGhgrcdgyu/haPYoSRbtWSJd5Rcb0fIjfYAntP8
         q0+VS5jRSkXF94p4WjTATN8erv9QC1vULP392uYi0gfvlei39NViF1AitDZPtfhUM9uy
         M77wMk5MPgqJm92WIrx7Vn9sRsv/2SYlLWXT4kauZerTUy3exM8ter7w/WbfonO9D4t6
         BOuA==
X-Forwarded-Encrypted: i=1; AJvYcCVqnRLnZnrJwazpL6Fb4B9irILrtEBNN3Vig4L6x7ADwe7pHWosAtn5jd3cI1QWmXmvfRm6t4ik@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9dAolhI5KMcCMZ+TO5imbBwV01AphgRwpL9FWuMAA5LaHkLC4
	+/boIby73Z9Q7AirVw7voo7+JdXlVe8UjIKPnfOl6whaYR9+pB7FUNx8QAUp45ea7DCi+ho+ojs
	mwMCmYDE8Eu9vp0mlyRzQopJ6W50DxN9Yf+QmdCfOhw==
X-Gm-Gg: ASbGncukyYuxJuU6CXTid9CAZwnF6Tt6UADgzqU03q0sAlgu/yai4jikRA4W0bPLlkO
	+vGN3Uds6OC2ieyzfk+147sXh9gTBrPNaFYbxj8xW1QZ/2x+S6bT9TzJYqxQXacVpj6/5LjPg9g
	NhQa7gDMXu47nqQbBVFwFCURXueZxrbz4Mab5N3gk0HX5cV0ckm6bVxaxzVXZ8Y3CBJCJNwLpsb
	Y6o257jMxj+etWuhKlGw+YjEXNvjMtr+p949qJeYq6QqjKLqo9+dzxLCEFrrw6TSRo/OF3F1S7v
	y8i4TMY=
X-Google-Smtp-Source: AGHT+IF6beW/FTQQ7sngK/DU1tUniqhX+cg5rzzfofzYLtiePPogSjjZLPMyZMXWF+zJPlOshlGeLXNvAdNE2XywNtM=
X-Received: by 2002:a05:622a:1e05:b0:4e8:b446:c01b with SMTP id
 d75a77b69052e-4f1b1aa7b84mr47097291cf.61.1765397562358; Wed, 10 Dec 2025
 12:12:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210072948.125620687@linuxfoundation.org>
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Wed, 10 Dec 2025 15:12:31 -0500
X-Gm-Features: AQt7F2qAPAE15_F1zEglUDRcRtJPoNPc50UUqoV-4xo4tO7GO-lk2vWhShSlXE0
Message-ID: <CAOBMUvhCuDJa50FXJtAvCVVu764ue=T5x+Up9jCHh29Mw76rtA@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/49] 6.12.62-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2025 at 2:32=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.62 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Dec 2025 07:29:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.62-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
