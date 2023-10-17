Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E928018E0F
	for <patches@lists.linux.dev>; Fri, 20 Oct 2023 11:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nGzljdv4"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B205E40E014B
	for <patches@lists.linux.dev>; Fri, 20 Oct 2023 11:18:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 0NrKxxP_AzYD for <patches@lists.linux.dev>;
	Fri, 20 Oct 2023 11:18:37 +0000 (UTC)
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 131EA40E0196
	for <patches@lists.linux.dev>; Fri, 20 Oct 2023 11:18:37 +0000 (UTC)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Fri, 20 Oct 2023 13:18:36 +0200
Resent-Message-ID: <20231020111836.GDZTJiDHnbcq9182yX@fat_crate.local>
Resent-To: patches@lists.linux.dev
Received: from mail.alien8.de
	by mad with LMTP
	id JuU4M1bULmXxJyIAc81XFw
	(envelope-from <adobriyan@gmail.com>)
	for <bp@alien8.de>; Tue, 17 Oct 2023 18:37:10 +0000
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C0E2B40E01AF
	for <bp@alien8.de>; Tue, 17 Oct 2023 18:37:10 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q9dJvYICQq0M for <bp@alien8.de>;
	Tue, 17 Oct 2023 18:37:02 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPS id 1EC3040E0196
	for <bp@alien8.de>; Tue, 17 Oct 2023 18:36:54 +0000 (UTC)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9becde9ea7bso710222066b.0
        for <bp@alien8.de>; Tue, 17 Oct 2023 11:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697567813; x=1698172613; darn=alien8.de;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UsOHFGretSLykDBJnCgkW04q5JdfeTlofJ06pDIWcfU=;
        b=nGzljdv48Aa8C77Ysuv9mDwAb5UQsFh7wvGwk7QWxF0aqTbi0x2H9J04bafHJ6j2YR
         Xc+gsBq9KjJFcHHc99aT1MZHCsVE0/8uFHpC2M65tlnmc8IQQXMCdwSYGF/RUrlXDScf
         BiIDNSmNPrIiThxvj21lkICqjCF9+efgQL5ql+7sBG7W79EXSoEA2PMXd5+lWEJ+vkVJ
         iYNDTacbByYoruW29g+4utqSGtDzXfl46AfzUsL5e1Q5VS8p28tLmyiT/lSsDbRzd08M
         +8gkbf1nU588ZP1yLoUGBjQUBevKWRHVMXA1hZx5SaT/+fdCDlX/vCnyAX/ND5SLS9r3
         acmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697567813; x=1698172613;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UsOHFGretSLykDBJnCgkW04q5JdfeTlofJ06pDIWcfU=;
        b=iXaiv02X6JiXEXAr8pTr+mIJ2DpHjJscXreHXOMHOXNxry6S8+rEVgPERba3LbuKqk
         r2i1Brwtb/+mgNvzQ96MmDpRzwaxKq7jk6edJeWGopx1hFowe2JskeRhcKJtZqdChkAo
         oWlnPtEaaYmkgD/JGuEKYgvbjVvu7wbDM6jAtLXiOzySKSF01v5Or8OICF9Dt9kmaaJy
         cAxTinnHGa2g/Hyi8Hlv6nj6DSJyGsq9ljdLclU0N5anOlmqaSAwu2uKBK6W7C/7OEYQ
         SeWbz29FiGXavJ/YfH1ITVEughUZFhccFDR7KsOK2Ga/GoBZWdQX+xcOMocqqJSIsyKE
         Xlxw==
X-Gm-Message-State: AOJu0Yzhfkb4t+472wf3GkX3NpAN+he8xXYsTWzzRgVTut2Q2eb3JK9v
	1zgRg7H82Alq+I+hTjU5NUJ7yxzpbw==
X-Google-Smtp-Source: AGHT+IGMbJkXzwWgf1JIhzqccBAXA+PwqiHlMknVj1qBOgQzgHjKikiyb2/AvNZEjJDc6LU+I9m8Mw==
X-Received: by 2002:a17:907:2d2a:b0:9ae:6648:9b53 with SMTP id gs42-20020a1709072d2a00b009ae66489b53mr2833409ejc.23.1697567813302;
        Tue, 17 Oct 2023 11:36:53 -0700 (PDT)
Received: from p183 ([46.53.253.142])
        by smtp.gmail.com with ESMTPSA id v12-20020a17090651cc00b0099bd86f9248sm248823ejk.63.2023.10.17.11.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 11:36:52 -0700 (PDT)
Date: Tue, 17 Oct 2023 21:36:50 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Subject: Re: [PATCH] x86: delete unused "struct thunk_desc"
Message-ID: <4f005482-d48f-4678-b633-d537dd6df8dc@p183>
References: <843bf596-db67-4b33-a865-2bae4a4418e5@p183>
 <87a5sh5d8i.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87a5sh5d8i.ffs@tglx>
X-Rspamd-Queue-Id: 1EC3040E0196
X-Spamd-Result: default: False [-3.30 / 20.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 ARC_NA(0.00)[];
	 RBL_SENDERSCORE_FAIL(0.00)[2a00:1450:4864:20::62b:query timed out];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_FROM(0.00)[gmail.com];
	 R_SPF_ALLOW(-0.20)[+ip6:2a00:1450:4000::/36];
	 MIME_GOOD(-0.10)[text/plain];
	 PREVIOUSLY_DELIVERED(0.00)[bp@alien8.de];
	 BAYES_HAM(-3.00)[99.99%];
	 RCPT_COUNT_FIVE(0.00)[5];
	 RCVD_COUNT_THREE(0.00)[3];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 RBL_SEM_IPV6_FAIL(0.00)[2a00:1450:4864:20::62b:query timed out];
	 MAILSPIKE_FAIL(0.00)[2a00:1450:4864:20::62b:query timed out];
	 DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	 NEURAL_HAM(-0.00)[-1.000];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 ASN(0.00)[asn:15169, ipnet:2a00:1450::/32, country:US];
	 RCVD_TLS_ALL(0.00)[];
	 FREEMAIL_ENVFROM(0.00)[gmail.com]
X-Rspamd-Server: mad

On Tue, Oct 17, 2023 at 08:13:17PM +0200, Thomas Gleixner wrote:
> On Sat, Oct 14 2023 at 19:05, Alexey Dobriyan wrote:
> > It looks like it was never used.
> >
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> 
> Can you please send patches to LKML as documented in MAINTAINERS?

Sure, I thought x86@kernel.org is x86 specific list for some reason.
