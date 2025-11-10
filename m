Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC312BE7B8
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 23:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762817097; cv=none; b=QO9dNv2ziMCMhC7RE1XgSuMJpvmTo663/hw3FD+upBgoA1SZ5RN4f96IZT6QU2ZTfQySvfI2h5rKBCX3tvQFKBwKAUfIYTwWFCIf2ZiVF1W70zQbpuVpvDRrYeYXhtgTj5C1vNK965EsVrNUodXSRcWzErmB5G5riXiovBfiFDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762817097; c=relaxed/simple;
	bh=LfgMc321C2gmcbEJ383Vf+rgHpae4BVbOamwU+8oUxk=;
	h=Date:Message-Id:To:Cc:Subject:From:In-Reply-To:References:
	 Mime-Version:Content-Type; b=YRCtZUapsdEoJtFijJ2OPzDDMTvSCOmNBYxP18Iil23vupnRJOpDmMRyzR3r2iAg4+MPZ87IFdmCfrj3A9HDZAwQF+jYruaICQg82lGy5WaiZzh1C8AMeVmMNTWn+Y1645uAvAaz4ottvvmBBpf2Abq6k56V7Crr2EDOjnHGJf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JKLwW+jN; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JKLwW+jN"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-298144fb9bcso15367125ad.0
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 15:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762817094; x=1763421894; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rB+sgp3H4KhlCjjfdfflHKnV1BKdMwtwK7bRa+WX+h8=;
        b=JKLwW+jNbyylYtYA75itO31l5fuem507gIKiCnUW/FIi+HeomW+/ZgCazXbJKg/yei
         w1Napu1KaPzaODXIgg323khxTjp2XjzcG+pk8M6P9ug0t78sYfbwgqwVZs60SW22goaJ
         fGwVyJl0EURAmHxEoCdgdXvo2SOeUr2wu023pjAgNdSAE7ZcmfwNWfbpVgSAaVirrs+k
         xE03SvgzP+p0j/aw21BJZem2wIi/SonX2SsO3Go9ZU3mv20NJLT4fK/9tHpvfNx3lHsK
         JFVQ7Yd39LTW4Vgdvs5mHnsKgSWKyiHkFduCCBWEvG8rKReIQpD7iwJvVCxJvH7ER2+7
         Jpjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762817094; x=1763421894;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rB+sgp3H4KhlCjjfdfflHKnV1BKdMwtwK7bRa+WX+h8=;
        b=I838UqcMWyAM4H6p5C/dRkFbPFiqpr+380jqWOF520N62vUtBOQsv/hbWO5k43Npdm
         9le3HUt3rNA7hTo41Zw7zyicanvVkqKKq7HYsE9kx3q056DA+ylzN6v6BVVdxaV7vL2k
         ZCc/nNEwyF/AsjpXgJxev2pA8ixQOH8jScRwnrdoL051VeaYJ+RHawscc+rGI5vWSnkH
         wzb9NE3Zf+R2Fm4mP6FBXCF+kwFhMAJ5MAGIDBjevJBikKSQZ4PhM2T78kIei7PV455P
         9G4JFv/9scINwr+ea82TWqkiCP0tW77dDZSctcRR6mJYf2E7bezhXFO47pLg/qL54iUp
         EzYQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3wPQEC4MzDXoEb4yZQc5yLc04ZJ1qwN6/Fc7rGho/Azi2FhiRTANuggETjWQMub5jTQ4ZLRqN@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0oolzhmYiLNoaFwVr5i/K3lcf2Y2JfakIR9BVmuFAAzx5d+yS
	srNByvRzLa8SCq+f1yqTYyFRC/IxHk+iaCXSW6JhNjoh1AwYxDCatqtp
X-Gm-Gg: ASbGncumvUPUur1TMOi9aMmuFTtki+dGHVDrNCmhg7jH5JDvD6rLK9GSH+ahZpL+GbQ
	UNrJyA3v8iVxfthKRjjyJYCmdj/Xja99yDOKiwh0uKYzsd4TvVDI9O0MEClLYr9qXGMsAeKYpog
	ou/6NW3iqeEX0iRDnZzlo7V7MBbLYuDe971Le+QWghiF9Pgz4EGPBWnQ8nHOcyhtlaT6AGm9YVp
	4LwTCINSrndiqw//IPLKQZhqAUmqaPbEItpkiqZXNe/QzhCRMlp8zh+wJRmpEzGdt7DWGGsQdgA
	m6z6B5n7Gqdc1VdgNFeRr4KDXuMh4n23XGGATeskdllPCZ7yxUYFksu3BbZ7SIZogJpsa0JQvdj
	bOyZWXi72a9sdCqHOy6auwaYhjUZqy02iHPJcNP9W8TZqlOEvizYmLedNXcq3vIsFwGVKhAhJwb
	xJpdEJfr+yrpApBBFYm89t8T3QXBKL9F1pq6+iXnad3WOOWvvqyYuM5VsTt7wXKyxW
X-Google-Smtp-Source: AGHT+IGPaBk6e9Khb1yqRKfYMFmfSNYwn1VnFyXe0wXMOkJC9R7tqlKr6n2Ksy2ki1vCKQog9xKolg==
X-Received: by 2002:a17:902:ef02:b0:295:a1a5:bb0f with SMTP id d9443c01a7336-297e565d7aemr118857735ad.18.1762817093570;
        Mon, 10 Nov 2025 15:24:53 -0800 (PST)
Received: from localhost (p5332007-ipxg23901hodogaya.kanagawa.ocn.ne.jp. [180.34.120.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3434c30b96dsm12092310a91.5.2025.11.10.15.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 15:24:53 -0800 (PST)
Date: Tue, 11 Nov 2025 08:24:38 +0900 (JST)
Message-Id: <20251111.082438.1117005832484432168.fujita.tomonori@gmail.com>
To: ojeda@kernel.org
Cc: fujita.tomonori@gmail.com, alex.gaynor@gmail.com, tmgross@umich.edu,
 netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
 boqun.feng@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com,
 lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
 dakr@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 1/3] rust: net: phy: fix example's references to
 `C{22,45}`
From: FUJITA Tomonori <fujita.tomonori@gmail.com>
In-Reply-To: <20251110122223.1677654-1-ojeda@kernel.org>
References: <20251110122223.1677654-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

On Mon, 10 Nov 2025 13:22:21 +0100
Miguel Ojeda <ojeda@kernel.org> wrote:

> The example refers to `phy::C{22,45}`, but there are no such items --
> they are within `reg`.
> 
> Thus fix it.
> 
> Fixes: 5114e05a3cfa ("rust: net::phy unified genphy_read_status function for C22 and C45 registers")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: FUJITA Tomonori <fujita.tomonori@gmail.com>

