Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7560E7A
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 07:53:52 +0000 (UTC)
Received: by mail-ej1-f49.google.com with SMTP id dr20so33996259ejc.6
        for <patches@lists.linux.dev>; Tue, 22 Mar 2022 00:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AAxWSvxZc3dHAbuVIHS0Ej6XKzk9JLz41VAoFlDO6jw=;
        b=C0uPodIT8HkST7rvrjEAsthafRPgDgdeogyPa1un9cJDZbJa20Jdr8DaXZoQwie8Rp
         ixs06Tox9foTZsYh0W4rZGlhEGSSnf8vzLBth3PHPtfpjbQuwwT32koIj3xMhRkuE35h
         mE9UL6Phgcf5ouszXqr829JHPnvDZRTUYybjYSD/53BKorbjQtcPrFnpZBR0ewkTJHPf
         TChrG8h/DJhGId7IDw1fS/XN/NneBtnb39sgjeNm5wSbv8QEpQ1rDfP/KIYwYPTSHObU
         6AqyTDMaTD6K0p2jV7IDqmIO+bQqhSdnK8Xa8JlOKnyNXwcBWkmSV3st3WKB8oKoxPRM
         hhuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=AAxWSvxZc3dHAbuVIHS0Ej6XKzk9JLz41VAoFlDO6jw=;
        b=MHhd0YXXCeqpb5INofDBTnlgqSLVp06p/ZwHiQReF7kLtq+9ZWDMvPrXzbRdSuYeaQ
         stTOKte46+nDqZfh+hyxCVR/ijRP/2dd62wX09mUx2rXuW8vSsjipkd/gkfh/s+btOq+
         oJT8JtQI1U46BIv9zftjPoZcuHffmQUroPtYSxVfahUEmbytd7KtCphA0vprSvPMDnqU
         z1lMGZwMrFTt8V/twIcvz0LMdc9p1KaDO980RKlpmiTEt1UL49oQLN5KFs0jHAuCiWZD
         1RmnhdC3RISME7WQF/jZbKczm607WT6KnlQ+2wOtuAtuLKuJIRuVjG5JvifooCkdR20+
         rT3Q==
X-Gm-Message-State: AOAM5318T0X27oGCmi6FB+5tLDWcwN2f/6sz0g4buJ7mvJGWL+8bovtw
	+S6GIG8Di2XvvW4woOkm2L8=
X-Google-Smtp-Source: ABdhPJxhTfnbx2XGatBlTfA7tIzj0wD63Dzv0AJ5fDSXXhpdMy6c64spTxxCKLobqnFlUuWCj4acoA==
X-Received: by 2002:a17:906:69c5:b0:6cf:d164:8b32 with SMTP id g5-20020a17090669c500b006cfd1648b32mr24065603ejs.233.1647935630735;
        Tue, 22 Mar 2022 00:53:50 -0700 (PDT)
Received: from gmail.com (0526ECD0.dsl.pool.telekom.hu. [5.38.236.208])
        by smtp.gmail.com with ESMTPSA id l20-20020a1709062a9400b006ce71a88bf5sm7763971eje.183.2022.03.22.00.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 00:53:49 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 22 Mar 2022 08:53:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH -next] sched/headers: ARM needs asm/paravirt_api_clock.h
Message-ID: <YjmAihCq5jtUVXvq@gmail.com>
References: <20220316204146.14000-1-rdunlap@infradead.org>
 <Yjib7hDFRFEOwaWf@dev-arch.thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yjib7hDFRFEOwaWf@dev-arch.thelio-3990X>


* Nathan Chancellor <nathan@kernel.org> wrote:

> On Wed, Mar 16, 2022 at 01:41:46PM -0700, Randy Dunlap wrote:
> > Add <asm/paravirt_api_clock.h> for arch/arm/.
> > 
> > Fixes this build error:
> > 
> > In file included from ../kernel/sched/core.c:81:
> > ../kernel/sched/sched.h:87:11: fatal error: asm/paravirt_api_clock.h: No such file or directory
> >    87 | # include <asm/paravirt_api_clock.h>
> > 
> > Fixes: 4ff8f2ca6ccd ("sched/headers: Reorganize, clean up and optimize kernel/sched/sched.h dependencies")
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Russell King <linux@armlinux.org.uk>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: patches@armlinux.org.uk
> 
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>

Applied, thanks!

	Ingo
