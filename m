Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B2737105A
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 17:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789319637; cv=none; b=BB10gMt+r2wtrvCm4sZpy853Y1/qFY5RalqYsoacCDWDx3ZBpxMFJGXoZYbKF4S9sZLfsiWJ5OyR9qcwJx4KIWcViU1HMmStLoohTjP7iYteuVWe6AgEnR8MhzQVxzsmnsfHIkWOFuzHqx70ETlSGbUXbKDQME3uY5HjUMGvw0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789319637; c=relaxed/simple;
	bh=c/rgNWkG8eebV4a+R990wA+dAtE6CX6lxhPqQ7MPdmg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IySXxEuL0D1aazTP8+lhGOk3RlY/WJLGGSRcw5H9nReotr5UXAu1nDNGAKGnEkIidfL8/rVfIAs4Sc6SQpn8mcNTQkQUt4cBIulRmYWesvWW1SnpR+1cqDSG2+3gqhXg6nAimlTlg+5Dk9tEPFV6zvMhdtwSaauszdiZXwJH+2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MBCCkUMs; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MBCCkUMs"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485b1d2874aso1059390f8f.1
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 10:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789319634; x=1789924434; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c/rgNWkG8eebV4a+R990wA+dAtE6CX6lxhPqQ7MPdmg=;
        b=MBCCkUMsk2jMcL1V8rv9jlg8QY2zEqv866prqvfLWSWKYFAU5SY+8HqOrfgyF9f9gx
         YSWO/nYkEP/58tZajqNOA1vQuAzc+/soVOnu9b1EVvUQ8exyb4LrHm/UYRmYefzXfMAb
         uxZEtMPZyVX7xk8gP3PlarJ64DlewNbdGk+1BNSUHAyu8b4WOo0lFH2qtt9oLq7AKEBZ
         5GW6s9Qo9UaaSPfa2dQ7IawKSMV2ngjkmidWIp5GcdiYWS3t713y4S/PRhRWXvjhn2+t
         6Wu1NnrhyEpFJYUhobokN20eg69+zWjosN8zEl5xWwJ1mr4Qm5bo8fUIxEeKbEtcde6B
         FGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789319634; x=1789924434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c/rgNWkG8eebV4a+R990wA+dAtE6CX6lxhPqQ7MPdmg=;
        b=CGhJJv30cF1FiaYFg6CKkqsO+A+nHb7KY2ykBCfPaynTIQizEPewzwUs1v3vYijztF
         3Sa8KuPKGNoF3ZA55PndGVW3ZSOmookipenDyqG+Z/So9h2HXpOrkOyOAqWJNdELKZB2
         kPwA5B5n1nvcaXpll7l4ZxE3avfee8CTc7DElYdoq2iuOqax5pFLhWndHsn4/L+u2nXY
         syV8ofB1F8BVnjLFxZ6BKHonIoVfzP6gxmoal8NS9K+F36hUCcEoLnoWIFLnMluSoWst
         mNF4xiL567DsoAZmaWQVX20slHvFnbzIPVQmYglkPPNSRUwgO2tFAdMvnD71ScQyzPQJ
         HcoQ==
X-Forwarded-Encrypted: i=1; AKwUvBxPxOExWZEZTzRkfpr1XkcTX8pZZ9exJPBmKoc+mH/NysHLN6pSzzpl8I4mQ1SVWpoYROv+YIkI@lists.linux.dev
X-Gm-Message-State: AFuF++mW98JORMrk00Y+sOV6zQI8oBG/FyWwHMzB9ts2OnXZBqTrvIeW
	VohgVzLVecNFtatbT+BWvpajgh40k57DLD/eD9rdc0HYq0Whre2RoiGc
X-Gm-Gg: AYBFou2g/urgnBRnnmKkqTtzqi4IMrezpZkSXkuLQCpBs7YfPUWJ+9ThQtoBELs40Et
	RFYLtv0QyE2kqZZxurhEUSCeFs3n2H7ZaxG9pD9eOG+YL4eXhxGVeUG94AzMW8402qeVzqjTV6s
	5JPjAeCl+VGee/hLyRklADhfWDicajzPwC16Mc0RzsKoh0N8lV8IFC65dyH+X1eDGJazrvJFjmU
	uofSvEFcDJ48kip2QX4PLSdQPiBDHPPRehsN4Qn32WkNZTjwP3SkVntsy72BaBwzYArr4PSBWrc
	uyRh8kCIQSB8uespVMcz1RZLzUyg5xcS9z1B9kItMyiMiVouA3p2hxJXE2cEJpdG8Mr7+WUnMY8
	xMK0fczw4JvEDxyd/82PdolY48n9T+LVStBogxbwmVNRp/GStrcqT9Dvl1nJ0TXI9NEMYxsBkEz
	Z811cPATelNKVtayn2Vv6egj8yAezxiAUppDvTTEq3qzYHbaaqoj1XyI47LwhkwjtXhfPzjsT4q
	rgNKKORZZ8X+dqpkwtwhtzT+uM4Ddpx2t3PctPScfYlnFh5IefHDeaHicwZUxjpDB/jjMv1ISZo
	WAF6tFzh2IMfyP0d2gjAtBbN9lO8HGN6OR7yj6Z4gROSFboz1eXqtB84v0enCYf9ERA0lSZLata
	ICa14pwPy
X-Received: by 2002:adf:ec86:0:b0:47f:7129:6e2d with SMTP id ffacd0b85a97d-486eb325de3mr23501505f8f.17.1789319633545;
        Sun, 13 Sep 2026 10:13:53 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0e6-2301-7846-2cfb-35f5-6359.310.pool.telefonica.de. [2a02:3100:a0e6:2301:7846:2cfb:35f5:6359])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb34f1f7sm20618159f8f.24.2026.09.13.10.13.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 10:13:53 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Pu Lehui <pulehui@huawei.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 535/935] bpf: Sync tail_call_reachable with callee state on entry
Date: Sun, 13 Sep 2026 19:13:47 +0200
Message-Id: <20260913171347.1594-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260912065539.091095476@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org> <20260912065539.091095476@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please hold this patch unless 5.15 backports of upstream commits
01793ed86b5d ("bpf, verifier: Correct tail_call_reachable for bpf prog")
and 54c27ea6dadb ("bpf: Fix tail_call_reachable leak") can also be
included.

This patch resets tail_call_reachable on callee entry, but 5.15 lacks both
the direct-tail-call initialization and the parent-state restoration it
relies on. This can leave the root program falsely unmarked and make the x86
JIT omit required tail-call counter handling.

I reproduced this on 5.15.221-rc1 in QEMU: Linux permits 33 successful tail
calls, so the test must stop after 34 program entries including the initial
invocation. The unmodified rc1 reached 35, bypassing the limit.

With tested 5.15 adaptations of both commits applied, the same test stopped
at the expected 34 entries.

Thanks,
Karl
