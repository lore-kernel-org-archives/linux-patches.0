Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FFA1FBC
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:32:48 +0000 (UTC)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1658326984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0WMMX/PL+6WBHpEkaakKlpFuXv9ANLYkb8EvAPIepkA=;
	b=EPavvLlGHMbvXTKjVe9z9iGz9grZmQeuyp+p1Hn4SsmAzSZ0TnoJMeXXzTJnEhgoecIIXA
	1VWzgytXZA1sOaeRm4GS/ev04iAK/Rc6rQDLRKna5MX90qmtRz+T0EHicH10t1L3LegVps
	0ATdoXJ6t8R18gVCfdMJ0KHjVtf1OBA=
Date: Wed, 20 Jul 2022 14:23:04 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: konstantin.ryabitsev@linux.dev
Message-ID: <a959e9ec326404f05d5cf5aa4550c534@linux.dev>
Subject: Re: [PATCH v1 1/2] Makefile: set appropriate release name
To: "Konstantin Ryabitsev" <konstantin@linuxfoundation.org>, "Linux
 Patches" <patches@lists.linux.dev>
In-Reply-To: <20220720-claim-for-kahless-v1-1-f787d95bfb7a@linuxfoundation.org>
References: <20220720-claim-for-kahless-v1-1-f787d95bfb7a@linuxfoundation.org>
 <20220720-claim-for-kahless-v1-0-f787d95bfb7a@linuxfoundation.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev

July 20, 2022 10:06 AM, "Konstantin Ryabitsev" <konstantin@linuxfoundatio=
n.org> wrote:=0A=0A> We are claiming this for Kahless!=0A> =0A> Signed-of=
f-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>=0A> =0A> diff=
 --git a/Makefile b/Makefile=0A> index 00fd80c5dd6e..e6d304ac1abc 100644=
=0A> --- a/Makefile=0A> +++ b/Makefile=0A> @@ -3,7 +3,7 @@ VERSION =3D 5=
=0A> PATCHLEVEL =3D 19=0A> SUBLEVEL =3D 0=0A> EXTRAVERSION =3D -rc7=0A> -=
NAME =3D Superb Owl=0A> +NAME =3D Kahless the Unforgettable=0A> =0A> # *D=
OCUMENTATION*=0A> # To see a list of typical targets execute "make help"=
=0A=0AAcked-by: Worf son of Mogh <konstantin.ryabitsev@linux.dev>=0A=0A-K
