Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E532F25E0
	for <patches@lists.linux.dev>; Sat, 22 Nov 2025 07:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763795527; cv=none; b=uCIgaQBzsk4aSOo+83OKGg80CicB4+o3fMdn1ZzvqyrWikyy+DO/Tnw0Jhv8hmF4aoM4NIkSqVA+kjB6m8B/iGvVPoVGwxQxsmF9hxUvJAAMRzOvC5UE3yScrrKxsRdaa3saEgrrzenOR76yYx2/g1cpLWcNmVmNqC8ZucrU5WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763795527; c=relaxed/simple;
	bh=ectZ6e4VQCoL5T9VJpM/UGLbJ+XWr+oyJ/8TtZUuXs0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TFJHQKyD1N7xTjCwHVGkDzmaTA362Y+8vg+vz1LGVpNny2RYAspbfym8w6+Gv9DW/WAMkwGahKUVMg5rMnVQXiffAq8N8em/NHV+VHLqPL4hNavz7R/Ek5gzu69pf+yzVRUCnx3P8nVDnE8CqC7ZEqTWohHGx9M9YwZeVEEQT3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lqNEmhEh; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lqNEmhEh"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42b3ac40ae4so1548382f8f.0
        for <patches@lists.linux.dev>; Fri, 21 Nov 2025 23:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1763795524; x=1764400324; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=US4Mpay2gyE8FdY72ARKmQUOFz15hL9jcMS+fDMwc/0=;
        b=lqNEmhEh1RoKXDNAuf6T0tp7fmzdQY8UPY8X2gDTz7VTYEIyQfRBAen/YLjIUTVaFp
         QOl6so2seClS0nRxoy/dECwGVQyWmxrh6170+nalb7HjUKQs9t0ZfPD/+B3bqCWS0wtq
         JoFxnBmxaivKDdGQbINqaZhRJY13Bs/AC+e34qi4feYR9vgFeRiB4+WCBb++s6vqlxmH
         PATxg5VIN9uCXoC+cty+9lbC4/0yxrQlJXVWZfW6A+nnsfq2a191Dmtah3wOehRYoCzA
         NL0YBK+yfY99FvxpB0BdHwXUpp9X9+voBCEQ2b7Go4TLegVy8IRnF12srZuZv8lkljD/
         AEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763795524; x=1764400324;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=US4Mpay2gyE8FdY72ARKmQUOFz15hL9jcMS+fDMwc/0=;
        b=syiifDmK7Au7Rah3LVE6T9lgHgzBDjtfLea9g2sU9+/MGB8TYzusoETbwjjHwORT05
         VqB/x5JpPhj+NMXj2h9JyGpUMG98RBPtLvGqiSCyI2RezklTuNiwTGcf0WORvSZ9aIuV
         ugSr0kUbVfBmtaMNidmQDIOlWELa/p4MDmvkFXywBT1qtKWBTxZVIUjNo0j2I1y6dyb3
         PCvJcT1yCs0KJCu5yaY94DP5qUeljU3BybGvxBOLjiQa8626/9rtL2SV8vBPC2srl5fv
         21h3IZA4LJr3hi3Aq2RDfLEp/BxL2CX67XxRCApzbASHKz/xhQ+0nxD5Hn63dhXeFI0/
         oJCQ==
X-Gm-Message-State: AOJu0Yy/+qp11vx1yzgxhC7KbN5SXrWMnzZ8/NsrOu7cBs78t11WSn4/
	Cl27TMgx3Q5Fml63S95eB2484PnoH0jjT4YXW7tQP83b8Z3552USrqw=
X-Gm-Gg: ASbGncscf8obsxOYwCduPSb+K56fR/voRz0hpMY/uU1+sYtf8AAN3bB8eScGVI8PLQ9
	cz4ZKMB1K9HPLt+XiIW9i260bBmDA55dOAGL94Y5uBvFrxVwxbg7/v7Yo+H/95FplAWt0Mzfvdi
	Ws8y6xsbOQjy4QRAL64SSF9hxU1lpDwsX3Wz7hAEtPdLspjHJkFOtI1GW0ssJQN395G10VVhchK
	27wW+axb33t3CXfm4GfdNRSxb5oBnTE7VFD43I9+i/RBlja39AsNkFGp8h81zPhUr/VMaS1j2OA
	InPlzTqked8UD6CihFIBbxMEBXFSoTEusg0LW0Nm+iGnHoH2dyxtThsjy/N/RtOe6tgpsuOFt08
	ZexFEn7ew6a4MuHd+BhDQduTcpyqZAmGSBaRqhNM6avivWv4vFbIgHCtTxzv/Glrh6+oAp4szee
	bSSdutHYbvrRImwC8ogBoDLWaNEPe5oLUQXo45OaO1QgNtILaivYEtG747lbvgng==
X-Google-Smtp-Source: AGHT+IE+1loCPHVNjxUG1NMgfGNWPNXt8w91CYkqgdahYUVagi55K5gXVc8gxXcnUGcXCGgbJClM8w==
X-Received: by 2002:a5d:588b:0:b0:429:d4e1:cbb5 with SMTP id ffacd0b85a97d-42cc1abe044mr5102430f8f.8.1763795524279;
        Fri, 21 Nov 2025 23:12:04 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac108.dip0.t-ipconnect.de. [91.42.193.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fa3592sm14670912f8f.21.2025.11.21.23.12.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 23:12:03 -0800 (PST)
Message-ID: <02cb91f9-400a-4b3b-86aa-e8eef9746ce8@googlemail.com>
Date: Sat, 22 Nov 2025 08:12:02 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/529] 6.6.117-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251121130230.985163914@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 21.11.2025 um 14:04 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.117 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
