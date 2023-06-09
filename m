Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992FCC8FA
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 09:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237B0C433A0
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 09:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686302273;
	bh=RQisGjj9KL7kg1igwwGHNm1IZaL2rbAG8kSrlm0JzKg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AYraXdMUTfAMqpeTaUeCqi+yUkaXnP8qNG0uUj3/dT/XFGJuKr4o+c5xAf+JLd9OT
	 o/jhll2InOsaLOaIApJVfzoypOS9floki0PYvS8xve4kgU+nkmLV/22ax/2NQOGGY5
	 stsHcklrZI2UIzZAznhNDRG2nYuiQleNWOixh1Un8C6MJ5cDXuW8Pwoh08f/jT0khW
	 x7CSsVUFSaZT3KMig1u6PEezo+U3P1kUZ175xUp7GxwEc6WQisXeBJpxJ+9q1PF3SC
	 4Trwib6QuE59m3YADNR97K01Cw27sz39k7OX9Yk7WSL11jxH8ig3Wrb04syqBYcuLT
	 09LTndIC9BMMg==
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-3f738f579ceso11218815e9.3
        for <patches@lists.linux.dev>; Fri, 09 Jun 2023 02:17:53 -0700 (PDT)
X-Gm-Message-State: AC+VfDwoBilJOPjqZj8uQ8DzsJVw/UtPtEjAPuO4TEogfNlOV0BM+fkh
	mCnm/UrNPeDFGB2fnYrlWAihPPXJmsxG6xr1ff0=
X-Google-Smtp-Source: ACHHUZ70M63/s5OAb5SuDf8GVqAjthMUYLs718VlOe6y2HvimEHtOeklfwr9dXNjNX4PdOTUT/IHiblpHj8LQ8LvlE4=
X-Received: by 2002:a7b:c8d7:0:b0:3f4:2cb2:a6cf with SMTP id
 f23-20020a7bc8d7000000b003f42cb2a6cfmr423308wml.10.1686302271124; Fri, 09 Jun
 2023 02:17:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230608032404.1887046-1-mcgrof@kernel.org> <20230608032404.1887046-5-mcgrof@kernel.org>
 <ZIHZngefNAtYtg7L@casper.infradead.org> <ZIHcl8epO0h3z1TO@infradead.org>
 <ZIITpjDXyupKom+N@bombadil.infradead.org> <ZIKofhpTXREOR3ec@infradead.org>
In-Reply-To: <ZIKofhpTXREOR3ec@infradead.org>
From: Luis Chamberlain <mcgrof@kernel.org>
Date: Fri, 9 Jun 2023 02:17:39 -0700
X-Gmail-Original-Message-ID: <CAB=NE6V-w+NWTZ0tZaUNhOH2uW7T3EEYKt-+YhkDX6tZZ8BccA@mail.gmail.com>
Message-ID: <CAB=NE6V-w+NWTZ0tZaUNhOH2uW7T3EEYKt-+YhkDX6tZZ8BccA@mail.gmail.com>
Subject: Re: [RFC 4/4] bdev: extend bdev inode with it's own super_block
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <willy@infradead.org>, djwong@kernel.org, dchinner@redhat.com, 
	kbusch@kernel.org, hare@suse.de, ritesh.list@gmail.com, rgoldwyn@suse.com, 
	jack@suse.cz, patches@lists.linux.dev, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, 
	p.raghav@samsung.com, da.gomez@samsung.com, rohan.puri@samsung.com, 
	rpuri.linux@gmail.com, corbet@lwn.net, jake@lwn.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 8, 2023 at 9:20=E2=80=AFPM Christoph Hellwig <hch@infradead.org=
> wrote:
> Again, every non-trivial file system right now has more than one set
> of aops per superblock.  I'm not sure what problem you are trying to
> solve here.

Alright, a 2 liner does indeed let it co-exist and replace this mess, thank=
s.

  Luis
