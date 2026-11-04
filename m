Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793810195;
	b=JyubpJpKq1p7nUqs9MsUfCFR3Ta3pWqMRn6cr0wM7uxO9r6LFNbkgYMplrzMSRn1mSOC
	 hVMWVytSXqtEfPzDWnqyjwK3hlGDj3Ejs1ZJMMolbKLe2Uu5JYaIe2GUF+jeMC3P/Hdu0
	 tctcZfYk72Jl5kYlOmtrjzAVTLQz+4KvyVOR9t7smb1lCjm3t3M2HXSRMPjqhaIHOC8Pb
	 fhzavecGOxud6C98vx24DHl5jIvS8HdGxp4VHMEEJZeBi9Xz/1fCcs5tQzJ4XjlR+Gg0w
	 vj4CPKALy93eWRbE7ybhjEQI0QayuszTJiewpUTWL2wIbFTAR5Yvg9+HPPntas263rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793810195;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TYgm2qFe044UpfvwwJj7/YqIL4ACLlokwv9PNbM6nXc=;
	b=rNkA0DtdzLpV4YBxiJ2vN5Xt/3YzfuZqAovWeGnWXqBr82447NOmKWTx9axJZODXfwF+
	 LT+iH3b2bixODW+MkvSu7pvRiQ2yGutdCSHKT4uiwGhhPqfVV5gYHYBU0nzfWiKzZr2kG
	 YeoUH632rhLLiiZKM5znjsaZ5g97sMFtafQIvrSUX7SsUHKnxopV9JHLFuUPNykCwDCXP
	 EOkooMaZnu0E+dxzXPyj5qDBqk5IBx/OcO4hjm7y81ug1C8rcQWCHClRSQUc5wO/Wms/X
	 gWqBAbVEw8bmXVIzlUPALxZdwUkoDLX8xyfXJPui/YHeBRikyfb4fdfWgLr3Cwn0XPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W8P6y6Ht;
	arc=none smtp.remote-ip=74.125.82.177
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F81606D835
	for <patches@lists.linux.dev>; Wed,  4 Nov 2026 16:36:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11F81606D835
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W8P6y6Ht
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-3535a54bed9so1197811eec.1
        for <patches@lists.linux.dev>; Wed, 04 Nov 2026 08:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793810194; x=1794414994; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TYgm2qFe044UpfvwwJj7/YqIL4ACLlokwv9PNbM6nXc=;
        b=W8P6y6Htn6PGins5/CMdRH7RGaKRju0BtfxxH+Y3sBL588rJcqb3AjeOHmWCJSi+Oe
         LCfrRsyhvGC5/EvR4MkF+zVwGOQ8UZOM7VpFIm9GfZDIBVM9eAk1bRh6EyyK1jEEyuBw
         to5MtUpVNKk40zb7EcFLVikyc1fBCPu4uMS+dcn3FG8i0Zvpm0qbgrgBIqc1JNRjyY3r
         Io5pDAjVpigCbJdjfrVp5qqlPQITZOHIj0ZkwMqlA+OHcH0DawkGzeejEIiVyCueVcuV
         gavVVgCeTpVYtwdle8L0Rymwzaz0d07r4gx8jWT8XtQr89aNc3rxlwtVSx6M4uOJQCAl
         2QSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793810194; x=1794414994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TYgm2qFe044UpfvwwJj7/YqIL4ACLlokwv9PNbM6nXc=;
        b=VpHChkzRmlkQoch12HCdiMVTvSeFjrFc+qIlohiq/kX/dG7/fk+gmjOY9tVWhZIPn3
         amejorQbEHzOAHdV9Y07GuE0WyeCZRpgViKn5KBLoglRsQ+iTsIw/ClBUmz8ICGuFJTK
         CPTqBvEpdTA68brX9Hy9EMhyP31s+PC/dgXo9IOmsdTeVQA0hI1ivBwM46PADFhGjgTk
         52iXMTwtpjY8q4GnTKkEdx3pTVBBlU5bwkSG6YH4gzCTCm3B2PcTzH+jBqJlI5Q+0hL8
         mk9Hav/IzZhjKfV9KJhEI235gfPpH/sieUeJHh+6TYb5a2aNB2W2+hDkI3SZqzm7sdoR
         c85w==
X-Forwarded-Encrypted: i=1; AKwUvBxNKT1FA3PvKy3ZmNTC5KCI/5lMfkWnqFPq0PAOZUilpJgJfUmxYtdzbmI86Z4+OnwH05nj1CcN@lists.linux.dev
X-Gm-Message-State: APuU4Z9+K+gx2WWWjVZlq0bqc7/xk4mSO+guMwDRjAp+BrofXMGmrUHE
	WqiqngNPndi5LlIHdLyMY8d5yq2ZUbXuX32X4X4vMuDTNTYS6aaYHpDicqRhXw==
X-Gm-Gg: AYBFou1GdVA8zGqF6lYXlfv8e4xQZFtMbWVnq3JfpJW8pvxDFgMkIzJQj8JzL+rodET
	d/hx1and6NUssoJq7YsW3slvDaplN60F/cCUNyNwXTvflQACY1WSjMIWgeU0v704pTRe3PELP9G
	hF2992mPz0Ox7/HQtR2j6ftRkyLvI3aLf03/eyF34hE62VJSey8RMuV/kqb9lN3yLe3CrEsxZtQ
	qpxV9d8Pe3SaIwFTsoyh/zd6ckjhmkQqUSV0A6sJcsA1p/J4NbiKw9fxs9viw1XFCREM4I/rA+P
	Y5ne3IX4bNhraYUaRVL3/K9/L/3ySLCt5jWFeLXBOeufma8EWtrZt/V2v2/5RV7f03NNywvHGWR
	Mu2JccJKh1jK28whCj1CvPYAhcNPWaAIfYBk4mho4OQJgJj1/+HUinwFrP3bdztMdsU1mdQoAqe
	KXZ+Da/xxFSHYOGdlapbiTA6nghPOxgwe/VNx6xsghmohqXm08ljnPCghY9otKMtFHsyrQNWQec
	J0ab9SRYVnVNi+VYi79MWChY99sSL5O99+iv0aNfEhqkY7i8COFp6s8xAMU/6ou0mp9w1YkxAnv
	191AhVexGdfcAcfb4GRLfBflTdv16sSMj7v5h0h+Zxeo2dUajlpfGqaFbDB+54SP4TPAP0Jk+xq
	F6reCrg==
X-Received: by 2002:a05:7301:103:b0:36c:9af3:22eb with SMTP id 5a478bee46e88-36c9af32cb0mr6408365eec.34.1793810193837;
        Wed, 04 Nov 2026 08:36:33 -0800 (PST)
Received: from localhost ([220.196.228.78])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca3958746sm9327852eec.22.2026.11.04.08.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 08:36:33 -0800 (PST)
From: Liang Hao <haohlliang@gmail.com>
To: ralph.siemsen@linaro.org
Cc: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	bartosz.golaszewski@oss.qualcomm.com,
	sashal@kernel.org
Subject: Re: [PATCH 5.10 159/595] gpio: dwapb: Mask interrupts at hardware initialization
Date: Thu,  5 Nov 2026 00:36:27 +0800
Message-ID: <20261104163627.92404-1-haohlliang@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <auj7ZUcOlNC-rEnk@maple.netwinder.org>
References: <auj7ZUcOlNC-rEnk@maple.netwinder.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Nov 2, 2026 at 16:06:45 -0500, Ralph Siemsen wrote:
> This causes a small regression in 5.10: the gpio-dwapb controller no
> longer produces interrupts, because nothing undoes the GPIO_INTMASK
> added in this commit.
>
> Only 5.10 is affected, because the following commit was not backported:
> 1cc3542c76ac ("gpio: dwapb: mask/unmask IRQ when disable/enale it")
>
> The earlier commit does not apply cleanly, due to changes in the
> context, but it is straightforward to apply by hand. For reference I
> tested with the following and it restored the interrupts.

Thanks for investigating this and providing the fix.

The proposed fix looks reasonable to me.

Thanks,

Liang Hao
