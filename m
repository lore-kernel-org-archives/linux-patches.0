Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F983BED0C
	for <patches@lists.linux.dev>; Fri, 22 May 2026 10:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779444391; cv=pass; b=pc51oENvKIFe1EOn8YypInSrNLtm6uge9znNfd7JseBANqvDcaxPa5QgGJoprpunBa96tqS0aSta6t1cqsrh/dSjZmvmun6EKe9RmaN3UMdT0r4d5lHZac+9lTzJUe4NyG5IbrRq1maPreqeKV3pgJCLfoXHcQozQn9Z4cE4uvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779444391; c=relaxed/simple;
	bh=Kk3dpWi4X7WdsgnppTwI9RI+M9l0h+1R6joOKnG15oI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tn5Y/BJpaKVvVnkj/EOTEBh6GmbHrkTVRMV/UfPyyzZ9r5Wqt5kas7COxoKopC4eyCuAC28vFZHScuQDXtpZIKrJJ0t75oiGnayPZfEQBEW4xAtsvqYquCxGmD5fHABrfWca3oW7RIaERYXUIgcbVvj/xzY4GSiQD7gPNTSlMX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in; spf=none smtp.mailfrom=rajagiritech.edu.in; dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b=xaQ0wC75; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=rajagiritech.edu.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rajagiritech-edu-in.20251104.gappssmtp.com header.i=@rajagiritech-edu-in.20251104.gappssmtp.com header.b="xaQ0wC75"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6746d0b2b4aso12389442a12.3
        for <patches@lists.linux.dev>; Fri, 22 May 2026 03:06:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779444388; cv=none;
        d=google.com; s=arc-20240605;
        b=f48I26C6dLAe6hQuUeAbla8BJirvLEsCptGkXb1JkW/wsC6GxXd0kCaQzPmJegPiz+
         aCUgE8nASLUoT0uMpJCRvOrDUzVmMNJk3mnDITvv2BFxcJsYN+KN2ge+/+DVcwxdpARr
         q6bb/UPgmbNKPbAdtRzhmspxncGPKLbNaCDBrlEYxFxz+th6zMYKR+iXlO93hjIm1Qm+
         6R8zUyz3b5Lf31Z11O1/CLkh2G4PLx2l44lJQ6br+8JCJSiIVkUZYRZVm2UdJVXx6Bxr
         bVGB+daK4H0HVLVDto6OcWoecJADepLG7fG3LmGkz4s7gmoE35GBxnFen/j90fosAJON
         haMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WN1ZLeuQim+cd0ClPrYAYFvTUVyk/+NH9mbV5cz9Q0Y=;
        fh=Y/6rSU40sOIgH6JGEcGuHncowOqogrQg6iqYj/Kp1Xo=;
        b=HPVqpyLAo3SpNP33CLmI/edGb4G97Gx2/PFN6x5xIZHKbZfy15KNT/7rUTOpN3GIwL
         LQvi9En4Snaazj2l3ifq81pYjJjdJxzlWd4TNXZgngTAGYk/vJwSovraHZrQM4wZj+UR
         uij0fsCQyD8P96nolVVfD23JSWnLOfGNp2hUJluvMuLc8nm7Y0nkl7JN0jJLPdPOu/8S
         hfLXkKsLrx2wYXJDpTe98Qniat8q3fzl6tjtEFY6dO2yDMxnSkA7j7CDb5Cza/mKeAu9
         iWUelugSUDKxzAgCTERwi7WSHHf6QZoDvTwJZ5NOD3QqwwzfXNADoeCW0l20aL75YCpW
         oqkQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20251104.gappssmtp.com; s=20251104; t=1779444388; x=1780049188; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WN1ZLeuQim+cd0ClPrYAYFvTUVyk/+NH9mbV5cz9Q0Y=;
        b=xaQ0wC75MRksahkeuUugKPQzrjJ/kvCFnI6FdZaJqnXshJ0JwbxZ57dF133Wr/6YCG
         m0Ldt27TYmZMKVCMa9zGc40RfzsHgGDOU2M4FRfsJcjcl70jFOUKiQY7oXCO7pkuJjsU
         THLYKp0X4KtXfjZtlgmiSRT7GWXSSx30GAYG4Ni9d94M7eEiqGqkvXNsXUOOvwJ0D5qq
         /eSDmFnvago94f/7Mi4+Ab+Bt0gzMp7F9LrX36AzrskRUwyKinGqielfWIH8UxyMlXX1
         TQ5gM+vghuJusU3PSL1V1bftBXwvO3dM8gX3Bmy2L31rO3Z2e8UHMFfoPZ2VM8b7IHPZ
         hDUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779444388; x=1780049188;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WN1ZLeuQim+cd0ClPrYAYFvTUVyk/+NH9mbV5cz9Q0Y=;
        b=B3/x7INRGLYewLgWtyVpBEl7GLdy/9nRRMumwvFAJWeWZBVD166KshWCqTTLK7g7e2
         3YXiUf8+aN1MI2+630jnxCAJ5PfFjxBdxmI0fqr9TYQn+YRzq9ATeTS1SyoPsjdblVVw
         98h5xWFxUk7QobfflbCwHkZzlKRUCMCLQYuwoikKCRxUUhKl8hXJr6U39it+Yggb5cgt
         Pnv2sSGE11Hgz1CvLkcL1BB29AeuDSKY0s09T4JHxroUKJSC8+re5hYtlaCCDnyOljyp
         KpDnx3RAYh7BQIoO5Vc8LkxuKG+60L2AESZE6rWeCLmsuYeTFesrUPp/m1NKr+Nxi2Gz
         lPjg==
X-Forwarded-Encrypted: i=1; AFNElJ/493qlfGflyfCZeHsPxBqrldSJCivNOV3qnsw9JO0+fSXEAUoqxh6oJQdgiuWrTvteHslnLpKG@lists.linux.dev
X-Gm-Message-State: AOJu0Yy46w0jYzFtkizpeAwEBC0Cc3ulIBY+tpLmU30Z/HA62/graQ8o
	lp4wd3weaAvJr8Yp/xGSTvlV2inc0BJEaBrpvVHu6IypRFvD4WNZr/5EWQnlilCe3JKUAzLzazu
	w51glBbJAyQ61qpF9/y/xg0UumihhkOitifdJQpnqeryqInw0+N+To1s=
X-Gm-Gg: Acq92OFthRltwpVQb46Wy7K8xhTdORDGyVVsnhHF9dvleOgaYirVCPe4jfJaZmIUnea
	ynkHPpTTqCnJeaS4zrZTWvwlm3A+46AKlANA9tX4HKSTyGf88flfB7tJFUa9H4RYx4DQmlUSNY2
	igmsbGOJOQa5K5s2xSxx6N6F7xgKCWkb1CD6jjoCUzwEBgnwUc2cejNkvH/JB8q7n8nTLsSszAE
	udDUV4Zg1iX1gIht9ufhfjyxOFPiyJlrvwMDJhnGBk8QO5Aa2O6ogak7q5Va1F4a82F5pLrpWB7
	G2jEvZFmaIXxX1x+UHiAI3rihZXWbeFst5hD9208N18m2JsNGzdkX7zq5tHfEPwUhWe2knHC9Kw
	TiUhgTg==
X-Received: by 2002:a17:906:844b:b0:bd4:7b7c:a4b3 with SMTP id
 a640c23a62f3a-bdd25cee487mr140755566b.32.1779444387877; Fri, 22 May 2026
 03:06:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260520162148.390695140@linuxfoundation.org> <CAG=yYw=zUeUFxBvLhAvhbhaSv=H0qUi+CFkcN1D+Oxxw6fW58A@mail.gmail.com>
 <CAG=yYwmZExpLR5DY73s4c2iQ1cQq=7UcTWO9W2saaad_fzu1UQ@mail.gmail.com>
In-Reply-To: <CAG=yYwmZExpLR5DY73s4c2iQ1cQq=7UcTWO9W2saaad_fzu1UQ@mail.gmail.com>
From: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date: Fri, 22 May 2026 15:35:51 +0530
X-Gm-Features: AVHnY4ID28TrN8CamZY6sA-EtlC_WOxEUP9oa3eKcZVeit1b0iyeIJkQr5nI08s
Message-ID: <CAG=yYwnRRf_=ivjChTxsFdFYXkV+mOURjxJB6U3mXSFTX-kPcA@mail.gmail.com>
Subject: Re: [PATCH 7.0 0000/1146] 7.0.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"

 final test .

$grep FAILED! perf_test1.txt
  5.1: Test event parsing                                            : FAILED!
 22: Object code reading                                             : FAILED!
 96: perf sched stats tests                                          : FAILED!
113: perf stat STD output linter                                     : FAILED!
116: perf all metrics test                                           : FAILED!
122: BPF metadata collection test                                    : FAILED!
144: perftool-testsuite_report                                       : FAILED!
148: perf record tests                                               : FAILED!
159: perf script task-analyzer tests                                 : FAILED!

/jeffrin
