Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441DB156F3C
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 18:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741718314; cv=none; b=tc7CnAe7WZ6XcCgn5uLqVDdVc7tg4l8kXosEkg0m+2lsn12NiHWTnN44/J9SgFwhwST/sWe6ZKGIm9XjixJBYxu8d8h+0VciNE2ve2SFZKhFcoQKIRxERfLE3JDbi+1eCScYXzDzhFOzkv84BR5Pv9DoIUdX6pCWEGAyNh9rJTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741718314; c=relaxed/simple;
	bh=JQMvBmSUnEOfFCl7wk0Kzpgglw2xDSk+h9+CJN6vN24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p7VMGrvTwSuJsOzKY7cQxdanI7VaLVXolmKkm0oc55DIf3MpHMJrdeqStUmyY1e3euHbbtr0K6slXC49QCzY+OATKIztSXr+IylX45GdeGB2VgZKY59jbzAui+vmJO06f1RSutvbxKLlynDnamxid9Ed0xknQecxPHUjnsbedeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JQAUSPzA; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JQAUSPzA"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-2bcceee7b40so4092398fac.3
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 11:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741718312; x=1742323112; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=uhVgBBWNaSmDcrv+hoLH9xcvrHQeKIG9+v/Scb+fpyA=;
        b=JQAUSPzArajhsoXPIRZxgsf4nD4AAm/On39owm6xbQd5RFwecDZSKyR5VRf3ycmaRs
         B5KqOnuB5fE9A9hDHVDJ55TM2we8TMQbAZmBx/j1FfsJKx8OJjXjIKxJgV7tIfyzmvof
         ufFIxjg1By1I24D3pT8ElQNHh4x2I7B6o3J+LewAcGqPAfqCl2qMtRjyOFU9XWjDCihC
         qTGzDabQzj0RyOrEkRoRPmHqY9ZH9EGR2pawNoGSBhewM2+Ql3Va+YFsuubZ6tglCz5q
         RJTYtnWrC3u5m6OdeskMXGZxDAWX8SRSuC7MZgZpKSWefwboT3oiC9IlB3dT/ZvXfhhm
         ESEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741718312; x=1742323112;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uhVgBBWNaSmDcrv+hoLH9xcvrHQeKIG9+v/Scb+fpyA=;
        b=gpCBxn3M5ywvFFqTy+pK6pT/UPZg+zuyfSkWWPvnGfIEdzq5zkuMBx8QaOTu3LQ1AD
         5qvzIQTfHKAcGCmlHtkGifdXhHPn8CDQl6otkPd6TQwJaovrq9XrIhIQQXT+DBxQv7K4
         g5wGVxzyDxY4Z/L9gOHzr7INe9tK+CpMUDKVPJ4VoL+jibE+M6AxNsX/h/uuIy9m9uRn
         MFTAWbzbpn0iDsRxH337wpm4CQ0riiK+S5ngqQ7p7dWyNTX7Fm3r5qmHx4g8y2yLOjeV
         3HdVQnDxRmn7bIcDNF88rWE7GZXul0UQR4Bk+veabJglcf75vDwUBtoaSRT2BuiwwaMs
         dPGQ==
X-Gm-Message-State: AOJu0Yy4P04nflIYnxeM5AT8uzOS6bbh3RHS38SaTGlFRJY+2HwQlGJm
	v90dXaIoP26udA7Wq4o8QWBsDWcxdBzuNrQvNQQRIdIwLXtSKdnP
X-Gm-Gg: ASbGncuplmRk7jhzG656BIELvjqZUb4EblpV/Mj/cN/Z0zVSAAhCLD6mn0+KqkW0WOz
	vlgLWnYkCU/HCnVs1Rq18DbIMfRPwWm5jYHlZqq5nRDlVQEXtc3HUV9OwMUIVazzyn57OW5/avq
	HbzIqNAEW4uVK6tRB7OmspCLCm1vDrrs86lbGudLjX3ENFxY8dSkDof2dwa07fWc+Y+STiZ4GFY
	tdLDHp++HLmVQ5thqZkLuRMKbhUmEmxrTG/qNPLTzMgidKj+vu04MWjhy0unj/UZSRRo2hi4rwW
	tXO2YGj3e2qt0p2SNE4d3zvmAt30AVOv3rXiOjb5nyD7KMPPWrC3MKXZmiZ+lXHNM4Xld11h
X-Google-Smtp-Source: AGHT+IEeO1Su5duSEokcrJQRq0t4evD/7K9UjO7IEFqR7+Am5Ke5eujTvXj8OYiD37lEFUudO5mfyw==
X-Received: by 2002:a05:6871:7502:b0:2a7:d856:94a with SMTP id 586e51a60fabf-2c26111fda8mr9685421fac.22.1741718312232;
        Tue, 11 Mar 2025 11:38:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2c248dd621fsm2692945fac.42.2025.03.11.11.38.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 11:38:31 -0700 (PDT)
Message-ID: <0f5c904f-e9e3-405f-a54d-d81d56dc797e@gmail.com>
Date: Tue, 11 Mar 2025 11:38:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/328] 5.4.291-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250311145714.865727435@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/11/25 07:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.291 release.
> There are 328 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Mar 2025 14:56:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.291-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>

Please note that "udp: gso: do not drop small packets when PMTU reduces" 
does cause the following build warning:

In file included from ./include/linux/uio.h:8,
                  from ./include/linux/socket.h:8,
                  from net/ipv6/udp.c:22:
net/ipv6/udp.c: In function 'udp_v6_send_skb':
./include/linux/kernel.h:843:43: warning: comparison of distinct pointer 
types lacks a cast
   843 |                 (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
       |                                           ^~
./include/linux/kernel.h:857:18: note: in expansion of macro '__typecheck'
   857 |                 (__typecheck(x, y) && __no_side_effects(x, y))
       |                  ^~~~~~~~~~~
./include/linux/kernel.h:867:31: note: in expansion of macro '__safe_cmp'
   867 |         __builtin_choose_expr(__safe_cmp(x, y), \
       |                               ^~~~~~~~~~
./include/linux/kernel.h:876:25: note: in expansion of macro '__careful_cmp'
   876 | #define min(x, y)       __careful_cmp(x, y, <)
       |                         ^~~~~~~~~~~~~
net/ipv6/udp.c:1144:28: note: in expansion of macro 'min'
  1144 |                 if (hlen + min(datalen, cork->gso_size) > 
cork->fragsize) {
       |

we need a more targeting fix for 5.4 which replaces the use of min, with 
min_t:

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 58793dd7ac2c..db948e3a9bdc 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1141,7 +1141,7 @@ static int udp_v6_send_skb(struct sk_buff *skb, 
struct flowi6 *fl6,
                 const int hlen = skb_network_header_len(skb) +
                                  sizeof(struct udphdr);

-               if (hlen + min(datalen, cork->gso_size) > cork->fragsize) {
+               if (hlen + min_t(int, datalen, cork->gso_size) > 
cork->fragsize) {
                         kfree_skb(skb);
                         return -EMSGSIZE;
                 }

Thanks!
-- 
Florian
