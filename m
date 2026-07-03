Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9383839B9
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 07:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783062267; cv=pass; b=XSufzLT6WnuzvezI8Y+BBw5qALPjLrGnFfu8F2q5G695MWscAPcKhsI2B2R4ROmp9p/vYOZ1V0mxPGJkRTjpskMsw88ZHIINB4xNo7AJk9laUmnWiUcOwLK8Xax0NWT8M1pDhw4Vh9zthSvxtHp94+8fjzGiaPkkN8BpSBPprHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783062267; c=relaxed/simple;
	bh=+WWG55iPmetupBVpWvPzN8FNXJL/33pLOLWrSC+icwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kQnefwVPQsAHTE8BYGJkI7Ww4tCMIk7z0qzwNhSo4pKXbCEIBEgk+MtsLSqcBNKGCUBCcERUGnNyOUPF8INMtahI4iThtLJtZeEsF5AuNi4qMo+Z9Bpq0TWbOypsjowjmnhYnt1AMZNht86IPf7kwfNGDp6I51D5RNcvQuYdVXg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HFbx+ThX; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HFbx+ThX"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c126fe7d0f3so22240266b.0
        for <patches@lists.linux.dev>; Fri, 03 Jul 2026 00:04:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783062264; cv=none;
        d=google.com; s=arc-20260327;
        b=BjZzA1s+1IZUTGVWo9pJqWcchgKTA/inbuz2POodrxPtBFFak4ii/wJTaPAPrYw1Gd
         4X5nxZqqAifurouUuxpRdFIqHQtoEz4iW1vyiWQuZZLAVMCUNFwDcOH4+1q2PKIPjrQK
         h+3NGRV8yMXqxfIkNLsIahTVzxvysABIUBpCQTMs8c3AAoShFWc+p8ps+ai1WWulqI1I
         1neS0JndrWJ1ScHjGsMo81SyrONynH8NQD0JQsbVAIxVrW6bbm/SvDtH2vr47++Duhwj
         lpkKj25Lfee9+kpIBxQV7EAUfFJg/41H2hjaALZe92QRG1MsuXxaAbMvI/c9kAr+ezCU
         RMIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MOh02fA3SZA2iuzmQFctiZnBgRTP/PzpfIgUWp1N9lY=;
        fh=UE/HbL9x6rl2dTqjLrYF3RN8NMCYSEBDoz9N6CkdpIc=;
        b=q2ieBfr9/enDB6J2fi3icZ7bE+J0UUU1JXuCQtqeBM9X8/cEBKWKEyM8nGFxupdbdx
         OFPqdg3JybrKhqhx3b7AWXj/gGgDCyxneZikCCO4KFIS8g1Z5X1uy6pwjrRjoihMs0YK
         nYI7LXPrAdArzQF8lNDJsJczM3phne+z0grO3ZsjF940EWeZq7CiwiunPjaP3hwpwhG7
         LYPhnhY30g/QE+0fNpV22leiGQXgRlesZ4GHwT7vVjYuwdj3p43wfw1M4gHLs3E7rEpY
         BA8NanOiTtNbmQLTu8HNYSIQ2+6T/KcBiHKpo5/DUNxGFmG499KUypeZbojekYMvUkPH
         5bbA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783062264; x=1783667064; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MOh02fA3SZA2iuzmQFctiZnBgRTP/PzpfIgUWp1N9lY=;
        b=HFbx+ThXQ/GtvLVnwfsVm/nIxRj76I4Dwg5KGNjrv/sVhtJPVZBBsW864aycYX3Kgd
         G5XysTgpT4CnVW0T/2wTVCyEb3/44TyOO7M8NJ5ovooDwYAbpfZ+56u2AAmlnQHXCiNI
         kRy3gp6ME0DufpLc1rLzGHTdz9qtpQnCeNjjHY2iwCrcBxgPzVl1JNyI7iBgPPoSSF0R
         rQ81sNt52ZWlABuILw+QOzRN2RIOMK7HbD6EFp41AIxwGo/m/4rLFs/BEdBzxdR9BFva
         CNi+4bjMNPC3JxeIW2ZA/kzQn3lGOpt0hEgyngP7kVn1AmdG1bv7QYccG2HPnvpfKAy1
         lWSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783062264; x=1783667064;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MOh02fA3SZA2iuzmQFctiZnBgRTP/PzpfIgUWp1N9lY=;
        b=BVR67cOReAXwr6C2ewbTFwjGy7LkuIbR+q/aFrbelS/MyVBJP4Rf8lIm/7l2YgX9yr
         KMF3IbSLiCJivuqJdOtj/w+Ou5aUB0xg9YdfzymEqxKQC08ElsZGprv4cVcwAD8C8bR6
         QulNRF39PAYYW0IQ3xhB7DeLjOSMt2iFbxp2rAn3ckdsboyvvRBaDSOPxPVAa1ZtgH0X
         x7z0XofQDP70Q9P9E8VIt5NyrY/G71tkGEopopyR88+EEb+XyC0qOcaYvm+rnXTu8L0H
         btNm69fQEd/neVG/2qDDi0CuvgkIbNIkyZho4/LrYxgnrU7t4Zy+UCigBJpBSdRtTIXj
         Eovg==
X-Forwarded-Encrypted: i=1; AHgh+RqHXh/YXgWExX0otwSaNZY7+d1c7a7vwqMcIurbxALFBDYPgqMiVi3osMO2gsV8YIBHCEQXs2Y/@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1lIH7+wzPgQvMBhWXqMF19RkPBD1GniUesXkS2/vIONpF4pCf
	o0DrjQC85pIZ3ug+wLFlTJDaAVDa3Zg3oqtRmuVolc/nhwU8+K3jNsKpvgJ04tkbAhUt/svg+H2
	VZBbPEqmTHjforqgLpLTk/btnIKow8VOUY7aQ2uT1Cdkcx53/4/PElpdxdqZn
X-Gm-Gg: AfdE7cmqXaiJne68gOjXZTMStAC67EwsTpTJdjH7v9ukkeR/xR8tFt7ESJM4RakwDFF
	GsuSL8wLTDAOeXEr8kRRz5oQzO1NveDNGm9NkwS73t5SHd98G4uvE3H7Xj4FRFp61ropB3wl7EL
	T9JqpcdAN1fV3RIV6GxmOXo3BbM2tP+jRXGescNehItUm2QASvInSgfzWrBSy8nLdJvu+MaqXDZ
	00JiWFWYSY6BLS61SsJhbxKdCnUmNbn1s1eNMigqjnBng9QzHXN3OzmBjKXH7/HXt25A9o=
X-Received: by 2002:a17:907:a0d6:b0:bd7:f75a:817c with SMTP id
 a640c23a62f3a-c12a9d6c21dmr367228766b.17.1783062264082; Fri, 03 Jul 2026
 00:04:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260625125645.554579168@linuxfoundation.org> <akddu8pDgJ3itnfh@u94a>
In-Reply-To: <akddu8pDgJ3itnfh@u94a>
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Date: Fri, 3 Jul 2026 15:04:13 +0800
X-Gm-Features: AVVi8Cd0csi63uxIrDTRJwEkzLcN7b-swi0CfEO28G_24PsvVFwDgkCXK5KP-lE
Message-ID: <CAJFoxQO=gH5kuXdzjYmTwkvB_DcqgTjn3OU7EcB8UkQtnX-Smg@mail.gmail.com>
Subject: Re: [PATCH 6.18 00/60] 6.18.37-rc1 review
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

On Fri, Jul 3, 2026 at 3:00=E2=80=AFPM Shung-Hsi Yu <shung-hsi.yu@suse.com>=
 wrote:
>
> On Thu, Jun 25, 2026 at 02:02:45PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.18.37 release.
> > There are 60 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> > Anything received after that time might be too late.
>
> test_progs, test_progs-no_alu32, test_progs-cpuv4, test_maps, test_verifi=
er
> in BPF selftests all passes[1] on both x86_64 and aarch64.

Oops, meant to reply against the 6.18.38-rc1 review. Sorry for the noise.
