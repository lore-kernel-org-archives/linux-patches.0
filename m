Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF7312B72
	for <patches@lists.linux.dev>; Thu, 25 Jul 2024 17:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721928988; cv=none; b=c3K8w1w6/sPVOet9zh14i30GUTNh3unIZ31kFZr0vbxP/oWr9vso033AgL7DPJNgAwLtZtui2rICSv+p8D4jMn/P4+4j0lchtZmht3lrN6C/tIB0IxQKnF/7sTUc8WxBREE34j919ZPMpIFrxlfeuf63P9ittjbJBwThiRr5B3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721928988; c=relaxed/simple;
	bh=bkVP/JveWOYBSqxEDtS8G6DuoYTZeUByxAQx044XrYo=;
	h=MIME-Version:In-Reply-To:Message-ID:Date:Subject:From:To:Cc:
	 Content-Type; b=mVVK5WlgvUgGUNadv9YCB6Vn/D8qm5j+XC9JGVFjQ90uAi/zSp+baMYdH6pIdqyfONI1BgFB6kUAf077l0cxhQ3NRCOBbvX2khSftQzujkyQm09tT3NCX7DtkL5b0HiUclWofe+a+6SGVvmg5EdQGxAJ+u0kGLdqh9FEcf9L9fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eODjGI1c; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cros-rc-feedback.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eODjGI1c"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1fc54c57a92so10640715ad.3
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 10:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721928986; x=1722533786; darn=lists.linux.dev;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bkVP/JveWOYBSqxEDtS8G6DuoYTZeUByxAQx044XrYo=;
        b=eODjGI1crEAXFmsp8E6XDWQNWvEw8KqDlnYnIwZC2k9q7JXrpadAxNT/005TuQ6BTK
         wG0ekKYgpkX9oKPeIu/NymZJcQwSe52USrmVMBbzLe8pNiLZWNXHULykynL3qYQD5vzH
         iDeoHiQ9E7cnk6ls9ROK9G5rnXIz2oA7EStaNZQWN6F26VU4zncj8GsLbjW+MaPJBx87
         Q5Q773lvgO6SV0uF4bpWjDBpSoh8VogPfEWqWjQUkEKNmWIKNvxHGtF6aZX/mc8FfnBh
         mwWYuM+hPFvkmZtgNA3Aq4dpH2AKQp1Veoq7XKczLRePGws96lvn8cSYqPkByipz5WU/
         kRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721928986; x=1722533786;
        h=cc:to:from:subject:date:message-id:in-reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bkVP/JveWOYBSqxEDtS8G6DuoYTZeUByxAQx044XrYo=;
        b=blPGvpg8CSfb6G43oZJ7xqHv40P178Vrc6MBqhtkvEV66tisDsE6ZGH+FcdIQIW162
         EJtkcmdb7hjZXJItEI5bAZMAQR4+pqlUPb2/Xk7CTyzKkS6PHpaoDqTzkK381gnv/FoO
         8h6MJGoWqv/OxWxmwWPHLZidpFkRXYTEqJ3QFV9ruCi9rujiGSue7q/tC0aIzD1Iy1QU
         kfwpdAIXljJcL44x/jxePdG9YabYfSLsDhNUO1gu7pW6/N+77owz/FLgPCxS5v3+Ar9b
         P0OG8Mei4nF2ooaegJfT/7DQN0sH8UnVztDPkYSa4rRuNx5yHHCEWWPB2r6UO3Dy9EW3
         p1Hw==
X-Forwarded-Encrypted: i=1; AJvYcCVUQjXGWW/q5orxzSM/H2V1eBJjx5ppiyX03BTbSXHXpmthdwb7pxpFnKSP3dZ1PRmZs2cECOt2cn5clGjyg1UdB7QgjURHwg==
X-Gm-Message-State: AOJu0Yz5CoFgMX/9Ywj91MJ9ynvZ8alieqv0j/RMD6mnZKmzvbelXaiM
	CZqiFWA8fTWyLChJjdKlVkIjL0QWFMwkIq1t+sRI/tGDAHuPMd5q9XdHQzrgNUUB9EmscshTt4E
	I5st5yu/X396qBH9Se+A5gDgr/TSYfYzMhqjDLL+JrjaSycgn8G+GLAzJS35xpl3WlYOrjNuoTI
	ktj0T0t9gMQl+SMGIdxgh118NT0Mjb
X-Google-Smtp-Source: AGHT+IGLENNFfLuD3BXA3lnI80YIlKe1lnhUu/JzKWAQr/SHqjW09uy3gexZtrel+vD4TK+AAdLk7jiQU0peQh9kochpv0/2n2w7+Jtamo0pXGW9ag==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a17:902:db0e:b0:1f7:3bb3:abe2 with SMTP id
 d9443c01a7336-1fed39daccbmr1347845ad.12.1721928986241; Thu, 25 Jul 2024
 10:36:26 -0700 (PDT)
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
Message-ID: <0000000000008e43c8061e15d54b@google.com>
Date: Thu, 25 Jul 2024 17:36:26 +0000
Subject: Re: [PATCH 5.4 00/43] 5.4.281-rc1 review
From: ChromeOS Kernel Stable Merge <mdb.chromeos-kernel-auto-merge+noreply@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: chromeos-kernel-stable-merge@google.com, 
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
https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/5741618/1?tab=checks

Thanks,

Tested-by: ChromeOS CQ Test <chromeos-kernel-stable-merge@google.com>
