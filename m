Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F3C29D288
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 02:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789351461; cv=none; b=lCKGIqokVrjpjQuOXs4VR9j4HgyotUdved9yFR/cFyLad7Ort25LKJjuoQTGxnYU1B/QL1DDRPLQnIwCrNEKISWki9xSo3WzH/Gjpn/MHLLeelSl09TdqnpN2Ej7h5d7p1I5Bin5+/3aLvQC28JXYKD2XEBcePVNhBHGHTzCJzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789351461; c=relaxed/simple;
	bh=OyHBm0aM6KH70QZ5Y8bPQRTTYqCndlWggB4rMvP7OlM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=H/DQlxFcMoWGO5IUM1XCRzvBVxWCyUPJ8STO3hFZ8PplkYbxdppa9eY7UsxUvi1PRA1grokpeCSranT3NEs09n/u7nvR4obAnGwNqK6wXUjIc5MNI7IfjCbuwvLLcr8g4BIuEkI89ZZxtbWG9vFcwFgcl9c3pf3asv+eVfU1gdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OpHlxgAJ; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OpHlxgAJ"
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910cadeb4so237274085a.1
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 19:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789351458; x=1789956258; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=u6VPj5Ei/NNEX3MNDuO9HYgV6AmHjtH/GQMIJlXajTU=;
        b=OpHlxgAJ81lp0/SVcDifkmLoYi5bhTBE+vNJDsZ/3F2p10a7Uh0Jge+xa+mjNfexC9
         5eOsAHfSJmIbG8KiXiWl3TF3aagWqxH5cURFiKMcn9Tty166xdM8pFEEvW90BJrfDGDM
         d+UgCKVl9kZ3/8QjNMXwu8RiFX0ez3nVbNVqT8awl1oZsq0o0vx8+6fvD/M2km1IZFN/
         2FyqdHGl9SvBn3Zce1nLhCFTXtlCRFQmNe3154rVvzoOsAVqW8IrzJPMkbuOFKGv4f2d
         pjOIH94XdmKQ9NsPfm+Jap8Vjt2yMcgmFLs05bTHQWtn3i1E3aARjxqPM0Y+VsH8CniP
         1N5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789351458; x=1789956258;
        h=content-transfer-encoding:content-type:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u6VPj5Ei/NNEX3MNDuO9HYgV6AmHjtH/GQMIJlXajTU=;
        b=EC/19CFTN42vJxjnFBuQq34sF7QiGcMggGC2mHlUvKNJcEPTMisrLFaDVQFlKf6Drw
         xn2dV0rK9jxPDkB58Vz4vugJLQqaw9nJ0Y+M1ZsSRqBn3vKavlgzkB2LcdX1JDvt4JRx
         Ix4erwzhfDW8jt/GmkaZ8yiKbxBcM9RuQ+DZS4XC8c2IA3OTt5r+JIOaJ1aoNshmmz14
         +ExInX3vvaJU+Kcej+0PI+FFqf0DNhZsRxjf65c+5vvhGC+LzeNHnWjQpLQCiFfPpDRZ
         naMp3dZXneblhD19ZsJy54U2yME595391wIo99c3Ct6SA0OJnOV6YkJcM1p+C8X5OVlm
         XQKA==
X-Gm-Message-State: AFuF++lx/NCyx5e6bPWAESMy3kmPBCjS2Udlz3BTZ/Pz2y6KAHKhdO3V
	cpAu0NSGib8I1dMLf4ge3t/k+279CTf4K6nxBFsZuzEGBp/bHeBTCKs=
X-Gm-Gg: AYBFou1f4aykmgIuVBjBjXzZkFLIW2QXjNHSJ+HGQu53LyGvhUr2OJGAkH7rqjvgYIQ
	jcPKhLE3e+Jgw5RWwrYvIWZUchJLtfMgpCFHzow1APnfCHUOy4fjZrufNgJO0um/SFzEHDLjcu5
	3rpMPOE10cAxsWTZJj/+s3hkrpqiINQZKLZNNe1lu8qYF0wTKHgBhDvqJ+qWiTeKHDLqtzxVD2v
	HTyXHPeXXZIkqUCRy3cYfgctDpm2RtH+0EwRMORpY4LxV9dp6alKASrpwiBmSrhHme8cUtw2CXo
	AQygUfrM8qnTtaJzVNT4uFkkRo1zGVDJN9AgbbDWtFoNbCf01k+FpsqBoCyJClImBqJoaovav/O
	AxXmPwe0+sVxjGWEskHTTbEURD4fO/YETttbcYozELJFek82qZfiPPRe6yS4dT/SYr+fnyMpkvl
	YKzw+2GHsh8/VivPe0XR5HJgdmVwvoypobsDWRlBeY/lPzHu5AJil3MFY+Qw7Q/56e0b4wDW0Q9
	NF4kwYGtgKAcv6UL7lZLltil1R4+9qmMRXD
X-Received: by 2002:a05:620a:4885:b0:939:5f4d:67b0 with SMTP id af79cd13be357-93a29766649mr99212785a.8.1789351458163;
        Sun, 13 Sep 2026 19:04:18 -0700 (PDT)
Received: from [120.7.1.23] (135-23-94-154.cpe.pppoe.ca. [135.23.94.154])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f45cd5dsm82051236d6.14.2026.09.13.19.04.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 19:04:17 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/798] 5.10.270-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065516.948645775@linuxfoundation.org>
From: Woody Suwalski <terraluna977@gmail.com>
Message-ID: <c9cc917a-41f8-0f2a-6ee8-9f328a2d9ec4@gmail.com>
Date: Sun, 13 Sep 2026 22:04:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101
 Firefox/140.0 SeaMonkey/2.53.24
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.270 release.
> There are 798 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
Built OK for i386 architecture, installed and booted on a 32-bit EeePC.
No new issues noticed....

Wow, that was a biggy :-)

Tested-by: Woody Suwalski <terraluna977@gmail.com>

BTW: Welcome to Griffin K.H. :-)

