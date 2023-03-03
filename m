Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDADF8F53
	for <patches@lists.linux.dev>; Fri,  3 Mar 2023 18:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E15CC4339C
	for <patches@lists.linux.dev>; Fri,  3 Mar 2023 18:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1677867403;
	bh=z9o+Fj7F9hEekeJkNgNCjr/Inru7KzeAHF1ZoYV9Iio=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tIJ7IPJ4KHsGCVQmNJVMq0GTuDbB7zi4lEH2qhnGRtaBwTofmI+hMCDYpA9763zfj
	 hnCWxc4EDetFEydMYfJYVCKCnuqX7lzBkQNF/3hHX/fFqg2w68Dz/J2NPZRFMC+ExQ
	 nspd4IdvGbl0PjPL3X5dDPVxgtnZL8vGWmW4GwY5J2Ab+G4cboaTKsqbRv/CUgJjYd
	 AlHYoz2pmiJ8UmkE+Tcrvn5IMXyPncF7oLw9cGdunMOy6vRssudSH3Yt9drtUnuDjJ
	 Tu0KBhBdcw9N12uoTUkInH/QUAcuy6fCuLrl3Q9h0Y1mx8oQdTybds27iOc5OdWhww
	 mcEJSCHEURnWg==
Received: by mail-lf1-f49.google.com with SMTP id j11so4658797lfg.13
        for <patches@lists.linux.dev>; Fri, 03 Mar 2023 10:16:43 -0800 (PST)
X-Gm-Message-State: AO0yUKX4zUCq8w9u0thoUEoVoILYNWehtDXbV8OJXh65h00M5IgNpmbk
	/0Dw8K080/V2wuD2mDOAu9zKi0rMF2mCXfMRxm0=
X-Google-Smtp-Source: AK7set8+TKohTy6ON4qynrd6qM7FwtWsRtV8zfmEmFF5syO7UhwA/Y8VS4hyO7ZdSGW9G+CTTREWUsKalOtJ4y3BnUw=
X-Received: by 2002:a05:6512:3c83:b0:4d8:86c2:75ea with SMTP id
 h3-20020a0565123c8300b004d886c275eamr3273736lfv.3.1677867401669; Fri, 03 Mar
 2023 10:16:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230302204612.782387-1-mcgrof@kernel.org> <20230302204612.782387-5-mcgrof@kernel.org>
In-Reply-To: <20230302204612.782387-5-mcgrof@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 3 Mar 2023 10:16:29 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4k1hpLDWcQGCtEeR6LEgSboTY+tqbiPp+30_2T+rFezw@mail.gmail.com>
Message-ID: <CAPhsuW4k1hpLDWcQGCtEeR6LEgSboTY+tqbiPp+30_2T+rFezw@mail.gmail.com>
Subject: Re: [PATCH 4/7] md: simplify sysctl registration
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, minyard@acm.org, 
	kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org, 
	decui@microsoft.com, robinmholt@gmail.com, steve.wahl@hpe.com, 
	mike.travis@hpe.com, arnd@arndb.de, gregkh@linuxfoundation.org, 
	jirislaby@kernel.org, jgross@suse.com, sstabellini@kernel.org, 
	oleksandr_tyshchenko@epam.com, xen-devel@lists.xenproject.org, 
	j.granados@samsung.com, zhangpeng362@huawei.com, tangmeng@uniontech.com, 
	willy@infradead.org, nixiaoming@huawei.com, sujiaxun@uniontech.com, 
	patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-raid@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Mar 2, 2023 at 12:46 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> register_sysctl_table() is a deprecated compatibility wrapper.
> register_sysctl() can do the directory creation for you so just use
> that.
>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Acked-by: Song Liu <song@kernel.org>

Thanks!
