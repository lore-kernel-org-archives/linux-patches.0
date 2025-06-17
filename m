Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E982FA620
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 16:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178044; cv=none; b=BIxlLmpzFN05AfnlPV1lPlH3yJUlC3QdkpQwu9N4284IcRhtxSas2SwlXP/zDFhvg4zucom4GbBV2zpBaW1Ck1x+hUJElhl+XN6OQQaZ674MrGumsslI6wF5KgzZfiXeA+MA1IL2NDLaCbm49XilZHU9yFsAcFHzsJ0AcEhdS4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178044; c=relaxed/simple;
	bh=wuQK4PY6Wesx93pO6kQyuApJXzA7Pnaiiz9upoFqK5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nbGwWFErAZd3lYzbGtNtqkxUr3EiT0ZHoziG6f9tdr/d/m1SYwsBzFfmxqxiQh2+6PlEHbOPhwEyaJK5O3Z0mzUOTv9m0t7ShZ53KhjBCAwsOJHnMcUfezZ/of4hLLsGv0q0AR7cmqIb6ppgCpWqNn38umHxQF+TlOv95yM+uew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hz/b3UR7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hz/b3UR7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750178041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C6F/xKShMaNc3dbnJiQQDmLIQrv9IiIqZlBulMM1x+A=;
	b=hz/b3UR7986jd3bhNqRvX+Wn01uf1SO/hAGr++tlVx6R2TZFQzPsCz1ypDyXEGTuatKIT9
	PRU+0BASc+ykFinGd5Qr8olO5zOQRlTwDLo73bcavhxJG3OUjHq9ZD3ZNqTObAWykFpalF
	AQVeMnHoFT/y1Di+YI/amzJx3zlGd+s=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-F_L3v5riOGenSXUdyWqtOg-1; Tue, 17 Jun 2025 12:33:59 -0400
X-MC-Unique: F_L3v5riOGenSXUdyWqtOg-1
X-Mimecast-MFC-AGG-ID: F_L3v5riOGenSXUdyWqtOg_1750178039
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a50816cc58so2017461f8f.3
        for <patches@lists.linux.dev>; Tue, 17 Jun 2025 09:33:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750178038; x=1750782838;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C6F/xKShMaNc3dbnJiQQDmLIQrv9IiIqZlBulMM1x+A=;
        b=vyCxF8whKpUa4VxgT5Yt3/WYHL41JZqvrayQIXwimzAvFB3STAySP213DPEXn7BWkO
         w72PyQga8ZauRM8e/K1V3fhOrXnMAo9s2SNNwbU3bvTZ/U1Paj8ldw9GwMLTGJuJyTLV
         tBN0k/s7TT+eAdrWm8fqZFOp10gCm1Ob6xhzP3mnS4BQTK4JlsX7yQffd2Fm3Ux2rx79
         fu3RB7dtNKgdVqihyRtyTbKOxFakYLrFRXeXsZJWuD60Kfc9xPyVOBAvQiI2LYXNhPPd
         cgQ7lwXyWR+cv1BFg6KRygCtpojJ9t9lu/eJYUPl3AKsec8q9DuSODIhkz2DXCyB2bMU
         rxLg==
X-Gm-Message-State: AOJu0YysAfv19xLgwpFTLwKBi4t5AWcGWeDi5J1GelNcWBWVaYR7vjFP
	uy0SAMk8MM2tTi9mHsR7aiEpXBQQrKEiUYSYvi7U03DjeqvbZbofvhzCPy319FsqgAbCwXZW5eZ
	mWX280f8DirtjSBG3JRoPZmg5o1WCHLODd5Xf4wU43bnJ2SD2wJPbUOQgDLg=
X-Gm-Gg: ASbGncsQ5VX7A++KbJ5nfEO9yZu956X3f7D17s19XVZYMSPE/wAiROkCJWMnniybro4
	rjYhSttOpk/ijq0usCNu94H0kJz+3SIEf+zJ5pNmYGmfg63RCTT8dqi9Isp/DrY8k49DOvnla9d
	dTkkrvfx8eA5bNkD+ermUh/SRUJL8KyC9Hi4MiLP/KpVnKGJRO4kLeXfbfyJbK2ezYyLbMofqWY
	u357agEX22zFxnC0ypc6HVvcoiLUB1jNRqgeSgDg4/IYoozgGk8r9lHdxFxT2LWPA40NNguEUGq
	gU2wWz2shnz73jCnm/N+8U2WVpnD3w==
X-Received: by 2002:a5d:64e3:0:b0:3a4:e2d8:75e2 with SMTP id ffacd0b85a97d-3a572e58576mr10299247f8f.50.1750178038588;
        Tue, 17 Jun 2025 09:33:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFxxUn4zKRtePUxOZR0MuA7rayI2tO49ibdi+Qo+0mW2vWHKUvMuun357PnFmBVQaX7neoNvw==
X-Received: by 2002:a5d:64e3:0:b0:3a4:e2d8:75e2 with SMTP id ffacd0b85a97d-3a572e58576mr10299224f8f.50.1750178038118;
        Tue, 17 Jun 2025 09:33:58 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2448:cb10::f39? ([2a0d:3344:2448:cb10::f39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b2b113sm14464854f8f.75.2025.06.17.09.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 09:33:57 -0700 (PDT)
Message-ID: <bc44f920-a1fa-489e-bc2e-f2e3acef7b5a@redhat.com>
Date: Tue, 17 Jun 2025 18:33:56 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 186/780] udp_tunnel: use static call for GRO hooks
 when possible
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Willem de Bruijn <willemb@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20250617152451.485330293@linuxfoundation.org>
 <20250617152459.054731860@linuxfoundation.org>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250617152459.054731860@linuxfoundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MAUFVNU7IBV3ZwY3RQ2TagDaLdWUP-4DJPBna3zDyM8_1750178039
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/25 5:18 PM, Greg Kroah-Hartman wrote:
> 6.15-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Paolo Abeni <pabeni@redhat.com>
> 
> [ Upstream commit 5d7f5b2f6b935517ee5fd8058dc32342a5cba3e1 ]
> 
> It's quite common to have a single UDP tunnel type active in the
> whole system. In such a case we can replace the indirect call for
> the UDP tunnel GRO callback with a static call.
> 
> Add the related accounting in the control path and switch to static
> call when possible. To keep the code simple use a static array for
> the registered tunnel types, and size such array based on the kernel
> config.
> 
> Note that there are valid kernel configurations leading to
> UDP_MAX_TUNNEL_TYPES == 0 even with IS_ENABLED(CONFIG_NET_UDP_TUNNEL),
> Explicitly skip the accounting in such a case, to avoid compile warning
> when accessing "udp_tunnel_gro_types".
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> Link: https://patch.msgid.link/53d156cdfddcc9678449e873cc83e68fa1582653.1744040675.git.pabeni@redhat.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Stable-dep-of: c26c192c3d48 ("udp: properly deal with xfrm encap and ADDRFORM")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This, the previous patch (185/780 -  udp_tunnel: create a fastpath GRO
lookup.) and the next one (187/780 - udp: properly deal with xfrm encap
and ADDRFORM) are not intended for stable trees.

185 && 186 are about performance improvement, and 187 fixes a bug
introduced by them, and is irrelevant otherwise.

Thanks,

Paolo

