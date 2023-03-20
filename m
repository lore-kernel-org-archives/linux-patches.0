Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7329A4C6D
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 18:50:01 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id le6so13505681plb.12
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 11:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679338201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kb5WAjnV64TvIqVog+ALrYqWwxpAYRDfoRexx0FHgtM=;
        b=P26WYm2NWf0WPj3f9FGlGwX0m8mwWNzYTAfzTeuhYb2tHlkAFxn2mVMAH473OO3ANT
         7vKoG8MyNXfWNVhiQcNRGKGUbpU79vDYKbw1Kr0WFv8g0GExqpaTgVKzKjeB1kUHS6o9
         QUPc+PnnpMvxu6on2j6T9QepUT6VNdKWeKucaXr1lpLbjvK1Duf5RBmV4yxqgNpaKw2c
         hJx4kk4VfJ2/mIVuiNi3Lf+I7SRTppK1q66hVY57y9kvE65FyRgSKOUN+gIE+DELu1f1
         /vc16H7piCvg04UVFaBHWjP6JfWqS22tgv6O8EeYrwq/tjhiEvR8aCyAhwqTa1rH0Nx+
         TO1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679338201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kb5WAjnV64TvIqVog+ALrYqWwxpAYRDfoRexx0FHgtM=;
        b=veNIgu/nIRbLoi2/D7NtOqL/VhxsPvEOe59nX4kEG0nskjgt/BTHtGQaNN1r+ZI3QK
         BPos9vJGNI6Iu+BG5/DU9C3X0O7eEbQJ0mI97mckg3oO9LzZBiJkRHGFKokwcNhn8sOe
         iWCIVLA3xMaCDUzSgwCd2SNOBYJsLqDzSd8XHfEQGeAFoIXjySDMqe+OBlDGIRsGb0RI
         SzNEW18ABFKBRFCVob5mJY2qIGNpOlsGnhGx1LcCO9ILmcFYXykTwbJQvevZUiRqTSeK
         NZz05O7A4qXGtLm+kXggRw0GhCNBFOiI4vFqiimPr1pWx5231lpj3H0QPhDRCR48MGHK
         TiTw==
X-Gm-Message-State: AO0yUKVZdFeCwhet2SMKFLpvOk+IKwGeKEiyn5ClvdAjG51LzFJ3QxE5
	kQQK/wRFkwMu9r7gCRI3ymIH6z46aWECoUpGmkCIQg==
X-Google-Smtp-Source: AK7set9eH0azJC4yqfUlAGq8InyKfmgAzfIqpPamku/x55+E9k/WBoIumDFLsuBW5qWPFIbB3U0nG1RRD8hPh+MZTlk=
X-Received: by 2002:a17:903:452:b0:19e:f660:81ee with SMTP id
 iw18-20020a170903045200b0019ef66081eemr7432644plb.2.1679338200618; Mon, 20
 Mar 2023 11:50:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230320145513.305686421@linuxfoundation.org> <CA+G9fYvNEThYX-c204_knup5G_1vA27j+HouS-n=HMUsdJpC_g@mail.gmail.com>
In-Reply-To: <CA+G9fYvNEThYX-c204_knup5G_1vA27j+HouS-n=HMUsdJpC_g@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 20 Mar 2023 11:49:49 -0700
Message-ID: <CAKwvOdnmwkoeToovShcmfpSAmBmKDTzZNv4R2jFA37hi=+ynaQ@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/211] 6.2.8-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Michael Ellerman <mpe@ellerman.id.au>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 20, 2023 at 11:40=E2=80=AFAM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:

Thanks for the report!

> The bisection pointed to this commit,
>   45f7091aac35 ("powerpc/64: Set default CPU in Kconfig")
>
>
> Follow up fix patch is here as per Christophe Leroy comments,
>  powerpc: Disable CPU unknown by CLANG when CC_IS_CLANG

Greg, Sasha,
Can you please also pick up
commit 4b10306e9845 ("powerpc: Disable CPU unknown by CLANG when CC_IS_CLAN=
G")

4b10306e9845 is missing a fixes tag.  I've filed
https://github.com/ClangBuiltLinux/linux/issues/1820 to track getting
these -mcpu=3D values for ppc added to clang.
--=20
Thanks,
~Nick Desaulniers
