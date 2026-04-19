Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0CA3B18A
	for <patches@lists.linux.dev>; Sun, 19 Apr 2026 11:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776598180; cv=none; b=eqqnm5S+I5nqckHLLKX+DmkP+K0M8pXwWUl8fYK19uYoIxEr9YaRy2a+ZID+vSuu+PTvHTkuuNZv394Pe8XDd+nQF+wpQBApIKXnjwBLQ23RXOrglsYSzR3mqUIybNhIdIRbiGvt4U5pc9Ay5gnNgFeZ1SdKrPmX1wCvVvHK75Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776598180; c=relaxed/simple;
	bh=QvkoHQtcOl5TpwI7NbsfPvRhnb3xNkWqZGsr9oYnyng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HVyypkwJM+/wcftP3eIL2RVoCe5cm9DKvtHiIDYFgmB2V2rvNrSfkKWYIgoECEEMRvfp0zSanZOxI8AHH02+UcyZXfjCNZn5HdJndc24dbwwIlqAQJ1qzIPzh5C5lh20X1WawdezAJh7d5hk860ZsXhvglIzUS58fCRkZWWj2LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZPagMwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZPagMwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB017C2BCB7
	for <patches@lists.linux.dev>; Sun, 19 Apr 2026 11:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776598179;
	bh=QvkoHQtcOl5TpwI7NbsfPvRhnb3xNkWqZGsr9oYnyng=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JZPagMwgiQ/4rahy9dgvu7yrpWs10SA7mLT1TpknzDQUOaR83aF7R5qk9W9CkRXHn
	 /wEX65dDwIe1gT1+V00b2dR+WuAlRJJFFD9RA70m9ZUCt6rty2aoATfou1wR9pkd4K
	 c7bV4hQINNj3e7eDNKW7idUIQAGvUpDIpwQu97T5DW8HH+//6A3jldyh6Y2OzJWH9Z
	 0b/6uIvLXXNxKZr6ptduMdBYFXNirhm7Zg8fTVZHtcHGxaipfHBvbo8dRkA0xajlwX
	 Ge5uYAP+3IXH9mRkl4YGQDGgOUJ943urG1Oe1iKCi3qEkEBq1uaE7af40LybuIdekY
	 54uvX38AV/Kug==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5a2c500750dso2328653e87.1
        for <patches@lists.linux.dev>; Sun, 19 Apr 2026 04:29:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/lltePJ7hA+k356rXUGw2nzPBE6/UBPUzv0El0+bipo/isyvKt9aIGGBWUrCZ8UhVCqYTAPXJf@lists.linux.dev
X-Gm-Message-State: AOJu0YwsiKECfw+45Qbs/Oxi5egWYkszdswnqb6Hxltcju3QS9KhPjdz
	kebHf953OeIIe3vxaMfOh1ZlzACVHjsyhbjGDBn2MCe+AAOnwNm8s/a5bJxFMucE9lXRaUPGvOY
	RROvpirTW9CrlH+ludHfz3iUQuJekoK0=
X-Received: by 2002:a05:6512:33d6:b0:5a2:c05c:1141 with SMTP id
 2adb3069b0e04-5a4172b749emr2855772e87.4.1776598178189; Sun, 19 Apr 2026
 04:29:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260415173735.24437-1-tony.luck@intel.com> <CACw3F522f6p-x6MEU8t7CEoU1P=PtU8dKy7opKjH8sOecdF1kg@mail.gmail.com>
 <SJ1PR11MB6083BF86FFA17D90FBF86686FC222@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB6083BF86FFA17D90FBF86686FC222@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Sun, 19 Apr 2026 13:29:16 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0jg-FrNmGuLFu9aoSshGRzUqYuGTzhh+uczkzsHB4Cf9g@mail.gmail.com>
X-Gm-Features: AQROBzC51TVKRs9me71FD9a-Bau7oqQSsYmMScOhs-quazpd4sFxkP76sutHqOE
Message-ID: <CAJZ5v0jg-FrNmGuLFu9aoSshGRzUqYuGTzhh+uczkzsHB4Cf9g@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI: APEI: EINJ: Fix EINJv2 memory injection
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, 
	"Li, Herman" <herman.li@intel.com>, Zaid Alali <zaidal@os.amperecomputing.com>, 
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 8:15=E2=80=AFPM Luck, Tony <tony.luck@intel.com> wr=
ote:
>
> > > +static bool is_memory_injection(u32 type, u64 param2)
> > > +{
> > > +       if (is_v2)
> > > +               return type & BIT(1);
> >
> > Hi Tony, just a nit: for readability would it better to introduce a
> > macro for BIT(1)? like ACPI65_EINJV2_ERROR_TYPE_MEMORY
>
> I thought about that. The old (v1?) EINJ type bits are in <acpi/actbl1.h>
>
> So "the right thing"(TM) might be to add some V2 defines there:
>
> #define ACPI_EINJV2_PROCESSOR   BIT(0)
> #define ACPI_EINJV2_MEMORY              BIT(1)
> #define ACPI_EINJV2_PCIX                        BIT(2)
>
> Rafael: Do you want that? I can start the process in the ACPICA tree if y=
ou do.

Yes, please!
