Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061E52565;
	Tue, 14 Mar 2023 08:07:01 +0000 (UTC)
Received: by mail-lj1-f177.google.com with SMTP id h3so15076358lja.12;
        Tue, 14 Mar 2023 01:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678781220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iwDokkDCp3gvd4WNjn3p9IwIzF1O1UFas2ZgKmXkVJI=;
        b=BnpTt+CwtlFY0mm8gOhspRyImXLr2eyZ/8mVMFuQBCPLXA7cgKRp5FDKgWxU2om0Cn
         DaVCITLeQBWUgPNQLBOyXgmsXeXm3RuzC22bj+DeBxUw0kqNJKaa18QbhPaTSXPMFRzF
         4m9N3/ffmAPfMfcXLqwetrZWe3qW80RyPPp3dh3N/AjblVvsR66tle0XyX6BvPJqs9W0
         muyM5KEcEezxwN45H3z43xdKGb3gK06bkCnoS9Tawhi3hGBdNO1i6kqC3hfufzQsToEY
         fNFjW6asyErZQdSYv0FOLw9CKDYlOk/2lCD9iS77cHUm0AMfOOGtKU4WKdFuvyxomDVE
         Oq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678781220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iwDokkDCp3gvd4WNjn3p9IwIzF1O1UFas2ZgKmXkVJI=;
        b=MqzECkzu7aBDa5/LLDcEJDEtG4O6WeGMndu3jLmxcOjNhpEhQN1KxOo9l6ZoNqFI9D
         JJsBSwAxPTlX6UP2fcepn8TQrwS2PxsMQrjbQYUSAFVr5/e4Zy64yUw033m7iLF6vcSJ
         Fq7DoBSt9Bkc99gOx5PMieTS5aktJr+5z4Qqw8KrDp3g1l90rmdYu80ShBy9VAGXoNSv
         kIm60whCKCioi6h9UJ05/yNcHZbOcGOL8J9Jw5X4OXITca7sxbtU6XILW3jPeW7wHTOx
         ZyQVGRDorGeBte8MPkJvNuIsUUVxSnJyVnsZle1n4P7GS4/N8H5QUCv83gU4zWH+31hc
         cOaA==
X-Gm-Message-State: AO0yUKWbUOxj1ujIyLVn1qnnDXA3rEL21yPWEOzEpN63TIs255TwhY96
	GT4nrDftGGww/M/bgwjIeiJrE97WT6mEtDVas/0=
X-Google-Smtp-Source: AK7set8ikbfZwHpd0zd3uhb8WhF1wXT9RDCk4Kevrrp3L4QFWYrViPVbZZ4pvMSKv6L1Ml/llbqKy/R0trZedVRhsW8=
X-Received: by 2002:a2e:7011:0:b0:295:ba28:a43 with SMTP id
 l17-20020a2e7011000000b00295ba280a43mr5249701ljc.4.1678781219868; Tue, 14 Mar
 2023 01:06:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230308131934.380395-1-gregkh@linuxfoundation.org>
 <660ef0b7-fb09-5a72-57b1-3b57ddee924e@gmail.com> <ZAxZCJn7AN/yWSRh@equinox> <ZAxx1kYjVKFRE3kz@kroah.com>
In-Reply-To: <ZAxx1kYjVKFRE3kz@kroah.com>
From: Richard Weinberger <richard.weinberger@gmail.com>
Date: Tue, 14 Mar 2023 09:06:46 +0100
Message-ID: <CAFLxGvwKaXviF=5OTtm+pPHwdtXTX6A2e_aRTUraOsxKOL3-4A@mail.gmail.com>
Subject: Re: [PATCH] staging: r8188eu: delete driver
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Phillip Potter <phil@philpotter.co.uk>, linux-staging@lists.linux.dev, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Hans de Goede <hdegoede@redhat.com>, Martin Kaiser <martin@kaiser.cx>, 
	Larry Finger <Larry.Finger@lwfinger.net>, linux-wireless@vger.kernel.org, 
	Jes.Sorensen@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 11, 2023 at 1:25=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> > > > Also the rtl8xxxu driver supports way more devices, and is a fracti=
on of
> > > > the overall size, making this a much better overall solution.
> > > >
> > > > Thanks to the r8188eu developers and maintainers and reviewers over=
 the
> > > > years, your work allowed Linux users to use their hardware before t=
he
> > > > real driver was implemented properly.

Both r8188eu and rtl8188eu had support for access point mode but
rtl8xxxu has none AFAICT.
Is there something in the pipes to have AP mode supported?
