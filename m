Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23791EB21
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 23:52:52 +0000 (UTC)
Received: by mail-ej1-f52.google.com with SMTP id u19so79249602ejm.8
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 15:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y/mZXU7qRI/V/MvZX6ht1aHbNSJYEFnEgfMHUHtp4/4=;
        b=2yW38aMpSX0exFi22UXZave3cYZHK1JoeAf4qPlGJesusL7W1YvUXhuBbJAYP+wqtv
         DQOn5zLJjpN2gtinBz+vLvTwfT3F4KV9rx2EKDiuU/UMoT7/jbQsYH1pHCrm1ORaDMdq
         ur2eNlrMJcsJ/T+IEaGbx73/H6q0nXlPV8qrFK8KXSRkrWup2yi4qro0I1Bssn5TXdhi
         LUqZc3mrrQ6kOLOXH/IhCtaOQdqc0rPA4xC/CbdGTqckuqmudqKMJD7f9K91FKh3C5hf
         jojWsdAb9bAUiitwevT9sX+Khg5DXK9K9Hb3tSJEO+A8MYd7g9zFpLD9BC8SQjzcXh48
         fHnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y/mZXU7qRI/V/MvZX6ht1aHbNSJYEFnEgfMHUHtp4/4=;
        b=PlUNh9Mn9i+lX2M+Nwrqz8QxJkediwSETPxYXC0RwX22XiufhI5zPjsw0acQrKtcKC
         Iqf3faP6rMN9gPhXhH9s9HdRaI4cAHNSycN1onFQzFRcZQ04hF5U6L7St0vyRorqDaaH
         qzpMA5ugfmWpPQqIVkksV1D2MZoXpzuRwxID8KYT5i5+VGD0VlhNBHKJr+3n6TKClg/F
         iTveDSLLRCG8kcyji6xmnYjPB++P+EuEupNECOpbEEWQfKUknntFy8YtdolyvJxLTIH9
         A4F9Td1J38E1d2N0/4RWG4N0/l5UGFbk39qg6rhJylvw5n3Wv5YnohBX40lVV7Hqgv1O
         opEQ==
X-Gm-Message-State: AFqh2krtO2XWZVDqM9wIDHs3Adh7pu0C7ya8d9sBhtI5Q8T/a/9zhMHQ
	+f1vFEPm4gw0DWhMGWqYIkD3vb2THxupxKMXE++zxQ==
X-Google-Smtp-Source: AMrXdXsls82t2PILkD7G2zbDyv1/54e4DjMDxXCi0cPvCotauoy67Z1f1l0rg9+LbNztFvQ1Za9slpIPhArg47hL3F0=
X-Received: by 2002:a17:906:80da:b0:872:618e:b01c with SMTP id
 a26-20020a17090680da00b00872618eb01cmr350888ejx.275.1673999571245; Tue, 17
 Jan 2023 15:52:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230117124546.116438951@linuxfoundation.org>
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Wed, 18 Jan 2023 08:52:39 +0900
Message-ID: <CAKL4bV52YzXBFhjNQO32iyv9N1Ybe5m_EWus6EQSqP=c1QNOXQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

Hi Greg

On Tue, Jan 17, 2023 at 9:48 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.7-rc2 tested.

x86_64

build successfully completed.
boot successfully completed.
No dmesg regressions.

Lenovo ThinkPad X1 Nano Gen1(Intel i5-1130G7, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
