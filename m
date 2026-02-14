Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4DC20E334
	for <patches@lists.linux.dev>; Sat, 14 Feb 2026 00:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030712; cv=pass; b=NEbs6ry5OLdGkxI/B+UCLUQ8xagwMhT7ylFD0jjCPRTPlTFfAUjEJUN56fR6sFh7fKff18U6WfugyFoj4YVYWSftOnFdkFONtTSIsUoO9c1RGfezXVqdVUorvR7/lDzinQdddTMwQOxezycI6PqUcBIYa+ylOJiBytleDp1Y0h0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030712; c=relaxed/simple;
	bh=W5nbte4rEtcfLm2iuE6VcT6d0KIL0jGVnJcfbmeUqg0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GPUafFqh/BX3quDO1OUJC7+VqBjFh6R+WNbZBnqf9vUd6quj0scrEUqvGmU+pFo4mxb09sJ+kCS2nk8kYM9plUXtpBZl/i2eWScwfVXPXE2kEyp0bLHCSOTkWweNqHWrp0ShQ3IlscnyO+Kr9KjYri2VzdpUpOFp5d0pmjKZBFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=VgjzApIL; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="VgjzApIL"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-89577f866d6so20915496d6.0
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 16:58:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771030710; cv=none;
        d=google.com; s=arc-20240605;
        b=CUtfqFKCCQ7TfQdLlJyDZLyS/80cYFK3T2ZdSyOILijlUpOrRg/7h0iEormnsXjDcR
         qE0m885E8n6egIstcM0GNMhgf5yyG44eyeqXJ3xGzC2OaVl4IZBHrxe1+uVwNq689BCN
         cIop8nxdFeH/GtYDUm7qHwPk+5AGoQvG1F3y/SnU8Mnq/Xr3201oU7OXu2p/eE9TQTSx
         j+i1+RFzq9uOsnIuRhBPsPLot8UdL7oxt71L1GRBUMWLkqIuM95hdbpbWeynBhH2yjbL
         YQtdW1zTh17PtEU8IrnH/DCtHJLEgxFLpYluFG/gw0HfPyZq490THVyyc4qV6jt3NWNN
         Lfug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vYrvYeGNl+ocSwonqior1WpZBamB7LqsZM5+HaM2xJA=;
        fh=tokp6i/Ie2VE6XGrGyXsoYGt5xkgLRzae1I6NSFR+JU=;
        b=BlOZC+TGk1sdpdhmwTmNA0oHhuHeRT2uyMiVy+3g+Mv1mUVnlvLwzPaR0fljwAJAKI
         OXbmbqidt4ARIfLMJYv3Dk4v1uFXuejLf/z80QAAmVsU7e8QZzLiiX1O3qfuY/LrUkPF
         JsCPOz5OJUtveWGjHWUWH8E68Njj+XUSka7PLlOiarlHomYzzC6Jd6xfCH1jOJPzi4st
         agjFdgAl4lZ7gVw8dXejErAOlI/b7h6oIAYPJQkcrzQ1kU6JLd5ZDtVXu+afUfWSBKjt
         XZ6x/vzRZCdE+zctHGNk8CSAfzMucW3TIR0ZxWmGftBA/KGxTYq0oEea3JZVY2Vs1IzX
         L2nQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1771030710; x=1771635510; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vYrvYeGNl+ocSwonqior1WpZBamB7LqsZM5+HaM2xJA=;
        b=VgjzApILOcSLaRi1b9AxHmbGzU6qLBw2Avi+CNSYc2wkduWPRJIgYJFsMi7Dy2plQY
         aoDo7rA/+3SaoLkmHkjaS4F1CQ+EyhcyOQwebdoekWX+uo1+j1Z5h75bl6jQy9hE69qf
         WKntNBrR+rE/UO3ykmIsJpIKRwlYeXzIFRyanPK/5ObDeYqryRA0cvng5N+bvedLPDBf
         GLRbOHg8q4t4bVbwRvP7TBKvCaaV6IbpBrMIHnwUq0vN9htqSXtaLRKxz1+RSRQGDY/y
         wqkz0W+qFNJ3urcbQVBfgo2qW1bvI2l2ih1At58Qv62cFMxGab+bNox2QEBYpaYP6126
         dBRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771030710; x=1771635510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vYrvYeGNl+ocSwonqior1WpZBamB7LqsZM5+HaM2xJA=;
        b=OMQHsz2d3pxKIEzM3VXWRBSXx0v0rzI0idLCGhCpsbSfRjcwbKiIOeSZDGDPVNhU78
         qShBh8iWVgzIVU3cJO1DpHDOje7aq8rbh3gXM+M0RwnjlLbaqskFDmc82T3B46rggQp7
         WHt5f7GU3cETzeZQvBbnFukVHF2GuC8i4e1ywJcf7Le52lRR0XBnqu/ha6WYHa719TW9
         dPtM6PKUWCWBKp8eG+hOkN4MXXGpoEajDRiaTIinX7UHC34NBA60eMTRI9CcsBcsu+1N
         Z6Zf9X1P/Tw7zPDuqcsa96IdHzFZPhklOubobIHRJBBz3X8ZGeFkr++wZxQVwPlfrW2N
         WXOg==
X-Forwarded-Encrypted: i=1; AJvYcCWk0dYCGBWhq6YmEwspU3B19FGPx7Gcc4Uu68LGI4sF2yhkqawd4l6Xt4NWzZavgqfg/FUk0031@lists.linux.dev
X-Gm-Message-State: AOJu0YyBQB+QhElgKvEQ3cgxvAVg4EWXf9bHsf7Oz4XdwsVupDFJ2mYo
	sbCf0P/X37fGThE0boTJdiRec12iT0VRMav7k842CyXRU9NrBxglOgsP7n0Z7fb81U21cwo1R1x
	8vMF49gX3AaIPE09nHjVpxcrx9lI7zji/Sg6iMLWzAg==
X-Gm-Gg: AZuq6aLciBAGdXrsTDxsK6fer4s4GateAFOZa/EMJdVMOVz4+G7edQbGSYIcNRygXBP
	Q4110BnhjzlIfYhMIqrNmjUqCpTKQiiY9bRrrui9J3N+h9vVtkwdmFIApjjOGqEukO/FRT95GkQ
	juTTev7haEL5rNrYJtp0B1b5ktOz+78FcIB6Hn2C4NiQ2CdAsnhV7s74VgH/mMcGavdSuSUulkn
	fG1H52W1AiyPiJ6UunqpL1jR7nD1MXTIveQzdFcm+Qn1/j6lxfhfJdQ+J6sTAwoD16zyDXqa/cp
	jwB49hES
X-Received: by 2002:ad4:5f0b:0:b0:895:4bec:b583 with SMTP id
 6a1803df08f44-8973f2fc9d7mr34071586d6.18.1771030710504; Fri, 13 Feb 2026
 16:58:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260213134704.728003077@linuxfoundation.org>
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Fri, 13 Feb 2026 19:58:19 -0500
X-Gm-Features: AZwV_Qjxj_PxbKXdyVWfsxa2vYjhA6CGoymxMpj0QhV6_8TaKXsloLhpNNGb3Jc
Message-ID: <CAOBMUvhAxqz=oyyLPUugqP9sP4bo0OB3izJ0oJTZCOemavWBvQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/24] 6.12.72-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 13, 2026 at 8:58=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.72 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.72-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Intel Core i7-10810U

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
