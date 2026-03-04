Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E19237EFF6
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 14:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.227
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772635991; cv=pass; b=m5WY17qX4Dp5enAzLS6gZ3CkeZbnu1g/lC+y4HdA9qnq+Zwy+soo95htC9MIWbswUMNPQJTcr2et+BfoZK7LWzakYSaxYxA3hSwbNXDLs0LnEmIAuQksSEowa79k56xDY3uaH9r9/Wug1WJfr7XAIsgkyGdsvurvvHVU+M3q64o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772635991; c=relaxed/simple;
	bh=3TYH9FSAOSu/tN/0u7rHzY8wEI1qzJkbFzO45qqSKz8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LrrcFCGwijEgu6ciihL2Thq1xaK5vUn6vtf4tmdukzA3g7XAbzBkMeNIrbsITTczdRP7Wj3hIwTMXkiGlUoKt9mfTDUwiRcaSITjnUPH544j0bHieVMkCjccvaBBexyKGxIW+Ict1owEZG8NRKmANJpJm1E8l/itNboCwcHpEt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=LHcHwvPl; arc=pass smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LHcHwvPl"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2ae3a2f6007so30852415ad.2
        for <patches@lists.linux.dev>; Wed, 04 Mar 2026 06:53:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772635990; x=1773240790;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lnho2s0CNgBebofmlEXmTQA6fDfCUNQWFGtdJw9wQ3g=;
        b=SiV/8XB2m0r1F3EvqT3xdWIAVm2SZd373NQIHf69/t4WqbmQyENPqAnAnyzBJBBAKq
         5g6UaXkMwXAYQd3wn1H7a5AGOYF0/c50jY+hRhlXs0CevsIzoNu0zjgVGMduekQJPh+X
         xlz+nk0bsn/FKlcYtdoUWUJ4PWT50Q/PyN7GXTMnpnYDXLysmiEH0nqbRXcCrL+xznwO
         T5U7NRWWbyZPFQ1xncCGFMT2ADcRITg8soLWT+6K/rEFej0mUicExrHrWqXWy1dM5U3l
         Aqo4nt4Pg+Kk0FxfmkT6etAJM54HKgWkEn5N1A8x5MtQdXW/NfhdOBCGFF+XSiBxy4hu
         xm9w==
X-Forwarded-Encrypted: i=2; AJvYcCXlw63pZnahTUai43vVPhjrPXcw1SxXSBwrf3oD50tQlumhwXupblO8uN7JIGDnsSNqLdHZ1qmJ@lists.linux.dev
X-Gm-Message-State: AOJu0YyFNR1+aSksijkx+Ofqvw23zbSFVvARZfcIaGIJqIzuisMtQgJW
	UbABV2YciHCcVIKRUXm9mTZvFkzZeuqrYgL8nSbDQD+T3EmH0Ay27fuJTWLXrw8e5iY3Ue8/Zi+
	ldXcXESy7c/ztEoMWygByX5BL+v6SfvJTsB1az5nDLOscGM3aqZlhzrZ+CgbH1Tq/rE4a0WI66N
	Gs/hVgCFLooMJXH+d4ZczJV9a2hiDaVxo2JJF0RT5wAGo0qMRkSqotdZ7JwTrAxCiZc8W18YXYd
	dRuMf3ApBbU3aE8OMmI3lms
X-Gm-Gg: ATEYQzyycFxumyqfZHeL8x4fpa5toXhChv2vk+iPJk4yjqMyNucZMyuFE0wyaXZBkky
	erVZiE9WoIOLJYbsTVA7+qj/khCe9g1iWEwJyDKLwvtYPAY/fhG+HIC+Q3GqAisu9m6G5ALORz4
	nLHN7k5/Z1qPBhMNPH/bd52wT5BMh7XBCDtbZ6n1uQ4TRGGXdEYV3NOUhI5N3F0khw4ZDV0PHHq
	aft7Lr0w/OahFtWYVDno28WkDFkQXYPUgCGxZ/5AeiXLGvg9NzjTkHIqJiDqZRaSm4OM34vyYs8
	J8/wNn3rH81Uw0SRk5NAgehoDBsAnWYwMjgh/HhPe9hlVhCFYWcKz+4tazNMIhE9e0Bqyst6a6C
	Qb/J9ecaBWeUxx5mcS2kI2KKITYfsQsPtCbsJ02FaHwxuw5khAlM7sakc2HYOl19YUp8Fx/g0Qb
	G2gDdXLLtEXo4bh3CrnRhqkhyEJEf5/3VzYfBwV6y9efeMHVI3AbpjazbKi9YYcsyV0Lsrtg4=
X-Received: by 2002:a17:902:e5c2:b0:2ae:5a55:3ded with SMTP id d9443c01a7336-2ae6ab6b4ccmr25256245ad.45.1772635989630;
        Wed, 04 Mar 2026 06:53:09 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-103.dlp.protect.broadcom.com. [144.49.247.103])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2ae47c5c786sm15449415ad.11.2026.03.04.06.53.09
        for <patches@lists.linux.dev>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2026 06:53:09 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-439cbc5fb4fso288388f8f.0
        for <patches@lists.linux.dev>; Wed, 04 Mar 2026 06:53:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772635987; cv=none;
        d=google.com; s=arc-20240605;
        b=ZNuCUfF+yB0AIgoAVeFR8qV7D/OWnGsSfV53GhXlDzsbF12lujzK61/5oyDVDlnuUO
         JimUsX04Yukazp7pBygpGpOT/3ltnJWsYFY4Yptpn54DMXPnP4hA3tb+C4NCck4tJCw5
         n+yue6pTyzu1q3JppDWHK8Zv1UvseGCdbIiGJWpQf3mwTs1hXMp9WgqrmW0hsHQeTFK3
         QYib3rB5ugltFmVWmS7QJH0SOZ1ar47+wB5mjrqD6xDni3i2eczbEtdi3va2uulrEW5Y
         sYwXS7G/+BqvqMTxez4j2mXfUL9sIuPG+tShPqRosYLhtQtl599VXQF8Y4kRvPfCRzVb
         oA7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lnho2s0CNgBebofmlEXmTQA6fDfCUNQWFGtdJw9wQ3g=;
        fh=HeTpgpjI3kzIKXBVVm03nVMCb/83NYCM+aaNYbgZkeo=;
        b=Sknchu4pGfl1Nu3G6YAVb+zOmPT8/grrcXy+ZiktAd/0ffjYbbmwUOTvKA5QeSRgW+
         8NJJ1ezcifIqdrGFbgeZy9gqog25VAhH7oxwiytx2gyk6Gi9daHgU6hfkkT8+7JoJY7v
         xuB2oYzybXLc4uDXMpJFFTBGZM2IlVHJNup5n5RrXQFBri3xa9Ho8Ko++SAakWWKuyyu
         FvbbDm3aPWsXGA8AEB4BY8yX6Sy6EF3+fURLNXTBGMUu401zMaq1jYgcSbKbpz8ouCYz
         IkgS+dzTPUvjdrT9QDaVYjoxhMKok9aTSj2o7KeHd0xYOqMHag9ObxulMnUsUdte0Nul
         NhEg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1772635987; x=1773240787; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lnho2s0CNgBebofmlEXmTQA6fDfCUNQWFGtdJw9wQ3g=;
        b=LHcHwvPl1nTV3cf+Tv6+cEBFehenxzWsB5bj8e1ohh5Eh0LpKEjlIdmLSCQ/phafTj
         QEEkRb5XgsBrnCC6ghp5Jsiym9V/zQAnRMt0iscfBPnd+mQ9Od+2mDYQS3H8YW6rbqIo
         VCEsOMluWtY648y/7oBVQ6hcxfd4ttGQGo/xI=
X-Forwarded-Encrypted: i=1; AJvYcCXMVlmr3obBgG3Y7gf50hnsdyKU+jn0wf0GCjJbQZJS8V2D9p9o39TRvWCa5561OzAGjyxZkFG5@lists.linux.dev
X-Received: by 2002:a05:6000:2912:b0:439:b886:20da with SMTP id ffacd0b85a97d-439c7fb0c37mr3904858f8f.17.1772635986602;
        Wed, 04 Mar 2026 06:53:06 -0800 (PST)
X-Received: by 2002:a05:6000:2912:b0:439:b886:20da with SMTP id
 ffacd0b85a97d-439c7fb0c37mr3904800f8f.17.1772635986016; Wed, 04 Mar 2026
 06:53:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v3-bd56dd443069+49-bnxt_re_uapi_jgg@nvidia.com>
 <13-v3-bd56dd443069+49-bnxt_re_uapi_jgg@nvidia.com> <CAHHeUGW5aOHbhETW624fM_MSkXAqUgw=T+6skPaA=R3py+9EQQ@mail.gmail.com>
 <20260304141149.GO972761@nvidia.com>
In-Reply-To: <20260304141149.GO972761@nvidia.com>
From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Date: Wed, 4 Mar 2026 20:22:54 +0530
X-Gm-Features: AaiRm50uoJCcSQYZgdb957JNsYl5fxpfWzbvWOnVYNeV0tioMWbd1EDEYi703Qo
Message-ID: <CAHHeUGWuWCnLw4-mqAPhPt+f_qZThjOBQU9V=x0MyCO7bkxyqA@mail.gmail.com>
Subject: Re: [PATCH v3 13/13] RDMA: Add IB_UVERBS_CORE_SUPPORT_ROBUST_UDATA
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, Leon Romanovsky <leon@kernel.org>, 
	linux-rdma@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>, 
	patches@lists.linux.dev, 
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000526ef3064c33fae9"

--000000000000526ef3064c33fae9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 4, 2026 at 7:41=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> On Wed, Mar 04, 2026 at 12:05:11PM +0530, Sriharsha Basavapatna wrote:
> > On Wed, Mar 4, 2026 at 1:20=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com>=
 wrote:
> > >
> > > This flag can be set by drivers once they have finished auditing and
> > > implementing the full udata support on every udata operation.
> > >
> > > My intention going forward is that driver authors proposing new udata=
 uAPI
> > > for their drivers must first do the work and set this flag.
> > >
> > > If this flag is not set the userspace should not try to use udata bas=
ed
> > > uAPI newer than this commit, though on a case by case basis it may be=
 OK
> > > based on what checks historical kernels performed on the specific cal=
l.
> > >
> > > Since bnxt_re is audited now, it is the first driver to set the flag.
> > >
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  drivers/infiniband/core/device.c                  | 1 +
> > >  drivers/infiniband/core/uverbs_std_types_device.c | 8 ++++++++
> > >  drivers/infiniband/hw/bnxt_re/main.c              | 1 +
> > >  include/rdma/ib_verbs.h                           | 6 ++++++
> > >  include/uapi/rdma/ib_user_ioctl_verbs.h           | 1 +
> > >  5 files changed, 17 insertions(+)
> > >
> > > diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/co=
re/device.c
> > > index 558b73940d6681..5b4fb47cbaeee6 100644
> > > --- a/drivers/infiniband/core/device.c
> > > +++ b/drivers/infiniband/core/device.c
> > > @@ -2706,6 +2706,7 @@ void ib_set_device_ops(struct ib_device *dev, c=
onst struct ib_device_ops *ops)
> > >
> > >         dev_ops->uverbs_no_driver_id_binding |=3D
> > >                 ops->uverbs_no_driver_id_binding;
> > > +       dev_ops->uverbs_robust_udata |=3D dev_ops->uverbs_robust_udat=
a;
> > this should be: dev_ops->uverbs_robust_udata |=3D ops->uverbs_robust_ud=
ata;
>
> Oops, are you OK otherwise?
>
> Thanks,
> Jason
Yes, it worked with this minor change.
Thanks,
-Harsha

--000000000000526ef3064c33fae9
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
CWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCBJz7vTD4Z50Y+u2eB16pfu99T9xWLvxY3J
51yQqCgU2TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjAzMDQx
NDUzMDdaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgB
ZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEF
AASCAQB8ySJNHktzX9STXa0ZKrcLsc0/KGA0lkTydbVcbgEtMIZGe26X1/lXu/dSiLrIhD0kUhwh
sr+6VWSsA10RgYOblxrZg1/CrFzg/upd5Nyc6gR4eG2hYrgxSw3Ho76PfieNbYh5v6zqq2r6bMMI
gxr4yLtJNx/rVg2KhlxK+U/qKDvdiI6XiUPjXDNqGy69YUaBSZz26aHIlVPKraySEQWG/OBrwsAc
haGlDEeDUk8mr7ftbk6rsQJLMh8tj2JhTx9wd+MUPGox4pQxz666bB+9Tm7uI1edJZnXvsbiC93d
h6EdpVMgNZkam1SCeWe+zVMfDc6+hrt8CvcEH7lvPtrI
--000000000000526ef3064c33fae9--
