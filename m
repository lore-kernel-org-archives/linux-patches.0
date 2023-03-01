Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4B18C00
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 21:27:54 +0000 (UTC)
Received: by mail-qt1-f179.google.com with SMTP id c3so11690829qtc.8
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 13:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q8pvJ0948Bk2bTb0EoAuertZuXCjz3BchLxRWB04Br8=;
        b=iUR84SphNv1FyhaQJhtzaO9+4MBhSlOjzCV+2WCUuwDRqrIOE0L6zYGz89lQiU4AZy
         yzJubnXadmlmV+B0iK8Hh8PCfXHiPPWDwpINBjUHGZnxIr71WemGK+ra1NabfgizxRZm
         kX7oLeaCiWmOTDSs11TgIQCs8c3Szd6q1b12PgPuw7aDC+aQKT+lwdqZlOBkq0J9mrXy
         CXioL8V1kWYdcdq7mPaH/guT1zxujVFotwLAdiDE2kDNJbiOgvvfv63dc1hUawvKMVzE
         G7D6ynOcKaEVrREA8cfvWj8xqaP7HgZScnz7fRQ0OFGPKzy4CU/YWfVN7hn/fowbK56C
         9gfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q8pvJ0948Bk2bTb0EoAuertZuXCjz3BchLxRWB04Br8=;
        b=cBVmC3Hi2kJFsgbUx5iZytTCU+CQ3Cdyzhew1yg2iwMG4jU8gj2cmJVneNnHZW8GJb
         B6hueUlQYp/XzppKkBgR2nZB4oFR08hmCQpbLkSw/ZJh9woEuQVbEzZ7PWMHnnAREVUN
         eSbC5vatYWlSOCA3hi1TB3odd6lacCl5q8sR+WnG0igie41ZgRV0b5eh8iKrq3uXiMHs
         DzMo+NvhWAtr0e76b7TrMLz/svTWx35Ide0vdnXiLbFZXdl+ULVejgKGgdVTRjzgE+6E
         T5C9p0/vKzRNkL/AYMHwLK+MYeZhDAU4p15JB4JzUR4rfoD040LoYoh9qf6+QRcsg8DM
         em0A==
X-Gm-Message-State: AO0yUKWWkynQbwBZCyWn4o6XEn5UODWStE25dUcj0IHAYq0aIqaNzJ6v
	J5tO4m17A5StqNZdyDI+jaYzPA==
X-Google-Smtp-Source: AK7set+3OG7Cb+dYkOj0BWXYtK5QZz0QoBg9DJDsi1ikeYlSy4O/EqZOXG4/cstsAfa3PjdHeMyv/A==
X-Received: by 2002:a05:622a:1356:b0:3bf:da2e:8c74 with SMTP id w22-20020a05622a135600b003bfda2e8c74mr14537968qtk.25.1677706073301;
        Wed, 01 Mar 2023 13:27:53 -0800 (PST)
Received: from ghost.leviathan.sladewatkins.net (pool-108-44-32-49.albyny.fios.verizon.net. [108.44.32.49])
        by smtp.gmail.com with ESMTPSA id l20-20020a37f514000000b0074235fc7a69sm9807283qkk.68.2023.03.01.13.27.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 13:27:52 -0800 (PST)
Message-ID: <5f6aae60-89a9-81af-0c1f-4f66dbb27f41@sladewatkins.net>
Date: Wed, 1 Mar 2023 16:27:51 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.15 00/22] 5.15.97-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de
References: <20230301180652.658125575@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/1/23 13:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.97 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.97-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

5.15.97-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade

