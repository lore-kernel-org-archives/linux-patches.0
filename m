Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F28E49C4CF
	for <patches@lists.linux.dev>; Fri,  9 Oct 2026 23:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791588596; cv=none; b=ZFl0og7rfHW8Ak8VTkC7q1+f0tTOKrti3/rBfB0kijcnUeunq+tGleRTj+XeNQF220TXE3FqjRhIaKpQBoDgatA2QwwuO1AFOaTv7rk0H25NEmGaM77It2MudoIB03Qjq72j1RrFOMolXBUUCz9WvYjB7E6j9qwSwQiy7ROB4Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791588596; c=relaxed/simple;
	bh=W+0BKaSSS5geABgZG0ihHeDh9uE0UJzbPOc7RSsg218=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:Mime-Version:
	 References:In-Reply-To; b=cirq9tINJ0AeQesG4ctZcHmWzFnXs7Heg5AOr1grLnOApr+LRVVyyMpEdQPGo7aneX7tbRwB7vL31+xV4Pq83Wvggy8TRVqTq+P7VTbPmFgslp43u65xUY6wcFwEUYuR8IPGq/wocpDKjUxv56TMm6nz/FRPoijhDltEodJVYEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nexthop.ai; spf=pass smtp.mailfrom=nexthop.ai; dkim=pass (2048-bit key) header.d=nexthop.ai header.i=@nexthop.ai header.b=LMaTTW0m; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nexthop.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nexthop.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nexthop.ai header.i=@nexthop.ai header.b="LMaTTW0m"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-3518cbe59b0so142043eec.0
        for <patches@lists.linux.dev>; Fri, 09 Oct 2026 16:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nexthop.ai; s=google; t=1791588594; x=1792193394; darn=lists.linux.dev;
        h=in-reply-to:references:content-transfer-encoding:mime-version:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IcQaew24vaZlVXB9zMTh3pNgIar2qi3hXpDnWpO6VUM=;
        b=LMaTTW0mr703aF3QYifD7uvqsYnxNZLnBFuHteO8QUPXJ0MYocRPBs7Msbz8sX0ysg
         lCUqQRs1dFIAVU/ATx9O0EB1NPS/cXj/3D2mkTlGgAFAegPrOxJgPZYwetxP1+xQjmLr
         dOPzPckg9sC0hFoReR6+ne0yEN0MgjXMS11ydjXM+ZkhiCIKIq2Jdpwe1e+6AKB1lU1K
         zKQELH4lAiy8TCb7eRWK56hFRNh/9sqKk/fwDXvM51fJ0skqoFR4Xu3aG12AQn8m1tRO
         iEjlcdHIOS47wh+XGV6hBu6TxIzLnA9wMYq0yhTWqjLPUx3lxUXtKS+MShw+SGdDD5DJ
         a5Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791588594; x=1792193394;
        h=in-reply-to:references:content-transfer-encoding:mime-version:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IcQaew24vaZlVXB9zMTh3pNgIar2qi3hXpDnWpO6VUM=;
        b=pLmL/KDwkFiPuRUwcoxrjAAyd1rsGPxLed5qAW9TJ9CfRuB/SZsYRXdVjKrxpFgGXB
         76PwHB85CxWRlKAw5yZK7zFY6dB0u+q8F374Wv+mLhgPHaP+gwNh3ixLWmFIX2RsCyfs
         0R8bBkKt7sHJ0zNzLAyrSXPDNM4mekw3uLZjKDuMQjQ1rk4LgFjy87fMWy51XjVN7T1Y
         IjGvoIjVoF7eOKpg2qAUgElWIT0EGj2u3MtdU9IDxtD11o+VDQHuNJWRDSPCeWpb/lBH
         DJPgHnYZi2pXfjuqXuT3ZihImWkLbVviZN0vAvcRVprlkTI8DkieY5UnGHziQtz4vai/
         /Lag==
X-Gm-Message-State: AFq9FYLOsxLsw6efTQRQ+/2dCiY87hDizd8UVjb5y0UeJZLB4J3VhUht
	AmzPuE0RTz6W4b2EbSVPMZCBT01EXQEqRtqEKebFMH5RhvVt9/M//9cWk439wUTiIG0=
X-Gm-Gg: AYBFou3nYyvGx5OymkhzLuTZcCUnAsR/BrD5FNLnZQk1lBX3vzbFS/7+M8S5MiGqR54
	RI/lchQMbnJM0OkaEcJPH31LXzhLAav+XA5TtOOnKrjv8HbhV0rMr5m3HJuJAt1NRLu2OMxJdaW
	A1IxCMV84EpJ4bLbuxacwhJbQexcEgkPXJ7OTOv/QaHe5yLnEdk/qRmXY02Yd+6heK6HcVbGLJh
	e0v/yv5gYGeuiA1xWTI5nV4jEawlfSU73++hNoGDydELJFId1zlPUnB8yCuks3xn0S2aBwpK/47
	dvkz2sBSQz17OuLdaaj2QzSlGiqEBZH61J/PL9KHpapYJCbqcQYyL0vzOO3H3NS+z/tre/Ksp6V
	WIS4rBldR1SKqSEbQ+g7O6wFgUOsp1gElqZROQFdXTyxmtC/CfQWdJ+ML89q+QtG6I1oI6Y1Wwa
	qjdFxTn+6ubDB2Heam67++uzmMjcNJe+aT5khnAM69rVIVmh7CxMY303W1Svu4YZLXcbyp32A=
X-Received: by 2002:a05:7301:fb0:b0:354:cca:1cd7 with SMTP id 5a478bee46e88-3540cca326dmr2855507eec.4.1791588594254;
        Fri, 09 Oct 2026 16:29:54 -0700 (PDT)
Received: from localhost ([50.145.100.174])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca0e64csm9419413eec.10.2026.10.09.16.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 16:29:53 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Fri, 09 Oct 2026 16:29:53 -0700
Message-Id: <DM0P5HE7X6JY.2JCW21G5D10FQ@nexthop.ai>
Cc: <patches@lists.linux.dev>, "Abdurrahman Hussain"
 <abdurrahman@nexthop.ai>, "Michal Simek" <michal.simek@amd.com>, "Andi
 Shyti" <andi.shyti@kernel.org>
Subject: Re: [PATCH 7.2 280/428] i2c: xiic: defer RX_FULL until all trailing
 bytes are in FIFO
From: "Abdurrahman Hussain" <abdurrahman@nexthop.ai>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: aerc 0.22.0
References: <20261009140946.008206689@linuxfoundation.org>
 <20261009140952.249649769@linuxfoundation.org>
In-Reply-To: <20261009140952.249649769@linuxfoundation.org>

On Fri Oct 9, 2026 at 7:10 AM PDT, Greg Kroah-Hartman wrote:
> 7.2-stable review patch.  If anyone has any objections, please let me kno=
w.
>

Hi Greg,

This one is being reverted upstream, and Sasha has already dropped it
from the 7.2, 6.18, 6.12 and 6.6 queues:

  https://lore.kernel.org/linux-i2c/20261008-i2c-xiic-block-read-nack-v2-1-=
76735ed0b0bf@nexthop.ai/

Noting it here so the review thread matches. 279 and 281 are fine and
should stay.

Thanks,
Abdurrahman
