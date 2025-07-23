Received: from mail-10631.protonmail.ch (mail-10631.protonmail.ch [79.135.106.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B28926E6E6
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 06:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753252408; cv=none; b=MSM7QhaDk3bQV2UgPVHnbW5CiFh4n47Ylu4VgetpXXKlx/zxqRlJhRIE/jIWKTsvT3oNCsL8X4VoVAVHAOd5a7J+GiaMvyhu+uu9vRVj2aH99mutr1ZQdRtoJJCBulUMzzNEtVChgBie+/Hbk24656N+d6tMbVmFtZuUs/j8qtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753252408; c=relaxed/simple;
	bh=qwX2FzqSMzFTBUQJOyfkjs1wiHihmaVt4fWqJWwPO9w=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PE0Bmhu71ZZjUYF0xsHjDiRekVcCsbdKTBGXAApmgOvOeWY0eobJKK9RhQALathASM/WMZXRbqwHAa4bzqDSVFNLnjLMe0l6cfN7i7cVIbI80uK80Bte+kjjFSmyn4qfiFA9JXnFOc/Msk2YvmTEw/EDsVCcxWJBBSZetnT+tQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=FnokaUiY; arc=none smtp.client-ip=79.135.106.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="FnokaUiY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1753252397; x=1753511597;
	bh=uIf1KfcX36Petlazf06JRhTOP8ZkwYDYer3AEPEsXww=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=FnokaUiYuVJP+A3fuDh8RXBy8LAmq8v39usJjDPZNqvQdZd4f5b3dyhzAECiZuhmk
	 Pv0xqTwLb2ue6CTUkICps4YTIw9gyb7HEMltMcWmbBHM/IJ7+SY9Irq4uWlSu+1pMI
	 g8PzurmgsxsFjXyfb87caWiWRy493virOgBj9QUBHl3TKbLIqYA8iWpNU+AXpJLoxY
	 lohay3GwdJ0rBuSATPOw+Lq3TVvrwXNH2u5IgJw/8Oc6zwAg4FqK4ffXjZVOJHGHlM
	 ppt+8etozbKoTWr9xEH8Zm71h8iyu57tRDxR8jxnkuCnOyGTtfrzNar+2XRTvSkPS1
	 l9raSJWFjSPmQ==
Date: Wed, 23 Jul 2025 06:33:10 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Michael Pratt <mcpratt@pm.me>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, "patches@lists.linux.dev" <patches@lists.linux.dev>, INAGAKI Hiroshi <musashino.open@gmail.com>, Srinivas Kandagatla <srini@kernel.org>, "sashal@kernel.org" <sashal@kernel.org>
Subject: Re: [PATCH 6.6 111/111] nvmem: layouts: u-boot-env: remove crc32 endianness conversion
Message-ID: <OtYC5V_o5aJvujD0QIBYfFMqHJbKopAZebvBnDZ398q36FII2UJGr-gWv2Z-ogM5GLwXLnmHjT0orC0RyuAbvPYG-P-EP82l14gy4pG7H-w=@pm.me>
In-Reply-To: <20250722134337.561185968@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org> <20250722134337.561185968@linuxfoundation.org>
Feedback-ID: 27397442:user:proton
X-Pm-Message-ID: e0674153ba2a2df5a3f944970ec0de84fb1fb1d8
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

I don't mean to be nitpicking too hard
but the manual edit description below would  read better as:

On 7/22/25 9:56 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

>  6.6-stable review patch.  If anyone has any objections, please let me kn=
ow.
> =20
>  ------------------
> =20
>  From: Michael C. Pratt <mcpratt@pm.me>
> =20
>  commit 2d7521aa26ec2dc8b877bb2d1f2611a2df49a3cf upstream.
> =20
>  On 11 Oct 2022, it was reported that the crc32 verification
>  of the u-boot environment failed only on big-endian systems
>  for the u-boot-env nvmem layout driver with the following error.
> =20
>    Invalid calculated CRC32: 0x88cd6f09 (expected: 0x096fcd88)
> =20
>  This problem has been present since the driver was introduced,
>  and before it was made into a layout driver.
> =20
>  The suggested fix at the time was to use further endianness
>  conversion macros in order to have both the stored and calculated
>  crc32 values to compare always represented in the system's endianness.
>  This was not accepted due to sparse warnings
>  and some disagreement on how to handle the situation.
>  Later on in a newer revision of the patch, it was proposed to use
>  cpu_to_le32() for both values to compare instead of le32_to_cpu()
>  and store the values as __le32 type to remove compilation errors.
> =20
>  The necessity of this is based on the assumption that the use of crc32()
>  requires endianness conversion because the algorithm uses little-endian,
>  however, this does not prove to be the case and the issue is unrelated.
> =20
>  Upon inspecting the current kernel code,
>  there already is an existing use of le32_to_cpu() in this driver,
>  which suggests there already is special handling for big-endian systems,
>  however, it is big-endian systems that have the problem.
> =20
>  This, being the only functional difference between architectures
>  in the driver combined with the fact that the suggested fix
>  was to use the exact same endianness conversion for the values
>  brings up the possibility that it was not necessary to begin with,
>  as the same endianness conversion for two values expected to be the same
>  is expected to be equivalent to no conversion at all.
> =20
>  After inspecting the u-boot environment of devices of both endianness
>  and trying to remove the existing endianness conversion,
>  the problem is resolved in an equivalent way as the other suggested fixe=
s.
> =20
>  Ultimately, it seems that u-boot is agnostic to endianness
>  at least for the purpose of environment variables.
>  In other words, u-boot reads and writes the stored crc32 value
>  with the same endianness that the crc32 value is calculated with
>  in whichever endianness a certain architecture runs on.
> =20
>  Therefore, the u-boot-env driver does not need to convert endianness.
>  Remove the usage of endianness macros in the u-boot-env driver,
>  and change the type of local variables to maintain the same return type.
> =20
>  If there is a special situation in the case of endianness,
>  it would be a corner case and should be handled by a unique "compatible"=
.
> =20
>  Even though it is not necessary to use endianness conversion macros here=
,
>  it may be useful to use them in the future for consistent error printing=
.
> =20
>  Fixes: d5542923f200 ("nvmem: add driver handling U-Boot environment vari=
ables")
>  Reported-by: INAGAKI Hiroshi <musashino.open@gmail.com>
>  Link: https://lore.kernel.org/all/20221011024928.1807-1-musashino.open@g=
mail.com
>  Cc: stable@vger.kernel.org
>  Signed-off-by: "Michael C. Pratt" <mcpratt@pm.me>
>  Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
>  Link: https://lore.kernel.org/r/20250716144210.4804-1-srini@kernel.org
>  [ applied changes to drivers/nvmem/u-boot-env.c after code was moved fro=
m drivers/nvmem/layouts/u-boot-env.c ]

[ applied changes to drivers/nvmem/u-boot-env.c before code was moved to dr=
ivers
drivers/nvmem/layouts/u-boot-env.c ]

>  Signed-off-by: Sasha Levin <sashal@kernel.org>
>  Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  ---
>   drivers/nvmem/u-boot-env.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> =20
>  --- a/drivers/nvmem/u-boot-env.c
>  +++ b/drivers/nvmem/u-boot-env.c
>  @@ -132,7 +132,7 @@ static int u_boot_env_parse(struct u_boo
>   =09size_t crc32_data_offset;
>   =09size_t crc32_data_len;
>   =09size_t crc32_offset;
>  -=09__le32 *crc32_addr;
>  +=09uint32_t *crc32_addr;
>   =09size_t data_offset;
>   =09size_t data_len;
>   =09size_t dev_size;
>  @@ -183,8 +183,8 @@ static int u_boot_env_parse(struct u_boo
>   =09=09goto err_kfree;
>   =09}
> =20
>  -=09crc32_addr =3D (__le32 *)(buf + crc32_offset);
>  -=09crc32 =3D le32_to_cpu(*crc32_addr);
>  +=09crc32_addr =3D (uint32_t *)(buf + crc32_offset);
>  +=09crc32 =3D *crc32_addr;
>   =09crc32_data_len =3D dev_size - crc32_data_offset;
>   =09data_len =3D dev_size - data_offset;

--
MCP
