Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795140562;
	b=afv88h+KqF7wfcwh+V3Kf+l/TvCwb764o/nhCB8lwbCg8/fBUBqKBGY9eLju6qd0Myxo
	 eEgSrpiBFPhE2PK9IgUFDWfJUU+rOCXk0TPpR6vQ6wpIfMwbCsVLBCVZ316jRTDwi7+1h
	 iKtuc7dVA8VWf2Teat4XyUWyOx9csTU+96OvHhb1q3bHAKEPFrz3Q12ceKFLOApmBdaNd
	 NvricKvQ3ZCyWE3dJpUPtpmFNCUK0V+8xabPoTEbaAqBXXuz+VmI6DyVaHt3kGJrXc4VE
	 tMsmzO+w56kW44JxWKZXy/Jk3L8vN59UxfgNJyZU1ES1WVTz6cdP8YIPcFcCmOpIo/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795140562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=qJiVJDNekAokQeNMicLCJvoSDU9IgFcCE09zzbGPJNE=;
	b=IcowWQMOUx2sA7qO91zG0JEk8a50XG2v5lPQKJS+BJAqzLjSguUrFXYB26mg+8jHLF56
	 gE7w+gREEhTJJSy538rjDc0VJmwCSEau6n6SMX+Qu/hGfId49qyL3UFMs2GlH1+Ub81mq
	 IHauBolriMOHWLzfi2wQo7pZw/rDxBm09wwt+5/TpzEmC9iKht3ph9wrU5Q9sJm01YWN/
	 7nWMT9bKWGpCx6DsBOTi3XI4OiuYCj+sCOQcJTnG45/+K+yZjmM5+erKcamEYJUVaQfBe
	 W5GFbIjYCWMi0SE4bg6IB5vE9zdvuMNEoVid9jt3hDBtWCddzWPgMx6J3v9ZXgXP4IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q1PCHG8d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C9460A260D;
	Fri, 20 Nov 2026 02:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q1PCHG8d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CB61F00AD3;
	Fri, 20 Nov 2026 02:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795140562;
	bh=qJiVJDNekAokQeNMicLCJvoSDU9IgFcCE09zzbGPJNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1PCHG8dHNQNiIabR3CwA0pJgN0yL9k4X6duHLLUa7dPXrPsxSWJe6aM3zPoyuWOy
	 wTOTeP2Fc0MRK4OJJyIiqcXZ9ulPzvhslV5dbOGQGAOXmKyr7KcO/fDvbLL+pIzq5O
	 Nvr5V2vKXbq/I+asQfgOwFaiaIKVrZjpTCxSkQTR8mpgEeWOOjqKyGB+WowC9DYbyR
	 Bj6d6dZMpUyvhXDJTw11b91DiELFCp8gK/D5/zDBAJlSPpCyUka4/6+JG8zjoUUwU9
	 uVibrhbO3yKctH2uEyi/KN6gKteIACmoLOYqb+CpUEvRuqacWG+tsdC1xI5cqNX6RX
	 l/d7nIX9auO0Q==
From: Sasha Levin <sashal@kernel.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.15 0000/2214] 5.15.226-rc1 review
Date: Thu, 19 Nov 2026 21:09:03 -0500
Message-ID: <20261120020908.2320910-6-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <65c24a95-1087-4f30-9f9c-9e8636da211c@gmail.com>
References: <20261118150009.797899913@linuxfoundation.org> <65c24a95-1087-4f30-9f9c-9e8636da211c@gmail.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Nov 18, 2026 at 11:16:34AM -0800, Florian Fainelli wrote:
> undefined reference to `__evsel__parse_sample'

Here is where this stands for the perf failures you reported across the
trees:

  - 5.15, 6.1 and 6.6 link failure: both evsel validation patches,
    2148e094671b ("perf evsel: Validate branch stack before byte
    swapping") and 02f6847e1822 ("perf evsel: Validate RAW sample before
    byte swapping"), add tests that call __evsel__parse_sample(),
    evsel__put() and perf_sample__exit(), which those trees (and partly
    6.12 and 6.18) do not have. Both are dropped from 6.18, 6.12, 6.6,
    6.1 and 5.15; 5.15 also loses 63c12ae2f246 ("perf evsel: Add
    bitfield_swap() to handle branch_stack endian issue"), which was
    queued for them. 7.3 keeps them.
  - 6.6 dso__symbols: 45d15e89a783 ("perf symbols: Don't let a module's
    last symbol overlap the next module") is dropped from 6.6.
  - 5.10 jitdump in_pidns: 67dec9269314 ("perf inject jit: Add
    namespaces support") and the four jitdump patches queued on top of
    it (dc67c7837a83, 9bef5cead63d, 4eddf7d9e341, 92d50319b4f0) are
    dropped from 5.10.
  - 6.12 and 6.18 annotate-data: 14ca0a28de37 ("perf annotate-data:
    Resolve type DIEs in the debug file they came from") is dropped from
    6.18 and 6.12; 7.3 got the missing prerequisite instead.

-- 
Thanks,
Sasha
