Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C599A1B86C7
	for <patches@lists.linux.dev>; Thu, 11 Jul 2024 15:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720711922; cv=none; b=AUUV7gQvm9WqID2joSPszLqYmMA4ttfSErCVtcASiamfocaF6NtK/AhmV/fM+rFKt4+Gd009sE69uWmd97hwAjEzAMXcDt7WHXLWmsIMdtaQWPtgrCLgw2gh0lPHsv241okx3gmeH1YCjdLRDvuCJWvQaNH3n3sRjiD1gJ2oDLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720711922; c=relaxed/simple;
	bh=M4nmkyH4QHTg3SbxLSHLMsr/yRq0Mzky4QvzjGSfkhM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Mv+oO9e5WzkW2EGaJXMWkjd8YGp/Jh8Yb8T+lRPWhXopD3ziYJK7Dar+YPLoBblnekCN0l0cOym7ACN25Dvh5sjXq4yXZZRv/dgMX9twy/wmNeetaxO/RPNn2dZZJlYvkHr9QrNH8Wp+ryBB4GjNrJdKmmrVWb6V+Tp9G5lXZRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=Nl/JdJ7E; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="Nl/JdJ7E"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-36799fb93baso590094f8f.0
        for <patches@lists.linux.dev>; Thu, 11 Jul 2024 08:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1720711918; x=1721316718; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IkgFy/p55P7RIRDwFamIanzv8uC6eQMVCp6t1WqK4Xc=;
        b=Nl/JdJ7ERo+J3ULQnJjDLP/Y/fWolFh6wskb9hGJTQlSfC3KQ1/M/QEZr376If8/kO
         S08FRGYodobIMbI+Y3o0XRaOk2LlZrwaxruv/UCQx55N9hNC081BKr+3GvgmektsRXWC
         G6x451keFpUIP127jBp2ztsZujxcoP2qUqyQjeJKwY/p5Jbd8xrnt7iD0MfTNXEi1GyU
         guwwEEd4zUHLz+tPp6G02P4CuJ8R6WZQlfD4cHzHDQuTak1hp1EcVE1UGCpsmuy4d705
         Dg/NseVHNUyD6iBCos9YN3G0HyCUHP90NW+nsy1zCqWNpJFyRiVmZaSdSZDupaELg1Q3
         4Qdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720711918; x=1721316718;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IkgFy/p55P7RIRDwFamIanzv8uC6eQMVCp6t1WqK4Xc=;
        b=pMY/UmislHKz37QMzgwhQY7evjKEnOHdsG/V0EIojcMTZGsR28guXS6dhk7xwoZtGS
         uShI/dNB1jdILvIh5G4+VPFxz9WdXtt370Ps+UmQvvlZo9VfbG0Vdz1+nEDi0oI1H1kq
         xsyScXcPR6v7glhhYjh8jtRn/6+4v4LlCxPB0veze6ykDR/xn5MrGTLRRaxF/WP3IOrt
         EFAx6FHmGoP7rC5XUBPqSVh8G//RvZm8bV9d+duEFlZGDkiaP2PEu7C3ryPdoL3TWWaY
         sCV9VCMiAWG7T9RP1IckMjepRrH3JwN71wjfHRFQ5r1/hoVM+zalWQbBUkdsy+e4VhT4
         gg5w==
X-Forwarded-Encrypted: i=1; AJvYcCWDSNtqMUMrXk9RI11XyNNiZwCMLZXmGXyrE+ifO3xo0pCrKXaB4cwCySYXMPYeJb/aK89I7ml6Xo7xzizzC0ohL2LHXyEFyg==
X-Gm-Message-State: AOJu0Ywmuko1AnkIqZJCMyEIzlvlsjpqZx8f1vojEtEjqg6JO/yXNAJr
	WNxnbKxe+YxPhrZd6kyrz4Bg8MLXd0M7S8CdA9Oqh716RwTrq+bLooKw7EpR/Cg=
X-Google-Smtp-Source: AGHT+IH/QgVm7rk7j08fEbHhm8EIHvMEnO1SEFaNr+NzPKB+Ns5nFIYcWbf7p5j2+CTtD6cVBIAYgQ==
X-Received: by 2002:adf:db52:0:b0:367:905c:823e with SMTP id ffacd0b85a97d-367cea7372amr5457142f8f.24.1720711917946;
        Thu, 11 Jul 2024 08:31:57 -0700 (PDT)
Received: from smtpclient.apple ([2a09:bac5:80cb:ebe::178:16e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-367cdfa0672sm8085510f8f.79.2024.07.11.08.31.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2024 08:31:57 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.600.62\))
Subject: Re: [PATCH 6.6 046/139] selftests/net: fix uninitialized variables
From: Ignat Korchagin <ignat@cloudflare.com>
In-Reply-To: <20240709110659.948165869@linuxfoundation.org>
Date: Thu, 11 Jul 2024 16:31:45 +0100
Cc: stable@vger.kernel.org,
 patches@lists.linux.dev,
 John Hubbard <jhubbard@nvidia.com>,
 Willem de Bruijn <willemb@google.com>,
 Mat Martineau <martineau@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>,
 Sasha Levin <sashal@kernel.org>,
 kernel-team@cloudflare.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <8B1717DB-8C4A-47EE-B28C-170B630C4639@cloudflare.com>
References: <20240709110658.146853929@linuxfoundation.org>
 <20240709110659.948165869@linuxfoundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3774.600.62)

Hi,
> On 9 Jul 2024, at 12:09, Greg Kroah-Hartman =
<gregkh@linuxfoundation.org> wrote:
>=20
> 6.6-stable review patch.  If anyone has any objections, please let me =
know.
>=20
> ------------------
>=20
> From: John Hubbard <jhubbard@nvidia.com>
>=20
> [ Upstream commit eb709b5f6536636dfb87b85ded0b2af9bb6cd9e6 ]
>=20
> When building with clang, via:
>=20
>    make LLVM=3D1 -C tools/testing/selftest
>=20
> ...clang warns about three variables that are not initialized in all
> cases:
>=20
> 1) The opt_ipproto_off variable is used uninitialized if "testname" is
> not "ip". Willem de Bruijn pointed out that this is an actual bug, and
> suggested the fix that I'm using here (thanks!).
>=20
> 2) The addr_len is used uninitialized, but only in the assert case,
>   which bails out, so this is harmless.
>=20
> 3) The family variable in add_listener() is only used uninitialized in
>   the error case (neither IPv4 nor IPv6 is specified), so it's also
>   harmless.
>=20
> Fix by initializing each variable.
>=20
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> Acked-by: Mat Martineau <martineau@kernel.org>
> Link: =
https://lore.kernel.org/r/20240506190204.28497-1-jhubbard@nvidia.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> tools/testing/selftests/net/gro.c                 | 3 +++
> tools/testing/selftests/net/ip_local_port_range.c | 2 +-
> tools/testing/selftests/net/mptcp/pm_nl_ctl.c     | 2 +-
> 3 files changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/tools/testing/selftests/net/gro.c =
b/tools/testing/selftests/net/gro.c
> index 30024d0ed3739..b204df4f33322 100644
> --- a/tools/testing/selftests/net/gro.c
> +++ b/tools/testing/selftests/net/gro.c
> @@ -113,6 +113,9 @@ static void setup_sock_filter(int fd)
> next_off =3D offsetof(struct ipv6hdr, nexthdr);
> ipproto_off =3D ETH_HLEN + next_off;
>=20
> + /* Overridden later if exthdrs are used: */
> + opt_ipproto_off =3D ipproto_off;
> +

This breaks selftest compilation on 6.6, because opt_ipproto_off is not
defined in the first place in 6.6

> if (strcmp(testname, "ip") =3D=3D 0) {
> if (proto =3D=3D PF_INET)
> optlen =3D sizeof(struct ip_timestamp);
> diff --git a/tools/testing/selftests/net/ip_local_port_range.c =
b/tools/testing/selftests/net/ip_local_port_range.c
> index 75e3fdacdf735..2465ff5bb3a8e 100644
> --- a/tools/testing/selftests/net/ip_local_port_range.c
> +++ b/tools/testing/selftests/net/ip_local_port_range.c
> @@ -343,7 +343,7 @@ TEST_F(ip_local_port_range, late_bind)
> struct sockaddr_in v4;
> struct sockaddr_in6 v6;
> } addr;
> - socklen_t addr_len;
> + socklen_t addr_len =3D 0;
> const int one =3D 1;
> int fd, err;
> __u32 range;
> diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c =
b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
> index 49369c4a5f261..763402dd17742 100644
> --- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
> +++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
> @@ -1239,7 +1239,7 @@ int add_listener(int argc, char *argv[])
> struct sockaddr_storage addr;
> struct sockaddr_in6 *a6;
> struct sockaddr_in *a4;
> - u_int16_t family;
> + u_int16_t family =3D AF_UNSPEC;
> int enable =3D 1;
> int sock;
> int err;
> --=20
> 2.43.0
>=20

Ignat

