Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2978A4AEC3
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 17:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991808; cv=none; b=Vw8/1mCUNpT2nsG2J1bmyWdRl4z5MY/IOJJfd9Nbjv8vSNnIZPKjgrC3XA+OIDDjId7uSW1vnFZQlui8lSjyYWK8iuiJka0J/Q4ZtMoCkbsaqNRsrQt1WVvbUwqhFnqluG28kSn0ad02wTPsqusLoD4JR2bwUHUwRCau4PJJmSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991808; c=relaxed/simple;
	bh=nyE92QsmSijPAgW5fCXN9A/NNpgraYl0b7qLIoQqZGs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sE0+M92vm39JeKbvSZfitjLpKugixvJ201yKscjGv1n6wFB60pm4TBgaz4jkFNqij5NUC0mydOPYmJpAYHp0NEXJJyZRcQYGmmr3VC41vacY5ZsmrBkdQy75unFptGr/D9zWptOcqDSFgGR0nitbsI988QzbMzgO28xIziLkJTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=USfuLNb3; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="USfuLNb3"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1e25da9c4c4so98445ad.1
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 10:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711991805; x=1712596605; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8fa5EnP8W2aS/t4kiCQUSns+zPxCGVmzWOLF7r3sV1I=;
        b=USfuLNb3ysn6+6Mqbkj7DQvrckxNdTyD19nVouYv21Ss2jLnLJu4c9XSKXEL8CpL07
         DDh39hn2u84fLhHFdbed5795rYRYL++2ZdnXPkp6BljKrgmsVTopZFAqLm0ZT7Ig66vF
         sV2s1eOk09CZhv9iT/51L3dlYM7jktpE07WNMJ8NS8Z6NqX5YPPaT6FxiII7umMLwwVl
         F1nbVeeA7XD3ZEdoqxcFcxRBBkv+szNTOYGGJA4npfIsHZJcUjIz3dPSwBlY5y6d8qyQ
         A3cPA8KRUymtmDG7r4qk3PS/fIl0TskmsLiCaNeZffyoi9glbehmGkPmKL/LRG+V8eVM
         4q2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711991805; x=1712596605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8fa5EnP8W2aS/t4kiCQUSns+zPxCGVmzWOLF7r3sV1I=;
        b=fiD6pSRUcr+OQ4Lxtir0BjbSN5C5MlToAH1BRpGfSI+McrZUMy3mhbMg1nX0ZVrdkD
         P26aqv3IHzB2jafAbRGrEcs2BHbzESup/O8CQSx3ClouXpqWNSOREqnjs0Ox6IOfXt+C
         pYDW3UWSVESDYLPooJ8iObFqrjpvgNm82DoJGmPAGxnjeSQr3sGF0mLD7VrPloz1kGIh
         Un14vwv22XSobQlATS1B72AP/bI6XkaHgcAvxK+NHC7WfAE78t4n2mCn8SaehbwCLrIp
         Una5HBBmCP4QNseRZ5hBK9LJUvkzo8qQgKVJVZJt3LpsxP9y3SMqKZ/2DP+pRxQNFYDW
         eqrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJsG+IeDFyYIM0dpN0h1zHxf/tVfqAivht48XHNf0ARhZTG5Q20udNzAtYxCGSfE0LElWdB0uzqAsFzNOqd/PB6SYvTY1Tug==
X-Gm-Message-State: AOJu0Ywd9v/tFrTiDabrCISIQ0gp5xb0Rh5mYht/VAVaIGdJ+U2OiSbn
	1a9e7VcluFLYCCHEkjP7IX+ktZ3cnxn3XPtMVRdAlzyKMMU4ewj7ppC+oLpp+pE+dmrzrD5GbhZ
	rFgAAxBEpehK88JoAhH1EqbxquU+VUGfe5YAT
X-Google-Smtp-Source: AGHT+IE3REtGqUHfJ4mA1gZLLDUMjjmkJZI7+58PEHx6u5kucIfNx6BoHW88vb4OIl85YrjTFIpJvVtYZ4TCoio83eg=
X-Received: by 2002:a17:902:b193:b0:1e2:1955:1b1c with SMTP id
 s19-20020a170902b19300b001e219551b1cmr544750plr.27.1711991804957; Mon, 01 Apr
 2024 10:16:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401152553.125349965@linuxfoundation.org> <20240401152601.112837269@linuxfoundation.org>
In-Reply-To: <20240401152601.112837269@linuxfoundation.org>
From: Peter Collingbourne <pcc@google.com>
Date: Mon, 1 Apr 2024 10:16:30 -0700
Message-ID: <CAMn1gO6XMjbn7o63JiHyLrf_z0AFW69LZ_RcxG=1DWw9KttWGg@mail.gmail.com>
Subject: Re: [PATCH 6.7 267/432] serial: 8250_dw: Do not reclock if already at
 correct rate
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 1, 2024 at 9:25=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.7-stable review patch.  If anyone has any objections, please let me kno=
w.

Hi Greg,

This patch is being reverted for now, so it shouldn't go into any
stable branches (I see that you sent similar messages for 6.6 and
6.1).

Peter
