Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4699456
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 08:02:02 +0000 (UTC)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-991f956fb5aso528494066b.0
        for <patches@lists.linux.dev>; Mon, 17 Jul 2023 01:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689580920; x=1692172920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Md2k3SrB9PFNNZtXw1D5bjJvxlmODL3oFcv29rGU+0w=;
        b=Tj9ESHlAIEY5Ok+t1+UQEqgXZpFohXw53hftfkkBeDtkJIo0nBvLvFnisMxq5Rj2iQ
         8PdNEnjyaoS3UOEi9nMjIifEQFGggbFY24svukX5rnVJOCICfNyxM2s59REzz8UWfsIp
         ZawCt/JduBAq7tD9sQFEtpyhZCVMxmJef/ARUOi/5XgDoiiri8ZVk3Ooe/THn+zFXcTM
         z4EiPvrbE/5ScWF5My9n5UAxbY+/u23lKTRQJM9dJ7+ItLjDQcSZkrc1jpUqsaxNIZmm
         zG/iJhwiSZQr96qBLHcF2SeD/Hsp4E00qsw5D1bKsKirfD/yPzGiMrlGRgYG+Tvf2j6d
         BgYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689580920; x=1692172920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Md2k3SrB9PFNNZtXw1D5bjJvxlmODL3oFcv29rGU+0w=;
        b=kysSqEozzFohlGL+RFakrGHo9EPULOApHbg7DQsjcfzKgM5EcI9uknmDUspX8DKsgX
         03RCdu6OdH5YuzAYKD7OvNwnLf0Z/MLD8CId4hmF7Evqpn56xnhxlzlXBTYuTkuMbzF+
         QFoaRqT6U1sRIGUp2QqJsyeaU5TvNiWjY0M/Fhm56Czoa+6/4if88Ib23yH4ybuESdoG
         Y0tWY1SuhkOSAn5UMpeCZF3ImxYw3lLbzzt5ce33EM7cKAwSb8aNW+O1zE8C8sY/JC9H
         m0UZL521ATDIlLn23zxjbeLbVvNfGU0MzU/tC8iEow9b9Vslnj65luPGxU6vF50XyCXi
         lC/Q==
X-Gm-Message-State: ABy/qLYb2K9CqOpIGfLpXSG0XheVyCPyF/Dc5DPvCe4ffY7UZw3vL5dN
	nqIrr7gt6gKlnqCn89MjgYF10Z6eeWN+zJylbiA=
X-Google-Smtp-Source: APBJJlHZQRmdkq0uytrbJpI4dB8Hr+FJMXkrPe3TaMiMWBSlVina9KNg9TPqxFql3z1+rKwkjMtlLgZZSjtgMCU/25g=
X-Received: by 2002:a17:906:20d6:b0:994:4e9c:30c6 with SMTP id
 c22-20020a17090620d600b009944e9c30c6mr3743404ejc.57.1689580920270; Mon, 17
 Jul 2023 01:02:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <b99a5149-c3d6-2a9b-1298-576a1b4b22c1@gmail.com> <0206e2ce-ff33-6017-15ab-cc89f1eb7485@augustwikerfors.se>
In-Reply-To: <0206e2ce-ff33-6017-15ab-cc89f1eb7485@augustwikerfors.se>
From: Nils Kruse <nilskruse97@gmail.com>
Date: Mon, 17 Jul 2023 10:01:49 +0200
Message-ID: <CAKVFSw+_EFNaYjOjNDQ0zOGoSFMt3yZctR47Rcss2KhkfNQJ9g@mail.gmail.com>
Subject: Re: [PATCH] nvme-pci: Add quirk for Samsung PM9B1 256G and 512G SSD
To: August Wikerfors <git@augustwikerfors.se>
Cc: stable@vger.kernel.org, Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>, 
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 16, 2023 at 9:30=E2=80=AFPM August Wikerfors <git@augustwikerfo=
rs.se> wrote:
>
> On 2023-06-11 13:41, Nils Kruse wrote:
> > Add a quirk for Samsung PM9B1 256G and 512G that reports duplicate ids
> > for disk.
>
> Is this the same issue with suspend as [1], [2] and [3] or is it a
> different case?
>
> [1] https://lore.kernel.org/all/20221116171727.4083-1-git@augustwikerfors=
.se/t/
> [2] https://github.com/tomsom/yoga-linux/issues/9
> [3] https://lore.kernel.org/all/d0ce0f3b-9407-9207-73a4-3536f0948653@augu=
stwikerfors.se/

Yes, this is the same issue.
