Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB92023A4
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 07:39:19 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-63b5c4c76aaso581976b3a.2
        for <patches@lists.linux.dev>; Sat, 29 Apr 2023 00:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682753959; x=1685345959;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GUn26TT+6QE4fhjQ462vLKoPFS6oTcj9n424rZaXnJQ=;
        b=m56y7+Ec0+XazAzTeGsnazVsGopYM8N2L/BhWOsolOQ95/zomtu1iSzHTHOsDiP0pZ
         axWWMjusFCak7GeN26RyJLT3mq7oHqdZwDgeAXLquD8pJFTQhlYlam8J/7KIWix5XRxK
         uzJ54LvmiHvXdIQXGzhnpNE3Cno1pO5g/n0o/xriVlg4LNl/yIyAs2X0bjuSwgiid9Fh
         Y+OmvaFX/6/RQftL5V1YJz1MMGpDzcEfpcf599+ozYE09sy7FjKxJkXNkOd1fuUMuFc1
         0JzehEKDy21gO2p4MNyCbzPbIQC2YfGoiAP+NoRaZToud0VbPEmKHmcacuVlN/Z9w2C6
         7BDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682753959; x=1685345959;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GUn26TT+6QE4fhjQ462vLKoPFS6oTcj9n424rZaXnJQ=;
        b=BbdgYR040LyTcv/habni3UBHsRxnUKywL8Ele+v9Xc05QDYhFf5jQRPCxfgmP/q/vZ
         amBHIvlae3r84uYJWK5CAQFRUby3xK9GnE89wF9JkzUZ74sZzfm21nvnUub2b0lKlr2p
         /NLO4VitKC/j4AEteABQcQNwit39I+UoUzBZt//Y43UAdKFmBE2G1q6ysmnXNxQ0MBft
         YNm+D/ZjeuND8KjMlRqx5QBX+PPrYoPrCnm4dpTxb6/6Yzu+Z+Io7c1UaZ28DnoymVbR
         E2ewxAbu8iNy1OfAibuCsNYSHynjqjU/Pd2F8PWKeZgN80DgLY+7JHXQxsjkZ7vM+Rxg
         evpQ==
X-Gm-Message-State: AC+VfDzgMlGJyRK5QCNqGDGvJk0GIysg8B5lCnqrs1L/pce6qwJ22FQ7
	pCNYjxQaUDanp0JkZQ56acg=
X-Google-Smtp-Source: ACHHUZ5RNocAL/D/4xKZqi5OP/8HjeS5BW/BmbNq6J2b1bTK/Isc8rd8wNwKn/hto9oFdTQWFAy9eg==
X-Received: by 2002:a05:6a00:1347:b0:637:253a:531c with SMTP id k7-20020a056a00134700b00637253a531cmr11474267pfu.27.1682753958948;
        Sat, 29 Apr 2023 00:39:18 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-88.three.co.id. [180.214.233.88])
        by smtp.gmail.com with ESMTPSA id t1-20020a62d141000000b0063b8ce0e860sm16290414pfl.21.2023.04.29.00.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Apr 2023 00:39:18 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id ED2C91067DB; Sat, 29 Apr 2023 14:39:12 +0700 (WIB)
Date: Sat, 29 Apr 2023 14:39:12 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 00/11] 6.3.1-rc1 review
Message-ID: <ZEzJoOueaYA/kJM9@debian.me>
References: <20230428112039.886496777@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230428112039.886496777@linuxfoundation.org>

On Fri, Apr 28, 2023 at 01:27:35PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.1 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully built and installed bindeb-pkgs for my computer (Acer E15,
Intel Core i3 Haswell).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara
