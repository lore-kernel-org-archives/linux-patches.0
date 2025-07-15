Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC902459F6
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 21:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752614301; cv=none; b=gbRlUvgiippxWj+z/0L+pFm3wao68qdkdwInxXDVbv0psCsrpGtOt8FWvVZAY8V/0XXhvDVPCLKP7eg4grnllTfD4cZ8vmDWL4eNLdCsmdC7OjZ/Kg2UiPzfTcld1mBcI6ylWlE/sA36VGKTAOIfqnWF8cylSRja+gEaYQHfP5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752614301; c=relaxed/simple;
	bh=+wfMaREF7FhsiaqBNGJC1bDiIJjh9++PJ8jKvpYsdZc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=FxSbqObUsAz4FZ419gR/DSEfeL+ft38AzoSuhAQKQBD7pmBzXnSOlDgKdrpHHoV/K/eEHL7Ed8JfHitCdQ+bTt0pgoNh1MA1s7XMjsBPasiJ/d+HStLHsG5i+rVVRf+iAwOMxLqtSctTdYXddrIzBmPxPr5foLYqd+khFEyy3CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZDu3uDwS; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZDu3uDwS"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7490acf57b9so4269826b3a.2
        for <patches@lists.linux.dev>; Tue, 15 Jul 2025 14:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752614299; x=1753219099; darn=lists.linux.dev;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ui4gOup47qcbVqCu/K/76dTKzJH4uTwnfNwpUaKJ/oA=;
        b=ZDu3uDwSvsI0QtkFp7Z+J3PYlH3plfE4Mvl2apMak1OlZ0R/bd1FUF25SAbWPHlFVP
         bnpoQEzYuPO+ToAM98WlKrUhis9JWHtkfM2/vIH1vTs3br3Jwphi9ICDJlPlrJi+fJ4h
         Tvax2lQkUqUT/nyyCY2iCa82pQF6piQECGsdCK+Ze8ruTmOKMD2/fcA24wXIaiJH/01L
         r+CXO2rMSk64MYhD5SSyvrB+64B+Kr/+YeKD/YbUff3STCSTepHvYOxBf66+zM04qoqE
         9JVxT88bDiJCJh/meZBhnMA/5K6Oula5EZkwXR6Ry18CGmseoJDGCSneR76x7zBwn5cx
         JIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752614299; x=1753219099;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ui4gOup47qcbVqCu/K/76dTKzJH4uTwnfNwpUaKJ/oA=;
        b=rSsxv/zOjIPRTmPPKiUduuSSD1GKK7I79Y6fqHrW2HAACvcip0UtCmbG4I3Ipd3T7M
         PmB+7/vIdu9BMTvMAiVMy9Xd1vOHPY9GxISTRB6lHp9o+9nQO1EiCW2iDOXclozHhSMl
         S6ShSgkm1k9n9TX/jjiRidVl1Q0Bo7DhymFdOFwDY6fw+Dj9dbuJLM10DdtGOIrieTcQ
         alE/8/hiZGHDNhIRoZUBSG9/NbwyiPwVV6JoAV5bzHMlqEZYUf3XxdKl/m4TVaBf5TS/
         PUIR+rtnS1aYDfgtR0lfbwlGOeSVMEl/DJJPvSU4ymnQDbBJI4ZRH4S0hx9sH837YuLb
         HwhA==
X-Forwarded-Encrypted: i=1; AJvYcCXKZFR8a+HTMZLRpN3R676FxwevKVqtPaT9YZlnnROpl2qFOztGhKdepUieJpexnMxtEVQyMUPb@lists.linux.dev
X-Gm-Message-State: AOJu0YwRMWm3bSfvr/txB7XCBHtYPKADovvt1YoHutVeu2rIdB9bhRyw
	e3dOTWyHXXR+2EQp4YnS/nvSDyo0tfDJq0wFaDXlavaIcElA4IBYdksj
X-Gm-Gg: ASbGncvFOO4P+EtnWWD0Grm7+pwuhKGk5iPC/OY2LrD4D757gqIjwdmYRJq3doRfPZH
	PJsCrVo2yMsfuq7gDG2Pt7DLN5BTHBF5bhWb3UOk60JxwQCLfmQgp06lqA5CJ1dv93mLkq9OQLn
	gSq6pZpsQ+9eg5mLrnZRhrwueRSkSyAS2f6wznGDLavHh/RPQ91RmFTEU7IIzz0f4WAokZn+ka9
	1ETeRfmmFsIweFkN8k/gccGcSNaWqZTAxc03taznW8bDvhSjUov7iH2V1/zFol7L6oQ/BWMdzXy
	PHer9yV83vFALRDk7MRKgzmK9+OkVcCVVSpuYioXvE6NGdmb0VmjNLYoS9sWN1MCIkSABXjo5vn
	P+YQpeScn7bLka74=
X-Google-Smtp-Source: AGHT+IHTrD4fzU9LDAiZ/nxBo7H+krIKyPmqbjEB+tTREWlp1t3tcahLf2H5TsGLYiJf6PY9PAUlJg==
X-Received: by 2002:a05:6a00:2194:b0:742:a111:ee6f with SMTP id d2e1a72fcca58-7572286b05emr127975b3a.10.1752614298767;
        Tue, 15 Jul 2025 14:18:18 -0700 (PDT)
Received: from localhost ([181.88.247.122])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74eb9e06bd7sm12831041b3a.70.2025.07.15.14.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 14:18:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=24d5de3020ad5859fecc6f26eaebf23f0527735eac16fb925147f5e516a6;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 15 Jul 2025 18:18:01 -0300
Message-Id: <DBCXWTOF1I2U.1RCR72IOBJO7C@gmail.com>
Subject: Re: [PATCH 5.15 53/77] platform/x86: think-lmi: Fix sysfs group
 cleanup
From: "Kurt Borja" <kuurtb@gmail.com>
To: "Sasha Levin" <sashal@kernel.org>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>, <patches@lists.linux.dev>, "Mark Pearson"
 <mpearson-lenovo@squebb.ca>, =?utf-8?q?Ilpo_J=C3=A4rvinen?=
 <ilpo.jarvinen@linux.intel.com>
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250715130751.668489382@linuxfoundation.org>
 <20250715130753.855799519@linuxfoundation.org>
 <DBCUJ1QHGTKA.3H4TW1FB3FYJC@gmail.com> <aHamVeuNznVqMb2x@lappy>
 <DBCVGAAFB8Q3.21ZP9FUITWDI9@gmail.com> <aHaoNDFKsoogzNge@lappy>
In-Reply-To: <aHaoNDFKsoogzNge@lappy>

--24d5de3020ad5859fecc6f26eaebf23f0527735eac16fb925147f5e516a6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Tue Jul 15, 2025 at 4:12 PM -03, Sasha Levin wrote:
> On Tue, Jul 15, 2025 at 04:22:22PM -0300, Kurt Borja wrote:
>>Hi Sasha,
>>
>>On Tue Jul 15, 2025 at 4:04 PM -03, Sasha Levin wrote:
>>> On Tue, Jul 15, 2025 at 03:38:58PM -0300, Kurt Borja wrote:
>>>>Hi Greg,
>>>>
>>>>On Tue Jul 15, 2025 at 10:13 AM -03, Greg Kroah-Hartman wrote:
>>>>> 5.15-stable review patch.  If anyone has any objections, please let m=
e know.
>>>>>
>>>>> ------------------
>>>>>
>>>>> From: Kurt Borja <kuurtb@gmail.com>
>>>>>
>>>>> [ Upstream commit 4f30f946f27b7f044cf8f3f1f353dee1dcd3517a ]
>>>>>
>>>>> Many error paths in tlmi_sysfs_init() lead to sysfs groups being remo=
ved
>>>>> when they were not even created.
>>>>>
>>>>> Fix this by letting the kobject core manage these groups through thei=
r
>>>>> kobj_type's defult_groups.
>>>>>
>>>>> Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface supp=
ort on Lenovo platforms")
>>>>> Cc: stable@vger.kernel.org
>>>>> Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
>>>>> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>>>>> Signed-off-by: Kurt Borja <kuurtb@gmail.com>
>>>>> Link: https://lore.kernel.org/r/20250630-lmi-fix-v3-3-ce4f81c9c481@gm=
ail.com
>>>>> Signed-off-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
>>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>>> ---
>>>>>  drivers/platform/x86/think-lmi.c | 35 +++++++++---------------------=
--
>>>>>  1 file changed, 10 insertions(+), 25 deletions(-)
>>>>>
>>>>> diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/=
think-lmi.c
>>>>> index 36ff64a7b6847..cc46aa5f1da2c 100644
>>>>> --- a/drivers/platform/x86/think-lmi.c
>>>>> +++ b/drivers/platform/x86/think-lmi.c
>>>>> @@ -491,6 +491,7 @@ static struct attribute *auth_attrs[] =3D {
>>>>>  static const struct attribute_group auth_attr_group =3D {
>>>>>  	.attrs =3D auth_attrs,
>>>>>  };
>>>>> +__ATTRIBUTE_GROUPS(auth_attr);
>>>>>
>>>>>  /* ---- Attributes sysfs -------------------------------------------=
-------------- */
>>>>>  static ssize_t display_name_show(struct kobject *kobj, struct kobj_a=
ttribute *attr,
>>>>> @@ -643,6 +644,7 @@ static const struct attribute_group tlmi_attr_gro=
up =3D {
>>>>>  	.is_visible =3D attr_is_visible,
>>>>>  	.attrs =3D tlmi_attrs,
>>>>>  };
>>>>> +__ATTRIBUTE_GROUPS(tlmi_attr);
>>>>>
>>>>>  static ssize_t tlmi_attr_show(struct kobject *kobj, struct attribute=
 *attr,
>>>>>  				    char *buf)
>>>>> @@ -688,12 +690,14 @@ static void tlmi_pwd_setting_release(struct kob=
ject *kobj)
>>>>>
>>>>>  static struct kobj_type tlmi_attr_setting_ktype =3D {
>>>>>  	.release        =3D &tlmi_attr_setting_release,
>>>>> -	.sysfs_ops	=3D &tlmi_kobj_sysfs_ops,
>>>>> +	.sysfs_ops	=3D &kobj_sysfs_ops,
>>>>> +	.default_groups =3D tlmi_attr_groups,
>>>>
>>>>I did *not* author this change and it utterly *breaks* the driver.
>>>>
>>>>This patch should be dropped ASAP.
>>>
>>> Right sorry about that - I accidently left that extra line of context
>>> you've pointed out. Dropped now along with the other patch you've
>>> pointed out.
>>
>>Thank you for the quick response!
>>
>>May I suggest informing authors and maintainers about manual conflict
>>resolution in the email's subject?
>>
>>This resolution was not acked by anyone and I don't appreciate that.
>
> In general we'd note a manual resolution and wait for an ack if any
> significant changes were made to a commit.
>
> In this case I messed up the context when resolving the conflict, and
> didn't consider it meaningful.
>
> However, yes, just noting that along with my signoff wouldn't have hurt.
> I'll start doing that more often.

This would help a lot!

>
>>In the past couple of weeks and I got like 50 stable related emails. I
>>simply cannot check each and every one for things like this.
>
> Is there something we can do on our end to make it more managable?

As I said, if some manual resolution was done, it would be helpful to
note that in the subject so it stands out. But as you mentioned above,
if this is already the case then it's ok.

Thanks!


--=20
 ~ Kurt


--24d5de3020ad5859fecc6f26eaebf23f0527735eac16fb925147f5e516a6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSHYKL24lpu7U7AVd8WYEM49J/UZgUCaHbFiwAKCRAWYEM49J/U
ZgsNAQCUsoIep7lguCXH5VFhqOP8uxcFHIxWhmndquQikTXJSwEAkGTCd2ygMZOY
BYg1e6mAmT9Oyb2Mk8l6/sSNL+LHGgI=
=tuUO
-----END PGP SIGNATURE-----

--24d5de3020ad5859fecc6f26eaebf23f0527735eac16fb925147f5e516a6--
