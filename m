Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE592127B49;
	Tue,  5 Mar 2024 15:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709653170; cv=none; b=eOL6ZhIGJxuzH1cIbB2nyIvGeRNuq5aiCelRzo6wZff3/rH+zaqO5mP4BBD7FAMyTLV3HopDwDwNPcB2R4bUvN7Kcbt9k8gtt1SiR2eMZvhX8ZJRxcORQ0dMWB6U39fEBg3o23Tr9gGOUawtag3r5woW5hYXgfgdurEDGKvqLKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709653170; c=relaxed/simple;
	bh=zu6dawwP6iMIyShTuCagsHimgWcoI8y5k1fedG9PSvs=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=g6GqCH1ncuz3GfDR0G7dYFpEdDv2y1cOP5oXk0baRZpi4cPxu8hDjd6voobS6v7HuXoFyd6tqRt9vfOAQKYmv5W4DqfI79voEyCloAmaCWubWRMrC+LzeXXdHM9puLEslL0SY0vsk3X/OuxVzGV3A8o+HzE4J46FqDS+wHmkXig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=fail (0-bit key) header.d=zytor.com header.i=@zytor.com header.b=GP7AAlD7 reason="key not found in DNS"; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=zytor.com header.i=@zytor.com header.b="GP7AAlD7"
Received: from [127.0.0.1] ([76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.17.2/8.17.1) with ESMTPSA id 425Fd9tn1037566
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 5 Mar 2024 07:39:10 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 425Fd9tn1037566
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024021201; t=1709653150;
	bh=zu6dawwP6iMIyShTuCagsHimgWcoI8y5k1fedG9PSvs=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=GP7AAlD7r1+sOFcVNynvK6GMDaH36FcSPgVcETJo454PRNG72O07g2zIAoyCuoInU
	 g1Xv6QyUTFdy4QpVJihT4lMze89VATuoFwpl8ronih2nB338xn8vMEhdyC8LbKlnnV
	 aSjwdditNqbwELAEKZzT8JARk9gh2iG5RI9uukEL3LmDpCZ1cQOdOub8JrQYUiB+QO
	 zpfqQHmc79RxGJH1jO3MRbLKAQEBtpNMM6QFc1xVDYcEyA+6VlQolJxdO03W2tnKcS
	 gMgRsEiZILufGpiUVa0mgOD+tA5sz2wYqmvtd91pLsUTUNw4DDnfDwsjRXSvsJoukq
	 QUpL0gNZnNf+A==
Date: Tue, 05 Mar 2024 07:39:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: stable@vger.kernel.org, patches@lists.linux.dev,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_6=2E1_128/215=5D_x86/boot=3A_Robustify_call?= =?US-ASCII?Q?ing_startup=5F=7B32=2C64=7D=28=29_from_the_decompressor_code?=
User-Agent: K-9 Mail for Android
In-Reply-To: <2024030523-parted-situated-8749@gregkh>
References: <20240304211556.993132804@linuxfoundation.org> <20240304211601.130294874@linuxfoundation.org> <E57FF738-3527-45F3-891D-FD54E6E7E217@zytor.com> <2024030523-parted-situated-8749@gregkh>
Message-ID: <5F305A61-B247-4C0F-B220-633504C72774@zytor.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On March 4, 2024 11:36:53 PM PST, Greg Kroah-Hartman <gregkh@linuxfoundatio=
n=2Eorg> wrote:
>On Mon, Mar 04, 2024 at 02:42:35PM -0800, H=2E Peter Anvin wrote:
>> I would be surprised if this *didn't* break some boot loader=2E =2E=2E
>
>As this has been in the tree since 6=2E3 with no reported errors that I
>can find, I think we are ok=2E
>
>thanks,
>
>greg k-h

Well, boot loader breakage in the past has sometimes been reported a year =
or more later=2E

#Pain
