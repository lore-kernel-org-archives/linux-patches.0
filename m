Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5120929C33C
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 10:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753268066; cv=none; b=RsEeNK2QaBApic0JUBtCVJIsoFwrtdf+EdxvW5Xe0t7aenjpdKAAxlI1X6V1DSPcSNahlSX7tuiRy5JEaTg9olRph0ibeeQNC2OyPqTFykeNknaR+qsM1uvsSXgP3sgAAR0yobOxAGyDmqWQMLOlEYyfABp7dXIzwC0zc1BSNgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753268066; c=relaxed/simple;
	bh=Zcas9eE5csMNiM9e3VG5sF1smKTbMZmNZrhcriyHhmo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rx2dzt78UkLCu8S7IsqIdHlyK2rkz11XF8wGB1mFi+/yuO6c5SASY7K93rsGqXaFZc6ubF2KvkL6Y9GMmIbY7ld0JNzQNkySFJG1gwHI1szifRl1wgqfOMl7WrJ/G2bWovp51YqgogCzoomtxtWWe3a+rwXrfysptSuIe05c38w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=q2/3dzoP; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="q2/3dzoP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1753268056; x=1753527256;
	bh=2UASD4ILAuLiyKedfAnn94cAyJ50UzLqHCB1+nHaE9Q=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=q2/3dzoPFiUbtioR8Nxa1GKizdawq+dlpfi9DmST8gvMGXUYBSD0AD8hCIq+h9rtp
	 6CrAla7rlo8Ypk4Ow2pddHf7Ei3mCBH83ReS0pWwiR+kN1vWfPI70nUpYJu3iWPLIG
	 X63rrSjS9x0U9D1qrwDOadp+fe7kEUVI7U7pQCLTbrZzs4rMjwhY+LsHidAnZBhKIh
	 lbNTdC5cDjgGRhlDx4ig0E05N7gT8gXzMnpmf0lI6NkfhSDzD4gHkjIh0v2dpchAvC
	 VB4ydY4qmbefyro3DA2Zyt5YdXZR3/uBPGRvENOhIW/8IrHGG3BEPBH5W3gk4l5UOW
	 M2ooCrPaBjSvQ==
Date: Wed, 23 Jul 2025 10:54:12 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Michael Pratt <mcpratt@pm.me>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, "patches@lists.linux.dev" <patches@lists.linux.dev>, INAGAKI Hiroshi <musashino.open@gmail.com>, Srinivas Kandagatla <srini@kernel.org>, "sashal@kernel.org" <sashal@kernel.org>
Subject: Re: [PATCH 6.6 111/111] nvmem: layouts: u-boot-env: remove crc32 endianness conversion
Message-ID: <Sl8R4r1d5VEvkHFZH5VnOWX1hdLmCXgNBy-QeLBTB8tbrzrz4XLmRcf6AS4MxWBzAY0fl8ISERCaTh8hJVDkBgpV5NLjweTQLXKjpm9vyag=@pm.me>
In-Reply-To: <2025072359-deranged-reclining-97ac@gregkh>
References: <20250722134333.375479548@linuxfoundation.org> <20250722134337.561185968@linuxfoundation.org> <OtYC5V_o5aJvujD0QIBYfFMqHJbKopAZebvBnDZ398q36FII2UJGr-gWv2Z-ogM5GLwXLnmHjT0orC0RyuAbvPYG-P-EP82l14gy4pG7H-w=@pm.me> <2025072359-deranged-reclining-97ac@gregkh>
Feedback-ID: 27397442:user:proton
X-Pm-Message-ID: e8e6ef109c1cd2174ff708943c60455be735510c
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Greg,

I still see it says "moved from" instead of "to".

On 7/23/25 2:41 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

>  On Wed, Jul 23, 2025 at 06:33:10AM +0000, Michael Pratt wrote:
>  > Hi,
>  >
>  > I don't mean to be nitpicking too hard
>  > but the manual edit description below would  read better as:
>  >
>  > On 7/22/25 9:56 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wr=
ote:
>  >
>  > >  6.6-stable review patch.  If anyone has any objections, please let =
me know.
>  > >
>  > >  ------------------
>  > >
>  > >  From: Michael C. Pratt <mcpratt@pm.me>
>  > >
>  > >  commit 2d7521aa26ec2dc8b877bb2d1f2611a2df49a3cf upstream.
>  > >
>  > >  On 11 Oct 2022, it was reported that the crc32 verification
>  > >  of the u-boot environment failed only on big-endian systems
>  > >  for the u-boot-env nvmem layout driver with the following error.
>  > >
>  > >    Invalid calculated CRC32: 0x88cd6f09 (expected: 0x096fcd88)
>  > >
>  > >  This problem has been present since the driver was introduced,
>  > >  and before it was made into a layout driver.
>  > >
>  > >  The suggested fix at the time was to use further endianness
>  > >  conversion macros in order to have both the stored and calculated
>  > >  crc32 values to compare always represented in the system's endianne=
ss.
>  > >  This was not accepted due to sparse warnings
>  > >  and some disagreement on how to handle the situation.
>  > >  Later on in a newer revision of the patch, it was proposed to use
>  > >  cpu_to_le32() for both values to compare instead of le32_to_cpu()
>  > >  and store the values as __le32 type to remove compilation errors.
>  > >
>  > >  The necessity of this is based on the assumption that the use of cr=
c32()
>  > >  requires endianness conversion because the algorithm uses little-en=
dian,
>  > >  however, this does not prove to be the case and the issue is unrela=
ted.
>  > >
>  > >  Upon inspecting the current kernel code,
>  > >  there already is an existing use of le32_to_cpu() in this driver,
>  > >  which suggests there already is special handling for big-endian sys=
tems,
>  > >  however, it is big-endian systems that have the problem.
>  > >
>  > >  This, being the only functional difference between architectures
>  > >  in the driver combined with the fact that the suggested fix
>  > >  was to use the exact same endianness conversion for the values
>  > >  brings up the possibility that it was not necessary to begin with,
>  > >  as the same endianness conversion for two values expected to be the=
 same
>  > >  is expected to be equivalent to no conversion at all.
>  > >
>  > >  After inspecting the u-boot environment of devices of both endianne=
ss
>  > >  and trying to remove the existing endianness conversion,
>  > >  the problem is resolved in an equivalent way as the other suggested=
 fixes.
>  > >
>  > >  Ultimately, it seems that u-boot is agnostic to endianness
>  > >  at least for the purpose of environment variables.
>  > >  In other words, u-boot reads and writes the stored crc32 value
>  > >  with the same endianness that the crc32 value is calculated with
>  > >  in whichever endianness a certain architecture runs on.
>  > >
>  > >  Therefore, the u-boot-env driver does not need to convert endiannes=
s.
>  > >  Remove the usage of endianness macros in the u-boot-env driver,
>  > >  and change the type of local variables to maintain the same return =
type.
>  > >
>  > >  If there is a special situation in the case of endianness,
>  > >  it would be a corner case and should be handled by a unique "compat=
ible".
>  > >
>  > >  Even though it is not necessary to use endianness conversion macros=
 here,
>  > >  it may be useful to use them in the future for consistent error pri=
nting.
>  > >
>  > >  Fixes: d5542923f200 ("nvmem: add driver handling U-Boot environment=
 variables")
>  > >  Reported-by: INAGAKI Hiroshi <musashino.open@gmail.com>
>  > >  Link: https://lore.kernel.org/all/20221011024928.1807-1-musashino.o=
pen@gmail.com
>  > >  Cc: stable@vger.kernel.org
>  > >  Signed-off-by: "Michael C. Pratt" <mcpratt@pm.me>
>  > >  Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
>  > >  Link: https://lore.kernel.org/r/20250716144210.4804-1-srini@kernel.=
org
>  > >  [ applied changes to drivers/nvmem/u-boot-env.c after code was move=
d from drivers/nvmem/layouts/u-boot-env.c ]
>  >
>  > [ applied changes to drivers/nvmem/u-boot-env.c before code was moved =
to drivers
>  > drivers/nvmem/layouts/u-boot-env.c ]
> =20

--
MCP
