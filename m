Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1801A2E172C
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 13:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755090492; cv=none; b=WAhX+191iRj25ZwtTxeY/R+SmVm41ocBrFeXHmNyVGEyGB7dyDFvJjiYUmFWm28CSR3nLdC5ZyRZii8FZqsiGmRmOkshNzW8MAhM+hWArWHz6wjwFAtyGUIFyFcjSxbub0sKRYFcVHEZbQe7SgXm+Wg1NVFG6jDoxAU0cOBQc40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755090492; c=relaxed/simple;
	bh=1pwQC3sEONEAAvu+FAQCD82dSlJxfgXF2c0gr1vct8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cuh3zq6tQB0ZVDi5j+X3pz7ReC7BjaGPFFwGs91BpqPn1vnEHjKDyHb10brpIU+Ze55C13KjdaGB19c2Gd82M9ztZXj/sF0ULUacOT8alUCYKFNrZhOttSguJVZne7OM0kFy9B67bsmahVTN/jsBZqcYajRbatuzq2JMb7CdXps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=z2bUhfcW; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="z2bUhfcW"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b0db8ce2ceso48201671cf.1
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 06:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1755090489; x=1755695289; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tYLwmIoR7ODU7t4F7MqXFYTcBZqidg2qKZ7p7O1eaZQ=;
        b=z2bUhfcWaKON0hdfmLN4B4ATCY8lMNwSNbFOTp790mieWTnCDhs5OWrlBpm51hkKqh
         RbEAiLPl70+B6NTd2T5VfOSLp7vv2Yeie0TAnQtcKY2v+0b7mYyZ3LSkxtchDApEGios
         VSL2xjmeO3ExxJly5i1gL4zeilRZ1RmAvrRjmVkvv6Y+ap+cTcX/+zF0sFhq1SGDgDHd
         izO1bJeu4qVzT0Za30SQITn1h7p1oBvnsMB10+t/E+3UxtOizEYE7l9kL8ALJRA3xJFt
         yhjzqiPYMemp7GRWqh7oZGAe7tBkiUn08vodfoGXpsnoM/QBoFXUstYIcyBx7sskAZqU
         93TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755090489; x=1755695289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tYLwmIoR7ODU7t4F7MqXFYTcBZqidg2qKZ7p7O1eaZQ=;
        b=ddQ5LsxXba634fcFK8W0+4eavZnrLNO6YRzFApLgzJ8Du1O2+g1xcLXss1+8NfcHnc
         GufzB/RkJL9puJXIwP9azxMBnmaFb9Vh4YH0TpQUTSzLpG+0ZzhSiKKngLZhi3DS5obn
         PeU+zKWACAT1z2x/JXAlDTkuP4dm9ozxLffbd7CaYvMM0sRuNhmZxD0WIhqoEkM25+yl
         ufx1iV8bsk+ekFxazFBteZ4n551CZ8+xwAFaHaW75nj+uJtjFMJ2z5BX4YO+ZOZeuDek
         7/lY0qj/av+GLwCr+a5mlR9PE6vsEg8EDiJx1Xm1VqybSEusBrZtkqPNMJXom4qBcUa+
         baQg==
X-Forwarded-Encrypted: i=1; AJvYcCUBmzmB6Uohu/QY9VNyo7yl8L+qh/15DKwRpkWUsZoAlTtCo+zURHlJq6nyuy9mKfWEekn1tzL1@lists.linux.dev
X-Gm-Message-State: AOJu0YxOgcVrFKl3UpifqU1rwW956Rkpmx+mxqPYbrf9iCUC9SOR0/fb
	+xwxlSKzV1IQ7uewZt1m+y703GSXFTun4q/DFHYK3Z+rtlKeHXX4CP1xrJIwHON0qwE=
X-Gm-Gg: ASbGncsnUWOirU1SBKdqKcomubfPhyn/6xqQJQZ0lAz45SqU5C0bo8u4/VX5Cbsb2sw
	1vVUsuVMHu62IG1rCW7QfHhca6sDm5UvTKwQ+5T5dFz5t1mgQkOgOrV2uAXol6LDZQRoMqFEk/O
	1bsqqZHc99TamxTcGiOWnN8uy8WPrdaVBaVdjQMaB2EcvklF+mDldwmF01X/8ptKimxY5QMYst/
	SXZjEb/RiKEHbXAAl57nOyibv0aILDkehi51cC21SjlhjwIS8/rVZ/Ena5/qCWld/swEZS4BF18
	wC1pdbH1Rxpz/WtSN2mSazh7/vMYs1U0ujbZP5dZZte5pkzQ2N45l1NM09UU0Yf1D7cbFWmitQM
	EYbKCz2lK8SAea2lPQmhAZA==
X-Google-Smtp-Source: AGHT+IHOQuq7xqUP9UjBEVVTqrAdJO6d4BVHEpSN1f1carg3pLIr+GU8HjaN4gDsBZDXdZno+UCFDQ==
X-Received: by 2002:ac8:6f15:0:b0:4b0:cb1f:e390 with SMTP id d75a77b69052e-4b0fc7b228fmr38411531cf.29.1755090488685;
        Wed, 13 Aug 2025 06:08:08 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-7e67f728a6asm1954259185a.64.2025.08.13.06.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:08:08 -0700 (PDT)
Date: Wed, 13 Aug 2025 09:08:07 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 096/369] sched/psi: Optimize psi_group_change()
 cpu_clock() usage
Message-ID: <20250813130807.GB114408@cmpxchg.org>
References: <20250812173014.736537091@linuxfoundation.org>
 <20250812173018.391927854@linuxfoundation.org>
 <83b69ebb-a052-482e-aa6d-34194ef18dc3@arm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83b69ebb-a052-482e-aa6d-34194ef18dc3@arm.com>

On Wed, Aug 13, 2025 at 01:20:41PM +0100, Dietmar Eggemann wrote:
> IIRC, there was a small bug with this which Peter already fixed
> 
> https://lkml.kernel.org/r/20250716104050.GR1613200@noisy.programming.kicks-ass.net
> 
> but I'm not sure whether this fix 'sched/psi: Fix psi_seq
> initialization' is already available for pulling?

It's included later in the series:

https://lore.kernel.org/stable/55070b66-0994-4064-9afa-de1e53d06631@sirena.org.uk/T/#m0ddd243fe107dea7488d119cb60e8a9e18e2c9a1

Linus just didn't keep the CC list when he picked up the fix.
