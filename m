Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDC62E65D
	for <patches@lists.linux.dev>; Sat,  4 Jul 2026 02:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783131146; cv=pass; b=G8ynGf/g/fw2PjSlzbJl/ZIMYYJZRCap6+OUkHvePKuFVkSZpYV9vs41vqbmXaqhrRPJ3FgXJrk5DCoeuAxIfG3XZpDt13hL0n56Y+X/ALsElOkPCejUu4CvqZ3IC0y44WRUfvByMDubmMO1VNhRwaeC78oySxt+POhe8rpGIyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783131146; c=relaxed/simple;
	bh=WtFu/7isZ4dlFs1BNOl7NircysrhnIaG8lu25+BYPoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aEtsPSEEcP+xQFrC1f75ihYPT8RaOgxB7kBZO13Hl6dYysf2m8SjtIA/hLHM5ACp5bZcnyszpPtnAnjudHTl/VKMiia/tF51JYX6smdknyvnwPnMTN8WziACu5NmeAc0CSM4Cg0m5GRFbfI2tKkAAbydv5S7ABQM4KfpZLZrEiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pjdKTWoT; arc=pass smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pjdKTWoT"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c9aaa90a791so868165a12.3
        for <patches@lists.linux.dev>; Fri, 03 Jul 2026 19:12:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783131144; cv=none;
        d=google.com; s=arc-20260327;
        b=FUv+Zaz8wufPZ3zuSELicWcIeEcNd07dHKAHHgrzwc8EdMItWBD60h+P46ljLtZ0SA
         jqWuvIOl9Tjx/0pSqRdHvTJT7HSyJzBGrDjeSthY7+bKC5zT+suk4/d5Pc/K6UciHj6V
         pVD4zoAWrf31VvAmW4MHJMCZ203ssZD+IilJMV4kF/Msd/NIU/JnkOOqJrp55dUnhCOk
         X4jHUgXAJHTmdBX2cv9h/boQDdDTKLHzn9q0vL14RH3yFlfnMcYJP3D0tGIVLpV4tWke
         ViMlcIqQ97RKgDhl6PTijTUK1eVkqUbFy/zAm+1l6sc6++kwpferspidZnycRYpQBvzn
         MSVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qTEF+jxKV5MhhsYoWwK9gY1uoGZyNE3Vd1jsBxP2q4U=;
        fh=/YIEO1V6BwmWvyHGbw7o7wVY9jHLlVFIA8A9e2DDczc=;
        b=TwwT77dBTaRttTBF4h3kMfXB6P14+Fp5uY9qudwN49a8NKVWvdOD7oYs6C/c0MrMLm
         t5Tg9poVhI5sQd+LCi6LP+Y3wFF6OhET2WBGJkSrQkicmDQ61v9zt29e1YFMfwMYSwuZ
         btplj+5ixJYVtCHZ7/0zg4D+S4+v7WD/afkbEORGCq8uM4yvBYPa07LxpIJv9B3hGNwo
         zKF49evrXQFVnE1SMxkbLf79p+YFnBp7xf9jmIoI9Wqp+Fs1Xd5UN5HM4xQNLliaojEi
         LAw4ub6zo5bfIWQvsb2EJiUsru/oem2g5cAl5YbXmXkeLc1TrjELQfv/uDKF5wI2Q+sz
         Dw5Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783131144; x=1783735944; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qTEF+jxKV5MhhsYoWwK9gY1uoGZyNE3Vd1jsBxP2q4U=;
        b=pjdKTWoTR9ewEY+yvwDGLFSP/h0GfsiGmq/9xbminEPL7vfQ2/0iznrb4800jn9BRy
         HUhQ74kI1/R//DSoUKAR8VyrR28ghRIj+3IL83X9d92gMOCknyM/4vctid06OHoNlFoX
         IH7EXcXdRg1Era/SOMoVtVkQmZPP279udK9rTo4/crWcmXorIj8rfvQfhzXoAPgN7tOs
         Yq6321fbC7rCsqT4CyMSCUt7MGupseJpvpdUM+ORRerHNNOmaLlfp5nwWWyrt87wVfDV
         JjSu4B4Y+34bzNFK4M+63pxukADNMI0G7RVyaRzLOnkyFoPHWmJKWieh32zad+wdkZHq
         Pm8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783131144; x=1783735944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qTEF+jxKV5MhhsYoWwK9gY1uoGZyNE3Vd1jsBxP2q4U=;
        b=jC+IDYN7PpHchBx2nnurupaeC2o2OZgUuosHMGQEqbP8pXI1c8XLzQ66haszFSC5qr
         hFU1YvFNq/QwEHbMOWUlRRO6chvnM3CLSeYs1PK1pygkmxy7KQ+QqNFt3OenFZOMX8Za
         P5FdZyQ+TvZgWoN4Dy+oW+fBzSh96lIah0lOANPGoC07HgThKLjjvDpJa9oT0bITC/XN
         3c4IkAmyFxNKCFbuGtN7LcCjeI/VoKSxr4PiAlgRetx3fefRSQ+g75qiTgd4QIwK9QD4
         0Wpl6lcuDBbPMJahPnNiklGHfw5k8ra3NddE6Rj7uOqQYoLFx5KImerAIWfInK4sbZv+
         QprQ==
X-Forwarded-Encrypted: i=1; AFNElJ9sVuSXVcMPkWwemyNiPls1XWiM78oAG+tBtBVPQUk5yy3ntB88R2dxLv+emzCkaRv8AnCsDYfW@lists.linux.dev
X-Gm-Message-State: AOJu0YwUE7Mt1Q6tGo7XQL2DxZFN+qKYzFaYiadhxU839ZlU13KNvMX1
	nmfL4nNkwNL1ZFi/rTDzJ34kDDTu8ZBmPy/QQvFDTUCHzntY0/6XPwtEBHYXJkQq6m2zt5R0nrB
	RRdrEFQ1QDg6rRCRQtfinPIk/VM04rvY=
X-Gm-Gg: AfdE7cn/3tX5PYLfm+eUf4qmPfyeqU1HNmq7mNkdRKGR0nI8JeE9oU9OwCF1UpvGoIR
	d3QrS2dztowcnw2aK88PHhdd1vY9zUXWcrQ4PmDAjxgZqF9oxnsF/XqmExkJ2KU3EvzWDNgez8z
	AhkVn2MCTpyYmN7Y6vwX8NnRDNltGzHwjhO6oWYAsUj9AMeehVACt2QvqaLdYlCt/e2QDa2/9IY
	sOXexVwBPMYlTTOKDXrL63IpA2yDOgGN7un/JkuCmlMZtWg0TpAzESzBelwo0y7b5xnJf2Cnw==
X-Received: by 2002:a05:6a21:6a0d:b0:3b7:d9d6:9fc9 with SMTP id
 adf61e73a8af0-3c03e18bb27mr1523827637.2.1783131144242; Fri, 03 Jul 2026
 19:12:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260528194646.819809818@linuxfoundation.org> <20260528194657.359703301@linuxfoundation.org>
 <CAFQ-Uc-wu8fbTDXhtyODCz36_1DBue5ay7V2LpzjrUgHs+0WvQ@mail.gmail.com> <2026062933-storeroom-amusement-0b66@gregkh>
In-Reply-To: <2026062933-storeroom-amusement-0b66@gregkh>
From: maher azz <maherazz04@gmail.com>
Date: Sat, 4 Jul 2026 03:12:12 +0100
X-Gm-Features: AVVi8CcEcw0s9HAXZ2couWs6WgaDEK3NnV2KxkcK-KT-2qNjLaUUzpSlL-MEyBw
Message-ID: <CAFQ-Uc9p7PhXp-FC4N3iYAtyeKgN6z4A_+L8YwKDAkXxZAvksg@mail.gmail.com>
Subject: Re: [PATCH 7.0 345/461] vsock/virtio: fix zerocopy completion for
 multi-skb sends
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Arseniy Krasnov <avkrasnov@salutedevices.com>, Jakub Kicinski <kuba@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Thank you Greg, I already sent an email requesting a CVE for this
specific LPE vulnerability one week ago.

Best,
Maher

On Mon, Jun 29, 2026 at 5:40=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sun, Jun 28, 2026 at 08:31:35PM +0100, maher azz wrote:
> > Hello,
> >
> > Is there a CVE assigned to this issue already? Thank you for patching i=
t.
>
> <formletter>
>
> Please see:
>         https://www.kernel.org/doc/html/latest/process/cve.html
> for how kernel CVEs are assigned.
>
> </formletter>
