Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567C6160
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 23:00:38 +0000 (UTC)
Received: by mail-ej1-f50.google.com with SMTP id k4so31096543eje.1
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 15:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=07VDJ5elyFb8DCNtKRtQSNQC+aoUsg3svdwL2SSVLNc=;
        b=LCcFWG8FE+1gDq/Xv3rOMz0d0y+lQwimcuMaLx+GnAAOtn3jAsKUoy3LRhfdesuMpK
         3vFTeD7p9CVaNG0huZCNphhe55rf5jttXYxXnrBA9W3yjx/R7OjK5pzCe9H2G4CRZud5
         NeVb+zA3mk2PFVworUBkZ0Dc3gvh2pMlEVj8M+KcBU0HvHPVVXGNKqiGClpGIczvHllu
         x8C0igS5iNsjlndNyvSP+l18NoL7rdNaAyuKZWUZfkfypnma2HahE2nbffjnHDh72fLX
         RNkjROVzhuLnaSzvBCctVLpjSXR8SQrQXFA99iIKdvxh6i0HLIqdVG6qw/1RKOZE0JQ4
         M2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=07VDJ5elyFb8DCNtKRtQSNQC+aoUsg3svdwL2SSVLNc=;
        b=ZC+c3G744LiTS8Haahljd3sgysnBOj+197+aOYECtzRylWHmPVWaTACBd2utupsOst
         oGzBS0JBAuKkJ6IYJU78QfUuUlalpZSXzAqhrsB3igWcIvjSc2OqR2UAwsUgnOaH+Z1z
         n7SRREWI56KVlfYqXfWcq22ryvRDUQVaezQCsKL4yKl+EsRdMhWN7nTcjZzcArgyS2+4
         DtxTzTx7lzSEpDHraK7SvXRWB4yapA6u/gSLyzWkt+KjfkgFmqujtee5Q63CX4rFp92X
         1KEkHCz5FLregi+J8K7RMBpaWvYBJbWIB+21b4o6DAnPcWVQOsa+3Oi42a41Bxu3UtTu
         41Iw==
X-Gm-Message-State: AO0yUKWmNvTb3EAsOYPAaAs9IKPcU/AcHWdxkM4uu0aNYItIHuKJBDtT
	o7ouqM9cI7rnNJYkXnv+RHiy8TWAIFoCvwkCOBu1NQ==
X-Google-Smtp-Source: AK7set9zqShyRJKOoelppWcEvIaO9rdtE83U/S1EjREGsVqjb7pZ0qQGTNK5qxq7uieb9FNjZZLOvFW8hEhI+k1Mb1g=
X-Received: by 2002:a17:906:4950:b0:88a:b6ca:7d3a with SMTP id
 f16-20020a170906495000b0088ab6ca7d3amr782284ejt.1.1675119636354; Mon, 30 Jan
 2023 15:00:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230130181611.883327545@linuxfoundation.org>
In-Reply-To: <20230130181611.883327545@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 31 Jan 2023 08:00:25 +0900
Message-ID: <CAKL4bV5CcJPtP9fyxYwkk9-C9PkgeydqiCeCirb8L9ShK+a+9w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

Hi Greg

On Tue, Jan 31, 2023 at 3:28 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Feb 2023 18:15:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
6.1.9-rc2 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Nano Gen1(Intel i5-1130G7, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
