Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1853193
	for <patches@lists.linux.dev>; Mon,  8 May 2023 12:51:56 +0000 (UTC)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-50bcb229adaso8543179a12.2
        for <patches@lists.linux.dev>; Mon, 08 May 2023 05:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1683550315; x=1686142315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yFivrtig9OalB2jQkNmqkqk5bNHkWlvaRKlvji8EAhM=;
        b=jUNUAuQ8lqy2X4B5qryu0zGlFNNkgTQeSpmvwVdIc1290XSGbsy8n1Rbx0um+wwkap
         V6vnQLrqEKql8a+cZKN50aEMj5Vh8+UhKjtCfRFvFRVsGUc8eg+Dh/zZWROt1XzE26Gd
         qydb1wJrN6ohz1bA4iAZLJXFg6UCSU3Do4Ya+gaDCRS3E35/eteRxO5rWCpyKvKxDWJR
         6Fq3gno/8DSlqoiZALVWS3oWEthH0THlAx5OfYLoNzNHoTh/vwUewyelLMooTq8TlLk1
         0aKufMCb33d2URm9b8dykcStXthn2DV3Kl4ZQ3/9yeifD3DP5UGthO0qX3Qz5DMx9qKL
         taPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683550315; x=1686142315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yFivrtig9OalB2jQkNmqkqk5bNHkWlvaRKlvji8EAhM=;
        b=FHZ6VJrA8KqQfgtopqRPzB3vqXUj8jrD/NAEuE50YomIahAd1ZJSQq8l6OwV+3lr4a
         pBt7NlZ3YNPSopWIZ1OT1WrAfOcC1E1PI+R/KOrHCWFG26iGr4z2B9Wkcp0j4beaUfkM
         MtxGMTvIXZGlWfoZp69EwHE3tajLwqEGVQctm8xZlax1p1Ta19xhC9r9f36eSLFSz4VT
         F8wyo1/JczRJGHCrnbdgBvMkRXGNGMNsYEn9sX87MjbF1SXVapCLFgF6pfAbNrtOpPHN
         cX9F/hvdYBV3eY4mPghYE9X/JOXSXqn8KC8aehHhAu3a/i0w0EaF823zVTYVYjvYdTTJ
         dIAA==
X-Gm-Message-State: AC+VfDxswUD4DyrZ+5tcUb63usNkIxNsbbwn+RXnrrhcbCE47dnGgajO
	fXZ5heJSJi+6k5wnaabdSj8FP5tkiD6k7qcU0c5NmQ==
X-Google-Smtp-Source: ACHHUZ7U/+wY/Vx6PFEt6WoITv7yJSSsKVa65gZ1L/PI1Bk8WFvhVMO5mg+66YWV8epPOITeYa8yUpVlYT6WyahnmLc=
X-Received: by 2002:a17:906:58d5:b0:969:9fd0:7cee with SMTP id
 e21-20020a17090658d500b009699fd07ceemr234143ejs.10.1683550314783; Mon, 08 May
 2023 05:51:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230508094421.513073170@linuxfoundation.org>
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Mon, 8 May 2023 21:51:43 +0900
Message-ID: <CAKL4bV6QaUA-Psd3dpdBL7QKxg+QwCF3LwYdYVfM-qDKqZFYPw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/611] 6.1.28-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Mon, May 8, 2023 at 6:50=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.28 release.
> There are 611 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 May 2023 09:42:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.28-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.28-rc1 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
