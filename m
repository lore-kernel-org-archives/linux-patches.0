Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CED1642E
	for <patches@lists.linux.dev>; Thu, 27 Jul 2023 13:27:05 +0000 (UTC)
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-403b07cf5d0so6415001cf.2
        for <patches@lists.linux.dev>; Thu, 27 Jul 2023 06:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1690464424; x=1691069224;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kTcJdJwbJqa4YZKH7dkPg8EzMfN3jKVbbeGvYMz7uFQ=;
        b=mqxt0Fn/51YsmSwzIqbheHb0iR9x5c25cHZygpnmC5NteEAhx/viMKjKcUDPao1+CU
         daqviNLkuyu4yDiCRZJxxSQvOZddc5AM17qWeFW7UT1nIaJgbcN4CQ3goVYAfrQREe/Y
         mjW/PPBSRp+Z22cOodj9ejPyKoiNcM3x5U8gU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690464424; x=1691069224;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kTcJdJwbJqa4YZKH7dkPg8EzMfN3jKVbbeGvYMz7uFQ=;
        b=P5tYPJIQ7l8bSLcB+uLbJblmx8mmnv2vEEqkm1JDgUm/WHB/NpakyAopEQfYojHk0S
         fsEydMmN1xDaykMIB1wanbI77sV8gcapCSqm4/atl1Tiezy0d0gGabAyq0ggv2BOIhb7
         /rINHyov9m8aoThZxYzMk9h8FaNL6JElBAovWZuv+h8kQYViFNMTQs7V5fNxbwb8TD50
         pmlNS0NrUZJp7GOn76IlI/JwNuh3X7TRU1ySo1WAqevdIxnJ20ct4soiPMQjiTD1mxid
         hcwyyB7mmouRh9oIbOEtj9tizrybj7hY+nAN3gfTzNB3l2OBzuqvU/LU8C8bqIMJTAPv
         0TUA==
X-Gm-Message-State: ABy/qLa9mrAAU8bCGtcpI+N2+eeofaMfUt1lqX0oKbXLLt239LUZbHCi
	+4Mz0xgbUspl5gyMN1K+OFpcOg==
X-Google-Smtp-Source: APBJJlGFVKeJQhavIzC+oE5G3ybmX+n/TER7+mb3cGDf4ooxFA89gZHP5VkHFANpBJkyk7SgNbkIhw==
X-Received: by 2002:ac8:5b07:0:b0:403:cecf:4ade with SMTP id m7-20020ac85b07000000b00403cecf4ademr7525298qtw.32.1690464424335;
        Thu, 27 Jul 2023 06:27:04 -0700 (PDT)
Received: from smtpclient.apple ([192.145.116.83])
        by smtp.gmail.com with ESMTPSA id x1-20020ac87001000000b00402ed9adfa1sm419357qtm.87.2023.07.27.06.27.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jul 2023 06:27:03 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Joel Fernandes <joel@joelfernandes.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 6.4 000/227] 6.4.7-rc1 review
Date: Thu, 27 Jul 2023 09:26:52 -0400
Message-Id: <78722041-D1F7-45FA-BA1C-41B92209BA6C@joelfernandes.org>
References: <ZMJWet00+9yIl/9c@duo.ucw.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, rcu@vger.kernel.org
In-Reply-To: <ZMJWet00+9yIl/9c@duo.ucw.cz>
To: Pavel Machek <pavel@denx.de>
X-Mailer: iPhone Mail (20B101)



> On Jul 27, 2023, at 7:35 AM, Pavel Machek <pavel@denx.de> wrote:
>=20
> =EF=BB=BFHi!
>=20
>>> This is the start of the stable review cycle for the 6.4.7 release.
>>> There are 227 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>=20
>>> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
>>> Anything received after that time might be too late.
>>>=20
>>> The whole patch series can be found in one patch at:
>>>    https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.=
7-rc1.gz
>>> or in the git tree and branch at:
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git linux-6.4.y
>>> and the diffstat can be found below.
>>=20
>> I saw this when running rcutorture, this one happened in the TREE04
>> configuration. This is likely due to the stuttering issues we are discuss=
ing
>> in the other thread. Anyway I am just making a note here while I am
>> continuing to look into it.
>=20
> So is the stuttering new in 6.4.7?

No it is an old feature in RCU torture tests. But is dependent on timing. So=
mething
changed in recent kernels that is making the issues with it more likely. Its=
 hard to bisect as failure sometimes takes hours.

>=20
>> Other than that, all tests pass:
>> Tested-by: Joel Fernandes (Google) <joel@joelfernandes.org>
>=20
> ...or you still believe 6.4.7 is okay to release?

As such, it should be Ok. However naturally I am not happy that the RCU test=
ing
is intermittently failing. These issues have been seen in last several 6.4 s=
table releases
so since those were released, maybe this one can be too?
The fix for stuttering is currently being reviewed.

Thanks,=20

- Joel=20


>=20
> Best regards,
>                                Pavel
> --=20
> DENX Software Engineering GmbH,        Managing Director: Erika Unter
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
