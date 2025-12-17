Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EC822B8C5
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 06:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765951531; cv=none; b=hTfXijwg39t/hRAitqxznGXU0mYmILf3HKgiE9LPS4eZOtzfEE7b4km21fOmOGG98hWT4vnqcE46A0Wo7GUXHbSkGFJx8E4GTfU6cuwasnydPa+CuQNLReHApGQkOQ6o1sWcL0rhHtgSg/rzD5gbrVEamhvPRnFNrVgj0aCJhgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765951531; c=relaxed/simple;
	bh=Ad7jbh9OQllWzVlWsfSRDDb21iSIkblF3QCWAyabS1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LdI2sfUGV8VD4IfN+o4avyg2rYDdW5bF8V3+aNsFmwUYAt4muIt79wrq7m7Aiq8UpGs0PIq9QSWzW3GYD3UNuivGByRNtPRt6wRpGeRShKwc4vjxGBIms6FswOyGuiM4e8WdlE2E4prcAdpzKRYGM00qx2OCs8MdLSokbY27ut0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=f7/NL1xK; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="f7/NL1xK"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c13771b2cf9so2851142a12.1
        for <patches@lists.linux.dev>; Tue, 16 Dec 2025 22:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1765951529; x=1766556329; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KiR86f9NEoa8u2CiVtbJoQt39drdbuU5otJ8Ulv+zrE=;
        b=f7/NL1xK8tbifbNG8bZWoch/rQ1EBfjLm9ftmtSzzXotgr1UICu32OZ6f09tl2mYUl
         WEkJ7CayXmd0w5g9cqxDRwT/FXSH4EzApYKWuFXHRMeUf0ocXrETjE3JjpVd+48RDSDq
         PUpewdet/qmPtaR1Ci8ST0kObGsyGlhfr1gW+BOxqwk29MlV7loplGrAVax6D5HQdRch
         Ae7XPVnaonLxQsXhs2JTPOULufGkPatV8wHX0V2mlBbnAZ5vE9vgozIUAhdzremgfUFr
         uFfP5SeToRc24kruw9uvLGJETq8yHH76qhKRL467oz64f7nX4OLvXAKeivTOZKlVvNV+
         vN8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765951529; x=1766556329;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KiR86f9NEoa8u2CiVtbJoQt39drdbuU5otJ8Ulv+zrE=;
        b=CGzjCqrxxC+DVYyvGUy+lSlBDIeFfYnYeJzEOX6AJdu5OCQyEYmNxU6ymc9oVQVN0a
         p1vb0q/ApifMB/Hmnbjq+pxnT32az2FbUUm/y8BDMjm9q+URAh09RwQV9mJVZGBR74T+
         ZEmq0S0KgQwjsm9TB0F4h5xF2Wc2yjHtmw/P5l6djX3bU05OR9xQSfnCAGC5dTQ7BWak
         DlaSbeew7qKDeIiYOzTpRmk+2Fd4BQbHN/sbd+1So2bJ5SX87r/juxc61WRrl+/788Ql
         mgE9Axg2WM1VIOlL1ywVctIrN/1lkqiW08H/UhrVDYwM8n6eKJeZXudg8PBA9RW1gEV4
         te9g==
X-Forwarded-Encrypted: i=1; AJvYcCVRCnN1oNyVVc6o03eqhfuz408QH3wNYsSmDMjblue4c0TEwuoluCXwC0RD9utyuuX9yCe59TA5@lists.linux.dev
X-Gm-Message-State: AOJu0YzsdxVqXuQj3Lz84gLu6N2OI/WSkXmyEKM6oH7jxdnZ62RPa4hn
	pZRZXS0+Uv5WbrKQe7fcKH6VgP0jZ5qwjG4qTRj3JDjwAcbZ7rpvyjbzi5SVOS7t4A==
X-Gm-Gg: AY/fxX7ByKhbXyQUP3WNja7g3W2YW/SCr//IQmtws9e+Tl7Fdn/EczJ0Tek1hhAy+zx
	wIYR8+JzWCl/sCwMc5f3vIfl5bHO+4dxJ46j4JDuQ+0J+jTD4ezyUlnl99iu7zijWnPYGhmIDsK
	ZzRvvjC/TH4LVjtQfTL38x2/jHTy8lThLQ/AykllqFvRwDQxs4PLKlVHvtKeBSmLJQ/+d/nmmYg
	AvrFUUXUKvN2Ym1hPPrPYTKae1JWcP6yRhY7F9QPoiisS/YWOdxaGt0Ll34mfoIL/LiuV0amEsa
	iFuqfa7by8SOy4pbURLiVu2gcsZilDus6aSv/a3NDjMSgzAJ/9dUKXfLQLCHEjXLOMmJeMLz0m1
	bOoo10CTgkFJELTQJC7mVtQ1TicxhLm0pJMoMLxPgAIVSXKKTQ9IqAMD8L9/9h7zLqYv1JyUO+m
	Vugnwn6Z7vsvAYIF8RHORv1fBjdwxq9fUTsV7xyT/fEIc=
X-Google-Smtp-Source: AGHT+IFpaLpwpmMAyJ8lx6LOfcUfhHVxCcXUNqCAf/QcneB9oI0byP2Sg1xC7/TQYNjWzXw0V9xhBQ==
X-Received: by 2002:a05:7022:3a8e:b0:11a:44d1:533a with SMTP id a92af1059eb24-11f349c54ddmr13362634c88.12.1765951529487;
        Tue, 16 Dec 2025 22:05:29 -0800 (PST)
Received: from gmail.com (ip72-200-102-19.tc.ph.cox.net. [72.200.102.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f446460c8sm22914800c88.10.2025.12.16.22.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 22:05:29 -0800 (PST)
Date: Tue, 16 Dec 2025 23:05:27 -0700
From: Will Rosenberg <whrosenb@asu.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Oliver Rosenberg <olrose55@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 240/354] kernfs: fix memory leak of kernfs_iattrs in
 __kernfs_new_node
Message-ID: <aUJIJ6QFNDSk8trU@gmail.com>
References: <20251216111320.896758933@linuxfoundation.org>
 <20251216111329.608256836@linuxfoundation.org>
 <aUGN6G0v6bi8joVR@gmail.com>
 <2025121740-utility-transform-f252@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025121740-utility-transform-f252@gregkh>

On Wed, Dec 17, 2025 at 06:17:24AM +0100, Greg Kroah-Hartman wrote:
> Please don't use lkml.org, we don't control it and it often goes down.
> Please use lore.kernel.org instead.
> 
> Also, this was totally context-less, what do you want me to do here?
> Drop this?  change this?  Wait?  Something else?

Sorry about that, here is the link from lore.kernel.org:

https://lore.kernel.org/all/20251217060107.4171558-1-whrosenb@asu.edu/

This patch should be dropped (or replaced). The patch is faulty and
introduces a new bug, as discussed in the link above. The patch
should also be droped for 6.6-stable, 6.17-stable, and 6.18-stable.
