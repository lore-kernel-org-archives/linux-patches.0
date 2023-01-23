Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EECB8821
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 22:13:30 +0000 (UTC)
Received: by mail-ej1-f54.google.com with SMTP id mp20so34292282ejc.7
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 14:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rYPZ+3YT/ARBog0kfKkyDDBPModET6xjd2wsv8OlAvE=;
        b=WXh+sD+kaChN4eOaCIw0TMZJr1IxW6MHJiCxhokTU3okHjoJ5FnMq9GXK2LwxnE1P8
         0VkGNKmYE02Rox1UIC4Sn5jEamziyDba/YMDXSqQ8q4wuI1/CEYFmdnOj1u03wzgJrNy
         q3jEpnFvUBMcwXcQGxNSJAV9ddhKRjxFy7FhJD95OQyQQSES8UzXDN6sqSm46k/9Q+3I
         96M7DxyCsUQjRm2vuYlvGmBJnyqggF8qZlHSQZgnO6c3yjAZGbvhqSjV0K7fVlcTPOTp
         7FLeAsGUtpXromrqzyz/rp/XxEXx5+7iXmTFTpoxCrYecyWt4nDIS2Tq1350S4gYbRzQ
         3VSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rYPZ+3YT/ARBog0kfKkyDDBPModET6xjd2wsv8OlAvE=;
        b=t6+pk0ErQmBJ7EMbBJ9rPAMT2MygN0rSPhd6/8d9+1Bzn7eqikmc4r8SI31u+ueQxv
         M9lbU3D9eDkoRsdgMBwL91fa57R9kZ64GIlwHBvXnFgP9jokG8WZ4lKrvu9FqCosbBI0
         w6+tM7oKNQWDbkqz8v6XMeqKzoPfN9Y2B0baT7HaHgKDCMRz75jMf50KqAG/y5NH8d9+
         IVyHA2uMtO9GZHcNbxE9JLW0iBMdwanUDZDPjyTkTiIeM2W2GQbgEVH0AUpuoSgZYJ8V
         Mnr079fO02aPYjPArslbKa5nQm/+4qM3p8P489HFHDJ1gZ1o7VLeQagEJyXA2yJ+uFJN
         PjkA==
X-Gm-Message-State: AFqh2kpgpWN5KFjRo2gleQk+HPaOascjYF0aKUo6YyrSVS4IqQledfnW
	9Uy7OnxFnfQOjNM0X724qa3dUyEcJd/dZIE0S/sIiQ==
X-Google-Smtp-Source: AMrXdXs2HnS1FJKy54VHK8KGVBckkCk5VAFa3vB+laLe/GcGT2JQehojeIFRMupuvIsIkQctXz+BF7H8u3GtSEje2FY=
X-Received: by 2002:a17:906:151b:b0:7c1:6091:e7b with SMTP id
 b27-20020a170906151b00b007c160910e7bmr2615615ejd.513.1674512008619; Mon, 23
 Jan 2023 14:13:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230123094931.568794202@linuxfoundation.org>
In-Reply-To: <20230123094931.568794202@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 24 Jan 2023 07:13:17 +0900
Message-ID: <CAKL4bV5C27Su54FT7SSEDiCzH=2XB7JuPkZObD3HHsQB4NhxGA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

Hi Greg

On Mon, Jan 23, 2023 at 6:52 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.8-rc2 tested.

x86_64

build successfully completed.
boot successfully completed.
No dmesg regressions.

Lenovo ThinkPad X1 Nano Gen1(Intel i5-1130G7, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
