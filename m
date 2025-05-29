Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A38922D4FA
	for <patches@lists.linux.dev>; Thu, 29 May 2025 21:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748555863; cv=none; b=ZCN0f3ZkIiu8/cOPKF0VSuabpFSz44DW11yYeisMWWh/nTPcKmwG795Lvwz0LmlKumnWkUBDfxKNBo3Vw2BZTjWPF5HbCaII7tGTDvaTPMkcOxX2hu418sOXjNicorJu1gulglPHLMcB8C3KaOCZc1Mvpz2dR4st7uiq7cXp9zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748555863; c=relaxed/simple;
	bh=hRhuj7xE1dBPPnx/EVxIJiotQ89zyqzhXVw7IFjGmE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KMGw1cFQf0Nqo+LnTEqk8SsEIZVj6fBwcHPAZFLYTjIqc+DaBR48RLYAbCA15IWk1IgT1zlDA24V76JbAVajPKXGGBlQCnPqksdcPEKaWuIhi6kJZto8h64EmSXPqJgmG6MEQ0bmtQREg+GY+QyVBVN3WQRC8zvMRvxLtMQCCfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mj3wVum7; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mj3wVum7"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22e16234307so12226445ad.0
        for <patches@lists.linux.dev>; Thu, 29 May 2025 14:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748555860; x=1749160660; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x0GMs9CYxQo1qYKiYb5d9sx6J+FnaGgIltFASAatpr4=;
        b=Mj3wVum7cfnBc8Lnpwz2umeHHbC4UlojZuinB/yuR30FjI57eLC6rVo7DuGRGiiTeO
         c26L++heRo7lKhqVQrg7Cs/Q6xfbCqcG6DAuDVKcv3yjkIJS+WelyQQiDS9xx2Fm2+wO
         SzM0RlFtTbD6Um8pEyFoa8TPwtOtSISt7o4Cutzr6GaBpzI6llmkzwIz3nd7zLpJNohL
         iYbEV7Jya0vBf4d+fo5M1jJZunmVoSsbipSeawjefbfW5DFBPz42V/9Py4IDleuoE5M/
         U27IWgC8QZRnyRnx9b8BgYuoyAW4pKt5Ks+P3Fso9ZBnfEknDRAzT9BgK59rXnTXGIW9
         nfow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748555860; x=1749160660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x0GMs9CYxQo1qYKiYb5d9sx6J+FnaGgIltFASAatpr4=;
        b=mkItq+eqaJFQMF6mY2BWdUDlWQqDGbpSij9mws52eLRzaLYEi28CStXq7lgT0k5xuA
         iUKuU5v/kFMHgvhhyT/9XopLlhru6IUFcFJKzl74cf5RM7eCeGYA8o3GfSKBatWh9zzO
         Qms0P3G4tIRL1rr9Leqkvdni497ij9KuCdTZWVHt9CiCjt7EazjsjEB/xWwQwh5KbXzg
         ht5ApEJ6H0r8MP6NvGGyCkTbkUY2v4YG9Ii+A2Uo9N+4vtgYr6uMn0/wxSqv1zIP+wCf
         1lx8VkQb2aVNltAsxqK0bbPREW1QfNn0pF+5sBC2zmh6T1BTPXMHMN+8a62/IAAmFFls
         TEBw==
X-Forwarded-Encrypted: i=1; AJvYcCWdbImdmzTTA0q2M3U9MOSax/t5SKQW4fDQmik0ahhbcYBWE+Q2KKa8JwQrXrHKw/Po8eC3U07t@lists.linux.dev
X-Gm-Message-State: AOJu0YzVABc9Ng3mwtPccnxT/68rXM/rIq9QlTf/kPMIjDDq6DHIOBVb
	1kPcKXTMwE2OuNExgvysNkKfkU1VVn7Km9JMgrMKWwpuYZtqEEhwoUL+
X-Gm-Gg: ASbGncvU/IOg0T077hRETUJb+un2tCNl489FNectlpSepqRKSZlQXly7lq+WdiMRFdS
	a0nFhhiX9D9bDNqJl9AUWdu37bB6TjnXHDbbbnxOcdDxUT1PWpAunziXlloF/tkjRNrHiKJWPUr
	75sy0g0TOHsy0EATkfUWo28qT+m/WMsBtMHDkAQrAoXxC+wvi/0davKiPpz8i4cUNEqi9jH/80f
	+4Xp+YDqlUt7k0/eYzNTdFD2ai67gmm50bo4OqB+BbHQX3gBs5bZOK3CIYwovELDz8vkutXX6N8
	guRyx8IaOYnMopbVZcLQ1aIO0fufmNshDRH+zMQxPBtWKEX2ot/hF1PlN+ZaBnw=
X-Google-Smtp-Source: AGHT+IFCgSmz/OIAP9QcUueti/TFiI+FoURwz75jbYsNGy7OOgBeFcGvWYnDLiQ58WZGcXzehIbEvw==
X-Received: by 2002:a17:902:e803:b0:215:ba2b:cd55 with SMTP id d9443c01a7336-2352af0b270mr13215645ad.2.1748555860392;
        Thu, 29 May 2025 14:57:40 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:4497:aae1:cfdf:dc31])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506d14c9asm16655905ad.231.2025.05.29.14.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 May 2025 14:57:40 -0700 (PDT)
Date: Thu, 29 May 2025 14:57:37 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Hanno =?utf-8?B?QsO2Y2s=?= <hanno@hboeck.de>
Subject: Re: [PATCH 6.14 750/783] Input: synaptics-rmi - fix crash with
 unsupported versions of F34
Message-ID: <mznd6ptvrkapnt2tra63bsavlzr6iuicd5o4re32vrtye5au6w@5q4b22g3oszc>
References: <20250527162513.035720581@linuxfoundation.org>
 <20250527162543.672934881@linuxfoundation.org>
 <i7tnbh7l2blxussxcdgjuvcpkzet5w552dqu6vl5upus4xf74n@dva72me3bdia>
 <2025052959-corrode-outback-6ecd@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025052959-corrode-outback-6ecd@gregkh>

On Thu, May 29, 2025 at 08:35:17AM +0200, Greg Kroah-Hartman wrote:
> On Tue, May 27, 2025 at 01:42:39PM -0700, Dmitry Torokhov wrote:
> > Hi Greg,
> > 
> > On Tue, May 27, 2025 at 06:29:07PM +0200, Greg Kroah-Hartman wrote:
> > > 6.14-stable review patch.  If anyone has any objections, please let me know.
> > 
> > Can you hold this for a bit? I might need to revert this.
> 
> Now dropped from all stable queues.  Let us know when you want this
> added back.

Thank you. It looks like it was a false alarm, but I'll wait a few more
days just to make sure.

-- 
Dmitry
