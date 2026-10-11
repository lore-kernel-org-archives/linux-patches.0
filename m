Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F3D329E46
	for <patches@lists.linux.dev>; Sun, 11 Oct 2026 16:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791736772; cv=pass; b=nZpDL8JhufoqBVawmNwNx8IteisyqJI3BreJFmTQ02bZhq/tePMxDvIJ2OPX5vg+mKQd6WsLdoBlJj4FC54sUYL5mWaR4wSKciW4+T7rYWShyg5gVZics2XcSsrHRXbmhv6o1hW+PAE8gjjgQoBMEj7kCQ1fUQmj4I6rq3U5VtQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791736772; c=relaxed/simple;
	bh=zBtcwkC1UetxURqz8HrxesKE3ZLqea1Q818EN42uR6c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FIAy58AOoXQD4a33v2mJE1kR6r1Kq99k98k6/v+QCIPRGOJmDmY30fBiDgn+TtqYDT1rElxBuUC+XfoG8yNJPuL1Myepq7dujS5RlkiR0rZGlB2Wp0/NPBRBvylqpPxJHe8d7SO5/XgOIzeDArj59QBeKCWYtiNo8IreE5Gt3rc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OoGfsVEH; arc=pass smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OoGfsVEH"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-3584f70a5aaso121112eec.1
        for <patches@lists.linux.dev>; Sun, 11 Oct 2026 09:39:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791736770; cv=none;
        d=google.com; s=arc-20260327;
        b=i2mR6GHKVC+LfFFeu4OHDd2nqZDFRAb36ufBStaPUzEr7or72AGQv4jhFjY0kF89nX
         DsYlZItOlr+qCFfWgi+MS1UW131qZbZ2uC8V5NTI9KGftO7Qve4QyYT+5Q8QYNzP6xqR
         dDHt0c6zyycZ6IVNy56QlKRoHwQxgBLTcuJmG2buh5XxkZPS1Ao1Cneu6IbG5cK6ldE/
         lrsb1iIN/XalCuEdjUkgjJnUVt/H5UwN1f6tjW53M7FDZngi8tLJNbApjhAoWqN4WlDB
         dFJqhwO/gSfflhze0SjmfJbNLQsFdoA6qk4YpNB3rPhTfodqNz9/e5bACWU4vGqIRhp1
         dvqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zBtcwkC1UetxURqz8HrxesKE3ZLqea1Q818EN42uR6c=;
        fh=/4TvKQwD6JwUiLqxtafIgfCafRlXi2fCXMSSlqLQd5Y=;
        b=XwNaM4SfMwaMTPcUkv8zcrL/iau5XDhBE/IVJ6jgp52H4Cs4Pe1MKvydoTz5mmPK4M
         xmFDMyyJesKnzshsIR01nhib8VpDiNh3Oj60SJLkbiuI9PRPff01wX2RGXx49JGOPQ/i
         FbYy18dWb6OlCMwx+XisZWlelIb5WSBfDzbrXaI95VPpJdX4uQjLKQ+DdWA5xX+g1F0j
         qBpYhYcy5JwZSfViFnODK60m+9aifSbIpww3IpFjI44VUmVrNJLgGXkAJyGdeJtKHkGb
         hHUH6dFIevlTDCn0l6UkOJSD1bZj1fx+H6J2JbEgGCbxIJsSiQwYnnWBFpWMBxjoArNr
         QS1g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791736770; x=1792341570; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zBtcwkC1UetxURqz8HrxesKE3ZLqea1Q818EN42uR6c=;
        b=OoGfsVEHwIMCnvzzCVMNNgsZ69aRcIikT6Qt6jsYJhXmaRrxBovbf3VfbaPs61zhm9
         hpBsdphRV5RUB62JPgdXKvJzd3hfMC6APufdRcaN/bZYLxquGoO32AE8Yk75muU+Odl+
         stlU2yvXIPkq6pksSPj2xFhGoLupLYMZOmeN0D23YJfPYIJ+0xYnm/QlZcU5/OwKyD3Z
         3nbAxrHy4W7j3RSsYFHMRB8fmKdNocxHxMQRVcG9UJ6BnLlSvy9JmW3Y0WhyzKh7g5Rh
         6LbKdez9RAWx7yS8lAdHX93diM2OchpEzaaSVbwUKeA/MN+o4VRPOBbCHCsGYcI+Dx5o
         4nwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791736770; x=1792341570;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zBtcwkC1UetxURqz8HrxesKE3ZLqea1Q818EN42uR6c=;
        b=GZthFc8r/2hNMxZNVc2P9zFifBh2TdEPH+oAMKo/J7Bg/gN3cIc+vrsXCfGRksPDqM
         xXoEK3pk8R0yCoSROxg6KV+R8P5lzerxvVduOYuNi0mogmYTTN5LYp5TaDr9TnT4lDfC
         lcwViNqplqDRdKqulaU2HsdMGPSJdepiOgXHE5Bsx/J4wBMJlc8ruRIcscvrzJIHREPh
         qv/qi8bCbY9V6cWaXMuDB+jYBs9ShMreC7EaWrG3TPB6F7e0PC6lpR0P1/imPzHoEzfM
         zakG/ECq6essI4GFdoBq8vTnBd6PJp6jzSDrhiwfRRCVbEYZONgrKr7Zip2hWnU1zFVV
         8+gA==
X-Forwarded-Encrypted: i=1; AKwUvBzgA4Dvnlv9WqBYGEs4J4pb4HGIwnsTa2pTim4uBUrUB0cK0aXzQWwd+qucYp3ufQQPupAibTQ6@lists.linux.dev
X-Gm-Message-State: AFq9FYKtBaYqMw1wQQ/meCa4a3WORGYTVGq+FWolo+O6jSF5BssQyWkx
	RligoF0itKJz/wKsAlDyzX4ePybwfLXVEhZsjQAD4WcKhKGNYKIDwPepwQWr7Loqv01GYkN9aGH
	VNIzbLiuKx3JnrbURT2C42BpzBoGTKh0=
X-Gm-Gg: AYBFou1hH2GtsD/2uJhi+9lb6gn80cxXjSHAeCQfoBVIBGtfsexV71kR05gtr/twdPA
	/dnsEz64/JJqYAwOgfUAppZkzxa9G5QDhAqgjm4t/dkU36+/C/etBxIexf2ad3nR6/jNGLp+JXO
	5zIrovzcpuy7yCnrE2AHPWIXbdALpnELfh6nTZ9refJ/MWpNeBXgRDKXWffr+hd0qOoDOcmpU0U
	qkTkKIfhYsKDV3I9CQBbeM/d/pwrIUwgbmYbj1VgGGvTs8DTb1X+rwFeYRtHRW0ysSRMwSbhDAX
	Od6azdr/mFj7B6eYUtuy9x5D5i8MbyWcB9D1XbpQYxE1xQsB66VCaYYBGq1+hBzpoM/R4dNQW3E
	+KPmzM6AXnq7KFTVql7NhaGnKN2o9CpyIJZPjRNolB5JOq4E0jihmZtq8U1cfrxlLzc/XVxR2LX
	ooiu4b/TW4AZn708dYlhTsICj7/ZvZnKPCnKq6jvAhLFMwv2dplILp
X-Received: by 2002:a05:7300:c01b:20b0:351:e21d:357d with SMTP id
 5a478bee46e88-3537dfdd089mr19829223eec.1.1791736770408; Sun, 11 Oct 2026
 09:39:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261009140946.008206689@linuxfoundation.org> <20261011111313.27648-1-ojeda@kernel.org>
 <2026101124-rethink-craftily-cb25@gregkh> <CANiq72ndhLush3bugar1YGPnsein8min1k3_NucBxzFwCWe9Ug@mail.gmail.com>
 <2026101103-fling-stipulate-084f@gregkh>
In-Reply-To: <2026101103-fling-stipulate-084f@gregkh>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 11 Oct 2026 18:39:14 +0200
X-Gm-Features: AclHuK894KXAsXO3p-x4bVKeUE-imiIjXxXeY6DW6N_dPzUVgjRMS5Bea-wNMLs
Message-ID: <CANiq72kjJ__OnsTjmsuQZH8+U-cRDCNnRpSuHU3PwYYT07Xf0Q@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/428] 7.2.10-rc1 review
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, achill@achill.org, akpm@linux-foundation.org, 
	broonie@kernel.org, conor@kernel.org, f.fainelli@gmail.com, 
	hargar@microsoft.com, jonathanh@nvidia.com, linux-kernel@vger.kernel.org, 
	linux@roeck-us.net, lkft-triage@lists.linaro.org, patches@kernelci.org, 
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, 
	sr@sladewatkins.com, stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <christian@brauner.io>, 
	Carlos Llamas <cmllamas@google.com>, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 11, 2026 at 4:17=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> If that works, can you, or someone else, send an updated version of that
> commit for the next round of stable releases as I dropped it for this
> one.

Done (I didn't add vger).

Alice: please double-check, thanks!

Cheers,
Miguel
