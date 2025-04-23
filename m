Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE1328B504
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 17:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745428933; cv=none; b=Qkl78C2z0978f3DppCvH2fu/esy7q7zOwC9KNBEwYMkwxhybHgM7k2f+jXvjabmLGck8b7BEajJJ9p2+r0nDVfbpZ1PVbW1fERd4w9vqa2lDAjo2PQuv510lNYeuDpczQ7hC27wgZWI2Nh0oI0zk/qs9jwXCtzeak8LEXRehYcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745428933; c=relaxed/simple;
	bh=oJSYqGkH8eJ7nnI4eONslaNCAK4zDKV2Mf6cPlywreQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Ei1uDignFuOeV+JMH1+JVHwNB4q2aEqvu+MW//nR0vCwKvR3ATWl0rCUN9412yYISH9YC7fqkkZpxCKzeD3/trqCEaa7aYbliBdloMAHJsdxF9gjBkpJhZSk8K3EiFJpQ1LYGsXNwnZ2LdQJ6ESR8vI7d+xnMTsSi3mnea6cGUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=B8REfkdd; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B8REfkdd"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3912fdddf8fso937728f8f.1
        for <patches@lists.linux.dev>; Wed, 23 Apr 2025 10:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745428928; x=1746033728; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I/fWatsoyC3ISeEvWnCn+x63EPNqLu0aQi3bXvQHx9s=;
        b=B8REfkddljlzh7emJNMJfaTW0pKVflLQsVsjzkKMlZQppyEhlehviYPakA9hCQJK6X
         XgbkCX9GOJg3noxtp3x7Hhi9+xT440kWVbk2NAlYfbjSU8JkavgR2ARsAjrgn+yk2lAp
         QpHoFzoi4B5iYL6I0ju17pkDwGlnVOKCcHm7EDhhD8bwN4o03OXNcO4ABgKSVLTYyy2c
         WDUsFfuPLTtOehH1LDlhuaPfESTztdkmxft23ihrVShT+yuRApU7iVfIooq8w8CwmWnp
         tbaDRYgL6Wjq78hGY6wz7f8+p2Iqt2u3I/0nSHGhFgm+Z7Hc6MFxgskdCeLsjSuBWN7u
         ky6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745428928; x=1746033728;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I/fWatsoyC3ISeEvWnCn+x63EPNqLu0aQi3bXvQHx9s=;
        b=fFXuRsboydbHtA1AE2jMf5oEOcvwcNo4vR78qIJa2py+VZlzOUKjptTv4/vgHejNcy
         HoKKfw6m1UpFC6LP/mwHcPMcAUbLWDGTIsCIRgJNpNAWHhvsfXltLI1TJNxIKkgrMFQf
         IXfVJypbsxNawKpwlP2F+Os1q+TjePDCxVKS8LlYQ5WzPmQCuiGBDNhutEasS1dqZ0Mc
         ySajeBnBv9Mcc0Rb6vcu2jesO/aB+qmaJS44Hm/T206e5Pa75Mt8c9Art1BAM01Rb3Ty
         IBITKS+1Km2TwUFDP+4ToUlNmaha4yCRaIzD/4OSCfOC1wPvyAs2babE0WRuVGCr7LWk
         jVyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyRlO+Y97KCKuWxaNJx7ZsQiwOGQC7GexQdlP+lc4vSrcLd8Z3vlFmf1qXVLeEpwzze/rC2Pas@lists.linux.dev
X-Gm-Message-State: AOJu0Yzf5gf2y2XX+hMyBxG1Bhk9HIb7+yYNxbOyZ4EhJXLY0MP1lEdN
	AJWsENmPtkwhCAMN6E5KzdKAqXc8RcQIuBCLEj3ieiiFfkK52qgpz2uZb6uFO8Q=
X-Gm-Gg: ASbGncuY7QeudprXEgdaQHuaCcYkxW/WBlh15fXVDvo2wFpbBrCfOd8dBEocCpH6UBh
	nRHcy5ozwn9tEld0HW+rBI44HIAzZB6K2sX5cdCtaWsU6QJdhXc6HG0OMgB+G0h7dGb5ORT9lTG
	hq7Us2hIzo3gYT9zZRm6uaimvmo4keEeW2NTp/YJ0sGRC26T8fJ8rhEGXcHvplcR8038oBI/VpC
	5nRTyEITzhY+Iro+EjySWhOPuW/QVuke02IReTnxBC41oIT54vwDqG635ueMnEb+88naF0SdwKg
	BKkdPy9c+oX1b5MC+UCbOPZ1PuOLXtrAKbTZqwbEhNdkWA==
X-Google-Smtp-Source: AGHT+IHpb3M2AX8ubADr1y8Clnmgy74dWjubTc/OZ082AsTXoWv1+RFKxrQiRpJTvsF1zuzQls4pfQ==
X-Received: by 2002:a05:6000:1acf:b0:39a:c9ae:9eea with SMTP id ffacd0b85a97d-3a06c6bd8cemr18787f8f.10.1745428928559;
        Wed, 23 Apr 2025 10:22:08 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-39efa493115sm19460396f8f.78.2025.04.23.10.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 10:22:08 -0700 (PDT)
Date: Wed, 23 Apr 2025 20:22:05 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Bjorn Andersson <andersson@kernel.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>,
	linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Arnd Bergmann <arnd@arndb.de>, Liam Girdwood <lgirdwood@gmail.com>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Marek Vasut <marex@denx.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] rpmsg: qcom_smd: Fix uninitialized return variable in
 __qcom_smd_send()
Message-ID: <aAkhvV0nSbrsef1P@stanley.mountain>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs+z4-aCriaGHnrU=5A14cQskg=TMxzQ5MKxvjq_zCX6g@mail.gmail.com>
X-Mailer: git-send-email haha only kidding

The "ret" variable isn't initialized if we don't enter the loop.  For
example,  if "channel->state" is not SMD_CHANNEL_OPENED.

Fixes: 33e3820dda88 ("rpmsg: smd: Use spinlock in tx path")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
Naresh, could you test this patch and see if it fixes the boot
problems you saw?

 drivers/rpmsg/qcom_smd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
index 40d386809d6b..bb161def3175 100644
--- a/drivers/rpmsg/qcom_smd.c
+++ b/drivers/rpmsg/qcom_smd.c
@@ -746,7 +746,7 @@ static int __qcom_smd_send(struct qcom_smd_channel *channel, const void *data,
 	__le32 hdr[5] = { cpu_to_le32(len), };
 	int tlen = sizeof(hdr) + len;
 	unsigned long flags;
-	int ret;
+	int ret = 0;
 
 	/* Word aligned channels only accept word size aligned data */
 	if (channel->info_word && len % 4)
-- 
2.47.2

