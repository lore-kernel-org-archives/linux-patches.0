Received: from mail-oa1-f99.google.com (mail-oa1-f99.google.com [209.85.160.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C042374164
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 12:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770640150; cv=pass; b=sgEQzyZDlTrVGVLR59/YKr8KvIW4eg92keWnxojfNia8HiXI7rQyCQGLzT0KHQ2TDgFNxosGD6btGhI0NbKEgmdIlKDBPAVEciGQB33kYX1uhH38wRTFPu3uMKCAol2bJUA3B52nG1dnAt+AAQXQcane0MDs1HgdYQNkRcBf8vQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770640150; c=relaxed/simple;
	bh=oUXPDL480qaBGK5yx2/6VAgc84OLPMOTp3mcsPrl6jk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X8/TW2N/rFWfpjBp6lZn4NEmO41npuB2M1hF0cIhmY+ek/MXLMB+YOVpLSILd6SWTiEFaaQR5We8xMr7Fle2hZ2FooVokDV0C/INr9T8uZ1I6e9Z1rrgpOG7qguV8VcRcfrh3y1ETMCWYDtHzKhfXLTl0HwqOaM9xd/AHVwmt4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=fFhQjdGQ; arc=pass smtp.client-ip=209.85.160.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fFhQjdGQ"
Received: by mail-oa1-f99.google.com with SMTP id 586e51a60fabf-408199852c5so3660425fac.0
        for <patches@lists.linux.dev>; Mon, 09 Feb 2026 04:29:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770640149; x=1771244949;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UC6CRxMs78CeFi9NSF91zEZyY8wkWwbwz8YsP35agDE=;
        b=NBiRqCe9N1T9OrXOzs9vhEl3U+uI1UVNmAQUj8nuI9dXoEYGELp9ao9lK1Uv4Pps6F
         iJj8M5TbruX3hIcNXMTxtj9CaBGVhBXA9PPGm5tMiFp69hpzb1p4S2VAobHeR6iQ20So
         pryHC/wjUBSCMGY1qu8167k19uUcKtFsXf/OCdYkf5nDLkUwBBw8MnoRd5LiOMmh6jOr
         +aRPYd6S/9TOsU8mzk7pK4u9DK5axaSAUVqNKRQM2fh4kBfuSli8Uq9+MCig1KhMNsgz
         eb+O/DpjfoIcggBER/laHSm+XM00Nolu3jyX89RalVIUrYk6uN+7emhosbDW3g2/Bv79
         WqNQ==
X-Forwarded-Encrypted: i=2; AJvYcCWmGB+w06MVt5EQ9/kkUE/H+5wg/8o8HKLhhRq9dzkaVy+nV1K7CGCtzgcFlXiJXPQ916vjmn2o@lists.linux.dev
X-Gm-Message-State: AOJu0Ywfji32ESLdDONyTiP0iRKGMwYn5wk8NZlm6AdGycCNYk441wnN
	N2wItql+k17W7qUiTgSPDA65fNjXDdVSZt+fEgv17AOG0R2AYiBCzKJeq1dtlOWpXsctLqz2b3T
	luQa0AnsHhJZrkdNhnCCh+EcH5GreAeYKYCkpbgYi9353ChKXtR+oGuuyjyiBJW+eMvunRYLbvp
	o6Gdc4NQM1INLDonOfMv/k+7ngHAxjaA6i6+8fonQhY3GTBtn8Tlmbl7yNkO2GmdWXd9sg8xCu3
	Nt1L5udeRUkEqxBF8cNcU9g
X-Gm-Gg: AZuq6aIptzr2W21cqGnWtxnSfemkOxdAzqoIFNAan8wyyyI2JO/ZCcQWYp71DDylCDr
	vl55VYDzhlMgmh79I6JpVGTSimbnJy5V9gUb7l/hl4yLgP028iSYT8LhOY8eEbA4HfJ8dIGYRyB
	ZC5CiCP6PikG+YjtbpQCX8EaNE1oXGyx8UrJlQ7z1Xcgx/R6kjDN9+mY6nHQz4gUxrxXwiXer05
	HCShGCjddOusGQB0md8eGakn2s++LMA0Sn2cv6JDHt7dEo3XjiD1EpuBDx/9ZVV7IMlbE+gCnau
	OfGOay1Cl8vynuLcIIhPfSV3xJ0uBgxgFFXWV2wn42FSHQp2McbhnpGMXS5Sm8Gj15qQzPUVlD1
	Azd3RPeI7zX/Aivqh/e31tdtQHKDtvD/s3FjN1P7bCbnEGiAsoaT4sv/snMZzA5FAxFzxDTWQyP
	aC0GgK32iYkjcYaPemNJUNM7RD9cSQr+KeIOOlS270Cl/FfFbNZJse62nefzY=
X-Received: by 2002:a05:6870:9e92:b0:409:4c35:a3ca with SMTP id 586e51a60fabf-40a96c96a6amr5737169fac.15.1770640149192;
        Mon, 09 Feb 2026 04:29:09 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-40a9964b271sm1575608fac.11.2026.02.09.04.29.08
        for <patches@lists.linux.dev>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Feb 2026 04:29:09 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43623192c6aso4025046f8f.3
        for <patches@lists.linux.dev>; Mon, 09 Feb 2026 04:29:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770640146; cv=none;
        d=google.com; s=arc-20240605;
        b=Bu+A5c9QQa6DgODQ53NUBjRdW3UuUNA3cq1xFQwYsXsajeNo9h8/SGwy5dtEJ38aYc
         pUGaVp/RXIIu8gyA13SZSkW/clYWmuVNczRXcg8Y2hrVtoISfqrdrlj3iD4IzxfVrUg8
         TY95XH7rxMt+Jc+wEN/I3yG9JKJE4IHK1sD5XoDOwJTTS8jbLtCVN+NodT4hC1E2ZTSd
         Ruhr2VJme7ZI7eOMAbirD+iVNmc4DxfK3kgfynHe53w7ue5S5ZClv1lS/7m4evaKtky2
         XW9wfZnIOqWJ56emelyYm0HzwWgZpocDlB8f6r+UcAnpmx5RRkvi5vV8df3Kg+DTpOJh
         yvAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UC6CRxMs78CeFi9NSF91zEZyY8wkWwbwz8YsP35agDE=;
        fh=Ic+8MsKIRT75Mf01nnMn6Z32lFBBi3M4amtKxqPAowY=;
        b=DKJfBjC+hdhmzlDVF4npDR7Xga9XXJNVsEugqTbvBaD00utLvCh/pYhtY6cjGzH/vR
         OIQaXYNgHjH+hm/nFTOdAyTEjQJvPhgEbQtioKSNME0iHTnl2qroOAku54bRmF4Ddqva
         yi4UNmJmiFAc1GPhy4Q2vCOF3cLKgImkfFhAvITXamfiO23hvBsjqaQx1lkA8wb7engD
         /FaZsM7GxTivsTvH44luXRxc820LjQUJkQtSvBQyvmHWN6iC1nBBsBKLhfgXROhZLocn
         uQbqxC1TFtTNFIgQ+wfLEU+iErob2aE0P9F9w61ob9rMN22TcCWX4gJFArm2wTyMySgf
         p5wA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1770640146; x=1771244946; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UC6CRxMs78CeFi9NSF91zEZyY8wkWwbwz8YsP35agDE=;
        b=fFhQjdGQn3mam7HcHwdFyiCuCtIdb6h1TBfwWpbWLOxXAQhseeScowZC2TWkbOhcfF
         /hFozCJKTyP4N9drAOgWd1LA5IuGroqc6iJp4c4e3rVO9LaklmKJgKeTaiT04Dn3Bii4
         OGSjpoPvk7zmb7R93xHNVBFJ17EqI8IMmbaok=
X-Forwarded-Encrypted: i=1; AJvYcCX3I3Dk6qxoM2py6E1LwsapFiR3K+XHi5G3Q7CBKBLFfZFEEgz/LYPA8Ki4Pz1QJSs+7WVhpshz@lists.linux.dev
X-Received: by 2002:adf:ea06:0:b0:436:307c:b762 with SMTP id ffacd0b85a97d-436307cb87bmr9982598f8f.60.1770640146354;
        Mon, 09 Feb 2026 04:29:06 -0800 (PST)
X-Received: by 2002:adf:ea06:0:b0:436:307c:b762 with SMTP id
 ffacd0b85a97d-436307cb87bmr9982567f8f.60.1770640145887; Mon, 09 Feb 2026
 04:29:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-89ea7d615ba4+636-bnxt_re_uapi_jgg@nvidia.com>
 <CAHHeUGWw221yuH7Ac8hbsVc+dMBC2GDnPZMmAjKMdu36wkY0Zg@mail.gmail.com> <20260206191101.GC1874040@nvidia.com>
In-Reply-To: <20260206191101.GC1874040@nvidia.com>
From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Date: Mon, 9 Feb 2026 17:58:52 +0530
X-Gm-Features: AZwV_QitFwbVOMJzRSszOUsK5R5LuX4jeRBhvyldBdfLIStIOAcxrlH9CMbeG_0
Message-ID: <CAHHeUGXQVYkapqi1Dgtjw-sA5Kk3d-VdngMTjdfy1xYGfOk31A@mail.gmail.com>
Subject: Re: [PATCH 00/10] Provide udata helpers and use them in bnxt_re
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, Leon Romanovsky <leon@kernel.org>, 
	linux-rdma@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>, 
	patches@lists.linux.dev, 
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000f99ff0064a6348d1"

--000000000000f99ff0064a6348d1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 7, 2026 at 12:41=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Fri, Feb 06, 2026 at 05:50:07PM +0530, Sriharsha Basavapatna wrote:
> > Thanks for this patch series. Patches 6, 7, 8 and 10 failed to apply
> > cleanly, due to conflicts with the recently merged QP rate limit
> > patchset in bnxt_re.  So please rebase it.
> > I applied this series, + QP-dmabuf devop patch, + bnxt_re DV series
> > and tested it.  It worked fine.
>
> Okay, I updated the github branches and we can do this first thing
> next merge window. If you send out just the DBR and revised more
> trivial CQ changes for the other series they can likely be picked up
> immediately on rc1 too. Then you can work on figuring out QP.
>
> Jason
I'm working on the DBR and CQ changes, I should send it out for review
in the next couple of days.
Thanks,
-Harsha

--000000000000f99ff0064a6348d1
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
CWCGSAFlAwQCAQUAoIHHMC8GCSqGSIb3DQEJBDEiBCDNpdlO5XjrmmKOXQFN4jc2gY1Plo20HB3W
dgY7LNznIjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yNjAyMDkx
MjI5MDZaMFwGCSqGSIb3DQEJDzFPME0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjALBglghkgB
ZQMEAQIwCgYIKoZIhvcNAwcwCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEF
AASCAQBcqa8dAIiqqzFAXE6Uluh84qpjqPqjS+UEtM68N3+5G3NQWa2K3GHUZsW2UXGSE9hDHapH
wTddi2Q2gH8F1wLXUClyHjshZp/KuxwiFjPco1vuGsP0kBqNxa0kr5TF3Ok1uqFPRBbx7oO2WFGm
lUUT789PXtDG1Em5MYuQopBPKpx/hYkEefTrV1hVEwsZAh1Qn9UCBmEcsWOxvCBjXyRigchPOCSN
OIJZ/lPHHymX3hWZQLenA9gHYgbYVN5boFAQd+3L0mOO8z+xsmmnSghZabYlKPQy4cdWGA28UWZ7
O6y9iKtPIjgZA9k+ZsFA6ULozKtcMtnb+yIPOcouiPwm
--000000000000f99ff0064a6348d1--
