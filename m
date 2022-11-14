Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DFC749D
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 17:25:29 +0000 (UTC)
Received: by mail-wm1-f53.google.com with SMTP id p16so7958132wmc.3
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 09:25:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rk/31HBoHkJxXf6djtc/uU3Q17y+7Ai7L4MxYQ2v+II=;
        b=uw52SpnRbr6zZot+h/NxwXQEovRY7hxkMrguvnq0+AWY82+Medp8qzt4j8sles6qWv
         cR5wqnGJ0+7UlHMQWPEC6mmK8WuFWyfgxZeQG41cMRWMFsqehmG16X1vfcHrhUwUxicC
         Kap8rJQmbHkfa2L1lPrhQrBOPBXlP3kr5lq6ijE7jbO65Al+SaF/NBnEehOXUDwIB/9A
         BmE9iqH07phlN7AGy5/p+BWz+ND7Sn0lkPB2mlcto/2zbDXoTMylyc1/J0ABHPFV4fMY
         08qCLr9nT7tXyEgNLe6d6CsquwdSaQYE4xjQWiispKhNrL/gMw2VIgfYPF8elJBGoR5y
         DrHQ==
X-Gm-Message-State: ANoB5pmVQs+OQtvX9qv3fyCPHDkm66389pByDkEZdEcagFUzLGQSV6wD
	qEsY9NyADJttSOttadcegeO/Bj26D90=
X-Google-Smtp-Source: AA0mqf5HMC/eh9L0x7KAEkhUl/NoLQhWWWi547gKmrlakHepkposHqlYkLyXePIcH39s31ZOffkfaA==
X-Received: by 2002:a05:600c:818:b0:3cf:54f4:eea with SMTP id k24-20020a05600c081800b003cf54f40eeamr8933017wmp.105.1668446728117;
        Mon, 14 Nov 2022 09:25:28 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id by7-20020a056000098700b002368a6deaf8sm10265378wrb.57.2022.11.14.09.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 09:25:27 -0800 (PST)
Date: Mon, 14 Nov 2022 17:25:25 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Wei Liu <wei.liu@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v1 07/28] rust: macros: take string literals in `module!`
Message-ID: <Y3J6BetkCdIw7LbZ@liuwe-devbox-debian-v2>
References: <20221110164152.26136-1-ojeda@kernel.org>
 <20221110164152.26136-8-ojeda@kernel.org>
 <Y3JU5xAGv3bNG7q2@liuwe-devbox-debian-v2>
 <CANiq72mE5=R4fv4Qee+hEkuXSHPjO3RzmOU45mqE3ztJ8XfS4A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72mE5=R4fv4Qee+hEkuXSHPjO3RzmOU45mqE3ztJ8XfS4A@mail.gmail.com>

On Mon, Nov 14, 2022 at 05:46:05PM +0100, Miguel Ojeda wrote:
> On Mon, Nov 14, 2022 at 3:47 PM Wei Liu <wei.liu@kernel.org> wrote:
> >
> > What's the rationale behind allowing UTF-8? Why not stick with ASCII
> > only?
> 
> The reason is that there are already some cases on the C side.
> 
> For authors, there are about 158 non-ASCII in the kernel tree (if I
> grepped correctly), e.g.:
> 
>     MODULE_AUTHOR("漆鹏振 (Qi Pengzhen) <aric.pzqi@ingenic.com>");
>     MODULE_AUTHOR("Martin Povišer <povik+lin@cutebit.org>");
>     MODULE_AUTHOR("Jérôme Pouiller <jerome.pouiller@silabs.com>");
>     MODULE_AUTHOR("Uwe Kleine-König <u.kleine-koenig@pengutronix.de>");
> 
> There are also a few descriptions too, e.g.:
> 
>     MODULE_DESCRIPTION("NAND flash driver for OLPC CAFÉ chip");
>     MODULE_DESCRIPTION("NHPoly1305 ε-almost-∆-universal hash function");

Okay. That's fair enough.

Thanks,
Wei.

> 
> Cheers,
> Miguel
