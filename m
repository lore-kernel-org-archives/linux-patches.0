Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645EB27FD4F
	for <patches@lists.linux.dev>; Sun, 11 Oct 2026 01:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791681479; cv=pass; b=UB7THmeb2vi3DD/dfl5qH42a1LCh9H/iYuV3MOJH5rDa3CqwWe+tI0xnO0hQYtQRnHtbI1VS/a5omiGTLL9Ov3Dw7D57yDe7Vyxo5Rqh2AZmKVno4CmG7ILCT2gQUnrHvxOE5BCsMM2YCYAhMdnKZJ1+g4Z5XcsLsX7s8eFcXbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791681479; c=relaxed/simple;
	bh=fnuiAUzH8i1RXzJbjDNXAl12hhVXicwYx/CWz3s49ps=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fCyGcycTLryhzQR0GhKDlBHMwIlMnQrew3Xij8nckei+Ghs7f5JYnj0Pxi2UITulGAtd/bdD4j5oQGRLfGcPFRzU4GZOEgf+jt6T582qkC/sTZPV9IVrjWAngjwfDgx59TIBvuLaStIR4fgNi9RBixJlCbouWApgvzj5GXDsBW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=FpaQn3cG; arc=pass smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="FpaQn3cG"
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-678febd9307so698957d50.0
        for <patches@lists.linux.dev>; Sat, 10 Oct 2026 18:17:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791681477; cv=none;
        d=google.com; s=arc-20260327;
        b=gsx+yzEJq4LQv+4jFPKFu9RfTgbJWxuB85crHdwrzVevErOnVkWfm8Q5q4Wg9D7RxG
         lFL97LyDFpFkECkBLwY7/VvWiwmA9cAfDCinhU/JX8182dWUpKbdEf2jp3ibElYJKzrn
         OCx5BGtLs765j1pnbJ8pYIdJBvWIIhlM/jNFrCVfVxHgnfS498J4YeoRJLIO5VbMhBJX
         CJ9JDoUf2fC7ShNVuf9drMGlixW0qBgdMOMbbcRt5MyGwoWq0N9hpb6cIfWjphx2sv3O
         fU1pfZeZ/Vo5MBuMcv9LwQMKLR/m89PPPEuyvnrcI0dsw0b00kPXNMMW6enZ8nVus9Bb
         D+FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bzVBreIIkdPuKDnn/qisn7+R+ttNV+LZ3ilnD4kWs40=;
        fh=cGaNBkRbBUVRJM7ZDussAqictM1ts646CwcGbN4nwbk=;
        b=Ru4spnXhRgfzf8jYYWIVlwOYPyE/UAqO2gG0Nizl22+IYHynEPfhXnH9G1GXsPd5DQ
         MnxO+e2LIKpYoU+FQlcOOsn4Lv9f1GHdpU1X1iMmItgtJluD0rHCBraO5dg4Uc7rU5/p
         xq6tD7CbU6MSmnMigP6rVutrotTMG9x5E+EgFvlrbNJU13dqLGYlW0BgPQD/JKixB+sb
         7z9IavKXqzyLN6n6NpGKbaS+4dAq9wXWnPrDJyvgFADFJQl1Z5qpKEIr9a7NVQ6l4SDv
         ykX1mXIbos7R6VTz7imWvHu8UdGaAngY4VE5jJWAd3zeGOdOVBVRrsxt0pdjJIbNn9Ly
         Mlaw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1791681477; x=1792286277; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bzVBreIIkdPuKDnn/qisn7+R+ttNV+LZ3ilnD4kWs40=;
        b=FpaQn3cG9CHrv1TOqMmhYWY7NlOpppI83jgLlm0qahivviD7X89mq+NbV3BPRORigv
         lBW7vb0Nwp8A8x/fWFq/WyZEtR5fem1D6XUZuVFATxr/haQ0rCzs8e8g0fMBu31ke9Ir
         2AStebCGIp0tMs+G65IFJqpg9bqlScGDZ60X/eLfg5gKyfgPOOF1xFmGpW/AlI8XqAPD
         uDB95iwSd7P5wwpa+wM5RkKwnKanZChV2mImQu+NZVmr7zdeFHXc7//W3mVH4w888LnU
         vHX0HnHk+Wu1WKhs+Oqee2GwdWBrje+a6zlNGOUDpPw1Yaw0S/iIEsH0LMOYBj8MgeYn
         kxvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791681477; x=1792286277;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bzVBreIIkdPuKDnn/qisn7+R+ttNV+LZ3ilnD4kWs40=;
        b=FJFKyUW2VaCbF6kfyoHd54uWqEZ6n1HIc7zMlcACs87huBgrOoYdHGhmEM8RDGWEHb
         QbGJoJuvox1bcnn7eafAnxhcdBXWXs7/cVSyLD+yjxhZTzfP9J5zJYH5r9ZTzpDPvXBz
         RQjRiAF8UBbqL/gz7wrvwPy4KK+4L+9E3XEqwX1HNOLzVVKGqAcspr/Jg2OpGouGH3Tn
         vpt2GUmxbwZjiGeH7EiIdry8Rt6+wg8EL1/14iG5zTcnlJd9KzItHgeuH1JXG4cMYbtL
         Dpchq4lS2bD9NDwbxvjzEaoE6hS1y48yfaCSutjSqdIde8kqEDK/9yC3cWNwPsoCrox3
         5uYQ==
X-Forwarded-Encrypted: i=1; AKwUvBzChGzyOXMKho/R72mv0xVhdCdAPuxLiLFXfVs3nSIcG2bW3IZPZPfeKRrSmEMzoJYrjsMAdAFd@lists.linux.dev
X-Gm-Message-State: AFq9FYIOf4rN7HtA3lferlOXLTxuI6Yn9TukCKM2Ms7dNvxJSd0U1Txl
	vj3/3NKJRHGq6SuMeXuuwnzk1AVdd6LDC/K7Rkp6/OfHlMP5yLih84eModsSdpxMNYYbkx5cAGE
	6Ux4wMoEFWwV+T95xUubdpziaGyZud9eSloN51Qrg79EGQhE1MMiKbxFxVAcLBKeISutnsfQtSq
	WTYkF1niK9QAB+poTg4MaL+/GiD2uB
X-Gm-Gg: AYBFou0ySuf9iPlbZDP+0LFVR1vF8gHcJyCvoAN48bWTEUDoIyx9LLcff1QTRHZp4It
	NlMavAe0cgbr3sg0UCvujGoTz5092LBF0ugKyUYsEkxoRbLXVSq26Se0lDZC5K20AtdoKduDpgd
	z1HYvotiNdxKA1t+tGkl/RNPrlEoNY/d9aiTiSeJM+KvR75n2Ku4pkXowcSQgH1Ypueun8DSYjq
	+cfJANQmQJuBWkpIbJVZFPlhqMjkEp4/CL6XpoQjGOGhe+ePEp1loPJL5yOPWMo8Pha1cSxtT4d
	tLn2bxaXNutd/7w7aUlj2Kh/scKMA/usNTZIew7dve/8ABzGjZ9uIfeuVm0ep00DSs4AucW8oDo
	E0G45xniYLA==
X-Received: by 2002:a05:690e:190e:b0:677:d35f:c4d1 with SMTP id
 956f58d0204a3-679369f7abemr1942202d50.55.1791681477199; Sat, 10 Oct 2026
 18:17:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261009140952.119038291@linuxfoundation.org>
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
From: Slade Watkins <sr@sladewatkins.com>
Date: Sat, 10 Oct 2026 21:17:46 -0400
X-Gm-Features: AclHuK-o_Bx3fweFB3qoGz-32K9Zbv921ZKMnF-L8na-GXc5lR3Y1ZGIdt8C0w4
Message-ID: <CAMC4fzL3rK3pdiZLpnVv_gju0dSUYp24AWnk1VTHHvch1xmVBg@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/403] 6.18.56-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rogueport-AntispamServ: glowwhale.rogueportmedia.com
X-Rogueport-AntispamVer: Reporting (SpamAssassin 4.0.2-sladew)

On Fri, Oct 9, 2026 at 10:13=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.56 release.
> There are 403 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Oct 2026 14:08:27 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.18.56-rc1 built and run on my aarch64 test system. No errors or regressio=
ns.

Tested-by: Slade Watkins <sr@sladewatkins.com>

Cheers,
Slade
