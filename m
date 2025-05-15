Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4091B2989A0
	for <patches@lists.linux.dev>; Thu, 15 May 2025 12:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747311343; cv=none; b=pMcfUs4sSJSPZEonRd+Ukj3JzFP6M0UEa3JQPTSwJLgUiOfMLT0WYCWXfFA0sVttOo6ZcWgrs/mfrvpITyFKthpxFhmdqJ/5VgTsuSOOblZMyVt703js9/x3cldkip078UD6m4OdoPt2/Cfbd1sG+TRYjNfj8jNexqx2Efbpyuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747311343; c=relaxed/simple;
	bh=xSdV6ElSngf/vG72YPll51aXchF4HcqQwTl808G2t4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XBj0wJWRtSTfXqBCSCRuqN9aXIKrjqC0BR2sV5NaI+4r5Rlj1OGLuJ4fYbv7kBxazFeiZitoAmelJy1tGdp0yRqsPUV/zrjfzOY0c3jWbnK95Vw/BnP94Er1w+si3+t7zWFDQYoaCXxc6ekwgBRxmLJpwozMNNT+qDM1zpRBDs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Zb4PNm05; arc=none smtp.client-ip=209.85.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Zb4PNm05"
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-3a0af41faa5so441125f8f.2
        for <patches@lists.linux.dev>; Thu, 15 May 2025 05:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1747311339; x=1747916139; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uH0GAaSc7W4vyN6o8zkocK26uhT3TpN4oC3foWYOu0s=;
        b=Zb4PNm05cj+WY8QcEcMd2VvOLTOVfJWNEC/CPc6+L8yfIBnVR/kW1FrilACwm/eUfY
         X97eabrrx/WPrAbHthz3O9U71vOaKuo8df8lFSucvUmKK19j5pCLbAk4W7jEm9MYVBIW
         i/LspboPRwUja6RueqVTXYdVc9b8p4LE5zG33fNBntD9GMG7XV7ovqhUjMsgpfkt3LjN
         sEFIWi/iS9l8hZS0nJz+OnFUhbu8naXDJ3BawNM2H6gX5zxBbTAkWTtzyRaddYV8xaYm
         WXehYQmwnoV9ZJzaHStw2Zr8zZTYn7w9YD059DegK6k7iA9HBk0XtQZ6SQYQpSC+mCAG
         WexQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747311339; x=1747916139;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uH0GAaSc7W4vyN6o8zkocK26uhT3TpN4oC3foWYOu0s=;
        b=A5ioLBkj36Yi3zJlIZY2V5b0WFVYsuLX9r53tdmNIyamk4Uz7g3GQaKN5NUYoKAZ4S
         pSZ84pzMBk4BVWsWVG5QYVJg8sXN9wOfYV4ACS3UsA6Qy8V76ytW6HCVqWiUd6g2DhTB
         pyGjDTK66pRalKsIaOIsRncvRlG9GfuGyoOeUfii7VHm8dGD63s8BXZivdbNpdB9nCg0
         BnqwKOx/jfo8oDyvT89wSnJbw2hlJ1znym8sVdw7i0Kk4groyS3fX+vcs9oQ9Px1O0OD
         073HepHRBdgC8qkVSJVoo8H4C5IBifjG+QjE1I4aZ98dujyUm4HS3VnB1uBdzLmUou0u
         mdmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIN0PzdoiGYT38SY66Nwa7zc0gexPtgClGbkOlt5MmyUuf1dTOD5GD7zhbTy155MsVeit4ehhn@lists.linux.dev
X-Gm-Message-State: AOJu0Yxxfjody13lm12pnWBmieuuBhHak1gpJfd9zHSzxpKB63obYCwH
	BmkYmE2pGMv3Hj4kuzyef95Wvf8rVwxsYandgybyeOj6jec3Mp4hOytSu7WZIG8=
X-Gm-Gg: ASbGncsIfbNQ6egZmmM9W/pqlM7NWvswx3HiWuymb8KJQzK3phMI7Ri6GzK7nwBswLk
	jHdjzLuQJRcL4FniIyNnBZOAtW//RqdeqXZu2cnFBEnE/eka5jpgqHI26ifcHJVNBaITCLGfIKe
	AZTA7/tcwuULKfNXBgpD1tVesyNUJJflDi4HXkG1iSZbXhmsJ1ogM+x3sjQSaTB4p6MwNk9K8+0
	7hWQ44tvCx1PO43WMj2ZKkwLsSNbNp4LWAjqgzd0Y/jMy5jyqlNr/2O0OpH4JyjwPlT/4xaLjK4
	/xv026e9WUkCHxKg1mOktMYLkvOVBQx0n4juATdrxhjbE2XjTrR0vN4OvGvPuV7GmIhL7YTm4QM
	iaKuDrjtzooEWeR8Vm5xxCSQK+0xD9LuzWRe3cZP8LDrt
X-Google-Smtp-Source: AGHT+IGvHF0ghUmj2Kk8tVmCLsRiUBezE1BL4S2vxUPaMXUrfbDHNuKJGNldtJMeEAHQa/avJuPj0w==
X-Received: by 2002:a05:6000:1789:b0:3a3:4a30:9286 with SMTP id ffacd0b85a97d-3a3537a8fdamr2085268f8f.42.1747311339495;
        Thu, 15 May 2025 05:15:39 -0700 (PDT)
Received: from u94a (2001-b011-fa04-b2d3-b2dc-efff-fee8-7e7a.dynamic-ip6.hinet.net. [2001:b011:fa04:b2d3:b2dc:efff:fee8:7e7a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237761f23sm11153625b3a.77.2025.05.15.05.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 May 2025 05:15:39 -0700 (PDT)
Date: Thu, 15 May 2025 20:15:32 +0800
From: Shung-Hsi Yu <shung-hsi.yu@suse.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, kees@kernel.org
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc2 review
Message-ID: <vrvefaimjqkseuoyuhgg6omt2ypgp5v6xwwuxihj2t5jidizyr@ir5w67k4kl36>
References: <20250514125625.496402993@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514125625.496402993@linuxfoundation.org>

On Wed, May 14, 2025 at 03:04:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
...
> Kees Cook <kees@kernel.org>
>     mm: vmalloc: support more granular vrealloc() sizing

The above is causing a slow down in BPF verifier[1]. Assuming BPF
selftests are somewhat representing of real world BPF programs, the slow
down would be around 2x on average, but for an unrealistic worth-case it
could go as high as 40x[2].

1: https://lore.kernel.org/stable/20250515041659.smhllyarxdwp7cav@desk/
2: https://lore.kernel.org/stable/g4fpslyse2s6hnprgkbp23ykxn67q5wabbkpivuc3rro5bivo4@sj2o3nd5vwwm/
