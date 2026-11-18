Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031373;
	b=gdRvi3MZ5Ezppxw0cjKitG5X3lEgqw0rLWDnn2wmKr02GrH1J3v7544x13XlpO1Xz1Lf
	 YgDzKV8/QrbbO8jN6N1pNCT+ULFnJKjvkhfYMwq5H8QV8bje9ud3FmcpVGXsswkI6nWJ8
	 aBao8x7EDPTGwcorSHx3caW+IPBC/lxW1eQRzMonyCVsRVCNZ3oBL6ZpxR0OUk2EvRPBO
	 iH65Qj9QaYxpuyGsJDrHmaUIlf+xUJhrcX4H15uR+hxm67z8MzUIVjp2a0v07rTuT57Rv
	 UAJHUnir9SUw16Ty+IoQHCgVyozgjN75XIKgs3gfKQnkC34uu7+IuEuenXwXGHgZLQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031373;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=5z9WeWVp8pZ7m8YhqVv0OCEHCS96QI2xcezf4P1GqsI=;
	b=cHrezlllR6FoFU58l0wetvzbLMde35AUnyf93jnOyp9688S5PefDwVC4D+RUeSDTu8Ia
	 l1MCVL+l7foQeGJDIvaM+mqZvYG7VpQZ3kH9zdJzic2O5qTEtoqm8tf+inBbXt4ds5Khh
	 0pZMoi5mJNnbFRXubR2WFSHPfWTCn1ymsNeLwsAwYpzFMDdtqzi8wE3Yt61aDy5plsu4o
	 aHRzCa39LrlMYE55RIgBEfnqNRExOl4Hxn6wn1rto70FzhD0mrPqGdNHAUoFTzD1OwPJf
	 Sh6ZannmZp3OhL8enzht5t1wFM3qs4/KUi+cJ5PMf1kkjJGotlOvYzwvShdBONaJfzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ekl6RCP5;
	arc=none smtp.remote-ip=209.85.222.170
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CB0606A33E
	for <patches@lists.linux.dev>; Wed, 18 Nov 2026 19:49:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3CB0606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ekl6RCP5
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-94965745d92so153917885a.2
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 11:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795031372; x=1795636172; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5z9WeWVp8pZ7m8YhqVv0OCEHCS96QI2xcezf4P1GqsI=;
        b=Ekl6RCP5kg+HkhmgxaUmBdZG0i6PupdSnmphAg7EDpAGXHIbY3anUXpDaE+Ml8PKqw
         lTp2sR9uL60Bi0O4TwKBPbKyOYBOEh7dUqWFU3kIwqrWoHGNr5i8uXlgJ0N/XEQBa6LP
         wy6nhrAlPAVtvUKyUH1418fuesncc6b0d4gqy81zWH7wQMQyPvgegN6wG+vxV38VhcpY
         wp31DfXp5H1mfvb/flKgz6YSL0Z6Xu5Ovamp8P2/N+vuLmDg/LtvvZQHyILf+azJODQa
         fJ1doGYIkzrXJDY14dZcZOTKPpyDoQbp9p9SETQa+M4kpVTxbogEnC6gK1ixEsVeF5pn
         Lj+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795031372; x=1795636172;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5z9WeWVp8pZ7m8YhqVv0OCEHCS96QI2xcezf4P1GqsI=;
        b=Q9OxXA9A/WsScIW/XTRDTDElTRLCbxfcMorlc82/NKwRAevez/2BjQdsR9kNO19Wjr
         0EXRXF0Ag23fvq+jbKPhv8/nOc8rY4sFRRGTEkd/731Xr/nk8fOHoUQ6XY1i8TWdTDBV
         YvoMkUMFWR89hNIN9nqsPvqIGTKLz/Bm/UdaEHWk9fRvT01Eb+9q/oK7RTJvgeGnYJ2Y
         FsQBLhwEmY4aUK52MVYx8b68yoQanmxtbKg12Z6TY/h7Tiyam0PqDwSwvaT1c56rJXWB
         vfgdhysDjXmShP47dbKzV0y5tZoH69HOmvfSyVVsAwxdlxzH9eb6yHkaIQmFrJAjpkHG
         0crA==
X-Gm-Message-State: APuU4Z9qXHWAtKc2t/3bXOXiercrMTrPE9gaXbrJt5vGdWPcns1nMA+D
	N9jTGKKGOD8fLor/1O+X1fwDvbl0C084fKgzRMVj+VBg0Rwh+9lw+xaM
X-Gm-Gg: AYBFou1oJnouWEyTtVoAXMP/MDD7LuTNbsMsrQDlWSXrB1qSyLvxAYITUez9ZiWBW5G
	3fFbi7ikhHZLumc0uQ0VLZf1nrzLtTJGx8bdqGtSRDSKgv/lDHKCiwpK+DwaPTrypHjn4hgrltE
	Qiq1iIs0mPVldFiLJ3V268IJHEdttbMgoiHGuOgL9U8IYZu1C2LfbefDV4HBlWdjyvObpppB95x
	w3ScW8W3dvWYX2pShwZbXocZGcXSC0nJzZTCaHNsXtOJXrGem+e7ymnmH2GWpUIjsAzdoNsyEKF
	/pWxOScOF1BiLxB5l/s4Bhl4JhrXjBzvuk0g1IXMG2QU0Fk03rdrhvD//0A5ExKfxYBW5M3/ocj
	TwV6bRtbRYWhLqXQmeAtyCCL0NZ0DGoBe0V4kU4s63zhnYNj6aK8Lm+jBjn60cTusWWu2HjIJrP
	4j0LKhcHnBe/9YZ38oC5k+3fHHgLAecG30R1NKsdGS5PLCPXAtuvEg4e9bW0kdOhy7WvGdJNqZA
	q0JahG6cGW9KAyWl6y3WywC42G6bJ2tJ1NLEP8tSxNZoZPpP3tUar17/6pZlmQTJSNTrtuuWoVV
	yKPp4xe62w0qcIzcjOicPcupNGkI677d8tu3ZwhbHEeFggrQfxOnO8mFvmNlHt1Vd8yUzN/9FQH
	FYg==
X-Received: by 2002:a05:620a:272a:b0:949:7bb1:ac5d with SMTP id af79cd13be357-949995a8346mr658000885a.38.1795031371742;
        Wed, 18 Nov 2026 11:49:31 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b743a8bsm257359285a.17.2026.11.18.11.49.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 11:49:31 -0800 (PST)
Message-ID: <30d88b7b-7a34-4fad-9ffe-84f2d8a927e5@gmail.com>
Date: Wed, 18 Nov 2026 11:49:28 -0800
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
Subject: Re: [PATCH 6.12 0000/1756] 6.12.119-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261118150007.957976754@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 06:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.119 release.
> There are 1756 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.119-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

util/annotate-data.c: In function 'global_var__collect':
util/annotate-data.c:731:30: warning: implicit declaration of function 
'die_get_type_die'; did you mean 'die_get_typename'? 
[-Wimplicit-function-declaration]
   731 |                         if (!die_get_type_die(dwarf, 
pos->die_off, pos->die_tag,
       |                              ^~~~~~~~~~~~~~~~
       |                              die_get_typename
util/annotate-data.c:731:71: error: 'struct die_var_type' has no member 
named 'die_tag'
   731 |                         if (!die_get_type_die(dwarf, 
pos->die_off, pos->die_tag,
       | 
       ^~
util/annotate-data.c:732:50: error: 'struct die_var_type' has no member 
named 'from_alt'
   732 |                                               pos->from_alt, 
&type_die))
       |                                                  ^~
util/annotate-data.c:743:44: error: 'struct die_var_type' has no member 
named 'from_alt'
   743 |                                         pos->from_alt);
       |                                            ^~
util/annotate-data.c: In function 'get_global_var_type':
util/annotate-data.c:801:26: warning: implicit declaration of function 
'die_same_file' [-Wimplicit-function-declaration]
   801 |                         !die_same_file(cu_die, type_die));
       |                          ^~~~~~~~~~~~~
util/annotate-data.c: In function 'update_var_state':
util/annotate-data.c:839:42: error: 'struct die_var_type' has no member 
named 'die_tag'
   839 |                                       var->die_tag, 
var->from_alt, &mem_die))
       |                                          ^~
util/annotate-data.c:839:56: error: 'struct die_var_type' has no member 
named 'from_alt'
   839 |                                       var->die_tag, 
var->from_alt, &mem_die))
       |                                                        ^~
make[6]: *** 
[/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:105: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/annotate-data.o] 
Error 1
make[6]: *** Waiting for unfinished jobs....
-- 
Florian
