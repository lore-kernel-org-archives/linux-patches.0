Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DD337F8C1
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 06:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.225
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772606128; cv=pass; b=MTGlIMmpe1OL0oiN8yFW7qvrAogQ8cKX81+uZg90wIYjubq4F8c0eIgZG/MF32xWErIBGtoYh5H7qZTFMYY+VGH6K+BZ7/XYv6qthVpIyDGKkY/YySJ7R327KzDO2GKCWsV5L8ppei6jnJTHW8y9WHNQpXfe6AAcN1y7ER7jkRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772606128; c=relaxed/simple;
	bh=0guPO6PNOGCbmzZ3ZFL5/dV/ZEjWqJL7WnEzzabpVzw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PcY1RNVI88BIUvJYPEgi3E+dwFzBigM0Pgx6y+EpCSHxBpuKISkXa1y8NiqkKunuoMwAnWFNvtlxIaKAP6EoFbjt6XCxewqaLqW7roS+7Vsr37hcLOGJsaBMJg7jQqTtWLJWiIQMc1CqLARf7ktyrsu4WbxaDCRPPhUQ7kLM/p0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cSBJ8rGB; arc=pass smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cSBJ8rGB"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-824a829f9bbso3027323b3a.0
        for <patches@lists.linux.dev>; Tue, 03 Mar 2026 22:35:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772606126; x=1773210926;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4JDec+c72cLl2bhPz4/UDEElyJNx4n3PS/2tdRw/lHo=;
        b=HCFJdZTxXDkk68WKOilOEmR71L8dyFK8eFaghHNAzhMumpIPX/xOtqx1zViV3B/e7K
         GRxaIVPDNVltpRo+/jBW4hufFVT+OBeVO5T/36VfDAYVIEI83vuIZgpaCpk7724LXpgX
         GsdMT+m6e0I015havHs7YOJWOmJaS6JY2zyODf8/CWJ8CbNwMprUTYKluZRGIaTTLlsF
         q9U4j5/Y4bZ/SwL0lnSmCnZjyv42A/GIIu1E5ggNzfY7s88EigFZAu3pr82YjsYDrL4X
         +woy4/uW5BXoOVob1k1g/R/CTSQiNqmq8UbCW3T55xqOX9LoQCxmjwLUBcpEHjfa7JC7
         SI3Q==
X-Forwarded-Encrypted: i=2; AJvYcCXCvobPVa/jjnjwpKBZBstGeYqO903Cwi7jXRMbDMb5dSGL+Wxh4IbokkyQVuWcmSIDhuNmbHI3@lists.linux.dev
X-Gm-Message-State: AOJu0YwtDkVMfSf81OFq5PH82vhtS/ACLGiSyGPvLzZkxXMCF1lYIxIV
	9vytsJKLOmpFs+HJhzikhUIM7puOzltxSx/9J6Fv9IPAsFCqdq+raGehPSihH7JlgCQFNizxIQ6
	4hinqWPkLxWSC97PIn2irfJdYKN5LGv1SZVBRvwK81jxdLCVk/4rSWbCpYrTgs8sUdoT4SZVwB9
	XKjKPe/HzJvy3xjiPQ6+3f5DmGxzn4evsrb1CRRBjYb4k6LaWpRgZi+ia7gruTEZkr5ol7b9QY+
	x+/q1YmYA7NEQWIvGVZzplA
X-Gm-Gg: ATEYQzwi76nWl+J2wIPgjR1IhQJCSzn665pkdchbGvovrqvnYEG2tVcMtCa/qjVhjEA
	MieIgGjzuOtpzcbLYqJkatUigQOx8BoMg81Q0AWRs4TnQq7TIl7Ht7L5VwAfJyQBmDvfKbTNL7y
	60y3BFhqszvPjTR8h8nQXs7+m3cnXhtE58tgFBdanmhT9eOE2By3l/bDoNySf2T4gHdZvtefDSl
	MEVueMEb25xf/tl2iQNEL8HzKIHzRUbD4Nwhka2xr7USqkoGmL5EP7WMjbux51tDx9L1qXdhO3/
	5UHLVtC24EzYlZkSqy9JVjlrXVnKEseKdQzOHxYrcrTGQVJ2AJgTPL8Nvu92HcjtLkzslOiqxP+
	BMDiP3270jl4i8shDiqQC42Nl6poIdyPPRNAHXBUIsULEggFYY+3jOqqdAAx/rxqqOB6Ap3QHqP
	Xe8bmBhMlaCRKfmbrnXslWB9ZVzz5S7K+fEuS+4l3vWucUSnzgXTyxHNXOpFW5hUg7MLu8
X-Received: by 2002:a05:6a21:4784:b0:38d:fa22:8ef1 with SMTP id adf61e73a8af0-3982dd66c5fmr900640637.3.1772606125525;
        Tue, 03 Mar 2026 22:35:25 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-11.dlp.protect.broadcom.com. [144.49.247.11])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-c70fa6165e7sm1338257a12.6.2026.03.03.22.35.25
        for <patches@lists.linux.dev>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2026 22:35:25 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-439b484ee04so1788079f8f.1
        for <patches@lists.linux.dev>; Tue, 03 Mar 2026 22:35:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772606123; cv=none;
        d=google.com; s=arc-20240605;
        b=UelpfAqFZR7Wf0aFc3bz+UGQbKZ7lo1S48CXknKWdwTeOS0Qs5M4EwiIbVaT1hMP6L
         7r/ytyubQrls0v6KaZvscQgC9QVtdOyt5H0VgXSmG0vNUp+paGEYR1DvshkW4C3GMXyg
         bZVW0TqFd3els7bU0WrYkxWwLu4gJQ7ru0P59KQTSFCui4SeOg+R87zp78vfEkHw3AF2
         fXwaguiFtxmiUUtFgsfAIx4VynDGoldP2rGLi/UDunf4zhdA9VM4OSAUhZx6xOENHcrQ
         N5w9DDxkymFoxHBZte8JOXwD9+3LtdDOA+B4Qr9JQW+WBpRdoaVDv4KfQul+D3DZeoTW
         n2gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=4JDec+c72cLl2bhPz4/UDEElyJNx4n3PS/2tdRw/lHo=;
        fh=1Ifyutj8Up06Tkcpk1P28lsGYKZpt4lKh/TfpjCGmYw=;
        b=C/L4BSBSlcTAecHPYINq52O8n+SiCDmc+U29iBWKQAxv95PK2N5Lz/nNW2hgED7pB8
         yL906Z7kVAnqGsoX1Ubpp9lJDkhD71xbnvmiHgMC9eOcSFYz10M5qDpIIMW+hEadPQZm
         1ZqTieEQyTGvTXGL9QOllJmAQPxjdljuDYInJhsdnJ2cyYlwwYOHOjjO8Byn6l5M44oP
         WBIU3RCTCm5do736EapJx+FIhj4DLGB6d/Lc42QXzs8zJRwh+kJsYBHMY7eFh+jsGoRG
         ZbRZNUsoowDvNmKRjZu27o5OE0Kufa9RhqNVVBHMgOOvAOm+jni6wY3KY9YXcgNryEac
         r6wA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1772606123; x=1773210923; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4JDec+c72cLl2bhPz4/UDEElyJNx4n3PS/2tdRw/lHo=;
        b=cSBJ8rGBfmuVKxKLayDwHRPUqOn9v8rDPrXOpn+ni87NfRBHDToBsbsXzcfGjQ7AgH
         CB945YkiJzbnM668KXl3txKcsK7Irveb4g0FA55nBq9aBcKUOTxUOwcJ50Pa8zxIQrlH
         RtJMv1QP48iD2iuCcVKV/siDHc9tWEqN/nolU=
X-Forwarded-Encrypted: i=1; AJvYcCXvFVCpbbmLIwe5n9GzVm5KUq/+aCLtYoiXS1Ef5IrKIZfSfz3KomXbKuoZtC5s5O0u4I1DCoZm@lists.linux.dev
X-Received: by 2002:adf:e3c4:0:b0:439:c560:bb78 with SMTP id ffacd0b85a97d-439c560bc6bmr3260359f8f.22.1772606123374;
        Tue, 03 Mar 2026 22:35:23 -0800 (PST)
X-Received: by 2002:adf:e3c4:0:b0:439:c560:bb78 with SMTP id
 ffacd0b85a97d-439c560bc6bmr3260333f8f.22.1772606122879; Tue, 03 Mar 2026
 22:35:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v3-bd56dd443069+49-bnxt_re_uapi_jgg@nvidia.com> <13-v3-bd56dd443069+49-bnxt_re_uapi_jgg@nvidia.com>
In-Reply-To: <13-v3-bd56dd443069+49-bnxt_re_uapi_jgg@nvidia.com>
From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Date: Wed, 4 Mar 2026 12:05:11 +0530
X-Gm-Features: AaiRm50aGUttJJht24MG4C2N0HMHRInd4YCzsOnkCMyDHR-q5HEnDIQcVprrLug
Message-ID: <CAHHeUGW5aOHbhETW624fM_MSkXAqUgw=T+6skPaA=R3py+9EQQ@mail.gmail.com>
Subject: Re: [PATCH v3 13/13] RDMA: Add IB_UVERBS_CORE_SUPPORT_ROBUST_UDATA
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, Leon Romanovsky <leon@kernel.org>, 
	linux-rdma@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>, 
	patches@lists.linux.dev, 
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000556b89064c2d0651"

--000000000000556b89064c2d0651
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 4, 2026 at 1:20=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> This flag can be set by drivers once they have finished auditing and
> implementing the full udata support on every udata operation.
>
> My intention going forward is that driver authors proposing new udata uAP=
I
> for their drivers must first do the work and set this flag.
>
> If this flag is not set the userspace should not try to use udata based
> uAPI newer than this commit, though on a case by case basis it may be OK
> based on what checks historical kernels performed on the specific call.
>
> Since bnxt_re is audited now, it is the first driver to set the flag.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/infiniband/core/device.c                  | 1 +
>  drivers/infiniband/core/uverbs_std_types_device.c | 8 ++++++++
>  drivers/infiniband/hw/bnxt_re/main.c              | 1 +
>  include/rdma/ib_verbs.h                           | 6 ++++++
>  include/uapi/rdma/ib_user_ioctl_verbs.h           | 1 +
>  5 files changed, 17 insertions(+)
>
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/d=
evice.c
> index 558b73940d6681..5b4fb47cbaeee6 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -2706,6 +2706,7 @@ void ib_set_device_ops(struct ib_device *dev, const=
 struct ib_device_ops *ops)
>
>         dev_ops->uverbs_no_driver_id_binding |=3D
>                 ops->uverbs_no_driver_id_binding;
> +       dev_ops->uverbs_robust_udata |=3D dev_ops->uverbs_robust_udata;
this should be: dev_ops->uverbs_robust_udata |=3D ops->uverbs_robust_udata;

Thanks,
-Harsha
>
>         SET_DEVICE_OP(dev_ops, add_gid);
>         SET_DEVICE_OP(dev_ops, add_sub_dev);
> diff --git a/drivers/infiniband/core/uverbs_std_types_device.c b/drivers/=
infiniband/core/uverbs_std_types_device.c
> index a28f9f21bed89d..12ca15739cd2cd 100644
> --- a/drivers/infiniband/core/uverbs_std_types_device.c
> +++ b/drivers/infiniband/core/uverbs_std_types_device.c
> @@ -247,13 +247,21 @@ static int UVERBS_HANDLER(UVERBS_METHOD_GET_CONTEXT=
)(
>  {
>         u32 num_comp =3D attrs->ufile->device->num_comp_vectors;
>         u64 core_support =3D IB_UVERBS_CORE_SUPPORT_OPTIONAL_MR_ACCESS;
> +       struct ib_device *ib_dev;
>         int ret;
>
> +       ib_dev =3D srcu_dereference(attrs->ufile->device->ib_dev,
> +                                 &attrs->ufile->device->disassociate_src=
u);
> +       if (!ib_dev)
> +               return -EIO;
> +
>         ret =3D uverbs_copy_to(attrs, UVERBS_ATTR_GET_CONTEXT_NUM_COMP_VE=
CTORS,
>                              &num_comp, sizeof(num_comp));
>         if (IS_UVERBS_COPY_ERR(ret))
>                 return ret;
>
> +       if (ib_dev->ops.uverbs_robust_udata)
> +               core_support |=3D IB_UVERBS_CORE_SUPPORT_ROBUST_UDATA;
>         ret =3D uverbs_copy_to(attrs, UVERBS_ATTR_GET_CONTEXT_CORE_SUPPOR=
T,
>                              &core_support, sizeof(core_support));
>         if (IS_UVERBS_COPY_ERR(ret))
> diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw=
/bnxt_re/main.c
> index b576f05e3b26b2..7af514524632e2 100644
> --- a/drivers/infiniband/hw/bnxt_re/main.c
> +++ b/drivers/infiniband/hw/bnxt_re/main.c
> @@ -1326,6 +1326,7 @@ static const struct ib_device_ops bnxt_re_dev_ops =
=3D {
>         .owner =3D THIS_MODULE,
>         .driver_id =3D RDMA_DRIVER_BNXT_RE,
>         .uverbs_abi_ver =3D BNXT_RE_ABI_VERSION,
> +       .uverbs_robust_udata =3D true,
>
>         .add_gid =3D bnxt_re_add_gid,
>         .alloc_hw_port_stats =3D bnxt_re_ib_alloc_hw_port_stats,
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index e1ba20c3974f08..58af61eae52de7 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -2474,6 +2474,12 @@ struct ib_device_ops {
>         enum rdma_driver_id driver_id;
>         u32 uverbs_abi_ver;
>         unsigned int uverbs_no_driver_id_binding:1;
> +       /*
> +        * Indicates the driver checks every op accepting a udata for the
> +        * correct size on input and always handles the output using the =
udata
> +        * helpers.
> +        */
> +       unsigned int uverbs_robust_udata:1;
>
>         /*
>          * NOTE: New drivers should not make use of device_group; instead=
 new
> diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/=
ib_user_ioctl_verbs.h
> index 89e6a3f13191b9..90c5cd8e7753c7 100644
> --- a/include/uapi/rdma/ib_user_ioctl_verbs.h
> +++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
> @@ -46,6 +46,7 @@
>
>  enum ib_uverbs_core_support {
>         IB_UVERBS_CORE_SUPPORT_OPTIONAL_MR_ACCESS =3D 1 << 0,
> +       IB_UVERBS_CORE_SUPPORT_ROBUST_UDATA =3D 1 << 1,
>  };
>
>  enum ib_uverbs_access_flags {
> --
> 2.43.0
>

--000000000000556b89064c2d0651
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
CWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCA5VYv4Yc6vem24fi9Y8pZity250EuxJPZH
q5pA/5qJrTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjAzMDQw
NjM1MjNaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgB
ZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEF
AASCAQBrxVNeXOoK3/DZFkMMr3jFhZGtQXxNo0V6A7Der5sc8uL67gz3hphD2t5Ay8N00+cGU0BC
fqoabuv/9YHnwvhD0f9SxXq5JjkT8tPuWXmD5ytKJEzMk/zpbUSPGBuOlIG8skOIfHWpCbOHdFHx
nluK0ZdIFU5plPIBxdehkzzmynt1sQxk2S46GYfnW8C6QrPGQB0hPnpzRHmO1D+8nfPQKMk1IL64
lBlknOFLAgTej/I5wQFDHTargk/vmiZdNGvdBMd6QiRZV1aTXAVP5rB6t2pBusbIb4Femk5ZtHD7
feO/I/4jNxJCj1xZrl7XdYBi+jtdo2hD/ck7vlX3iv3c
--000000000000556b89064c2d0651--
