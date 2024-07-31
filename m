Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6AE4879B
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 19:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.222.135.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722455047; cv=none; b=ksO1KIf/ZPqpGn8XdZKjKY7/gdoqpXXtorNOnjM8Ed5OlrJ7dgwP+8agzt5xV+RZ0IDpHz1ao4TONkv76y4+YbF8NRbj73rhCzNLVnNl3swic/cSV3ksH01k5OBbZU9mS6Yi1whT59fG1qd0zOdVGRgaMjrYMPnenb5yM8qsmTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722455047; c=relaxed/simple;
	bh=6x1M180eaHDroVe7k6rzwMRYLlHLrdf5L76No5YBXMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QQbSw8EA+ZLkF0zYDKJBIiwEo4ywu2gIMrPsmymKTpGU8tqgTUdWzy1xsaYYiBHVDFFRWTlcL0kZBQmuAafkHyxDIKYd4BIQ3xREZJLeXjVX7KAIoDVlaAr/C5smTrF/CnkoTOOsd+mP0y9oYRiMCaMimLkfW/+9TFqoC+eqcYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl; spf=pass smtp.mailfrom=o2.pl; dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b=wA90v6ky; arc=none smtp.client-ip=193.222.135.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=o2.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b="wA90v6ky"
Received: (wp-smtpd smtp.tlen.pl 24051 invoked from network); 31 Jul 2024 21:44:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1722455041; bh=q07+jOy3Ed9mQauc7wsqveqYmCjuI5OGEKaX1cXwEyE=;
          h=Subject:To:Cc:From;
          b=wA90v6kyg319KSX6EQ250GcAomjLekzndMLkXUjgj4b2gJ7GzufXZRcF4ffVtrmRK
           A/dgMJUL1j/W78hlZLQU2Zzvhhkb1T/ohNDEyopLbM7PU3VC2qyPT7P/xtoMR6njq2
           vlWYgyec0Fq4XZcxfcGZJCk6zECOquqiQFd9kBGE=
Received: from aaen12.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.117.12])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <gregkh@linuxfoundation.org>; 31 Jul 2024 21:44:01 +0200
Message-ID: <974b072b-9696-42c9-8cec-f68454eedc33@o2.pl>
Date: Wed, 31 Jul 2024 21:43:58 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 678/809] md/raid1: set max_sectors during early
 return from choose_slow_rdev()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Paul Luse <paul.e.luse@linux.intel.com>,
 Xiao Ni <xni@redhat.com>, Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <20240730151724.637682316@linuxfoundation.org>
 <20240730151751.683503374@linuxfoundation.org>
Content-Language: en-GB
From: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Autocrypt: addr=mat.jonczyk@o2.pl; keydata=
 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
 TANkZ3QqXNX2
In-Reply-To: <20240730151751.683503374@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: 0016bc94910de5aa5be2e80f71dff402
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [sWOF]                               

W dniu 30.07.2024 o 17:49, Greg Kroah-Hartman pisze:
> 6.10-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Mateusz Jończyk <mat.jonczyk@o2.pl>
>
> commit 36a5c03f232719eb4e2d925f4d584e09cfaf372c upstream.
>
> Linux 6.9+ is unable to start a degraded RAID1 array with one drive,
> when that drive has a write-mostly flag set. During such an attempt,
> the following assertion in bio_split() is hit:
>
> 	BUG_ON(sectors <= 0);
>
> Call Trace:
> 	? bio_split+0x96/0xb0
> 	? exc_invalid_op+0x53/0x70
> 	? bio_split+0x96/0xb0
> 	? asm_exc_invalid_op+0x1b/0x20
> 	? bio_split+0x96/0xb0
> 	? raid1_read_request+0x890/0xd20
> 	? __call_rcu_common.constprop.0+0x97/0x260
> 	raid1_make_request+0x81/0xce0
> 	? __get_random_u32_below+0x17/0x70
> 	? new_slab+0x2b3/0x580
> 	md_handle_request+0x77/0x210
> 	md_submit_bio+0x62/0xa0
> 	__submit_bio+0x17b/0x230
> 	submit_bio_noacct_nocheck+0x18e/0x3c0
> 	submit_bio_noacct+0x244/0x670
>
> After investigation, it turned out that choose_slow_rdev() does not set
> the value of max_sectors in some cases and because of it,
> raid1_read_request calls bio_split with sectors == 0.
>
> Fix it by filling in this variable.
>
> This bug was introduced in
> commit dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read_balance()")
> but apparently hidden until
> commit 0091c5a269ec ("md/raid1: factor out helpers to choose the best rdev from read_balance()")
> shortly thereafter.
>
> Cc: stable@vger.kernel.org # 6.9.x+
> Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
> Fixes: dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read_balance()")
> Cc: Song Liu <song@kernel.org>
> Cc: Yu Kuai <yukuai3@huawei.com>
> Cc: Paul Luse <paul.e.luse@linux.intel.com>
> Cc: Xiao Ni <xni@redhat.com>
> Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> Link: https://lore.kernel.org/linux-raid/20240706143038.7253-1-mat.jonczyk@o2.pl/
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Hello,

FYI there is a second regression in Linux 6.9 - 6.11, which occurs with RAID
component devices with a write-mostly flag when a new device is added
to the array. (A write-mostly flag on a device specifies that the kernel is to
avoid reading from such a device, if possible. It is enabled only manually with
a mdadm command line switch and can be beneficial when devices are of
different speed). The kernel than reads from the wrong component device
before it is synced, which may result in data corruption.

Link: https://lore.kernel.org/lkml/9952f532-2554-44bf-b906-4880b2e88e3a@o2.pl/T/

This is not caused by this patch, but only linked by similar functions and the
write-mostly flag being involved in both cases. The issue is that without this
patch, the kernel will fail to start or keep running a RAID array with a single
write-mostly device and the user will not be able to add another device to it,
which triggered the second regression.

Paul was of the opinion that this first patch should land nonetheless.
I would like you to decide whether to ship it now or defer it.

Greetings,

Mateusz

