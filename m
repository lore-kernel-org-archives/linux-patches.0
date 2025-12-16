Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2D32F49F1
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 16:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765903934; cv=none; b=Zgjjx0OxmbiVynXeT/Dxz5e2k1ZRVNMuJYf98591X6DGcjqxkA9zLtkZa8nz2XAAbzdaFyyAQfJoabGxxZeeXX1qvljEdRR2qZmkMectKPYuHhvm06zOoLUvLXlQ6CVmzPcwtn+3hcCUhf5oAFuQSa+hHGOnzfH+m3OkEXCKuV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765903934; c=relaxed/simple;
	bh=FwjdDS1Sox44VxEqtfgWxa7v8a0DK1bpiJ12VqO95CM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EacHr4BDKTThgp9deGop0R/muxGzDUEwsKyaIAIAtRakiK0Y4z4y7CNqu05Mq75qggfOZTehzL6IlJK8LN4ToXB4UVA7dda5EYNldImP4sjR3rz7moBCdbgOr1IrI0ULhhvj0xSheNbRL1t4VHXZeO5axYL/qXNDm4ApPSk3Ot0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=eoWJuz0i; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="eoWJuz0i"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-29f102b013fso58909365ad.2
        for <patches@lists.linux.dev>; Tue, 16 Dec 2025 08:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1765903931; x=1766508731; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=044jJ5OZga77MHiu5HO2sauTgRDM/5MaBSigPsMPKDw=;
        b=eoWJuz0iZTUNG3P1H1sfKfeJKHUHOkhROZDXP7XWyM10qLYbkJklL1ODOEtSsWs4yU
         tccIhHejNO4TFDEs/mSvXFVu3c7laROpOQ/wsY2OnjX9B/ufUQHQNgu0/rzaez6vvNsn
         oM7GyzSKJR4d7xWw51YrjutKlr5pdA9G4vv2pnvhB6R6gVeZKzggCaxY82s4xr6xVaeF
         CrI7egF9O2uQ+lSqSHEViTAaCL5nGQngvSNFOOdWDIiuJHICJzk1MnJ6PDlR9p7ISC/d
         +R4KnqwtJaJzcDoJ9TOxgRpZch7sXNOg2kGcxQHhX2joE0AMqfKMMPq0T0PVBpBsvpaD
         gVuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765903931; x=1766508731;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=044jJ5OZga77MHiu5HO2sauTgRDM/5MaBSigPsMPKDw=;
        b=nncB0wIQqCdAMRbn5laUc4w7daMw2N7lSrHUb2T8AQRQhsIsFRKTOQMO6RfGopAPUu
         W2Vm9ynJfR9l3lU1eQH5+SXTFRmyUIDXCJh6yppG56UmqH9d+EJHBRerRgMu4y/2P/rv
         /rFhKv9ORbZ2KOhc0FUtLUzza4AJj2AuDulftbzLMXkBbqKmLpkhlQQVXobcsmwTN9/W
         lb8cnPVpPi4+VbtacSpwRqC73NQUvQen6+wkLwHehCoKo9NesBT4/7kjjwtpLumLUo7a
         OqHvbbjxNWOdGHgVPVnhzi6dGazcg99BHAFhEng9loRokFbW+396y4cigyIORyKP2K5X
         /mgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXp5UxmuP0gRv/kQwy1UWJC3QNN7+UGQWMaorRLrnzBximFhEuVvJXv+GB7ZOzv9P3IEzlS+AFm@lists.linux.dev
X-Gm-Message-State: AOJu0YwP1qZJ0IgpKrecbAJORjtzCIo0qTf9tXaJ5M3UyXQ6YyWJSD/s
	7yi7Nl2hslXd2Y5dKcjUfn1NCX9709LdXk9/kj5m76dFLxk+MFNj0G0uvGFZSGZNug==
X-Gm-Gg: AY/fxX72SU4mlwquZoVLcXPQpeF82FvvJEXJFpdpojzpZiLKZAlmaftFlhN9vz8QFEJ
	WCB3+UkDpF82yZOabHjVDd6zOUI7zSJqfhr4qCTChnbFJBP/jtiTM0A+4dsMF04kSTwRV9Radhc
	5km53wVV0fBbFJGmI7TvaNvfuEktXKAbxeavZsMc6qRaMG66Vz0DbtHYp7CelF1KduoY8uOo1P9
	90Zn1YIMQ2NZZish8hZMzIzUK0hXLbxu7aOxW/npoIUvXmKoOkY0/398eSfoMqcUxRxQJMeG2eQ
	2DhA2PqFBB4MeCGLjoivaGN27Fp5eR0H4uggxxcE+Cy+BXdEOAMia4co1f23OAb6QtRhsfRgTO+
	4DAz03xPWD11Pzf2rmQ97k5wsCfTXxvZBDWWpcP2qCFI8znM2h1fUSMxxDWrffy3+7B7LWRsYx4
	HuIDMwBbxaBOzAhl4L9MQk0a7JSUpMe+e4
X-Google-Smtp-Source: AGHT+IEpWCbeLGHpAd3C/0Y1ZbY5B1k0NJpI5pCZS9qiA4FHSv0ZUXZnpihKTE1T/asTYZyHKQFkMQ==
X-Received: by 2002:a05:701a:ca88:b0:119:e569:f620 with SMTP id a92af1059eb24-11f34bfac4cmr12209335c88.25.1765903930546;
        Tue, 16 Dec 2025 08:52:10 -0800 (PST)
Received: from gmail.com (ip72-200-102-19.tc.ph.cox.net. [72.200.102.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f392500cdsm37342761c88.7.2025.12.16.08.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 08:52:10 -0800 (PST)
Date: Tue, 16 Dec 2025 09:52:08 -0700
From: Will Rosenberg <whrosenb@asu.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Oliver Rosenberg <olrose55@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 447/614] kernfs: fix memory leak of kernfs_iattrs in
 __kernfs_new_node
Message-ID: <aUGOOLGP84wGy6cM@gmail.com>
References: <20251216111401.280873349@linuxfoundation.org>
 <20251216111417.567991274@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216111417.567991274@linuxfoundation.org>

On Tue, Dec 16, 2025 at 12:13:34PM +0100, Greg Kroah-Hartman wrote:
> 6.18-stable review patch.  If anyone has any objections, please let me know.

Please see https://lkml.org/lkml/2025/12/16/1248.
