Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CF1130A79
	for <patches@lists.linux.dev>; Thu, 13 Jun 2024 16:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718296511; cv=none; b=muszDgFH58ons4EHEVqHbaUsHnVfZ9dV/ZN72fbyW3rgLSX+H6fqKP2PQ3t3bYG+uvEqJLmNljVWoHlmNgqF8i4TFd+eOzECwAH7tPWezGz3m8Rhh3RMYM0YF6wj7utr5QCb4B+LNPUIv15vyDyGenmnP3STSJ43Et2W/8YoEwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718296511; c=relaxed/simple;
	bh=7euHBXMSi/kaVkj8AhsW9pAkb/1KDYWGLaUHuBaHXwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FPepuO9ZT0N7hDe5RiVLKH16HE+6MNxeCA3x+Eg5J4LBemGS/TssPfMwC+QIXczsgUII6pBajoPVJ5BRHkOd6pQzkJLYxlttTcomMM0V9JbgJ79aUs51q5F7WUpWY8kK0TBpWgC6HZb3WAubmTUugDdoepAnnNIae2OWqVZaD8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DOZ6bklW; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DOZ6bklW"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1f6e183f084so9764055ad.1
        for <patches@lists.linux.dev>; Thu, 13 Jun 2024 09:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718296509; x=1718901309; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=som+/sJ+Se4Beu8MAdu4wW2b1WRUEu8QLH2yvLXXBlM=;
        b=DOZ6bklWTvWcUPhjuCVUAr7z74WMTwBluLkPwxePLgF6XuLb5hRtAc0WeXf2mcbCAf
         35RhrIfAWM1vdcRZkOhBdvNAVoBuTXTNxVRsRRL1chTEYBdoBu3syKdFmGzck+5829z4
         g8MPi/N10avLmm8NbrAfF8Y1MsWL+R/jKKUW7TesGIcF1mMQg1dHVYZ8n0cr9fMTwnmr
         Fy3Chwfh1bzCE+nqmpeMfTwFy/AkLCgrSv5spkPnrdEgBLMjcTrWldT15nurjWg7HVWe
         KF1RSXqzroDqh9heKzIaXLg/DfV6vkoGUcPnsYN6MDy8UOmuw6kre9hsnwU390LkNmeO
         MzDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718296509; x=1718901309;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=som+/sJ+Se4Beu8MAdu4wW2b1WRUEu8QLH2yvLXXBlM=;
        b=XudKYUfYktOvqNkyWvOzuYn6+RsZps/WNrXtALtSyf+eWVJkvOJM0cV0daOLAc+J5x
         PFSzrEfVzJOsdtLeexicaeMvjnxwVV1DpTZ+/3iLSwDzZ8DxnGRI+kj3XemIDuxUg9mW
         OzlSZfVIqL7eHKkv5JevIKOPmE4RMiy4+7TQ7hkxMbH7RDT6wUR5k8OECS+Y0Pr9ANvD
         nBDVH7YxmReliEtZ/QaKu7tLMBf5E02TCXy4L1aH5mH+hAI97WBxia2tNcFLfVRNtBwm
         KW++k7M96q/ssg3xM05UEBVugqGBCrklnFNo0SVbvNwsgDPGCAnE8GTcxcI1Vrd6y+eu
         PMbg==
X-Forwarded-Encrypted: i=1; AJvYcCUtY/SaWJ92UMgM9bZ8/2E88R/D4PkTCYJ2FHxJQcygKgwoBY3u3ZEyrTwo1YvEIHqRwKwoqDDxBnUHBHvgd0OHMFBeuZr9rA==
X-Gm-Message-State: AOJu0YwutNnVIDmSRjZ/latUj3V47FDKDk/FmXaxkbIgk043Bdl29Bl+
	XUzyFylACTWKc6s0R0zkdu52Iy44n/ROZg4xKVRkjHHwsCkCXO4L
X-Google-Smtp-Source: AGHT+IHpCGuCoL507defMb9VqgUzyDLOdtSlPTwYqUErBCiK90elGO8dIGwxF5qj7XmILZ94Kj5RTw==
X-Received: by 2002:a17:903:2a84:b0:1f6:fcca:12dc with SMTP id d9443c01a7336-1f8627df843mr2427545ad.28.1718296509435;
        Thu, 13 Jun 2024 09:35:09 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855ee8096sm15972805ad.171.2024.06.13.09.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 09:35:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 13 Jun 2024 09:35:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.4 000/202] 5.4.278-rc1 review
Message-ID: <3ed1ecee-78bb-450e-933f-1e06b1e392bd@roeck-us.net>
References: <20240613113227.759341286@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>

On Thu, Jun 13, 2024 at 01:31:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.278 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 

net/nfc/nci/core.c:1455:15: error:
      mixing declarations and code is incompatible with standards before C99
      [-Werror,-Wdeclaration-after-statement]
 1455 |         unsigned int hdr_size = NCI_CTRL_HDR_SIZE;

Maybe enable C99 on older kernel branches ?

The code is

+static bool nci_valid_size(struct sk_buff *skb)
+{
+       BUILD_BUG_ON(NCI_CTRL_HDR_SIZE != NCI_DATA_HDR_SIZE);
+       unsigned int hdr_size = NCI_CTRL_HDR_SIZE;

Swapping those two lines would be another possible fix.

Guenter
