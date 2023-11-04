Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26771172A
	for <patches@lists.linux.dev>; Sat,  4 Nov 2023 20:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FPmR3T+N"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1cc53d0030fso25475795ad.0
        for <patches@lists.linux.dev>; Sat, 04 Nov 2023 13:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1699128997; x=1699733797; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F3q+26NQjsCSsUclbOoVT3OpgFnwDtiYbZS3n2A1sXk=;
        b=FPmR3T+NacFExEbk74SAblnUqtxqkFaT3Fbc9hYsUS4n17VpwT8KAg+RJMFMYwmnHr
         UZ7AYHvqvQp5bi0faDPuz7v+h+3Bhu3Sre83BJzaWIoss/qIglqOsDVJ+pkw0yV4XVc8
         jebSM7h5RUD0nQY6scPSmMU+L5f/xM6UNVK9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699128997; x=1699733797;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F3q+26NQjsCSsUclbOoVT3OpgFnwDtiYbZS3n2A1sXk=;
        b=VsiizMuH5KfrfE6DBrxdJ893TJ7Hy4tgLzGiLhsypU8dENVkcHSrRFJHmivuSbJ0N5
         ttCrFFmpQTo/HkhKupuKlWr2SSoZzdCYpBpTFOm+HDJI0TwW71IczV1YtAmXAEjnqkOD
         wecq3Xmrd9d2IM9XJaFlMeVpsfC+tPSd58ERGNgcm6YUIk2oj1ZI2KDOEeFOaN1qWIkk
         ESECLJ1PzT4TjEdQy39kHywz5eAG+gl4zJDfNE1PCy0QXmP3+7lZAKRPNvrIa58F17Sb
         Os9lLOD+hqF2vMtYEmVkiPeAsUIDwMUaYzmHMjrHLIbVorwcJnX3DbXIzYLxQ64TVqhl
         qoww==
X-Gm-Message-State: AOJu0YyRRaypWtJBA8W+YQnoMkRHDG80mMEVe/riaJ/bEZrgNmuNfajQ
	WKCRGHWAVw4s+K43QoXN96kYSA==
X-Google-Smtp-Source: AGHT+IG3c5xfOJz1RbIcNJcl94Po9noSiBFDwt07JlMVvyocCZu40rrhyVtY2DVrXGeuet84jn2G3Q==
X-Received: by 2002:a17:902:e88e:b0:1c7:5776:a30f with SMTP id w14-20020a170902e88e00b001c75776a30fmr8832331plg.12.1699128997174;
        Sat, 04 Nov 2023 13:16:37 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id q16-20020a17090311d000b001ca2484e87asm3280474plh.262.2023.11.04.13.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Nov 2023 13:16:36 -0700 (PDT)
Date: Sat, 4 Nov 2023 13:16:35 -0700
From: Kees Cook <keescook@chromium.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: j.granados@samsung.com, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add Joel Granados as co-maintainer for proc
 sysctl
Message-ID: <202311041315.F91B4DE@keescook>
References: <20231102203158.2443176-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231102203158.2443176-1-mcgrof@kernel.org>

On Thu, Nov 02, 2023 at 01:31:58PM -0700, Luis Chamberlain wrote:
> Joel Granados has been doing quite a bit of the work to help us move
> forward with the proc sysctl cleanups, and is keen on helping and
> so has agreed to help with maintenance of proc sysctl. Add him as
> a maintainer.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

And honestly, I should likely be switch to "R:" -- that's most of what I
do for sysctl. :)

-- 
Kees Cook
