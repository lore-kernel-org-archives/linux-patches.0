Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA63C192585
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 12:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728475435; cv=none; b=LUcdKLCK+oP4crdH9zexg2f8gGtHG1/LxhHbn2p9ZMp8jxsWur1nFnB9lQmGgOVRxmqa4t9MGZ5rPQyoIy+9MTUqGI/LbQ1WC8z3+6yxG04n4/RX9aGwoUn6UdNtr/Vzaap5c9yjJGQ5OzV6Cr42/9+4hmgQJTNljHwwtmH+qeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728475435; c=relaxed/simple;
	bh=d8Kavz4pG0DrcMSTG519JLahfgY0ngVMi+UX0VgfOxk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O0Fot+FTij6KtnoUBAnrWdy+BHubld4ZYK58BbFE1P1lP+UDPvtxVDzsPhnsuCMoy6GbHYuYaTXZHmxkP3wAreJDaJmP4xJEOlM4v3c/TN3U5+7I0hSg60+6aImCk+lWXIxEmNW0NOcjm4zCcRKQtOJRU5LKxagOUS0P6UpvgkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aaRKU9pf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aaRKU9pf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728475432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d8Kavz4pG0DrcMSTG519JLahfgY0ngVMi+UX0VgfOxk=;
	b=aaRKU9pf/FlOC5TYh/NYDWzJD7cArUf6VXNH9in96tJDZpYfgSFNFo4r/IHj+AXeZekcQ6
	2qR4g6Hr0qvKJ7NrY1nUNnrDouLsdTix7vk6DJIzte6tGZtzvEwfPQi3yL3j8VQPSBGZpw
	NmiU0ZEp/bB1hNofzw36WVnPsldfEkY=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-5Np2OYQwNFGVSKlb7EFtjQ-1; Wed, 09 Oct 2024 08:03:51 -0400
X-MC-Unique: 5Np2OYQwNFGVSKlb7EFtjQ-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-287b3c7faf8so4115008fac.2
        for <patches@lists.linux.dev>; Wed, 09 Oct 2024 05:03:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728475430; x=1729080230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d8Kavz4pG0DrcMSTG519JLahfgY0ngVMi+UX0VgfOxk=;
        b=bv9mJtBn2U9ucHMp+YtTN4rgRba7IruVoHm+gX22H/zE4BJSXBs13CMXJmxngSBWlN
         qSBc2RhAjdFY1qvYowYAllPM+jxcYRPf108hfH/q+XH5qatBkDNejLaKy6NTxem3A80A
         Xb0FHChUYQmzE3NlB38eA9ZOh4rGehekoQVbBd01EFC3mOD3f9tRhol+OMXAdxdGxPJz
         hZIySan4tkN8jUxCna6VYP/UfC2OxpqtTub4O+gi6roa7QCuixmISBsj3FBrLZuZD/UA
         t05gwdkd6jG2SAf0ZVIL74uXNy1N/mJK3cLpE8J+GwsOSPFfNkGm/WpPonu4kTuTYLpI
         yBAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbLJCJl+t6FmGvaLGwA/iGALoq8XZIt4wkWGh4byJOnVuRpLQZQoZigX2+GmSItrl+hmDlssrO@lists.linux.dev
X-Gm-Message-State: AOJu0YxaXRc83DP7JC4+iIzNc3a+AOjFetm11KJ38wTHvMIo0xrD+rU4
	Tv6KHjQlPofiMGzsnthgz98DuoVWlAf9uXDltaixZv7v4YWidZZDsUc7rsmLhHVCP/as9MbiV0O
	w8X9VPSRvbgobZgzV62afFca9tXW1tadgYEgoOJSDzE+bb58Uy7m7RY3NwV5wPhjCTdufE9Ey64
	poEpxlrj4nmthnzJkB0q4xcnq2qyY2jg==
X-Received: by 2002:a05:6870:d88e:b0:261:f30:fda3 with SMTP id 586e51a60fabf-288343063c1mr1385929fac.21.1728475430458;
        Wed, 09 Oct 2024 05:03:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEunAW49fg9TRqfk2Wul+wjLgorZM7rhrZCbIHsry+h80qprHZ8RuUHrprF5ApY/0Yivrsxi+udN4/j+iPW3fY=
X-Received: by 2002:a05:6870:d88e:b0:261:f30:fda3 with SMTP id
 586e51a60fabf-288343063c1mr1385884fac.21.1728475430088; Wed, 09 Oct 2024
 05:03:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241008115648.280954295@linuxfoundation.org> <CA+G9fYv=Ld-YCpWaV2X=ErcyfEQC8DA1jy+cOhmviEHGS9mh-w@mail.gmail.com>
 <CADYN=9KBXFJA1oU6KVJU66vcEej5p+6NcVYO0=SUrWW1nqJ8jQ@mail.gmail.com> <ZwZuuz2jTW5evZ6v@yuki.lan>
In-Reply-To: <ZwZuuz2jTW5evZ6v@yuki.lan>
From: Jan Stancek <jstancek@redhat.com>
Date: Wed, 9 Oct 2024 14:03:31 +0200
Message-ID: <CAASaF6wdvXAZyPNn-H4F8qq6MpHmOOm9R+K+ir9T_sOG-nXpoA@mail.gmail.com>
Subject: Re: [LTP] [PATCH 6.10 000/482] 6.10.14-rc1 review
To: Cyril Hrubis <chrubis@suse.cz>
Cc: Anders Roxell <anders.roxell@linaro.org>, Jan Kara <jack@suse.cz>, lkft-triage@lists.linaro.org, 
	allen.lkml@gmail.com, stable@vger.kernel.org, shuah@kernel.org, 
	f.fainelli@gmail.com, jonathanh@nvidia.com, patches@kernelci.org, 
	linux@roeck-us.net, srw@sladewatkins.net, broonie@kernel.org, 
	LTP List <ltp@lists.linux.it>, Christian Brauner <brauner@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	rwarsow@gmx.de, pavel@denx.de, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, conor@kernel.org, 
	patches@lists.linux.dev, akpm@linux-foundation.org, 
	torvalds@linux-foundation.org, sudipm.mukherjee@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 9, 2024 at 1:56=E2=80=AFPM Cyril Hrubis <chrubis@suse.cz> wrote=
:
>
> Hi!
> Work in progress, see:
> https://lists.linux.it/pipermail/ltp/2024-October/040433.html

and https://lore.kernel.org/linux-ext4/20241004221556.19222-1-jack@suse.cz/

