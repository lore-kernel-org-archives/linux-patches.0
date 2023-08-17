Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46739168D6
	for <patches@lists.linux.dev>; Thu, 17 Aug 2023 19:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C4DC433C8
	for <patches@lists.linux.dev>; Thu, 17 Aug 2023 19:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692299040;
	bh=F7AD3M4xNl1qSRA2L9BRUkJkg9IqWDtyg701TZMULmY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lopif8b3h5LOT7baNb0sCKlKzxCsccYJ37QhyUVyjn/Hxmgcbd2Fvcr9GzOKq0e0r
	 ZHevELZlOH2tmyI46Ct15W/vhQGsyCX07CCQ7VoUhWqk1d0rMqXxk8rTePxljgyp4f
	 QRC6JjQJCwA+BcDpBHzfXl7x62bW3iTWdmyzdsPoyHjl3GYeSu1q606aHdz0POzLg7
	 Q0fvdSHd6i8sDuEILdZLXGmNiGugyK/AhYoP5SH8Gssw1zEvqlhUqccP9kjgB+ffBP
	 KN48Z5Vn9p7Qbt8iqGBPvSgN9lvdaAphhqDkveqSLo9VHBa7H7HVA7vDy1wds6p2Wy
	 i8vKH2JbhRoOQ==
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-3fe1e1142caso1939735e9.0
        for <patches@lists.linux.dev>; Thu, 17 Aug 2023 12:04:00 -0700 (PDT)
X-Gm-Message-State: AOJu0YwrgakQKCGxz+WFeX0r5ZL8qGQ2HSQyvJ2kCWeogXXbntCowkRx
	ShcGDfL5kv2JL+QHoBFQQ85ld5rFVkwrHE/n7RQ=
X-Google-Smtp-Source: AGHT+IGjaEP/Rbc/WSZSks4drzyJM7H4wWVB/dEDXwBTiNBNGTVxuD3j4GdAFMnW+RvzIeE+x1BCpV/BtH5U1AyCGsI=
X-Received: by 2002:a7b:c395:0:b0:3fe:f45:772d with SMTP id
 s21-20020a7bc395000000b003fe0f45772dmr469853wmj.28.1692299038327; Thu, 17 Aug
 2023 12:03:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZMwi5oDiAKGpPh8B@bombadil.infradead.org> <0b69bd4142afc5be0a8d76d00373d93317f609c3.camel@kernel.org>
In-Reply-To: <0b69bd4142afc5be0a8d76d00373d93317f609c3.camel@kernel.org>
From: Luis Chamberlain <mcgrof@kernel.org>
Date: Thu, 17 Aug 2023 12:03:46 -0700
X-Gmail-Original-Message-ID: <CAB=NE6WiZJmMr0=OuVooNaaTbTz62HwTpQtAswoVVBdqtB_mSQ@mail.gmail.com>
Message-ID: <CAB=NE6WiZJmMr0=OuVooNaaTbTz62HwTpQtAswoVVBdqtB_mSQ@mail.gmail.com>
Subject: Re: Mailing list request for kdevops enable persistent disks
To: Jeff Layton <jlayton@kernel.org>
Cc: rt@kernel.org, chandan.babu@oracle.com, amir73il@gmail.com, 
	josef@toxicpanda.com, a.manzanares@samsung.com, 
	patches <patches@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

We have a mailing list now:

https://lore.kernel.org/kdevops/
https://subspace.kernel.org/lists.linux.dev.html

  Luis
