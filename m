Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45118D505
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 19:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F352C433C0
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 19:55:19 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=permerror (0-bit key) header.d=gmail.com header.i=@gmail.com header.b="lMvd1eUS"
Resent-From: Ard Biesheuvel <ardb@kernel.org>
Resent-Date: Mon, 26 Jun 2023 21:55:16 +0200
Resent-Message-ID: <ZJntJORFs2OGeOO+@gambale.home>
Resent-To: patches@lists.linux.dev
Received: by 2002:ab3:5d14:0:b0:22b:28fe:6113 with SMTP id j20csp1224397ltc;
        Fri, 28 Apr 2023 09:09:07 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7KcDOu9l9kgBUsszzrVvzo0gjRl6ZjTr6Zb7KDRvPAraHd434HP342tBL46Eeq2JADeabV
X-Received: by 2002:a05:6870:732:b0:18f:9f3:347 with SMTP id ea50-20020a056870073200b0018f09f30347mr2797420oab.2.1682698146898;
        Fri, 28 Apr 2023 09:09:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682698146; cv=none;
        d=google.com; s=arc-20160816;
        b=wC3NshsTDEJ7GdzuIErqUIl+My9PrER8yzEngnjSQ4pJAwsrBMqzqCxl8ncUxn0gHk
         3YgLfb8i9zNEGVaGzZvDh4PJAXJe2+gpQSqsWzmljMoSoeDcqrJp4JjZVvSRec5IwqUK
         zRqIH1MZ+29gpKUfIZk9U6ZNCJfxa/H0zmB5PmDXHP+VSjIAF5o5xmGLgU1yjGQdnmYJ
         7a/vRaX5VT/8GcH47r9x1HmnrZncSgleaIH4QhNwHlXRJhluymIpv1qJnAv+o6ULFh/a
         NhYCvuvoCAiOIcvVl3BFZKFetG5XLnwL5rt9KbauUK4XXMkJFO9tCYLFlenOcZDVcxxn
         +DOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:dmarc-filter:delivered-to;
        bh=htmZbIciMt7hj0Iizm/QcOxSP4fxhr/s621rUCEnn3g=;
        b=UE7aJyk/99u2vw368GpCKU+KdQT79J32YZTk27Cnz9bLcvg2z5ZUC/c4+flE2wglU7
         8iamepzHcEkmuNInvAS+Ys2umvb2YhcE/6LA4oeBgYvlDhINORULbA+rht0uITFguRTK
         UPVFMrxM8huVcpQUprey5Xh0QHsfyoIx6rjwllWZwieBxfG3KS/PcuH6MhfbKDTSKCdX
         oyoqzbNWAVIEspi1UZOjkqSkIuZ0kd43EOw7phzToQxTRZqaTriNf2WeizWkxt+/QVkR
         5uL+Mr3BTpDzOewcWM8YBcW0wygx7B939oHgyHBvDiiUX6oL6sLAEtlJgpACnnzY8kyX
         NFOQ==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@gmail.com header.s=20221208 header.b=lMvd1eUS;
       spf=pass (google.com: domain of srs0=mt7o=at=gmail.com=rminnich@kernel.org designates 2604:1380:4641:c500::1 as permitted sender) smtp.mailfrom="SRS0=mT7O=AT=gmail.com=rminnich@kernel.org";
       dmarc=pass (p=NONE sp=QUARANTINE dis=NONE) header.from=gmail.com
Received: from dfw.source.kernel.org (dfw.source.kernel.org. [2604:1380:4641:c500::1])
        by mx.google.com with ESMTPS id i7-20020a056870a68700b00187c3684fd9si17243062oam.83.2023.04.28.09.09.06
        for <workofard@gmail.com>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Apr 2023 09:09:06 -0700 (PDT)
Received-SPF: pass (google.com: domain of srs0=mt7o=at=gmail.com=rminnich@kernel.org designates 2604:1380:4641:c500::1 as permitted sender) client-ip=2604:1380:4641:c500::1;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@gmail.com header.s=20221208 header.b=lMvd1eUS;
       spf=pass (google.com: domain of srs0=mt7o=at=gmail.com=rminnich@kernel.org designates 2604:1380:4641:c500::1 as permitted sender) smtp.mailfrom="SRS0=mT7O=AT=gmail.com=rminnich@kernel.org";
       dmarc=pass (p=NONE sp=QUARANTINE dis=NONE) header.from=gmail.com
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 970D564389
	for <workofard@gmail.com>; Fri, 28 Apr 2023 16:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 1EF1FC433D2; Fri, 28 Apr 2023 16:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F06F8C433EF;
	Fri, 28 Apr 2023 16:09:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org F06F8C433EF
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-5ef54bcded4so992286d6.1;
        Fri, 28 Apr 2023 09:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682698144; x=1685290144;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=htmZbIciMt7hj0Iizm/QcOxSP4fxhr/s621rUCEnn3g=;
        b=lMvd1eUSh4mWlShrmJvCtWgkNb9KXG/oq/QESDWfkgLWjrXa/DXQwsVTesQrt68rOY
         SAVc1MlnfNo77W0Otna9zQl435pkij++BQ6y127Umaj5UbAAMBzdbIAILg/yVLRmXaMc
         bRZ//kMDGuySFkx+Omukzo8/0LJKaCuAzzcWa94Ajy47BpST/MupqCfe1J9d5PGZjf4b
         Pv5JJh7HNQWSFZV8oMAKZYdJhOZnnLA9fl3lc1bHK9MWLVW9A3kVcxsR7QqMiVr/oUEZ
         +4cY8ciXDpUSO/UAvdYGRlP3MpjKexoV3ITdmiHpinJDCYlmbhn5TIbkKos2Qme+s7OC
         IFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682698144; x=1685290144;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=htmZbIciMt7hj0Iizm/QcOxSP4fxhr/s621rUCEnn3g=;
        b=IcxS/Fiow+uk6LMDKBi2ddrZhPH7DrmZLnYmYm1BP0+xTo0aiJ+eWdcAUl2bPGuKxL
         THcvVZG9wIoajXJ1f+f5U8OLTQLXxvgfZK5zRwHW1TmNDiCcD5zlA14DhBb7HtstCzlW
         asjKBDMTqel4qmnR93HngDroJytuJUfqLvvUC/nlj43SYU4YNBu0YfRbPBEI174NPUTf
         y4M8iEaWaqfbdznTCUPqbhNq4YBjFwKVO6rwPiLAawOsiq0OieQj5Zagy4ezGJPT8D2P
         4GmeSKYNaoqfJ4q/9czneYBQ1haXl6qd2trOcwvbfXlq2NEKn4fuIcNWsNs9SykYzX1W
         gSFw==
X-Gm-Message-State: AC+VfDz+71ztWv7RjkgM7uI/ybEZz1QLKNCS+TlBtc/iBFD3sCsXiMzw
	g7wb2u6q9nS+vpg3PBwK0UmFrrY7wNzvMp9HVnPVeXVI2j8=
X-Received: by 2002:a05:6214:ca4:b0:5ef:423b:1f4c with SMTP id
 s4-20020a0562140ca400b005ef423b1f4cmr8588725qvs.50.1682698143890; Fri, 28 Apr
 2023 09:09:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230426034001.16-1-cuiyunhui@bytedance.com> <CAMj1kXEKh9O-ndk3QFibJMYfMbG7vm-cLN2vVQM5eDsYK84NzQ@mail.gmail.com>
 <CAEEQ3wkJB5CKm33mHXUOPX5makYOHF8By6FYGnNzRkM-Mo72OQ@mail.gmail.com>
 <ZEj33QLZqEeL+/y4@FVFF77S0Q05N> <CAEEQ3wmDBJkfOeKCQfcnuE+1=1K0D2pzu+Sn+zPEWk+RHs0NFQ@mail.gmail.com>
 <CAP6exY+ydbzh1EkWTFejzwaW+PA-ySVO2Qj+CVJ1XbSMce2S9Q@mail.gmail.com>
 <ZEpbTE4gcsf8meXc@FVFF77S0Q05N> <CAMj1kXH5kZJ6ff=PRCRDLCBcw2AkEnRL_L1ABuvu5n71=unvAw@mail.gmail.com>
 <CAEEQ3w=495snOz3UNBO4dpgyfZs3jQoRKo4QRAXXqR5-0j4SWA@mail.gmail.com>
In-Reply-To: <CAEEQ3w=495snOz3UNBO4dpgyfZs3jQoRKo4QRAXXqR5-0j4SWA@mail.gmail.com>
From: ron minnich <rminnich@gmail.com>
Date: Fri, 28 Apr 2023 09:08:52 -0700
Message-ID: <CAP6exYK9ytcgqcy2gFyOGvbxd7DPGQNs=m7nNgnfunnh8et9aQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] firmware: added a firmware information
 passing method FFI
To: =?UTF-8?B?6L+Q6L6J5bSU?= <cuiyunhui@bytedance.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, rafael@kernel.org, lenb@kernel.org, 
	jdelvare@suse.com, yc.hung@mediatek.com, 
	angelogioacchino.delregno@collabora.com, allen-kh.cheng@mediatek.com, 
	pierre-louis.bossart@linux.intel.com, tinghan.shen@mediatek.com, 
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

There is lots of text in the preceding notes :-), which is nice because
we're clearly looking at something that matters!

But, note, ARM Chromebooks run Linux, and I checked with the firmware team
just now:
"Right. We're not using UEFI or ACPI or SMBIOS or DMI or any of that on
Arm. Just the Device Tree."

So I do not agree that we need UEFI tables due to some presumed semantics
that they implement, because: several tens of millions of ARM chromebooks
running Linux show otherwise.

We've got a chance here to move to self describing data, and I think we
need to take it. It will be a long time before we get this chance again.

On Thu, Apr 27, 2023 at 8:18=E2=80=AFPM =E8=BF=90=E8=BE=89=E5=B4=94 <cuiyun=
hui@bytedance.com> wrote:

> Hi Ard, Mark,
>
> On Thu, Apr 27, 2023 at 8:52=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> =
wrote:
>
> > and the only combination we do not support is ACPI without EFI, as
> > ACPI on arm64 depends on the EFI memory map.
> >
> > What this patch seems to be proposing is a combination of all of
> > these, i.e., doing a pseudo-EFI direct kernel boot where the EFI
> > dependencies of ACPI are being fulfilled by ad-hoc descriptions passed
> > in via DT.
> >
> > I am concerned that this will result in a maintenance burden for Linux
> > with very little gain, so I feel we should not go down this road.
>
> Judging from the current kernel, getting acpi smbios, memmap tables is
> not just a way to have EFI, right?
> smbios:SMBIOS_ENTRY_POINT_SCAN_START
> acpi:CONFIG_ACPI_LEGACY_TABLES_LOOKUP
> memmap: e820
>
> Our current situation is that coreboot does not support EFI, but supports
> fdt,
> but we need to support ACPI,  and riscv does not have a reserved
> address segment
> like x86 that can be used, so our current solution is to pass acpi and
> other tables through fdt.
>
> Based on this, do you have a better suggestion ?
>
> Thanks=EF=BC=8C
> Yunhui
>

