Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB541922F4
	for <patches@lists.linux.dev>; Tue, 27 May 2025 20:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748378564; cv=none; b=WBDuPrAzngSR7HqMVGGWaTwOI148v1T+ZAHxPLQ9a6N7PEbOAMftv+LTqn/ZYRB0LhoHUSq1KlD/KQNhZ68IVtu0PZaZhWKOUfH2yqkNF/hOO3Q+Ieqa65Z1cFIX1rlq1fU3yYRwvwXK9GKlCLcyNuKt2TxHOj9Nvx8HoG9iKpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748378564; c=relaxed/simple;
	bh=uP/ETRmxYfpv79+aKID0wczhU8q7Cin7HrOkWLqkoYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jFOQ+KiPBnWOVnVgnA6db/6C4J7JEan906kqgkxnb2RDSJU8z2iYJGSed7fGhODLIsN8NblkRzb6x09w8zMdq+7y+Xi3RegY5bWsS0fexlNFQPNtKQYsM9L2NUTI88apP0TPWwiNKQNp0FTl70ODE5hCsTS1gJIUZB6Eq9XtM/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OfgnBbZj; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OfgnBbZj"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-745fe311741so3517846b3a.0
        for <patches@lists.linux.dev>; Tue, 27 May 2025 13:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748378562; x=1748983362; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=71zN33qLtaIe0yTmvh4SAEZ3YM0w29hvj5dmuTw77xU=;
        b=OfgnBbZjt/ElEQivKSYTR21CfPk3Q0Ioic0uE8QEOxZlc3KNoKiYyjoyn4eqo9tlqh
         B9aGx66otD1IOAHyd+O6aFq33X5DeR+2N/Y30bKIoqHyhUCxQRbCCHRCR39HQDQuwOtL
         X1OufQttb2BZBF1NpAR6xBL6zPy/fQ2cNnzKHi0e1vobAGq4+1ndZ81vxJ/4lWb0ASXm
         GQbTohZ3FX2zkrnND4SkGieaw0RZ+oaPocZcxxZ5s+ATBqsIirv30hD2MRBDZIxhYwiN
         dYiX0tPuIpv1Vjr5xn3FpiKSbqqVIwa05qCMY8rh6NJwSH070PqViFQJIpHqfVJfZWIY
         5Oew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748378562; x=1748983362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=71zN33qLtaIe0yTmvh4SAEZ3YM0w29hvj5dmuTw77xU=;
        b=rjnyMgDQT0u4ZEMkaR6COsPeg8c+On09jfyL+uZUBgZoHcPyUUE76yXyF8IqeD6X1w
         6yVbgZjHMaWNc2zL5lvVZ1EqXltYOGr9FyksnWvN98J6YkefZLxFcrDjyhpuuTGGMvRM
         qlfgYF9lJJFQfTtk7I2Q7NBwNsRVuF8mzuW7XusGNNmWHrolwuqeNSO3EOKdW+vjqIyL
         dFwTDSQHh7zyfuc4H90g621hiCQ1waJJrekefGLzgRKDbniEzECjYwpLJP12I4EYo3Iz
         ome7w0LD2z1MS5ZX8249bVZg77Koa4p7DIvwY6KxtRbIMiKTCQvYIguzf2Fa/PCGaxWL
         3llg==
X-Forwarded-Encrypted: i=1; AJvYcCWCKzC+6eDnigPzmPb0yC4xjf+oPtEjaDpkh87SFPBE6iYjptyAYAzb3r2CY5ZfT9Fv6rwiZyXv@lists.linux.dev
X-Gm-Message-State: AOJu0Yw++PLc3ECxRNI5XQF47kWkcdWGMk2FTUUsCTKKyHBdE19kXsc6
	iHcTmkiBqP/K+15nwr+MYyijhNBIEQIDmxFkql0M6vCJN5dMwlMxBzh1
X-Gm-Gg: ASbGnct/atUE60w3euCsKOicKQmVslugcGXhai6bYaBLdfdLXvpwVilzH//U4PiJiLK
	NoORETGpkg0Ausg3e1Mor1k2uLBXhd02cSTNX2MQJpD5yWN3tDT+9uvoqcHaWilW6J9ltrVycGK
	d4RHa9LthhoNWaMmh6q1VGxa61yt3a4QQJxV9mhCaKoXJeeqT7WVAMVEbVHK9suP3NxLBmaiaqk
	bx+Rjvq167LsBZkbIbG3QJ+mb9ugdLREYeaCyhZQMjjtDUFcIRqjv421aK+wbXM7QPNIIfcQGRN
	lLvL1CwdcFT1gFVOVtGrulz6mmFHabOAEx7lrjdrUAZZE2lrf31c
X-Google-Smtp-Source: AGHT+IHpuppsxx7/qH07XR9DEL3kqR66WdWTpxQfInM5tiIRbZC5YtXPXT5Egumuq53I/QwZEA2kGw==
X-Received: by 2002:a05:6a00:1482:b0:740:67aa:94ab with SMTP id d2e1a72fcca58-745fdaf1dadmr21321973b3a.0.1748378561773;
        Tue, 27 May 2025 13:42:41 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:234b:b801:3ed0:528a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7465e6484f4sm10275b3a.32.2025.05.27.13.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 13:42:41 -0700 (PDT)
Date: Tue, 27 May 2025 13:42:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Hanno =?utf-8?B?QsO2Y2s=?= <hanno@hboeck.de>
Subject: Re: [PATCH 6.14 750/783] Input: synaptics-rmi - fix crash with
 unsupported versions of F34
Message-ID: <i7tnbh7l2blxussxcdgjuvcpkzet5w552dqu6vl5upus4xf74n@dva72me3bdia>
References: <20250527162513.035720581@linuxfoundation.org>
 <20250527162543.672934881@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250527162543.672934881@linuxfoundation.org>

Hi Greg,

On Tue, May 27, 2025 at 06:29:07PM +0200, Greg Kroah-Hartman wrote:
> 6.14-stable review patch.  If anyone has any objections, please let me know.

Can you hold this for a bit? I might need to revert this.

Thanks.

-- 
Dmitry
