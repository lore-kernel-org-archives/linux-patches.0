Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1E229CEC
	for <patches@lists.linux.dev>; Thu, 10 Oct 2024 03:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728531615; cv=none; b=VSD7aDtDyovvUzerrghDucz9fDiK5l0L+XPepSHoByjt2lUaP0C4w28CnmnLrAxMyAUkJ7kV1ghNVOL4Za42Cx64MnoKtHvW5PkCxqzxsPOHk7Xc3wDN+OW0mZHEiSaScOBr280trjT5SdmhkbHs5r694nTbLqmCoWob7WYExLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728531615; c=relaxed/simple;
	bh=Ob+Ntnua/FoRpn9pOzoYKMUT2OeE92O8Rhf/EVVh8hk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eTgYfyO4Za8/1lgwXrQqAW8GY5V2L227l2AQvOukS9VWi7A02buT97oFCj5THHLstXnlHewEiIrg7Mxeg1LjNsJJjOFtpoo7QYAyxS29leQaXWiF/Uk8jvUkt3kAaaGaoBJ2Id8qbSXOZ3sBFCGOjZj94dVww7gV24y9ahmbQWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=igi8MmM8; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="igi8MmM8"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20b78ee6298so2460695ad.2
        for <patches@lists.linux.dev>; Wed, 09 Oct 2024 20:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728531613; x=1729136413; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UPXPxZjohle7EMIgLFLm4P/eY6ik/SjavlqMACxZNMc=;
        b=igi8MmM8o1mpYPLuU7IsuNPkqOCnUprRxHY1GjZsoqg0Oh8nFqe+Lw9bg4IMZwuqTD
         cu2u/W8encBopioXn4Yc3JmMt5jo75deV6Kexks8nBhmT2sQQOthpx4wxZt/8asN0tSZ
         3+TsAds0/oahbQ8I42yZeys7yo1/7LFH0rJk3QuuOq63KvbJAWyCIJSMgWc3vkJG/Obk
         pLf551rNTz3tOJGxcGjXDZtCZhLBu5T7t0+xPV9nZQzGZzrPR9jteajwEOGiplmIqGCU
         HpTH+LvRVjIBuEIy+pB6TL/3bmJVCyt/FDyvb3wpjnPTfS1+CNPBTutcf+g/zLdENDQV
         wpdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728531613; x=1729136413;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UPXPxZjohle7EMIgLFLm4P/eY6ik/SjavlqMACxZNMc=;
        b=pZCm1umZWssHmj/ScY+x9NLR9ru5N5arSINO6eaqouMubgm0ot4uw8uV8eWebh8G4K
         7MSv+tBF3szsZYrxc/ufY4R5mhq8ZN2CxntWpZWkEjY9OKf2hoLostkyJ2F6lb++pEky
         xaEiLGiZwXwzXRxIKG+zdQ+qTC4/BtzJhpCMrJK8uhQQRWClO58TG3n12JvTEC3N0T4u
         xTt/ofBMnZwnZ/h23l7oIAvyJ0GJA7RVKhexp3j2eelGY8B+eqIpR59fBr1FZ7MT/43V
         YIbaW/WfEL3D3/K9iZ5q/EpgyxAaon1xY4OSkDAEQmpU2SQMwA10zuT5Uzv55DW0TEhC
         EGNA==
X-Forwarded-Encrypted: i=1; AJvYcCVg+iH4/I0NrnMLlbMeR4vFKe2AOXlMb9dDYX3G/Gi+CGzPdmA9e8iT5CL1YM7lIDxeRjyXkVuJ@lists.linux.dev
X-Gm-Message-State: AOJu0YzQfPgQVSOWOPmx0J+vL6MUZ/CY6AD/H31siNW3ht4HyzJEr+im
	9qb91AYmmxyUEe63a3XF/pDOyRYA12c+sAiUSbVsVvSb+ST5GGkL
X-Google-Smtp-Source: AGHT+IHH9ArVpyMyyw+nVSDLNigypX02b+J3NTGKJIJZ0A5Gb61UIUG+/lPFav2BEeOe9FQBu3Fr5A==
X-Received: by 2002:a17:902:ecce:b0:20c:5508:b61 with SMTP id d9443c01a7336-20c6378fc2cmr69220095ad.49.1728531613065;
        Wed, 09 Oct 2024 20:40:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c212e9csm1496465ad.188.2024.10.09.20.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 20:40:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 9 Oct 2024 20:40:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@google.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	David Gow <davidgow@google.com>, devicetree@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of: Skip kunit tests when arm64+ACPI doesn't populate
 root node
Message-ID: <fde631a2-88c3-4c3c-b777-9237387e9868@roeck-us.net>
References: <20241009204133.1169931-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009204133.1169931-1-sboyd@kernel.org>

On Wed, Oct 09, 2024 at 01:41:31PM -0700, Stephen Boyd wrote:
> A root node is required to apply DT overlays. A root node is usually
> present after commit 7b937cc243e5 ("of: Create of_root if no dtb
> provided by firmware"), except for on arm64 systems booted with ACPI
> tables. In that case, the root node is intentionally not populated
> because it would "allow DT devices to be instantiated atop an ACPI base
> system"[1].
> 
> Introduce an OF function that skips the kunit test if the root node
> isn't populated. Limit the test to when both CONFIG_ARM64 and
> CONFIG_ACPI are set, because otherwise the lack of a root node is a bug.
> Make the function private and take a kunit test parameter so that it
> can't be abused to test for the presence of the root node in non-test
> code.
> 
> Use this function to skip tests that require the root node. Currently
> that's the DT tests and any tests that apply overlays.
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Closes: https://lore.kernel.org/r/6cd337fb-38f0-41cb-b942-5844b84433db@roeck-us.net
> Link: https://lore.kernel.org/r/Zd4dQpHO7em1ji67@FVFF77S0Q05N.cambridge.arm.com [1]
> Fixes: 893ecc6d2d61 ("of: Add KUnit test to confirm DTB is loaded")
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
