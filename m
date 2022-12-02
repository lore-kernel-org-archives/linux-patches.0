Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082EE23D3
	for <patches@lists.linux.dev>; Fri,  2 Dec 2022 12:34:00 +0000 (UTC)
Received: by mail-wm1-f52.google.com with SMTP id c65-20020a1c3544000000b003cfffd00fc0so6380600wma.1
        for <patches@lists.linux.dev>; Fri, 02 Dec 2022 04:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3F5VNxfTKyX6PR+sW41djwfBxWIbg3en8d5fF7dJfIk=;
        b=mQ6FPmuhqOfaeQd+TrxoA/zz5LXCSnpmq1JA509g9a7+RsroPVWL3hg1Y2R2mEPzv2
         gktmnTU7c6cgIj/wJ+/73gn1mXg67h7ald6IftYa6TWbj9elL0GA8wkWlDcpEny8X87w
         F+eeFr0v1xMvRVfwtT7xwechvCuw5iecZpOJVyteTzx17884a2fAe4OccI8c7zDPeM4Y
         Mf1h7ks1fU2QAmS8HX7qZa2E7+zi/28tYC0tDFVH7LXuL6zgS3ChIY7HH3nWbL3sCMBg
         cK1zZGZSSJtjG299m9oAKVcMr9/I/mYAB4FcVf+gB83IesCLB9nvSN6ryReRnyHuNhxt
         vXRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3F5VNxfTKyX6PR+sW41djwfBxWIbg3en8d5fF7dJfIk=;
        b=L5TEKMueVzm6iv0T0g7Tpznu2hv/GJXtoLq+KV0qpCKidIyb2Bz5UcKfAM5d8zcEi3
         noMnV8x0ZwSkMnPLPZcFRhvRMxBq4ZwoITOKCSJPqG3D+aL4T9RH4J9i7oL+DhlrOuNV
         zpsNOunU82lvXQRkW9aBcoAHfwyPaBEYzlAYQHZwIKglTw9FcXCU76QZKIkoIIGPEizU
         vVaafou7JbQ2VuKG+FmpkuZ0NgeP0ZFWYSXjtbiy7lnxGPyG3J+NBEX9keyzAvL30Ixt
         SSwWjuuJ8qEjju8s8k8Q12xehOXea6p8CibiIystXcw2PW2J+b/7VzYThirbSH7dxA3Z
         L4Zw==
X-Gm-Message-State: ANoB5plYX5P1yEkprweqm7y5a96bG+V4E98Up8NOhGtrJ8jddVyaGXM8
	MPQ/CpC60D1anmXCbT9VqA5EBqFEc7VrNl0Qckg=
X-Google-Smtp-Source: AA0mqf4jTaPPu5I7MfaXRWWcmi8TzcblzWY216hb3SlPhlMJMzzTD/6X+bjJuC1A2b9ye+p0Py5kKo+w4iFZc7GC5Go=
X-Received: by 2002:a05:600c:5127:b0:3cf:a4c4:777e with SMTP id
 o39-20020a05600c512700b003cfa4c4777emr45782892wms.72.1669984439131; Fri, 02
 Dec 2022 04:33:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: by 2002:a5d:55c5:0:0:0:0:0 with HTTP; Fri, 2 Dec 2022 04:33:58 -0800 (PST)
Reply-To: keenjr54@gmail.com
From: "keen J. Richardson" <laurarichard051@gmail.com>
Date: Fri, 2 Dec 2022 12:33:58 +0000
Message-ID: <CAL=4qitXHqAXuFEx5_jJ50AFFo5_8UL2-VzVCOtrbuRvYGy-Hw@mail.gmail.com>
Subject: =?UTF-8?B?2KfZhNiz2YTYp9mFINi52YTZitmD2YU=?=
To: richardsonkeenj@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

LS0gDQrYqtmFINil2LHYs9in2YQg2KjYsdmK2K8g2KXZhNmK2YMg2YHZiiDZiNmC2Kog2YXYpyDY
p9mE2KPYs9io2YjYuSDYp9mE2YXYp9i22Yog2YXYuSDYqtmI2YLYuQ0K2KrZhNmC2Yog2KjYsdmK
2K8g2LnZiNiv2Kkg2YXZhtmDINmI2YTZg9mGINmE2K/Zh9i02KrZiiDZhNmFINiq2YPZhNmBINmG
2YHYs9mDINi52YbYp9ihINin2YTYsdivLg0K2YrYsdis2Ykg2KfZhNix2K8g2YTZhdiy2YrYryDZ
hdmGINin2YTYpdmK2LbYp9it2KfYqi4NCg0K2YXYuSDYp9mE2KfYrdiq2LHYp9mFINmE2YPYjA0K
2YPZitmGINis2Yog2LHZitiq2LTYp9ix2K/Ys9mI2YYuDQo=
