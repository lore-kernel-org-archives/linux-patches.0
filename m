Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82641DA20
	for <patches@lists.linux.dev>; Fri,  8 Mar 2024 22:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709937564; cv=none; b=VaHf3JnQfLeqp5va/NTpZIiBVsy3pO8QmhHBQuMJ8/YOQQsjJcTqyeqAjiL4HamXH6nLY0l7ezBsfzexKrBKNYSqlauNHhlhxFweMf2PHIaVCpFbQJkauQFbBONRu6pN2WoyfQy1OSGA9Pul37GQPaX38uMQy9H5q52Up7zkZM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709937564; c=relaxed/simple;
	bh=ONjv0VtUftGGTVaaqppbSyYYxndj4Wvui5PdudKSKsU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:To:Cc:
	 Content-Type:Subject; b=utAFAhxb4lMHpdt4G9vufK+gfaa08iAFfEPcZARlceUvoxGjPQp8NjCNOfz7yvWMADsIehlqhH9FOlLFI+lugm8cSvmlwK1z4qWpJDTJOpqXK+TYHh/jm+Ye0CjPJN+CeHq25VdWi/Fm6ZyBv1Qi877ByhnQ866hAt0UZvV5TVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hM+N0GIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hM+N0GIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24CAC433C7
	for <patches@lists.linux.dev>; Fri,  8 Mar 2024 22:39:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hM+N0GIb"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Fri, 8 Mar 2024 22:39:19 +0000
Resent-Message-ID: <ZeuTl62Y7aBRupVm@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 08 Mar 2024 22:36:00 +0000
Received: from sin.source.kernel.org ([2604:1380:40e1:4800::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=SFBo=KO=gmail.com=m.cooley.198@kernel.org>)
	id 1riioo-00CHqw-Az
	for broonie@sirena.co.uk; Fri, 08 Mar 2024 22:36:00 +0000
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sin.source.kernel.org (Postfix) with ESMTP id 23A3BCE2662
	for <broonie@sirena.co.uk>; Fri,  8 Mar 2024 22:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 6FD08C43394; Fri,  8 Mar 2024 22:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97BF5C433C7
	for <broonie@kernel.org>; Fri,  8 Mar 2024 22:35:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 97BF5C433C7
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2d29111272eso35540571fa.0
        for <broonie@kernel.org>; Fri, 08 Mar 2024 14:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709937352; x=1710542152; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+osjGBHTR09d/MwYxvJc9Om61QsxQtq+K9ltwKLvAc=;
        b=hM+N0GIbhkDoTnzAKGvFYodkIAWZsVMNhtXOXjEofjnapLSpEw/Aoa+/e6C1k4yA3h
         2oe1P38bHFaDk3++Lx9SBij68ZUI5ldLTGxhKVnjnNU25IH7G4zARRsH7NKmc7DAt6/w
         PvLssL3HUlhjV0SvTC7k+dBSNdDlinvX4SjIZRvmPH4u5bi916tz9ytRFf4ZTjZWt8N6
         Z49gimOQAORGQDJdiv9jVDGgpjLEF4Wt5qDhu4NLBsk+mbwLrvMl/fQiFr4zUIOenUpu
         oFbhKrR28R8sXZNqp7zjsG8hodqCz2ApXcOavSk1lVknVHeAkGT8i8Bw3tTiWGq8GXtE
         tAWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709937352; x=1710542152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p+osjGBHTR09d/MwYxvJc9Om61QsxQtq+K9ltwKLvAc=;
        b=MG8BNl+NS6ldh8aOhQz54E8Jbzvueq+txpkDks/8lx/MYwCB04gYK9m1PjdNV3Qf1h
         eGTbnCeHiTbl5jH6D6dwcV+VzthK9sGheOA9DGw1arV7sZ8s/ZUvFXfRiWjGnUvyWrER
         3KfYA0tcdp/sXzoE628xdYj9UAnujA+P205jGUbFvzR9iWMjIu7xw6B3wLOpJz/fA2cB
         68TbhEnzHNgB7/+X7h/Ia5CRqd1EJBdcmuC7g5dJb8vQjNmrbfWwJzRLtNqGYsQGVI82
         4t/PJOct+8maJD3nceFPafDGsta+64USksaMzAm2UbKOmJRkLNce7RTSPzDLIAbeL/6I
         QGuQ==
X-Gm-Message-State: AOJu0YxW/OnyKTTCp+ZACdmCmqFvRc6xAZewQ9Hf+sx658rf8cATNBQH
	135hKgnNvClyJZETgO4tlDnn+x3W8E8uIuW5B6DKQOTR5HPJZ06BR1S49BrMEnSQHGiI0J2zjwO
	verlxZIwNyYwas6gdg5pjWnCbUZkVnAbQ+X8=
X-Google-Smtp-Source: AGHT+IFTCILwfXto0Mg+Fmlxx6jFy/jU9acKGcQjbmCoHCIpBnJ9WoOt3a8qRrKjY6DtagOCjq2lSdp4C5WpYX9i4+c=
X-Received: by 2002:a05:651c:4c8:b0:2d3:7e8e:de23 with SMTP id
 e8-20020a05651c04c800b002d37e8ede23mr374734lji.23.1709937352038; Fri, 08 Mar
 2024 14:35:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CALijGzn7GL_tmdGZXy-tTGCgpT4bwLW2+QU1QBseMRQwjPhbtw@mail.gmail.com>
 <5eb9f2b5-62ef-442d-b93f-ea6b0d85eac3@sirena.org.uk>
In-Reply-To: <5eb9f2b5-62ef-442d-b93f-ea6b0d85eac3@sirena.org.uk>
From: M Cooley <m.cooley.198@gmail.com>
Date: Fri, 8 Mar 2024 17:35:40 -0500
Message-ID: <CALijGznExWW4fujNWwMzmn_K=wo96sGzV_2VkT7NjvEUdkg7Gw@mail.gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-sound@vger.kernel.org, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-SA-Exim-Connect-IP: 2604:1380:40e1:4800::1
X-SA-Exim-Mail-From: SRS0=SFBo=KO=gmail.com=m.cooley.198@kernel.org
Subject: [PATCH v2] ASoC: amd: yc: Fix non-functional mic on ASUS M7600RE
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: KmD2zQeLGFVr

On Fri, Mar 8, 2024 at 4:37=E2=80=AFPM Mark Brown <broonie@kernel.org> wrot=
e:
>
> It's a patch whatever the reason for it - basically your email looks
> like it got almost everything right (assuming git am likes it), you just
> need to delete the process question above from the changelog and add a
> Signed-off-by as covered in submitting-patches.rst.  As that covers
> there's legal stuff with the signoff which means I shouldn't take a
> patch without it.

The ASUS M7600RE (Vivobook Pro 16X OLED) needs a quirks-table entry for the
internal microphone to function properly.

Signed-off-by: Mitch Cooley <m.cooley.198@gmail.com>
---
diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index abb9589b8477..af90da8646ba 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -311,6 +311,13 @@ static const struct dmi_system_id yc_acp_quirk_table[]=
 =3D {
                        DMI_MATCH(DMI_PRODUCT_NAME, "M6500RC"),
                }
        },
+ {
+         .driver_data =3D &acp6x_card,
+         .matches =3D {
+                 DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+                 DMI_MATCH(DMI_PRODUCT_NAME, "M7600RE"),
+         }
+ },
        {
                .driver_data =3D &acp6x_card,
                .matches =3D {
--
