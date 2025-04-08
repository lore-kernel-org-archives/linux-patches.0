Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093362528E9
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 20:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744144055; cv=none; b=XnEIdjmOHUQrBdg+NkEr6TxNiBiRb2RJ2IWux7TsLEcfc1kWSMPJJLp2AzAHxlEeYjP+lxPCFMpd2fcThmoeb3G0ezK1H0KKQuP5qorpkSdY5dcqqYRO2h68eAH4HdWEwBDx2pG+A+NIZxpj+VOrmx3HROnZugCzmC0smxz282o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744144055; c=relaxed/simple;
	bh=++qzM9pZTYWM+BnyPIWIoUaaUk2WFwLNWQkAezs1dho=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=TZpGZNQVuQpULSbSOGRghS7Y7vS7IySf2jkpmy44fhDBv3XG601ck7qzN9T3xO8SONgPz+/XLKMHBUSsenWfLn3lPS98vXoOsr6NmF/WoID0ZVPy4XbuC9h4IcL2mX8Ga6Q6+9VBbC5sZwZhNsYpfXvQw1+px60vM6VpZwH/CmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1qN+jDG0; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1qN+jDG0"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2264c9d0295so48575ad.0
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 13:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744144053; x=1744748853; darn=lists.linux.dev;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zl9eXElVYvC/d08LUxLapHLfK6yOmAPuCukaZLlYMGc=;
        b=1qN+jDG0S0zpP5ENxPiYzKBvrtbc72He0ev1WzlKOZltvT2an3D+ssFv1vV7QjvaWw
         b2njzW4Hf/foKdMwEsRufiAG2O3dbLPrPtlYLKdLRAUlPVQT7/aa+emyfSyQEHwtDLaw
         1vBb92Abmi5lQqRVsal9uFtFAcDy0K+20I7KxYNprX7jIbx4IIFywmcVZ8RD7Kg75yVg
         CZtZbZxsv7/+ISFCtMPAgcS4DPODj9ykgguDckPZ7ra/DdgX5icEiyH6EvjN0Rygh/kf
         iAoJRPtlevhG6pyxLwLQWXritbqoGFAxD6dc7t+qxC1Voh5E/h1JdLnOyxgQDeL1KjJO
         Ks9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744144053; x=1744748853;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zl9eXElVYvC/d08LUxLapHLfK6yOmAPuCukaZLlYMGc=;
        b=PQPu0GlAM4ZVXUCdAZCR12mwvi7wK5ZwLEdXRltSPNvGxZf/qWgwbOr5gNY+vNHESy
         5GM2OGO5+KNcDy6rgTZ7CrsDTsM8iVrYEzj1UnSExts9Z72yplVwYAtNam8bMcLFL03F
         LjTnDNJYf6ROGN+OJxW3NLo3cuMgJD27Ta+sWolBadedADhNX9c6eHwGy9kgaBycdUjI
         dVBJuNIBKyqz02/Y3dcr+pJgzTtQLbB25S4KlwILpBOo+YbvVN81SB+fiu0vMOwr6FUj
         BK7oCkHiwf4Yv+BDiN/v+TwviJ3BgIcIvoN7n0pDsK9PzkFI0P9t8xVYa9qUSZuWgnT+
         i5hA==
X-Forwarded-Encrypted: i=1; AJvYcCWP28DoguBzmwqWvZeYQ0Kb0htbiL8fRQH8+OpTdEApepG9snQkl9G8TjyGdgHqGlfDzxO520X0@lists.linux.dev
X-Gm-Message-State: AOJu0YycPa2YN7sWhAY22aURmBsAXN04j0wTFxLXB6LCWSrScEjGLHWd
	vuiqkV0rxHTLgf2HC1p0lgD4lKsq9xD7RbmIh1rB0g8BWopIfpxHbWjZ/l67fA==
X-Gm-Gg: ASbGncvFtE57vxnRMEMHXfxXad21MFJBdtB3T50fp1wkOjmqryZ06/x51fRiF1aJLgP
	sS7BFg319o36SPUJoK1TVMVIBLZA+YlvrKveozPsTCkKBK8eZntDrOwvNKetrSXW7okBoQXxavg
	wKKUOG5h20eW9Lbw7dsr+TZ/5WJvZggAAw/hxePQrB+xNTOl5RojIdEPhowzW6wexOHRrml0450
	SSIR4wQssZyBt9K415rekLC3+LWCUwOcOXPKab0xC1FTF5HzieasLLs3OQNxuVQpgMVHdA2I4d5
	5d0ZTfvFiuX7IUWkePiLiuMKsXZpMew+PTJ/CHxALwZSwmQSuMjvYZpQ/+PkI5kZjRCAGZx++ic
	BmMhLxPpJqtbMUR8KCxJhGPhotGPN4N3uheBJ0cQ=
X-Google-Smtp-Source: AGHT+IGaP1tt5XEyPUt0p5S4YVh9UW+3H3LMheFD+j349byeR79n33slYeHHkSlxeDJqUXSafc4QvA==
X-Received: by 2002:a17:902:bb81:b0:216:201e:1b63 with SMTP id d9443c01a7336-22ac4626b25mr11015ad.11.1744144052977;
        Tue, 08 Apr 2025 13:27:32 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:85ad:f0c6:8d52:20df] ([2a00:79e0:2eb0:8:85ad:f0c6:8d52:20df])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3057ca1eb89sm11664405a91.5.2025.04.08.13.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 13:27:32 -0700 (PDT)
Date: Tue, 8 Apr 2025 13:27:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Harry Yoo <harry.yoo@oracle.com>
cc: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, 
    Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
    patches@lists.linux.dev, Pekka Enberg <penberg@kernel.org>, 
    Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH 1/2] MAINTAINERS: update SLAB ALLOCATOR maintainers
In-Reply-To: <Z_Qz55SbnHK9LoW1@harry>
Message-ID: <839394bc-cd6c-4d34-2f85-8aabf7712459@google.com>
References: <20250407200508.121357-3-vbabka@suse.cz> <Z_Qz55SbnHK9LoW1@harry>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 8 Apr 2025, Harry Yoo wrote:

> On Mon, Apr 07, 2025 at 10:05:09PM +0200, Vlastimil Babka wrote:
> > With permission, reduce the number of active maintainers. Create a
> > CREDITS entry for Joonsoo (Pekka already has one). Thanks both for all
> > the work!
> > 
> > Cc: Pekka Enberg <penberg@kernel.org>
> > Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Roman Gushchin <roman.gushchin@linux.dev>
> > Cc: Harry Yoo <harry.yoo@oracle.com>
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > ---
> 
> Thank you, Joonsoo and Pekka, for all your work you have done!
> 
> Acked-by: Harry Yoo <harry.yoo@oracle.com>
> 

Acked-by: David Rientjes <rientjes@google.com>
