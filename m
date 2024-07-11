Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E17E19EED7
	for <patches@lists.linux.dev>; Thu, 11 Jul 2024 21:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720732727; cv=none; b=jbb/2c9XzG+M7cPg0Y0m/r6Y8NdwHjmDUAnxK5errOQxMLfcBtJyaPPeSziBL29UaW6ILuTFQj77q//k9dFiU71DGf+MG2OFU0aNaA710avH3z4eAKjsf4V63TLB+5NfzEgHJsfuntRSe9m7u8XtKarXgPGioPnFB/3YcE7V3W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720732727; c=relaxed/simple;
	bh=sV9UkDpgdJI5nO8J8h6KzE9TPuuDtH2Js+kWDGsoqiA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T5I05AZN3jPP8HX/qark2ETO9bgAvHKZ0JjbE35bFjMDmaEYXnp1Bb9Oq6Z0qfLvkWD4FXMaRXWewHK68vPrdELcyy+bVDldv2wfdM7TLEisoFwhX98rF25coTUSM5Kfx2NtnlqA9lcZLLThjbBDd829ejCz3YnaKFQYjhmxn1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=DfOcPfJn; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="DfOcPfJn"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2c961b5f215so1065629a91.0
        for <patches@lists.linux.dev>; Thu, 11 Jul 2024 14:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1720732725; x=1721337525; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j9e6a5/Mi00lPqSFUCY2ruWznGIW0bflPYVcqQ/6g94=;
        b=DfOcPfJn14VWqUZxqUwtb/rcs2EI0RTd+VL5dryONwpOJvFm9OKuRXQDzupCe6EMIO
         zLU8hRidcxe2rznrwu012YM/3Ic7bRz5XL5aho1EkHHaesbyAd3EoKgLN7adG22S/UNp
         2z5gCrgmK8tMPx4YRJ5I5dncApw5XQ9wkVdx24x1bErhx05IQXAhZ2yWvrnsgfN30h77
         CiW+Tzv7gpsAXKPMRauK5vibu18gMo1CMSdAdiEcXZsgmSa1dbArtEc6hr6NrOCtaBca
         0F6aEMn9oOWOx0uM2MvsiKzAX823TApHAvTE5CZ+8Io3o64edS1xVb5flMUjuXxnPOkn
         OE/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720732725; x=1721337525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j9e6a5/Mi00lPqSFUCY2ruWznGIW0bflPYVcqQ/6g94=;
        b=QTRS5twjqB0KqVXuUxVG7uH8fEzXOr1LURpokAL5A1VnRWpKhJ17u5MC0V8KYKOrjO
         G7ETLp1NXnZH/JX7ygYapPkV8VpY6vaGFnSkaaGLQS7TRxBUqWPlGnE5mQhDnvg/NW2m
         2OtMTn89wZ+PtB0wwUAp2EAjxX2ESrajEk4mlX7gqt3mLNmiKV6CjoTJm/0JNIJe85Bs
         ihq6kwi9kbIxYBcd4QrGXLOgp0aMPcz/mq70LTCM1VYP3BRUhWgT5IlUALXOuFtc17Lz
         DL1/7uSZIxrx2NTWhJJfLKS/SkmoOh6yjR4L/2FLHhr32sG9LQUDzBkbXcn0mfkMHfow
         4LOw==
X-Forwarded-Encrypted: i=1; AJvYcCUdVbmPJJv5/rtf7E4CXk2hOXKB6RpgSnghLk4fK2xzQ52nRTD5QF9yMuUXxdJQnyjFEvZUuco10xNAWn4HS4wHcMzHIVmHow==
X-Gm-Message-State: AOJu0YyTJ59FwkKjA1oIq2HL/YTEWfnKSjlYfoVMrKdOxAPnygwKppLs
	yCTCFsCCya4XsOGRC2CjBmbuR1x/g3wDneZUDb+CBKeu1mO5TIpNIAjHUCbJCI8pBIXu360dNPx
	U+z3NtATvDD9rnXZgRCsszwMV2mslMB9Kxcp9TA==
X-Google-Smtp-Source: AGHT+IGiV5enzDmTVIOm2s/WT/YwkVXtCf2KBIl6kclbmBVx+zOZ2q3ti8a3fIkoikgcfxRFEME+6X63EW0yPUphrO8=
X-Received: by 2002:a17:90b:1049:b0:2c9:8d58:1d31 with SMTP id
 98e67ed59e1d1-2ca35bdc26emr7540332a91.1.1720732725432; Thu, 11 Jul 2024
 14:18:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240709110658.146853929@linuxfoundation.org> <20240709110659.948165869@linuxfoundation.org>
 <8B1717DB-8C4A-47EE-B28C-170B630C4639@cloudflare.com> <dfe78e1b-eaf9-41e6-8513-59efc02633fd@nvidia.com>
In-Reply-To: <dfe78e1b-eaf9-41e6-8513-59efc02633fd@nvidia.com>
From: Ignat Korchagin <ignat@cloudflare.com>
Date: Thu, 11 Jul 2024 22:18:34 +0100
Message-ID: <CALrw=nHVvVNA5M7=jAspdcOnmDFz=zL6axC6vv6j=t1HbsaO9Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 046/139] selftests/net: fix uninitialized variables
To: John Hubbard <jhubbard@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Willem de Bruijn <willemb@google.com>, 
	Mat Martineau <martineau@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>, 
	kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 11, 2024 at 8:16=E2=80=AFPM John Hubbard <jhubbard@nvidia.com> =
wrote:
>
>
> On 7/11/24 8:31 AM, Ignat Korchagin wrote:
> > Hi,
> >> On 9 Jul 2024, at 12:09, Greg Kroah-Hartman <gregkh@linuxfoundation.or=
g> wrote:
> >>
> >> 6.6-stable review patch.  If anyone has any objections, please let me =
know.
> >>
> >> ------------------
> >>
> >> From: John Hubbard <jhubbard@nvidia.com>
> >>
> >> [ Upstream commit eb709b5f6536636dfb87b85ded0b2af9bb6cd9e6 ]
> >>
> >> When building with clang, via:
> >>
> >>     make LLVM=3D1 -C tools/testing/selftest
> >>
> >> ...clang warns about three variables that are not initialized in all
> >> cases:
> >>
> >> 1) The opt_ipproto_off variable is used uninitialized if "testname" is
> >> not "ip". Willem de Bruijn pointed out that this is an actual bug, and
> >> suggested the fix that I'm using here (thanks!).
> >>
> >> 2) The addr_len is used uninitialized, but only in the assert case,
> >>    which bails out, so this is harmless.
> >>
> >> 3) The family variable in add_listener() is only used uninitialized in
> >>    the error case (neither IPv4 nor IPv6 is specified), so it's also
> >>    harmless.
> >>
> >> Fix by initializing each variable.
> >>
> >> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> >> Reviewed-by: Willem de Bruijn <willemb@google.com>
> >> Acked-by: Mat Martineau <martineau@kernel.org>
> >> Link: https://lore.kernel.org/r/20240506190204.28497-1-jhubbard@nvidia=
.com
> >> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >> ---
> >> tools/testing/selftests/net/gro.c                 | 3 +++
> >> tools/testing/selftests/net/ip_local_port_range.c | 2 +-
> >> tools/testing/selftests/net/mptcp/pm_nl_ctl.c     | 2 +-
> >> 3 files changed, 5 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/tools/testing/selftests/net/gro.c b/tools/testing/selftes=
ts/net/gro.c
> >> index 30024d0ed3739..b204df4f33322 100644
> >> --- a/tools/testing/selftests/net/gro.c
> >> +++ b/tools/testing/selftests/net/gro.c
> >> @@ -113,6 +113,9 @@ static void setup_sock_filter(int fd)
> >> next_off =3D offsetof(struct ipv6hdr, nexthdr);
> >> ipproto_off =3D ETH_HLEN + next_off;
> >>
> >> + /* Overridden later if exthdrs are used: */
> >> + opt_ipproto_off =3D ipproto_off;
> >> +
> >
> > This breaks selftest compilation on 6.6, because opt_ipproto_off is not
> > defined in the first place in 6.6
>
> Let's just drop this patch for 6.6, then. Thanks for noticing and analyzi=
ng,
> Ignat!

We noticed on 6.6 because we run some selftests for this stable branch, but
by the looks of it the patch needs
4e321d590cec ("selftests/net: fix GRO coalesce test and add ext header
coalesce tests")
so it will be broken for every stable release below 6.8

Ignat

>
> thanks,
> --
> John Hubbard
> NVIDIA
>
>
> >
> >> if (strcmp(testname, "ip") =3D=3D 0) {
> >> if (proto =3D=3D PF_INET)
> >> optlen =3D sizeof(struct ip_timestamp);
> >> diff --git a/tools/testing/selftests/net/ip_local_port_range.c b/tools=
/testing/selftests/net/ip_local_port_range.c
> >> index 75e3fdacdf735..2465ff5bb3a8e 100644
> >> --- a/tools/testing/selftests/net/ip_local_port_range.c
> >> +++ b/tools/testing/selftests/net/ip_local_port_range.c
> >> @@ -343,7 +343,7 @@ TEST_F(ip_local_port_range, late_bind)
> >> struct sockaddr_in v4;
> >> struct sockaddr_in6 v6;
> >> } addr;
> >> - socklen_t addr_len;
> >> + socklen_t addr_len =3D 0;
> >> const int one =3D 1;
> >> int fd, err;
> >> __u32 range;
> >> diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/tes=
ting/selftests/net/mptcp/pm_nl_ctl.c
> >> index 49369c4a5f261..763402dd17742 100644
> >> --- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
> >> +++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
> >> @@ -1239,7 +1239,7 @@ int add_listener(int argc, char *argv[])
> >> struct sockaddr_storage addr;
> >> struct sockaddr_in6 *a6;
> >> struct sockaddr_in *a4;
> >> - u_int16_t family;
> >> + u_int16_t family =3D AF_UNSPEC;
> >> int enable =3D 1;
> >> int sock;
> >> int err;
> >> --
> >> 2.43.0
> >>
> >
> > Ignat
> >
>
>
