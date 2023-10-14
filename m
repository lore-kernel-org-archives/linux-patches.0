Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22541804D
	for <patches@lists.linux.dev>; Fri, 20 Oct 2023 11:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OR7DZNlk"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1343040E0187
	for <patches@lists.linux.dev>; Fri, 20 Oct 2023 11:00:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id qwsXAnCVw7vQ for <patches@lists.linux.dev>;
	Fri, 20 Oct 2023 11:00:45 +0000 (UTC)
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6EA6D40E0196
	for <patches@lists.linux.dev>; Fri, 20 Oct 2023 11:00:45 +0000 (UTC)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Fri, 20 Oct 2023 13:00:39 +0200
Resent-Message-ID: <20231020110039.GBZTJd13R9JyDm/zwt@fat_crate.local>
Resent-To: patches@lists.linux.dev
Received: from mail.alien8.de
	by mad with LMTP
	id WRl5N1y8KmVEOg4Ac81XFw
	(envelope-from <adobriyan@gmail.com>)
	for <bp@alien8.de>; Sat, 14 Oct 2023 16:05:48 +0000
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D1D2340E01AF
	for <bp@alien8.de>; Sat, 14 Oct 2023 16:05:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cq4CGJxLiheq for <bp@alien8.de>;
	Sat, 14 Oct 2023 16:05:40 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPS id 2E28B40E01AA
	for <bp@alien8.de>; Sat, 14 Oct 2023 16:05:32 +0000 (UTC)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-9ba1eb73c27so504296966b.3
        for <bp@alien8.de>; Sat, 14 Oct 2023 09:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697299531; x=1697904331; darn=alien8.de;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z/uhBRsYnsZAgV/PYH2bfS1hGLi77nzjJTP1PTjxsEQ=;
        b=OR7DZNlk+21TyApuyvg8yyAFit7zJtFfdjSV3tK54qzb7ZcRDpPWdIdopk/Nx/JldJ
         74r8+Eb+WK3jczQ3TaS8RXuDC+VOmv2RxxFnmnU1BvKs5jAo+tdZx/IAFl4jxVfRO4sB
         Zpn4MrUWtRiLrB3/1oHzIMslFIhJdl7kBCJOB5hIO/ZK+GIbEFsFK/HKZI2F6U47RvLv
         IC6a54VwNKe/RCNN1CUpAGL7yT7gvsEiuedZsWRTS5yatjivYTODp82TB+jPtBOiK8pN
         vkSYM84KXqLj5gKRH/aPdx3h47UtbN/e4hsfUEQuhsbEwgiBBvARyyvRHve8vVW7uXvC
         TYNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697299531; x=1697904331;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/uhBRsYnsZAgV/PYH2bfS1hGLi77nzjJTP1PTjxsEQ=;
        b=MPXfliYq/8ByoWoK74siGnsTk7ILiTrXXWVTiVBUMy0B6ch2IsoU6qDyHhxTjOAM/m
         mDCwEK6Xhj5tQt/4CT8Q3o8ZCuXEDO+9zH+WFiQX1mcbg1db2Lrq2rbB7QoJjd1F6aKy
         D7G4JJ3uNjH+Z5wJb+tmtZUXXnBMlunpnh0bEtlW1B3kNiNF0tDZ4x6xR8OnhjRDFte9
         hMMtnprQ/ZN1o5w0B/WRu+VlD0r0EHz3j1AVAhLvh7PWeGxlEQ/t+0qMeSeI49tgP7S1
         iM5sGxr3lgpL8TrbKFUOOwVHKXpDF5f9Ge/iYy215sWKDTYspQ2yMwIv5QZV8DCCwkqQ
         1HJA==
X-Gm-Message-State: AOJu0YxSjbg9CQBO5Xt3Wsehg4OQxRAwJb3N7NzT8semG0uMHS25hJI+
	9y6Lj/6oRbpKMBlsTVmMqQ==
X-Google-Smtp-Source: AGHT+IHMGUOruNcUTBq23x1z+s/KD54UBIasslc2/F0Qe+EoIpbPQsJ2YCp7C0BkrrTqsBf20dBqpw==
X-Received: by 2002:a17:906:4fc7:b0:9be:aebc:d480 with SMTP id i7-20020a1709064fc700b009beaebcd480mr1837575ejw.24.1697299530992;
        Sat, 14 Oct 2023 09:05:30 -0700 (PDT)
Received: from p183 ([46.53.253.206])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906029100b009786c8249d6sm1110537ejf.175.2023.10.14.09.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Oct 2023 09:05:30 -0700 (PDT)
Date: Sat, 14 Oct 2023 19:05:28 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Subject: [PATCH] x86: delete unused "struct thunk_desc"
Message-ID: <843bf596-db67-4b33-a865-2bae4a4418e5@p183>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 2E28B40E01AA
X-Spamd-Result: default: False [-1.91 / 20.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 ARC_NA(0.00)[];
	 RBL_SENDERSCORE_FAIL(0.00)[2a00:1450:4864:20::632:query timed out];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_FROM(0.00)[gmail.com];
	 R_SPF_ALLOW(-0.20)[+ip6:2a00:1450:4000::/36];
	 MIME_GOOD(-0.10)[text/plain];
	 PREVIOUSLY_DELIVERED(0.00)[bp@alien8.de];
	 BAYES_HAM(-1.61)[92.54%];
	 RCPT_COUNT_FIVE(0.00)[5];
	 RCVD_COUNT_THREE(0.00)[3];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 RBL_SEM_IPV6_FAIL(0.00)[2a00:1450:4864:20::632:query timed out];
	 MAILSPIKE_FAIL(0.00)[2a00:1450:4864:20::632:query timed out];
	 DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	 BLOCKLISTDE_FAIL(0.00)[2a00:1450:4864:20::632:query timed out];
	 NEURAL_HAM(-0.00)[-1.000];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 ASN(0.00)[asn:15169, ipnet:2a00:1450::/32, country:US];
	 RCVD_TLS_ALL(0.00)[];
	 FREEMAIL_ENVFROM(0.00)[gmail.com]
X-Rspamd-Server: mad

It looks like it was never used.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86/kernel/callthunks.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/x86/kernel/callthunks.c
+++ b/arch/x86/kernel/callthunks.c
@@ -48,11 +48,6 @@ EXPORT_SYMBOL_GPL(__x86_call_count);
 
 extern s32 __call_sites[], __call_sites_end[];
 
-struct thunk_desc {
-	void		*template;
-	unsigned int	template_size;
-};
-
 struct core_text {
 	unsigned long	base;
 	unsigned long	end;
