Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E191D28C02C
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 19:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752606018; cv=none; b=pYISS5MfnauyU0U+nV6BqxKPtgTP1bLLe5/epcwFMrmxLhsmshDGxpoBt58FPgLjZ5OeuMLoxbW9ff1/xnY6otzdpG/0bA+9UByxI9rX++B01G5Xq/1WLrEVqpspQk68BoYLKX+TH0hGPzX9tT0aqWfisk36Pfo1WAID2CHiozc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752606018; c=relaxed/simple;
	bh=pWXwXM6tAdo40Zqoke4D1RqRiDl4ZRREhPbpU8XtXRw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=dwpmX9IRFmiNSnwqm7xCjD0u7BM62aQk7/yGBTscJzxIyOz6Uy4z4r1mbB2NJ3KptZ4DjxgofWyltmVtF9Ra0PV7smH9uQTNbfZrTTXY1Gu5uBqU4lXBj8mK68s6nNzfbkOQ6jxdU3I1Ci1DXf3sbS6vidvgetrGRiC7AFTERgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DNa1mSE7; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DNa1mSE7"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2350b1b9129so40203285ad.0
        for <patches@lists.linux.dev>; Tue, 15 Jul 2025 12:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752606010; x=1753210810; darn=lists.linux.dev;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B614pib7pAycthxoO8JsT0qk8Pb5A/7JMNSYzzDIx9g=;
        b=DNa1mSE7rSwvaGRJsocum1eizwf8npac9nvoQJn5F/Vcz+HX+xVwXIxl9/CxaehFeJ
         qmX/EgGeCJ+YRDkexTacdPuIZokq4kTtWeAc19p+eSguiPw0IfUy24zw8smGs8+T3ouj
         7mNXDJdZE7ffQz+giyUmONF07ipJVXbVfinHTHufhNrFt38GbhrpGKsiUNBs/7XPnt29
         rt8mkvODefUdK/ixNt6X/FPzQJqISv+tRdDqxGfAC6zJpXweWiDyzr605UjktjbPWyv3
         UwTS6AfrYp59wIARJV6pwYadZGZnnrPNibLOUUAWdd6FRQT8TtZPxyq7rY8WiMdbZZHZ
         4ZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752606010; x=1753210810;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B614pib7pAycthxoO8JsT0qk8Pb5A/7JMNSYzzDIx9g=;
        b=eEFV4uLAoLWxQFLaxsbSVi8CXJQzeGx6dTcfRpMOcxT7ZTtdrli78HYLV46MyEU2Kq
         TBZY5D+tK+kDtFTg9jcVrU6cFhimfcXpk7m3uzL+JCcssCeagSGgm5mkjtVc/CAKd3lh
         3guStoJwdyZZ8nWGF9PbyUMjbWakY5xnnM2GdLj0LDjQqrOv+H5ujlHJir5Yb3GRqQhO
         gIxFr4LwEzct8RphGyDbpc5toQzhKClT3iQaafqH8n6eCzHgsr3mkEBK1SPLW/LQP2MB
         kjvXPRoO+3xqRTk9hSOJzV4N2b7BBLeV9zOhO+qZjGCP+IgoIPSGRSPJ059R+JiPIgpC
         o9WQ==
X-Gm-Message-State: AOJu0YxAjVRr878oBNcxUsuOlIt43CfDdOOAUBe0h07/DoqG0/09OkIl
	aucW6xWwiArjENyE8ZuNTvY0aVqcRGhnBKx9r4hRbiW97G6eJW7JNAluBqWhbZ3l
X-Gm-Gg: ASbGncvAMziKpKHUKeaXx2uhdAAWWl8YP7YpMbL9lNOmT3GyY/rOR2uzvlAkk1l9ZrW
	PfiSDGvwxvjnaSTn91WWgCOY6MNpIBm4YHsiO62HxSW1n65iXwnscgyD3MGZRYSEJYGnTmXQuiW
	+ziD5YHRdGJgQW26MQUehnrz2vtitM7yfOYoDjXeBMcndBMQ151frBc+2x2e5EXmuZ8JhzenXFk
	nnUc3kaFeHxvnBPKrKHyyeamtG3Nf+C2304u6wvh9JopGf1hSWQxigi72Ei/fdHJ3PX4zhZlS4q
	l2CaItkqyx/cZLL+0hEete2Yh7O4GWTEnXiIoRijqiP+c6lBYzn+b4qmnqm+YGGQmQUl65Hyp/N
	ob7EatEdOp3EaF2c=
X-Google-Smtp-Source: AGHT+IGXg63En8UwNbHvC3EVCnl48K0RJt2iU0X+MJUPoLgvwhmELNpjE06v08xMkZ1otSaUADAgkg==
X-Received: by 2002:a17:902:f64b:b0:235:7c6:ebd2 with SMTP id d9443c01a7336-23e24f4a447mr1572015ad.31.1752606009764;
        Tue, 15 Jul 2025 12:00:09 -0700 (PDT)
Received: from localhost ([181.88.247.122])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de4332e8bsm111828635ad.159.2025.07.15.12.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 12:00:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=88259b1cec92413ceb591c4ba6bff3312655c8c3fb7b4f234cc6a689c960;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 15 Jul 2025 16:00:06 -0300
Message-Id: <DBCUZ88MSEOA.1Z8AFHVC0U0T4@gmail.com>
Subject: Re: [PATCH 5.15 53/77] platform/x86: think-lmi: Fix sysfs group
 cleanup
From: "Kurt Borja" <kuurtb@gmail.com>
To: "Kurt Borja" <kuurtb@gmail.com>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
Cc: <patches@lists.linux.dev>, "Mark Pearson" <mpearson-lenovo@squebb.ca>,
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, "Sasha
 Levin" <sashal@kernel.org>
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250715130751.668489382@linuxfoundation.org>
 <20250715130753.855799519@linuxfoundation.org>
 <DBCUJ1QHGTKA.3H4TW1FB3FYJC@gmail.com>
In-Reply-To: <DBCUJ1QHGTKA.3H4TW1FB3FYJC@gmail.com>

--88259b1cec92413ceb591c4ba6bff3312655c8c3fb7b4f234cc6a689c960
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Tue Jul 15, 2025 at 3:38 PM -03, Kurt Borja wrote:
> Hi Greg,
>
> On Tue Jul 15, 2025 at 10:13 AM -03, Greg Kroah-Hartman wrote:
>> 5.15-stable review patch.  If anyone has any objections, please let me k=
now.
>>
>> ------------------
>>
>> From: Kurt Borja <kuurtb@gmail.com>
>>
>> [ Upstream commit 4f30f946f27b7f044cf8f3f1f353dee1dcd3517a ]
>>
>> Many error paths in tlmi_sysfs_init() lead to sysfs groups being removed
>> when they were not even created.
>>
>> Fix this by letting the kobject core manage these groups through their
>> kobj_type's defult_groups.
>>
>> Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support=
 on Lenovo platforms")
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
>> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>> Signed-off-by: Kurt Borja <kuurtb@gmail.com>
>> Link: https://lore.kernel.org/r/20250630-lmi-fix-v3-3-ce4f81c9c481@gmail=
.com
>> Signed-off-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/platform/x86/think-lmi.c | 35 +++++++++-----------------------
>>  1 file changed, 10 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/thi=
nk-lmi.c
>> index 36ff64a7b6847..cc46aa5f1da2c 100644
>> --- a/drivers/platform/x86/think-lmi.c
>> +++ b/drivers/platform/x86/think-lmi.c
>> @@ -491,6 +491,7 @@ static struct attribute *auth_attrs[] =3D {
>>  static const struct attribute_group auth_attr_group =3D {
>>  	.attrs =3D auth_attrs,
>>  };
>> +__ATTRIBUTE_GROUPS(auth_attr);
>> =20
>>  /* ---- Attributes sysfs ----------------------------------------------=
----------- */
>>  static ssize_t display_name_show(struct kobject *kobj, struct kobj_attr=
ibute *attr,
>> @@ -643,6 +644,7 @@ static const struct attribute_group tlmi_attr_group =
=3D {
>>  	.is_visible =3D attr_is_visible,
>>  	.attrs =3D tlmi_attrs,
>>  };
>> +__ATTRIBUTE_GROUPS(tlmi_attr);
>> =20
>>  static ssize_t tlmi_attr_show(struct kobject *kobj, struct attribute *a=
ttr,
>>  				    char *buf)
>> @@ -688,12 +690,14 @@ static void tlmi_pwd_setting_release(struct kobjec=
t *kobj)
>> =20
>>  static struct kobj_type tlmi_attr_setting_ktype =3D {
>>  	.release        =3D &tlmi_attr_setting_release,
>> -	.sysfs_ops	=3D &tlmi_kobj_sysfs_ops,
>> +	.sysfs_ops	=3D &kobj_sysfs_ops,
>> +	.default_groups =3D tlmi_attr_groups,
>
> I did *not* author this change and it utterly *breaks* the driver.
>
> This patch should be dropped ASAP.

I double checked and apparently it does not exactly break the driver.

But still. I did not author this patch. It's similar from the one I
authored but still has other issues. It breaks cleanup instead of fixing
it.

Was this an AI conflict resolution?

I really don't appreciate the lack of transparency, specially when it
claims to be authored by me (!).

Please, drop.

--=20
 ~ Kurt


--88259b1cec92413ceb591c4ba6bff3312655c8c3fb7b4f234cc6a689c960
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSHYKL24lpu7U7AVd8WYEM49J/UZgUCaHalOAAKCRAWYEM49J/U
Zt03AP9RPeO+DDoeBYDtV2lxY0uoJz8T4pTzTZGmlqMJ9gk8PwD/WDQ6gKObLgX1
CSsQxgX5YggbhZzZpOrO0yotg+uYCwQ=
=oycW
-----END PGP SIGNATURE-----

--88259b1cec92413ceb591c4ba6bff3312655c8c3fb7b4f234cc6a689c960--
