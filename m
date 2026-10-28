Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.208.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793210205;
	b=MDPi0zbLeSAVEBFCMGTTdMBtAcfzzP59IWhLttOzR/hwWHZef2sr+LUgz6FB/No+/Cjg
	 NHkoXkBGXHSat1xPP/rqo6JdUDWY3EsxWDhjHWs4KAx5perupNsnXD5f3E57iuSRGaEpa
	 KUkwK0I4VwfJBySr/aSCeH/jMeNQOMDKeDQYyBftGIFKn3Xq4q2qlOTb1bLJo6iUqIDko
	 H8Z0GJPeXoAxZZPso6vYScWbpduJeKRIj72O+L8mjedTq+kSBl0yTBw1zxt5skN2EsQ3Z
	 iu8Zi95KxxPAz2t9tORmQoh8u8f7WHaAaWzCNqY4HqVU0V6lFwyfypvNtqf6sxfj5Ew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210205;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=+7QuCpMDuaPEn/821Gdh04dyOpLKWIkef/TiSBsZIMo=;
	b=O+Lij8zOb4KOSvDF8VnAzWm7AWkkE5JmGk2FS+iijUbr6py4pdg7mHV2uN7hL1ZVUV1j
	 +oHGSJREaQbHcnG8h+74cc+EhWXXhQWcaLQz3gj22olaMUdch5Va9mtmxZEL5H/jlmd0i
	 KENZxXycOC8V/GcxYzPE5uarGH1H00bLHHKRpl7wpEOVyk+SM6f6011a1lllaeT9hB4h2
	 Ls4Q4uOWhpZml8dDkLpQQl552jDLssQZgIY/7eQvJZMh6TemOE/FGxVQA86FzqWr3Xhis
	 RYDZNQ6+MhFTUWe9+PF0b3h2RpcP6g66o/jdsSDwOk/Gk+pbfpaBSs/F1s38PqjLNDg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eXgMSbJg;
	arc=fail smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AA6606A31E
	for <patches@lists.linux.dev>; Wed, 28 Oct 2026 17:56:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60AA6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eXgMSbJg
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b1dae0febeso2034859a12.2
        for <patches@lists.linux.dev>; Wed, 28 Oct 2026 10:56:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793210204; cv=none;
        d=google.com; s=arc-20260327;
        b=FilNrM5DHV3Y/r6Naguk/vvo5VjlaDgJkuPaKnKdSfp7emRTX7IQZW4wPFbtddIjGy
         sVC58TxzK01D/96Z+OMCbBzjpg4EmKqYKULoPkgpUYkyTqrF/xr8z12so6Ie4+s062TY
         Pi8/GdaFfM1Mf7HlQtEhatelOs3A1pLQHCw7E9GbvYD11iX9LsptKkSer9r/NOT3oykQ
         3kvzElvCklsKjPIdk+8lyNwn0br8YTZVq/g6Ru+wzzJ5KfXTMKX29gcCc9NFciPYLCbz
         SJiQ4EJZgIov2ofO4wE6WXDArdDGcd8IQuidlcq78RNxAWVGaDiawYwDqiG2x+2EmqSM
         wn9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+7QuCpMDuaPEn/821Gdh04dyOpLKWIkef/TiSBsZIMo=;
        fh=iyOIARXbTk61NaYCZpasG9A5zKtPLjhZstSVuMHZtl0=;
        b=cgfM4qzAKN8Q40uaLA8DjY6S2IgFXyWF9vcGuI29FxNwdKDQRpopTUBIwxFhc3AOzu
         WNXhAs4g+GM7gBni4V+EKmaUvhlFCJ3rCDVg82pDV6GOfNA+T9Ic6Wsxu1/E+C2jeKF9
         lcfC86qmfy2jFtFwIzU3oukK2KZVSqHOrJBfhzXmHke0lvbWDCoVMd9t4ehsaNXE1Tfs
         Q0MyWWVoa/oOYKaou9NOd0D3NCtqj1Ta5qTnDdTXq4KKu+qgMtxQTzjdJks4E6o/M0XM
         v471a0NSE9P2dzppAWFbCaNgpcWPAYa6zlmUb1+4bHv6TF5I7dLhAFPjFwov5vpu5a4r
         86pw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793210204; x=1793815004; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+7QuCpMDuaPEn/821Gdh04dyOpLKWIkef/TiSBsZIMo=;
        b=eXgMSbJgmaQwmABNm2EzY0lQ5LGhyGM1blcUYArkIv9J7LiyXN4Vhh/sMgKJ1vjYUh
         gKPRYBsosDAuJeixZaLkAx+ltjA0nXzq1u2ces6qxvI39k6lM2HTfH5hhevVGhXf9l2o
         /EvNkBzsHgw1iIgU3F6/GnPhm+gsyXZVnE6vHwpcrp5loOG96VsbFq4ezgoMSv2V/Pws
         RNxZdcINhBEwHZ+YbAqWap8qZqvBHXhAI8M/ffceDV+O9uzHmuBSqEv4ltH3DfMUfBDU
         12F8OTrlLlmuitBKPfqmhA2DcPKVUSQdA0HCEsCXsxfCnraSq/MlEqJLXiCdZavpQLWE
         sU2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793210204; x=1793815004;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+7QuCpMDuaPEn/821Gdh04dyOpLKWIkef/TiSBsZIMo=;
        b=eFyTL4/sSJsflZIdKhsReTtmRETYxjHxJ4A0GgoEOM7BwOUQAmwwL0yX/Jqulp50Cx
         te7B4+9CD93mNdnduu0fVehgxjg1PbdZ/U51rNaJ24fAApdE8e/tzo8I8v0dp2saR+he
         7meHqvFGxGcjRaT65q2NwTXaW6WXeFdaby8p2qf6e2/aDaBaouMHMgMGyCp+UE1X/AcR
         S8//jQytiakYeOre9nhibB/rHSYGB4eiC3AM8wJRZrtY9T7/rw5Nqn2eABy40Y/Ds7jI
         23MaVeY1duqMVqC3ob8dpUoVEbKr5EI+dxBvIImrsFz/CvBsBWZJ0LIEfZ0J6kAWVRbw
         4eBg==
X-Forwarded-Encrypted: i=1; AKwUvBxQ4VW2vytRUhlYTsuK6ultl9BQ/HfHkFrp6GSQpwRqfBiwxWZB9OzXi3odvQVRZOKXsDgzhzU6@lists.linux.dev
X-Gm-Message-State: AFq9FYJeG3ht1v1LskZhOzi2I757FDRt6NJtp8LQ3cmiYA99Vm0pZG6Q
	7qaSJIHXq1Np7LKDCQ3Xb05jnATv0hlNXY8tyDtQwxd+YT3N4J4nPxb7JZaoDWZcKNaNnQaxxBZ
	0oLVFG+9dUUeso+vvDYxgcNW39RhZH+Y=
X-Gm-Gg: AYBFou2Tk62wZo1ZP+J6LmAAKTN3wnE0cEjdJbk2uBTr1XMt2X3WcJlEGuEukUs04Mg
	jvYdmY5Ji0Qis38cEJTGfj29eAT6qxIagflJPJC+HUBJpuZBIQaMWi/ifkta2ceMqh2RIEQ85uC
	vn/O+IXn2h05Raihsxa1pCdUvdlsTOQHRouTmn3Lk47AA0gMv2nS70imJpOD2s7noRF4O2I20Ry
	bBuHJtcRpD5MnvjvQSgFglrXYHrNxDDhwPw87GllJBsGBIGvwLk+rTENyyVnxwcv+RcEf5l66kx
	i0jrmx3qcuGPhMvVJd+LEmvhGruQoUmxKaYnLSDGprV/cXybv+YuwUzfeatKpo7WyT+OH49Cjfh
	AiVyM6P9lxGc9AtjaHNPdiuJl6u0mOy5CFfe2NgJ3TjHNssYjwXp5/FmF0queroLTiC33Iw==
X-Received: by 2002:aa7:d152:0:b0:6b4:21b3:a407 with SMTP id
 4fb4d7f45d1cf-6b49cbec0d5mr1632982a12.22.1793210203401; Wed, 28 Oct 2026
 10:56:43 -0700 (PDT)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261028165947.349197979@linuxfoundation.org> <20261028165950.290722602@linuxfoundation.org>
In-Reply-To: <20261028165950.290722602@linuxfoundation.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 28 Oct 2026 19:56:32 +0200
X-Gm-Features: AclHuK-tumKlKRu862aY7gzIO6eryO1Aqbm0yAf8iy9yxR8Czrude8p5hPdV6F4
Message-ID: <CAOQ4uxjuTuVpx9GV86vt8JwKk9qOPayV7dx_86EofozKkK_kWQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 122/247] fs: get rid of __FMODE_NONOTIFY kludge
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Guenter Roeck <linux@roeck-us.net>, Edvard Conrad <edvard@tuta.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 7:15=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.12-stable review patch.  If anyone has any objections, please let me kn=
ow.

Objection.

This causes a (potential) deadlock regression:

https://lore.kernel.org/linux-unionfs/P4sl5iz--F-9@tuta.io/

Working on a fix, but no reason to backport a commit, which is essentially
code cleanup that causes a regression.

Not sure if this already hit other LTS kernels.

Thanks,
Amir.
