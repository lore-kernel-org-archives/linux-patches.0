Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EBED306
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 17:55:49 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id w4so8795483plg.9
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 10:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled; t=1679421348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=anmwm8yh/Vv8uX68Kbemfb9lejd4xrXhy7Hrxs7x/Xc=;
        b=p+5z7EVJQPLlOQLYbDplKK87mDndC8RzhIx2+st0XPbLsiD60EhRtLtfqfOMrMg+UX
         /6Fwj04we+rGkipUMwrnIhhNChD58Q+D0HcJUHND61pTEtL7rj9utgbbf8CfmF/HIZbF
         EDeRugM3ONkg2u9p7433FET+ZotZEyzDYdmf/hRf9jAOgoYDSNjm1bEYnHJI5BHOvQ1y
         PC2DH9oJ4lT9AG6rBH6ke+6Py0SlJmK5fXwyCpNspaE/JhcQP8CehRxKb7kOddg7f5om
         LTr1C2/zgoe8GetVf6eCS9oLMEcn6Qvb3IETEgBN+7KAKQUJf6eumactKjZ0GyKoighV
         JuTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679421348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=anmwm8yh/Vv8uX68Kbemfb9lejd4xrXhy7Hrxs7x/Xc=;
        b=5LtpyZwqnO/s62BWEAzFCR2Jp8VlOsyWbPNSCUa6wmIn4mBWs1ZTQUEEQHDrUR9wS/
         cnhEfcru/UOhpkJmX9Czsn2tnRvUg+vha0Jx/652WP4iL2Dd9DkZCnBSDv9Zbm9bLYCi
         TrXG433RRuENz7aYsrJTbrPN6N1XrcJwXi+u0e4HSJkoGY5EcFRkDi+aCychZuBpd46h
         e7oT2Kctc/VF9SOEv+1c7lBdT55OvTrUscTplwYMlLBIQnnqSiwWvfYZtvUmLvfO/WX6
         WXoQzUmM3636aYZjDzPU/6KbA1aKeEWoCS+nrq136Fd1e3Iwdd+ozew7WBTeL0dqCJsG
         Z/CQ==
X-Gm-Message-State: AO0yUKXHlXnmepY78Os66VChzHrDRz0h5hvTtLdZZ/vVy310m2UvJb6w
	iPpwEtPPlDkDWFW8aHd/Dlw4uLNFQzHAeWHDMu4aiyuykNnhUMzn5KfR8Y/EVPTUubXWCr3Pdve
	RsKRomViMtFIzUdOzxtOgKAfWlbLx
X-Google-Smtp-Source: AK7set+aSSNndRQzBA2NvrSAm3VcmzzTjttcwiReGOC8KcfvRLO1EcHhKyk4ELdF6t0E/8bB9RzPogDwF+CPhKhae0E=
X-Received: by 2002:a17:90b:190b:b0:23d:535f:59c7 with SMTP id
 mp11-20020a17090b190b00b0023d535f59c7mr221120pjb.7.1679421348502; Tue, 21 Mar
 2023 10:55:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230321080647.018123628@linuxfoundation.org>
In-Reply-To: <20230321080647.018123628@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Tue, 21 Mar 2023 13:55:37 -0400
Message-ID: <CA+pv=HOG7Ye9qvUTyYuCNYW=iEbmwEtGO9534EcPz4iUKTFMcg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/57] 5.4.238-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-SWM-Antispam: Scanned by pmxgwmtau.interior-mail.sladewatkinsmedia.com
X-SWM-TLS-Policy-Status: enforced
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Tue, Mar 21, 2023 at 4:39=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 08:06:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.238-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.

Compiles and boots on my x86_64 test systems. No errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
