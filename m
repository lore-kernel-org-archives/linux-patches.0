Received: from mail-ot1-f100.google.com (mail-ot1-f100.google.com [209.85.210.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C8BB67A
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 12:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770380424; cv=pass; b=IR9VP4WegZj5ViPEh3yqjyhpCN+jQdiFx3HyyFZpClmlW1TxoLbFFDebx8asO00Gr2Q7YLrrOjE+6DeYoudjlSqJm63AKRHwaV90V1YT4H1Gbg5Vit9TjgEm2pEnzuHI1YtzQmQKTVipDmFOeaN2yyn+y4kC2J0R+jR5HsH4G7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770380424; c=relaxed/simple;
	bh=ORBY/6LUkdWh/1n65MxWSSNWMrRzKn40fAB0WUnoX5w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mAAq4CIIcd487BWrEpnM7J4eczFPcBmc+/EYsyQmhBMfblDK+QuXpszpbYLAkNnu5VYu6sBT5UQnx/iJ3e6qH579WVyU3K/r1Bk3QaBpBlHvK77L3EAyP5kOqjPeg4fGuHUnW4TUZxRTj7K7tVRkQ8WDN1VmCgyxlC9sLbBbx9k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=c2Rko5rZ; arc=pass smtp.client-ip=209.85.210.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="c2Rko5rZ"
Received: by mail-ot1-f100.google.com with SMTP id 46e09a7af769-7d19d3c7208so1212927a34.0
        for <patches@lists.linux.dev>; Fri, 06 Feb 2026 04:20:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770380422; x=1770985222;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eDPtZ4eZLHeoaNkTdjvS2XwH11d2QMC9htfQ399niYM=;
        b=Wj3mk75SE5UGk8wYiF4cYewq8oNx3He3F/vftvxL3PhdnF5T3nQy3wAc1RKzgMzW+z
         P8X3bYx7aDuaB5yilXDSWEDP4pKWnvgo4Mi56UFwlLyEBxJ4qdWzXUjCEw8BTyVQjXWI
         wqNZF1gjgsAueKp+ez+Uo2E/Zk97ZbHQWYBdmYY1SIyzUXRTz+cSy1ErQ5cmt2djVgFW
         vc67TMcWNEcx9nN0n+en0yuRjP2eBi7VUfpBq0/023xOsisWvoy8Ly/FtUVkmb7shM+v
         c9NkM8gL8q3AUq3g5st2hwMn6aubsMiHpmIv8F2AJYwX69fFWjjWmgBVvxPy01q9sMMD
         UNyQ==
X-Forwarded-Encrypted: i=2; AJvYcCXYYjZ4u5yabHziezo681eCFqNXUFlLdOVmL7c+WgX1gImyKl5ksK1IzFk9I0yDry+R9Q9OxSt0@lists.linux.dev
X-Gm-Message-State: AOJu0YyjuTzG1eGaM1GNk6VRwSbnRYysf1rPkRUZvulBPcQXpxi1lixB
	j9IaNSOfVLM5/a6thO7HAbfOi42e5iGiTV9cpsjd3uM1oRKsA+Ska0AO1m7zLm06+7bSDpQrqkE
	zdYisDzFZfurg9ItBX1j+QsquRIt3SmFXSyTH25Rl6JCc9xzFGOCo4W6RBHbZodSaKRb5Az+lWu
	PRAOI/F6DKgu3hVQI7PVEZWwTDu43TK2KoiNvli1UA278PmaaB0mJYZr6C7PzYYkMF7bJ6Rb58i
	X9mCY3yerQKCR1Vyie9Ctis
X-Gm-Gg: AZuq6aI+gS/izQQXaOjWngwd6I67M/nWXCNj2vifFrBuVfr44YPBNluXv72GU8OxyrJ
	bzEEyzlVDKRqgg6MRMwGgM05JrpIPOoBp8NyC1lVyp7LSD4/Gcp3ORx2JNYrH0JN4ew4OM9uxjK
	6D79XURyIm0moglIhG54pGuYWSF6I+zEz2GdxGs7TE108fiw86U5e3BB/yVuMPALjm0jseVh7wv
	h5coLsuC815+JWAYOA8bbgNLu9o78TNTBcWsWz6/r/Sdb5dHvQhxtaeF+CM5BHUHTl5R6t6yO0E
	7bH+tnjc9WUnSFArmQzEDqDwPHidIlP8xczMMGtrEvVifMKs4P/JncPb546F4d0ey5w9LZi6l/h
	qZoV2RKRxoJw2910D9P+lbiLNlyeBwc56mgjEoIlkdXR/QjU26X0ZpvvTDM4EipCQXL9C9yxsDu
	v/BlyPobVWxqfwL5PGadtT6w3gm+PLfhqoiLtnEqblAnzgYwmitPEBXg==
X-Received: by 2002:a05:6830:20c8:b0:7cf:dbb4:320a with SMTP id 46e09a7af769-7d46467e7f3mr705101a34.27.1770380422384;
        Fri, 06 Feb 2026 04:20:22 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-0.dlp.protect.broadcom.com. [144.49.247.0])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7d464796d1bsm447597a34.7.2026.02.06.04.20.21
        for <patches@lists.linux.dev>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Feb 2026 04:20:22 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4325b182e3cso1790848f8f.2
        for <patches@lists.linux.dev>; Fri, 06 Feb 2026 04:20:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770380420; cv=none;
        d=google.com; s=arc-20240605;
        b=KXVc9lVpBetoiTMiCxhYUjMi/3rJ/zKrbMs66QIkxYxk3x0W/enEgJDeowA4xfH4cY
         Oh50DUzd25srLD+8hLeoB/clXX7mvSZkh7nmPGoHTabyjRDEhKgbMOrSFsN89O6ylVE5
         aKWlNTz52tAx15BQcjF1jtKKpTiDC3+V7B3K6WNJt9o1k3ShSy/ZkB6Vng3fb78i51i8
         kdC/PSYFrDcxOznfxTIIu6PilMm8lPLMxyTDHJ/c+9jUWDSZBnbnMtL5SDvL/B+AFDpA
         wCgx0y/PtXxnPYCIvnIAEBn2WVgo4zz7Rqu50Ni1tnJ6HUdKZBXND3+/rDOi01NMC4yx
         pD4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=eDPtZ4eZLHeoaNkTdjvS2XwH11d2QMC9htfQ399niYM=;
        fh=Td5qKT+Gv1oK9y907/Ch/PfDUGEePSk8kh5Q14CSxXw=;
        b=j7sBUgTR2+MCe+WxBoU/ob6DFqlyoW5hOFsGKDNieHg4RwMlnVeTLq9lZut7lKoSGN
         4IzzzwfvSUbOgHR5sIVPI2pjAnuuy34GKaIMTgmVUzSjunsheSVrQ3VYWPC8eM+WY8cB
         VToA6WVrGXNHcmAa2YIr+p9N8OJ3XcVykwbglD+PkgUShcQjswBaFElFhrpF8FQywtmr
         0G3VRum5drwKo/iobHQ1MqrdJdYBYcXhWJiT8QPWa/LirMdz+HQcAmm7tEjCzexCdLdn
         xXoLPekjYAA2o40rSxQzSGVyS00fB4+EbrV+yTVbEc8bypxizlxyptJyIP+OPYGjvkCy
         O4qw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1770380420; x=1770985220; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eDPtZ4eZLHeoaNkTdjvS2XwH11d2QMC9htfQ399niYM=;
        b=c2Rko5rZSuY2qzHB8sLcDNiQXj+xIAWeyq65Fpmtwy2lSWMlMCZkGNjErOGclHXbMZ
         Gg8L5pgGHvmv3L3Z/hT7maYMwBXbtNDbveDZAgXJ5wZIg8FbVbbShkYkuB6LyN+f9LCz
         if0s1ZJq8KdBizonnHBwmGMHC2fvBpZpuQMLc=
X-Forwarded-Encrypted: i=1; AJvYcCX6hwvBM7T19KzrwZvtxq6HL9rQIOdXY4ic+NBU86g5kY4kzuVJQsOOmJ2r6QopEoI/63oYTGp2@lists.linux.dev
X-Received: by 2002:a05:600c:1387:b0:47b:deb9:15fb with SMTP id 5b1f17b1804b1-48320229ce6mr41483095e9.33.1770380420570;
        Fri, 06 Feb 2026 04:20:20 -0800 (PST)
X-Received: by 2002:a05:600c:1387:b0:47b:deb9:15fb with SMTP id
 5b1f17b1804b1-48320229ce6mr41482665e9.33.1770380420110; Fri, 06 Feb 2026
 04:20:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
In-Reply-To: <0-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Date: Fri, 6 Feb 2026 17:50:07 +0530
X-Gm-Features: AZwV_QiOstocTtD1A7zQmEpj2xAVTA0JLrJ2Pjm6bSBFQ0ReYlaFPkCh-BRSpps
Message-ID: <CAHHeUGWw221yuH7Ac8hbsVc+dMBC2GDnPZMmAjKMdu36wkY0Zg@mail.gmail.com>
Subject: Re: [PATCH 00/10] Provide udata helpers and use them in bnxt_re
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, Leon Romanovsky <leon@kernel.org>, 
	linux-rdma@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>, 
	patches@lists.linux.dev, 
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000001c3ba2064a26d0ee"

--0000000000001c3ba2064a26d0ee
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 6, 2026 at 7:15=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> Add new helpers that entirely execute the expected common patterns for
> driver data uAPI forward and backwards compatibility so that drivers don'=
t
> have to open code these.
>
> The helpers were developed by looking at the entire tree and moving every
> driver to use them, but this series only converts bnxt_re as it has a
> pending series to extend the driver data uAPI and the lack of correct
> compatibility handling will be problematic.
>
> This handles both the request and response side of the udata using the
> following general rules:
>
> 1) The userspace can provide a longer request so long as the trailing
>    part the kernel doesn't understand is all zeros.
>
>    This provides a degree of safety if the userspace wrongly tries to use
>    a new feature the kernel does not understand with some non-zero value.
>
>    It allows a simpler rdma-core implementation because the library can
>    simply always use the latest structs for the request, even if they are
>    bigger. It simply has to avoid using the new members if they are not
>    supported/required.
>
> 2) The userspace can provide a shorter request, the kernel will 0 pad it
>    out to fill the storage. The newer kernel should understand that older
>    userspace will provide 0 to new fields. The kernel has three options
>    to enable new request fields:
>      - Input comp_mask that says the field is supported
>      - Look for non-zero values
>      - Check if the udata->inlen size covers the field
>
>    This also corrects any bugs related to not filling in request
>    structures as the new helper always fully writes to the struct.
>
>  3) The userspace can provide a shorter or longer response struct.
>     If shorter the kernel reply is truncated. The kernel should be
>     designed to not write to new reply field unless the userspace has
>     affirmatively requested them.
>
>     If the user buffer is longer then the kernel will zero fill it.
>
>     Userspace has three options to enable new response fields:
>       - Output comp_mask that says the field is supported
>       - Look for non-zero values
>       - Infer the output must be valid because the request contents deman=
d
>         it and old kernels will fail the request
>
> Since bnxt_re has never implemented these rules correctly and now does,
> provide a UCTX flag to tell userspace about it. If
> BNXT_RE_UCNTX_CMASK_UAPI_COMPAT_SUPPORTED is not set then userspace must
> not use any request or response fields beyond the current kernel uAPI.
>
> Using any new fields is only possible on kernels with the flag.
>
> A series converting all drivers to these new helpers is on github, I will
> send it later:
>
> https://github.com/jgunthorpe/linux/commits/rdma_uapi/
>
> Jason Gunthorpe (10):
>   RDMA: Add ib_copy_validate_udata_in()
>   RDMA: Add ib_copy_validate_udata_in_cm()
>   RDMA: Add ib_respond_udata()
>   RDMA: Add ib_is_udata_in_empty()
>   RDMA: Provide documentation about the uABI compatibility rules
>   RDMA/bnxt_re: Add compatibility checks to the uapi path
>   RDMA/bnxt_re: Add compatibility checks to the uapi path for no data
>   RDMA/bnxt_re: Add missing comp_mask validation
>   RDMA/bnxt_re: Use ib_respond_udata()
>   RDMA/bnxt_re: Add BNXT_RE_UCNTX_CMASK_UAPI_COMPAT_SUPPORTED
>
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c |  84 +++++++---
>  include/rdma/ib_verbs.h                  | 185 +++++++++++++++++++++++
>  include/uapi/rdma/bnxt_re-abi.h          |   1 +
>  3 files changed, 251 insertions(+), 19 deletions(-)
>
>
> base-commit: aace79adb7196a02ff45a334839a4d31a0e262fb
> --
> 2.43.0
>

Thanks for this patch series. Patches 6, 7, 8 and 10 failed to apply
cleanly, due to conflicts with the recently merged QP rate limit
patchset in bnxt_re.  So please rebase it.
I applied this series, + QP-dmabuf devop patch, + bnxt_re DV series
and tested it.  It worked fine.

For the series:
Acked-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Tested-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>

Thanks,
-Harsha

--0000000000001c3ba2064a26d0ee
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
tJVewHuOmXgWQxNWV7Oiszu1d9xAcqyj65s1PrEIIaHnxEM3eTK+teecLEy8QymZjjDTrCHg4x36
2AczdlQAIiq5TSAucGja5VP8g1zTnfL/RAxEZvLS471GABptArolXY2hMVHdVEYcTduZlu8aHARc
phXveOB5/l3bPqpMVf2aFalv4ab733Aw6cPuQkbtwpMFifp9Y3s/0HGBfADomK4OeDTDJfuvCp8g
a907E48SjOJBGkh6c6B3ace2XH+CyB7+WBsoK6hsrV5twAXSe7frgP4lN/4Cm2isQl3D7vXM3PBQ
ddI2aZzmewTfbgZptt4KCUhZh+t7FGB6ZKppQ++Rx0zsGN1s71MtjJnhXvJyPs9UyL1n7KQPTEX/
07kwIwdMjxC/hpbZmVq0mVccpMy7FYlTuiwFD+TEnhmxGDTVTJ267fcfrySVBHioA7vugeXaX3yL
SqGQdCWnsz5LyCxWvcfI7zjiXJLwefechLp0LWEBIH5+0fJPB1lfiy1DUutGDJTh9WZHeXfVVFsf
rSQ3y0VaTqBESMjYsJnFFYQJ9tZJScBluOYacW6gqPGC6EU+bNYC1wpngwVayaQQMIIGszCCBJug
AwIBAgIMPiCpKhlPGjqoQ++SMA0GCSqGSIb3DQEBCwUAMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAy
MDIzMB4XDTI1MDYyMDEzNTQwNVoXDTI3MDYyMTEzNTQwNVowgfIxCzAJBgNVBAYTAlVTMRMwEQYD
VQQIEwpDYWxpZm9ybmlhMREwDwYDVQQHEwhTYW4gSm9zZTEZMBcGA1UEYRMQTlRSVVMrREUtNjYx
MDExNzEUMBIGA1UEBBMLQmFzYXZhcGF0bmExEjAQBgNVBCoTCVNyaWhhcnNoYTEWMBQGA1UEChMN
QlJPQURDT00gSU5DLjErMCkGA1UEAwwic3JpaGFyc2hhLmJhc2F2YXBhdG5hQGJyb2FkY29tLmNv
bTExMC8GCSqGSIb3DQEJARYic3JpaGFyc2hhLmJhc2F2YXBhdG5hQGJyb2FkY29tLmNvbTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKS3kXt4zVFK0i5F3y88WV5rV0rr2S3nOVTaCGMB
o6Se8pIb2HJcdpQ4rMiJuIRSyG2XDWv6OB+66eM/6cD2oklFcdzpC4/eYOQFWJ/XM8+ms6HT7P5e
uE7sY6CeUzLzHNjcRwVgZRWlELghY7DIW9fbMzRNDFsbxuIN/7eSofavP1q7PF3+DqhHZpmrVkDu
vcEBTRZSn8NWZ0Xhy4a+Y3KN2W55hh6pWQWO0lt2TtpyaqYp95egJGqDUPtqydci+qrBzXbL05Q0
gcK0NfqGJwLsEVqxHwzz/jRrzKBYKQEK4Bpau91oxVGLmxy1nQDiyI1121xyvsJBDctKH245XZkC
AwEAAaOCAeYwggHiMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSB
hjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3Nn
Y2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEFBQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5j
b20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1UdIAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgw
QgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9y
ZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAyhjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dz
Z2NjcjZzbWltZWNhMjAyMy5jcmwwLQYDVR0RBCYwJIEic3JpaGFyc2hhLmJhc2F2YXBhdG5hQGJy
b2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBQAKTaeXHq6D68tUC3b
oCOFGLCgkjAdBgNVHQ4EFgQU9Dwqof/Zp1ZdK6zi7XdRGdBWQt0wDQYJKoZIhvcNAQELBQADggIB
AKzx/6ognUMhNv+rh7iQOeHdGA7WMDixk+zrD7TZL6O5DPqXfFqaTLpswyruTymA3AVxZkMJyF6D
zOAsRfU23BjVlgC95zl1glr7DorZW7B/CQDwbLHlkFy92Oa3E+gBzwdiDMjnq6tOW5p83zoVqiV4
qm4OwC9JILEkslV4uZVXHPm5cZoOQURTECE2BN34Qhg5qD3EKYqOTeMVRed1qQiIPqQv1b4xjPVS
qBwNPl7/4TJGiZGnRB7FsNnNUQRJONnEFifM3KGqjbqA4F8BhLXCYjqtBxxCGA5506StNfsjT8UU
28E6lcuJXC4hQXau+xXQ5GWqS4ecWwm22FAVy/i8FJVfXPTJnZeixmqaadbIU3fOJs5+XfyNkU2T
mlCafSr7KgV570M6tITSyminW/7rc8hdznGYypCNa+45JYJTaK4x1+Ejptaxc7TCS12B1zQNCxa7
AHX5PZra3SpDb7g1p1i1Ax0JVJTkThiCSNDbiauVn7xIJpf+H8HC6O2ddGmtKUxe6NseFnSGJsi6
7lO/cU+TpduV7w3weUy+nHhp+GsbClfvAGhFAs/GkyONExCwwIEVlFp9Mj5JLAgB+ceMbojBIoaO
d5rOzdIII5FDwKAAqyjHuniYLrP0xIH4L5kWOAy+LudP4PSze7uAxTiCiSJg5AaNBTa5NuwTnSX6
MYICVzCCAlMCAQEwYjBSMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEo
MCYGA1UEAxMfR2xvYmFsU2lnbiBHQ0MgUjYgU01JTUUgQ0EgMjAyMwIMPiCpKhlPGjqoQ++SMA0G
CWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCC/bSBRkxztnbzlWU5j61igsX1cm8DH4Lri
0VNq1MoHSjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjAyMDYx
MjIwMjBaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgB
ZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEF
AASCAQAkk45ogv2yQpdDtFRYRV65GlmDdj5GI0l5KgTBB8YAH9IZCQP90Y4Y0pkAIkhx0TZ0cdax
lHN36K7XVca4r4wLw0ovlaeFsP2285vzA7glTC0j25C8dil3AKPaZR3ySdA9I1rk/0I2WXwp8Nrq
U2iIuOqX9TccTtvORNRGTLjvPi32RH7f07GPHyLGO3m4hSvfNlt6Dl07ys6VqR/lCDv0DdR2bFXd
iT5ZwGYfkWF2N2umJ3iYtpBQg+vOXWwkS3S9Bu4vJneBHOSkVyMJJWdo1FTLL0MZI2mzOshGDZ80
xYpxcaQLrqSEK+sgMT4H3dLA3aUSsmdF/z3mL59N/U1a
--0000000000001c3ba2064a26d0ee--
