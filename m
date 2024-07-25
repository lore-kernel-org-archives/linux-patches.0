Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13501990CD
	for <patches@lists.linux.dev>; Thu, 25 Jul 2024 16:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721926752; cv=none; b=Zp663sVEu35cIQ9rgAhb9GVPOfEqMavX6R8ZnA99U9Q5WDHJKZiX7KMMLk+Xsjkw18XAh9OSt1bGfWq2oYioP1J43sz4cvqM2BrDLqZZMoW/TyIFscPKoOis8vGZOZmpunFBueFn342BbdnDrvSmJ5EoLjNxfxl7k8oTtOedXLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721926752; c=relaxed/simple;
	bh=zbz2uz2X/Qj5LK8ZHZYiF+bV5FFXK8uOhdFiKgWEdrg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tqid0RHTE0ZYR7vKc/4YyKbmOWefMyX/foEI6uKLWPbLa2P+lHcMTbFUYwqKBGPYFEP8sZZf4K8uNcIyxqh1yhYEmx0OWingfB5TjIl79hMEkWlC24V7anbLd/tL3YxtKUp2/Aw7HmT0vYSHio1jDGQVjZtV/LRAZt8s6KYZ6So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Su0jnOgn; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Su0jnOgn"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a7aa086b077so75481366b.0
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 09:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1721926749; x=1722531549; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=otHL7EsRGMXAdCY+bJE7Pic8AIGF/rLoS3HxdujJZJo=;
        b=Su0jnOgn2x5dRFEOYqcmJFsU7+Yk0Dx9xd0QxVJY21voqpZ3Lgkec1r3JxbK/i6SG6
         KOpBhsz8Z9IuFY0rb7OwsxwNJ/oK6wwE+VqLrPJgrBrc0Pc4DBHOfx31SeKdrtCDx9+R
         nk4GYN9LYagTp9GVTPsc2RUnrA6LMm+Ft4odI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721926749; x=1722531549;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=otHL7EsRGMXAdCY+bJE7Pic8AIGF/rLoS3HxdujJZJo=;
        b=lbcbakiRd8o36jjrf0rfv3seNMXidW0CZkP3cSY3afGYGHL5FOc9huxy5R0h3TDv+f
         cf0/HvJ+w6dfXNmhmUVRJd/9p+Q3KZepFaMY8o1xyDd8cA2nDHSxXjGWaQPzqqlV5Mgt
         kycrW21sQpCxSFSgHXUoDzG2X4wPy8gyF9kkKPpbyC1ZfQjqnL4tqI2zaGYMlJYi7oMt
         PSU10c1DNDIjDXb/7ah+AP7Wk11ZRHYK1z74bGp2ljGssa3JoHr3CzTOKD8WcJUFKXCN
         lyZHeqtNayz5CjN5PDWfl1Uf3yD9gtkb+Mjv4PMB5GwG1py3mO767LhjnGtWqjlkhK4c
         iSSg==
X-Forwarded-Encrypted: i=1; AJvYcCWmPi/Irx7KHAO/Tlh8jjq8HY+ptRQKQ8Ibw1AJ1BiKVKpYD7BZlOaFJoVitlY/xN4pNIG/ZwvIqBupvQ5FLY3fgr48N9rumg==
X-Gm-Message-State: AOJu0YwOjUspUNQKoBdju5ZcN5H6fDZW3XRKuqJrm3h47fLgaDMa8G3t
	Tf3YmAu6vL6NFlyYllpG15KhmbPOQwqJ3nhXeqdy4Yk999z8fBDFOjb40f9HuKfCWPcRcYptO1x
	w5hIPkQ==
X-Google-Smtp-Source: AGHT+IHB2eADE3R0TZ00FyQVE3bSVv/aRyQiAi+5thXkrn/sQANYBUAgH+cmBP4BE/GbXzqbXBL7Xg==
X-Received: by 2002:a17:906:c4e:b0:a7a:9a78:4b5a with SMTP id a640c23a62f3a-a7ac5034379mr194193666b.52.1721926748958;
        Thu, 25 Jul 2024 09:59:08 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acab28b8dsm92379666b.13.2024.07.25.09.59.07
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 09:59:08 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a7a9a369055so81832366b.3
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 09:59:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVkoS+0MTzXEHewJxQq15GC+w36/AuEsqwAIvu/fpkk42sgsPDigx+AG2C39ISJ/PAxhRXqzbeCad4ksNhq1M/mtC2av6js5A==
X-Received: by 2002:a17:906:dc95:b0:a79:8149:967a with SMTP id
 a640c23a62f3a-a7ac4de31d8mr293056566b.16.1721926747586; Thu, 25 Jul 2024
 09:59:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240725142738.422724252@linuxfoundation.org> <20240725142741.075359047@linuxfoundation.org>
In-Reply-To: <20240725142741.075359047@linuxfoundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Jul 2024 09:58:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=whsVLP==D=VYGJUpuWaNbcB_nW-ZR5XBs_RddXgtLRiGA@mail.gmail.com>
Message-ID: <CAHk-=whsVLP==D=VYGJUpuWaNbcB_nW-ZR5XBs_RddXgtLRiGA@mail.gmail.com>
Subject: Re: [PATCH 5.15 70/87] minmax: relax check to allow comparison
 between unsigned arguments and signed constants
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	David Laight <david.laight@aculab.com>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Christoph Hellwig <hch@infradead.org>, 
	"Jason A. Donenfeld" <Jason@zx2c4.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 25 Jul 2024 at 07:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 5.15-stable review patch.  If anyone has any objections, please let me know.

I assume the min/max patches had some reason to be backported that is
probably mentioned somewhere in the forest of patches, but I missed
it.

It's ok, but people are literally talking about this set of patches
causing a big slowdown in building the kernel, with some files going
from less than a second to build to being 15+ seconds because of the
preprocessor expansion they can cause.

               Linus
