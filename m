Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384837B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 10:33:48 +0000 (UTC)
Received: by mail-wm1-f53.google.com with SMTP id m25-20020a7bcb99000000b003e7842b75f2so4956107wmi.3
        for <patches@lists.linux.dev>; Sat, 11 Mar 2023 02:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20210112.gappssmtp.com; s=20210112; t=1678530826;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gaevICdR3uGJO5MxpE9/ghmqPbvg20KO7Uq8/0/lElI=;
        b=emSO3Ntc3y8Ed/e0M6rK2CzinbJ/kW/LVOBDc/VojclQCZ1Bq9oubYUzVD4Zqwd93v
         ig8vypNywV/cwqYyaOZxvQL+S2lVSlqknsUnyfRpIXPZ++lwN4nMt7qmYN5cxcgYqSwe
         D5GBQ8lcNPmmCYVHLUqo7ql4auo2WAxk3aiUqGq4SlBXWul7ga7Q6G1Xt94VhyiYhjrx
         otpdD2DeGwUXfFYCgfdyVDErYZi0XOEEYEu+E9Jbv59xokdyPtcraO2IZvTyzATwBEWE
         /uCRYLJU8dFpAv/X8SXAla1mIjIE9PkepA9G6GM1aJ+kJrl2y6DD6m+zoEBXDPLz6gQD
         PJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678530826;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gaevICdR3uGJO5MxpE9/ghmqPbvg20KO7Uq8/0/lElI=;
        b=5hqG7N3mtknndj613vzmkGiliMaHaDFBUNmRNxLPQGLHIobjWIGcNG5Eo7O+V2XCQl
         G2dGp5vDeo7fJKXzFGTuOwShnIwOq+0pnFyo5X2D0PGkLWF4+9yuBLJF27DwZKOBuoLm
         Tjp/7BKzoLJg+b5EkY24Xh99SaCpm72tPZ1kx1NiP7FwO46TxjQnUsAnDLLBjyu/R2d/
         4wyDMghHdQ9mBD7SvMJlNyQy7sqUJxCNr/2eYMFaViiDIOxs+qbbQcofzJdqCV4arqz3
         +0OWvku2PHEtv01kGWuKued+275fJ5TELeiSr6xBA0utaL4Oh6Lj/2SCqQUIwOHAo2un
         QYyw==
X-Gm-Message-State: AO0yUKXaDblFuLydm5kSZPCciaRqF3MGyCvQSgFU/4w0aEPV6LWM7LaT
	uPxYnEuEcG+7KGUhAemRxKBK5g==
X-Google-Smtp-Source: AK7set/iRv1xyDHWGGtSBzAFSZCaRqPduvE3iyIsLdkTOHrtBj3iqh1jlWldZhQpqywYdibCTCMUrw==
X-Received: by 2002:a05:600c:3582:b0:3eb:38b0:e748 with SMTP id p2-20020a05600c358200b003eb38b0e748mr3708086wmq.13.1678530826415;
        Sat, 11 Mar 2023 02:33:46 -0800 (PST)
Received: from equinox (2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.a.1.e.e.d.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:dfde:e1a0::2])
        by smtp.gmail.com with ESMTPSA id 14-20020a05600c228e00b003e118684d56sm2424066wmf.45.2023.03.11.02.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 02:33:46 -0800 (PST)
Date: Sat, 11 Mar 2023 10:33:44 +0000
From: Phillip Potter <phil@philpotter.co.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
	Martin Kaiser <martin@kaiser.cx>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: r8188eu: delete driver
Message-ID: <ZAxZCJn7AN/yWSRh@equinox>
References: <20230308131934.380395-1-gregkh@linuxfoundation.org>
 <660ef0b7-fb09-5a72-57b1-3b57ddee924e@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <660ef0b7-fb09-5a72-57b1-3b57ddee924e@gmail.com>

On Fri, Mar 10, 2023 at 10:08:49PM +0300, Pavel Skripkin wrote:
> Hi Greg,
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> says:
> > Now that the same hardware that the r8188eu driver supported is
> > supported by the real wireless driver rtl8xxxu, the r8188eu driver can
> > be deleted.
> > 
> > Also the rtl8xxxu driver supports way more devices, and is a fraction of
> > the overall size, making this a much better overall solution.
> > 
> > Thanks to the r8188eu developers and maintainers and reviewers over the
> > years, your work allowed Linux users to use their hardware before the
> > real driver was implemented properly.
> > 
> > Reported-by: Hans de Goede <hdegoede@redhat.com>
> > Cc: Martin Kaiser <martin@kaiser.cx>
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: Phillip Potter <phil@philpotter.co.uk>
> > Cc: Pavel Skripkin <paskripkin@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> 
> I guess, I am late to the party, but if it matters
> 
> Acked-by: Pavel Skripkin <paskripkin@gmail.com>
> 
> 
> 
> 
> With regards,
> Pavel Skripkin

Same here, won't make it into the deletion commit log entry, but:

Acked-by: Phillip Potter <phil@philpotter.co.uk>

Regards,
Phil
