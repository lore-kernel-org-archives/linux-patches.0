Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B468515351C
	for <patches@lists.linux.dev>; Mon, 12 Aug 2024 23:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723505727; cv=none; b=e7EqzggyYyvzEcT7dRczARJiE2HOR9NFb5Xnu8l5whw4Db+s8+37tCN9Kmb2c7HbNfOVDPKvypZDK1NQGtOjIHNjscmQK7vS7D2T8iKFYMY8XhWm3XW7Gjg7Fke5Yc194B6dwTl1KIArlC8Wcm36dIs84qv52QOtvlcibLELFwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723505727; c=relaxed/simple;
	bh=Hy0ZvmapsHnKQsjI2/9Kuh7dY0hLrow3eJAbXthoyh8=;
	h=MIME-Version:In-Reply-To:Message-ID:Date:Subject:From:To:Cc:
	 Content-Type; b=e3OHMvLjP7T12eWnYcm1SbwC+E/zPZIm61hmnbyQs+/y2lUTRFZFXHW1KkL1XyKpJpb8KVxIfy/ojcPrRPVcd5hiuiIi4QGhr7o3c1QLx71+rGNZ8goBl6w7VM19SHPOdmNAUoP9lkypvq10SxVij0EQoY5bUz+pUCq5tyc/HPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QCbjkoY3; arc=none smtp.client-ip=209.85.167.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QCbjkoY3"
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-52efd4afebeso5618857e87.2
        for <patches@lists.linux.dev>; Mon, 12 Aug 2024 16:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723505724; x=1724110524; darn=lists.linux.dev;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Hy0ZvmapsHnKQsjI2/9Kuh7dY0hLrow3eJAbXthoyh8=;
        b=QCbjkoY3CxZ8zX6/NUeYEmjxtZOSBNJl7+CVO8Gr3NJJFhFx4+AooHY03Cuzd+0fic
         XL14+d1SRbyzsZ0DqQ3TDoWKWtjEyIJfnvx+n5CEZlaKhcJYrEz1yEhwrMGECP4+OIcV
         3qQMntsU3LpT7MofmMuJNGMUF6ST5Q2htqF4u4KNHBnf7fycduLuhQokleR/Gis7fC8S
         8JHaP7Ohh/h6yhviPnZKEXPwnuA60mCajyhC4whAfZPldieRMJNkEzguiZl1omUJGPlY
         6ij0SBdrUiqRzGUL4zVwVadDtTgHxXNcVERcNvJQpMXOoBGi5Ole895QKQjMV0DcJ3mP
         md2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723505724; x=1724110524;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hy0ZvmapsHnKQsjI2/9Kuh7dY0hLrow3eJAbXthoyh8=;
        b=VDyDQOlstoo6JIyEmt5npYOvpjQwTBHu21OboaCe6g7rQ7kJv/sQRyQfZFGBYp+QBO
         ED2jj84/hdjdd7sk1aGjgiVSuI+/hOGibWC+vIUesi7Wmt4fV1nhPPPvS/3KBRyvCFMH
         hrMImqSivn6EDoYLYTUlTnfo7FO9Bs7fdPtR/mYVN9nRYutsZ8aO0HhQuvKjR4JEIZc+
         A1mQO4TWa71T0QB5v0T9OCCTKGHDvgzFRQN01b7s6jIR5dxlPwxcDtIAuHxVRhvfHFjT
         PY5LZQHl4lGOVVQUqbd2OTuZflTPN8lkfKzrBkzLRxFGnYXJJrFzSekYeTRUUgQRGtFd
         1bXw==
X-Forwarded-Encrypted: i=1; AJvYcCW73q6llR4U+1c+AOPcLE+uyeTlmJMvk/l0BujUIhtDKgqzZPC5tyF2LKi95wT3zpE+mSSswIOsfkicvKBGcJY2IywjOO+GlA==
X-Gm-Message-State: AOJu0YwUjEk/tE54PlvxvBPvCeE2QRSjESKCSZes1RQLqEZ59J/SWOmo
	kbx3vAciZcgTtmByXQ3q8JNj+8GfU8k/gV2sa/BeXPbw8h9dEgfj1J/09G0YNLxuxk03mYH1Mnr
	dYW98lPXi+cmbJ3xEI4oM90Ew2s7ddQFfg76AaDNk6+jaRHD9nmfLVdF0jdzVUCLtebj+tlHUSa
	o3IP3F6dJnpD8LIcNtquX1D5DT8n8o
X-Google-Smtp-Source: AGHT+IGEp+AwdpeFm4dxHYRCCnoilgVvaClqAM29tGqqDOKna6lHdwZJdY1EXP7H5dtHO2HUltCC1HJ6Z63/LBHkMWlKRjtPdAWISN57IgE25B2mOg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6512:1291:b0:52f:384:1a1d with SMTP id
 2adb3069b0e04-532136a5aa1mr3029e87.11.1723505723801; Mon, 12 Aug 2024
 16:35:23 -0700 (PDT)
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
Message-ID: <0000000000006fd56f061f84f2f3@google.com>
Date: Mon, 12 Aug 2024 23:35:23 +0000
Subject: Re: [PATCH 6.6 000/189] 6.6.46-rc1 review
From: ChromeOS Kernel Stable Merge <mdb.chromeos-kernel-auto-merge+noreply@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, chromeos-kernel-stable-merge@google.com, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Hello,

This rc kernel passed ChromeOS CQ tests:
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/5782321/1?tab=checks

Thanks,

Tested-by: ChromeOS CQ Test <chromeos-kernel-stable-merge@google.com>
