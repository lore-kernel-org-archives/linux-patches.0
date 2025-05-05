Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7F61A841B
	for <patches@lists.linux.dev>; Mon,  5 May 2025 17:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746465433; cv=none; b=jU5JGZ5L7LAS7m2W/qluN9rTdO/AS7rKds8JthltXyegNR2Ma6xJdPj/JzlQRXextPylUXMI2dVmAr9LgMHSfWHc5sWJGMGOzPi0rBvREVqd/Tpa4H/Fke16pS79jtvb6p6me3BYoepCKPfZMAwVLeyjZKKXPs+4YPye5G4zKGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746465433; c=relaxed/simple;
	bh=XwhrX5688XfHG0muf4l+yvgcLX5Pt+ya7oVl24w7wsA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KNwOjeHYaYtwIUYzsNjuF6WZLOrkoH20C5/dqkgo87gnATkNpxfVpmD7uGUcLej8DuklpqMY3a2HyloA2nSnznkjWNPBl86ALRsGymAcpaGdBVfMXl7PLdqw+ous2sjQ6hqGJEig/t4xRWel4j7t4xMIRVx6k57RNPxpCNZLXb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PpyqFqm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PpyqFqm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32C0C4CEEE
	for <patches@lists.linux.dev>; Mon,  5 May 2025 17:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746465432;
	bh=XwhrX5688XfHG0muf4l+yvgcLX5Pt+ya7oVl24w7wsA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PpyqFqm0Kq+6GO0UyFOmcYlso29dLcLhwa9vGeVLSTNf6YPsdnoJGwozYB/FDD4jr
	 6+ufva/uUuirffr8BTZze+YTTRefqS+16//hJunoWE2t2LMmqN6PddEd91YWulWyvv
	 GtLD0oVEkqUJBcSe2VFlnkDQMtDPRFHwckbHsbmo/VtBVYeFVK5VMdyz7Wda+e+c9N
	 2NmSxr4GzoMr2rYI54zUsptLvcE2Cra/Jq/M0MDawyqL4cAYkgbGpDmrCvT6l1Mibg
	 RC4UOyTS3H6OdokxtNeJUrwW3NP+O55obgRIbwUDmulmZUL5UzUkJwxFyqCTUIqfEd
	 uDydqgVYJOjgA==
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-2da3c5729fcso2557601fac.0
        for <patches@lists.linux.dev>; Mon, 05 May 2025 10:17:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWb4yTjb7Uw96Gi/pLW2LyKl3EEOD/ETVUUHfAJK3z67QYdVsjR+RAg5gxwVwkId+K9lSo/whMn@lists.linux.dev
X-Gm-Message-State: AOJu0YzTwppSS9UKd+YBwdRGu/HA+CZIT2vg6HKnl+eoO/AvFx8W2bSJ
	YDTObSytS3Hz5jXXXfBWTn7+8CG4GYOsZ5y0m6meWu8kG/MZSPgu8RNkI+hbp67g8JPOmeTqkaK
	by+Q0hkehdPHmmyx+VyrDSqAlcgY=
X-Google-Smtp-Source: AGHT+IG26hieWdXffhDj4dGbE8M0F2bOh1fmNZd9NNoGu7oIJPkd8RdYORqFuleYnObxvkfUU+ir8/ZXZ36gkFCOMCo=
X-Received: by 2002:a05:6870:a1a7:b0:2b7:d3d2:ba53 with SMTP id
 586e51a60fabf-2dab2fe1dfamr7344930fac.12.1746465432182; Mon, 05 May 2025
 10:17:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250429202412.380637-1-tony.luck@intel.com> <20250429202412.380637-2-tony.luck@intel.com>
 <CAJZ5v0ju_Xirnft+5C=-GtG3hmT9xGjVqNFPRugXR7o1RzfHrg@mail.gmail.com> <SJ1PR11MB60833EFB63D1356DF14336F7FC8E2@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB60833EFB63D1356DF14336F7FC8E2@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 5 May 2025 19:17:01 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0hU4drHhqWcj0Q_U_P7bkjDs-jUMN-KCSQNW9Avkqk=ig@mail.gmail.com>
X-Gm-Features: ATxdqUGskPJuK-G9lNlMrid3uP4z4sDmx663ya8BRYM30u6OaROhtVDw5gFZdHI
Message-ID: <CAJZ5v0hU4drHhqWcj0Q_U_P7bkjDs-jUMN-KCSQNW9Avkqk=ig@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] ACPICA: Define MRRM ACPI table
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, "lenb@kernel.org" <lenb@kernel.org>, 
	"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>, 
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 5, 2025 at 7:12=E2=80=AFPM Luck, Tony <tony.luck@intel.com> wro=
te:
>
> > > +/* Values for region_id_flags above */
> > > +#define ACPI_MRRM_VALID_REGION_ID_FLAGS_LOCAL   (1<<0)
> > > +#define ACPI_MRRM_VALID_REGION_ID_FLAGS_REMOTE  (1<<1)
> > > +
> > >  /*******************************************************************=
************
> > >   *
> > >   * MSDM - Microsoft Data Management table
> > > --
> >
> > All of the above definitions should be there in linux-next now.
> >
> > Can you please check if they are there and they are correct?
> > Alternatively, please check
> >
> > https://web.git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git=
/log/?h=3Dtesting
>
> Rafael,
>
> I checked the "testing" branch. The MRRM bits there look good.
>
> Do you want me to post a V5 of this series that drops patch1?
>
> Fenghua had some comments ... the one about a spurious blank
> line in mrrm_init() is real. I'm less sure about documenting the
> meaning of "X" in the ABI documentation patch.

If you want to update any of the 3 last patches, please send an
update.  Otherwise, let me know and I can pick them up from the
current series.

Thanks!
