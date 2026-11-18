Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031673;
	b=ZzQXyzN2dH346gDcqI0rJiVTe1Z8ms8VA0sJtVJGpvpY6WKG6F3u39q8owRa3p1HD+NM
	 EQgi3T81YjTwqOIz4VqjGs2L4ICWjH6X8OdqiCLHkhVCw6Qo0ugeIaU5D7+votwxv/6vA
	 EEJhoZh6L1BJ0HTjpou+XCS+m4Qmk8QuLBDaw+D6X+yG+PiVSVW0K7C2GbLJf6A6BR0H/
	 krrz/BdTEthVLwSc1zq0G1KtEkmdjaO7KlRgM//O2c4KA9yS215Iuq75Cwl+uYijVFUPA
	 yjWaDSr8cvhGrruOtrCV2hZkt3niO6I5RNlRqt0LCMM+/qwf7mYisel7o/wbY/I8EmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031673;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=i0RPIOg/N02GB/FO0QU0LL8vtzFon8FGCvQcjRptq9c=;
	b=s65EHyTVOINlGhl8H6lnfLLsqGBr084hlUbEK0TFWXnB0st/BtddvYKo29B1SHcz7L7u
	 ELE7ikYqMwRFKXAHLc/Pj3HHjy1LKnvR1hj/WFFHcFwhqVs54h2VVQx7ZFtWM9+DD0vKG
	 CAWBpMbqCdRt2PPjmjqb839/NU89PM33pQbWHNJLSOr37W2AW+21fP6DB4YL3akJzRwq8
	 kzLL2/f67m7e3D81e5AQChwWruH3JPy2ZCjUC4VbdOqpQpZW2X+GbqV+n96ex301zDy3/
	 1y8a0HO+msj5gVwTglK51T+MTalm8LTgO//b/Ol8lYlU/NPOqY78hgyxtrduEQ340MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FFgokOVJ;
	arc=none smtp.remote-ip=209.85.222.170
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD894606A33F
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 19:54:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD894606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FFgokOVJ
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-94961b68685so121072585a.3
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 11:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795031672; x=1795636472; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i0RPIOg/N02GB/FO0QU0LL8vtzFon8FGCvQcjRptq9c=;
        b=FFgokOVJA8dxeNm7TfhKM8UtGpCYGjp7osifC9x/WACvezvT+O0HCUAv51ROu06s6m
         Mr39Hik0xdlJS/C8+XD4yM5ihukt0fjn9yvrB3aemfrx0B6ODh/E++JEiLXJ54fEuWb9
         PygQ8bwzpK6TcFvpp6R1WvZS5HRoXjamX44/NfUkCLQNIKEC5LGkOKQ3KzkDHiDlF3v5
         rTSjnzKLdV51oFGAnU8sgTpdVI5CZQwiudaxff3W9Ae/gPNsKFw8wSIhaptCYjbearhz
         6Z/uD/FGS05rmE/Vl88lvPQlFaPR7fkkHQADe3hwbYMaxpptS+3C6SjPtWxLA+VSn/jQ
         nMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795031672; x=1795636472;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i0RPIOg/N02GB/FO0QU0LL8vtzFon8FGCvQcjRptq9c=;
        b=wUbQ2gXb1WINB3W1OsI+RKQRda8N6AbamGdBKzOXLo/0xwa2mqlPv+f6r0Zy4Gxf6t
         LAsVnYpn8mgvMEAXUWdAD+fEAjY73CrI+jMWZxNVN9bbRnn7Df2pah4v1JSWB1NUiqAu
         GpHiBDLBvZEndlik2hOg1Qkt0GQSzATvcMVOKMDrRCViuURPYTti06C2ICwIQpPRXKKA
         x47qaEXTKUpyaUP5D4wxLCJM/gsbFC14rRxH7l5Skk5GLPbr/Zjrmqv2J0JNKcI0OM0c
         7eAmrkecetr31xunzwv4OO9A/PeIEdh6RsPw4Yzfk5I8t0QgToVZXGEZtwAIePCjX55X
         P8XA==
X-Gm-Message-State: APuU4Z8pdaZkDn25Wo9JsTYHl/u1q+SSH+0aQ0SJ0EueVQb3Lv2HQRbY
	5iS4obqHPUB2QnBCEkiTXoDHSBB7bg1x+RvMTcTpFvMz3GTFlbn10gOI
X-Gm-Gg: AYBFou0b8WUR0rysWJFrmhDgyKF206XfMmUZhkqRuOub2QKYxqVBHkhIKWYqoDkHItp
	in0gOwWM7NnLt8nfqSTNWUA5wC6kmUHO0iXre2ffIkAPiDdMlS/MIWulV4wpdVi4s+D1vRfZP/n
	+IvVc/u/UMtQo8QbZrkay7zP9ii07rGfjGcLT3XEXxHBFGz+fWAS1Wzir1XY9hRcpkc5adcB7/E
	DJzrgLg+n08A2IUGhLTH+ujWoi+K2y/bmGFfGkWX0/1QQ6truHUp+7I1QmBNInHmnDDIg2jUuvJ
	vaGLDbivBJNy5+XGzLFTOStYJfi1IIc2z5ME78snzGWofSLUsfs6Gns0WznjHnJ0G0cZgn8oEVS
	xDnkqoz+FOmr7RMI9L6Rz87lIcA3wJjd1cdN0/TG4sWjXnGXrMY+NYtyuUZawtlJbae8GlHYx9z
	cEAZz3bpT1U9vNKw/RC3WxbHHN71ELQe3bi2I9JkHjhpfEFNYgrQW2UDOWZdl9JWMuWqfJEJ9I/
	NUNRJzMzJX69AEVqLp9QNdesUao50U1+VGKqe99sASDLFYYDyOlH2fAQtpxegghktC9XhTqPMrp
	cw28cC98q3B6o3O5fGv+zrfPC8/40XafqKnm4cS50pISaOHst+3rgLGJ6Q==
X-Received: by 2002:a05:620a:7084:b0:947:9060:7efb with SMTP id af79cd13be357-94999574d09mr635823285a.18.1795031671725;
        Wed, 18 Nov 2026 11:54:31 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b7475b8sm257960785a.18.2026.11.18.11.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 11:54:31 -0800 (PST)
Message-ID: <c7f0c78a-47c1-4dfb-bf21-808e25f05611@gmail.com>
Date: Wed, 18 Nov 2026 11:54:28 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0000/2151] 6.18.65-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261118150121.603863898@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 06:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.65-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

util/annotate-data.c: In function 'global_var__collect':
util/annotate-data.c:765:30: warning: implicit declaration of function 
'die_get_type_die'; did you mean 'die_get_typename'? 
[-Wimplicit-function-declaration]
   765 |                         if (!die_get_type_die(dwarf, 
pos->die_off, pos->die_tag,
       |                              ^~~~~~~~~~~~~~~~
       |                              die_get_typename
util/annotate-data.c:765:71: error: 'struct die_var_type' has no member 
named 'die_tag'
   765 |                         if (!die_get_type_die(dwarf, 
pos->die_off, pos->die_tag,
       | 
       ^~
util/annotate-data.c:766:50: error: 'struct die_var_type' has no member 
named 'from_alt'
   766 |                                               pos->from_alt, 
&type_die))
       |                                                  ^~
util/annotate-data.c:777:44: error: 'struct die_var_type' has no member 
named 'from_alt'
   777 |                                         pos->from_alt);
       |                                            ^~
util/annotate-data.c: In function 'get_global_var_type':
util/annotate-data.c:835:26: warning: implicit declaration of function 
'die_same_file' [-Wimplicit-function-declaration]
   835 |                         !die_same_file(cu_die, type_die));
       |                          ^~~~~~~~~~~~~
util/annotate-data.c: In function 'update_var_state':
util/annotate-data.c:873:42: error: 'struct die_var_type' has no member 
named 'die_tag'
   873 |                                       var->die_tag, 
var->from_alt, &mem_die))
       |                                          ^~
util/annotate-data.c:873:56: error: 'struct die_var_type' has no member 
named 'from_alt'
   873 |                                       var->die_tag, 
var->from_alt, &mem_die))
       |                                                        ^~

-- 
Florian
