Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633F128F7
	for <patches@lists.linux.dev>; Fri, 30 Dec 2022 17:08:48 +0000 (UTC)
Received: by mail-pl1-f172.google.com with SMTP id d3so22424562plr.10
        for <patches@lists.linux.dev>; Fri, 30 Dec 2022 09:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oM++bh9Bh4axNAul7AUOReOANFnvoVaLIIEIZ8Gw2KE=;
        b=nr7Y49BkQKTNbGyN4IedxtT58gl4JEeQzDG+hQLfK/wDUWARdJEyhwXUPM9Y3V/S0s
         rJFbtb3Q8aDhB37kqsT2QWqPxE5bZYr7ACiuljJUQdmAG23NR9fK5ysW9M0D9eIwiLIq
         lzO9kK9l4J4vhqK7tqIes/Iqw8ZR7Ag3N5hTZ9h+uOLRqBQbO/aXRWNJBuUK41euOIAC
         LgVj2tSLa8gdA7zs1TCbIbKNi7TpebioHiesui46bzodtNKJrKP3NbTS6+B05WsTLVgH
         cppSpjMxSgrf5oTk5ECI+G83JvpKGgfTcAKjnoO9u5dxWlSJH+oXZ7JRAL6S56cVRVBb
         uSdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oM++bh9Bh4axNAul7AUOReOANFnvoVaLIIEIZ8Gw2KE=;
        b=rmgh8MCoZqd/9JTHlg6Gfiy+Aqd8cyYXCr8kgftEl7in+cE8LvUIzVe+iv59lXGJe+
         wUaCKxOSE6XGEHkVqBwLsgDJpDPyt4udBXjuqXDUGuYPJAefwS9A6U/Cm309hNQMX8RF
         jgrht/6069gnyaMBd5XGgjbjGZsMwvsZjHKnTXZm2cvtHXUmo3IPbsxOf0LWarlbka1F
         +8lR79VTjQnlaKbzIjupLzo315fxFJ3nMyDiaJUZpXRaLZKwGH8+tfkaWJT11dH+t739
         RevfbRrOwbwQqU55lsit2tjTyDTuDBgGdnRjfsid6VplQdMMBX2uJvqx98GbU3HuAWhj
         /9gw==
X-Gm-Message-State: AFqh2koLlI369SSE7XFK7np88YVQE/sm23COBcafYxn5qxp4CVAoXPZt
	DUWkcTu/JG/f9o3FLpf979POIpY1OLPg878c+AzHJA==
X-Google-Smtp-Source: AMrXdXv9K0gsrBxyagf7trADmKRTTVIlqkB8DMDLyGBOpb9C1KtINwxTFwzptVOOileVXZv8XEVrH4c5p9uWtkL16E8=
X-Received: by 2002:a17:90a:af91:b0:219:536b:41ef with SMTP id
 w17-20020a17090aaf9100b00219536b41efmr2904558pjq.71.1672420127701; Fri, 30
 Dec 2022 09:08:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221230094021.575121238@linuxfoundation.org>
In-Reply-To: <20221230094021.575121238@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Fri, 30 Dec 2022 12:08:36 -0500
Message-ID: <CA+pv=HPDLWQNJGTCGjdEfJ+q=M3QZXKtkPSxtRcadqX8A2yFRQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 30, 2022 at 4:49 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.

rc2 - Compiled and tested on my x86_64 test systems, no errors or
regressions to report.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
