Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E8437E2ED;
	Thu, 30 Jul 2026 02:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785379260; cv=none; b=fxdTXU49BiWFGkY/wk43cXi6VN7b/H/Z1ogB1FgGfpyyvE7HsWWXKM76r1Ldi4X/hzsRgf9dKBbDZPGJvWFOnan+xeNgUaRrgRnA4uR38KP0x7/jehczH4VGS0zCZWb6/u/cUj8Gdg/2IHFlxj4cmw9js9aYV/F46VFjnHy4Ebw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785379260; c=relaxed/simple;
	bh=496ZtkJDJFwl6+el+kxBnCWr9DqgVZVDuhbTkj6XccQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTf0RtB+KgaeUcKyq+qKWyLEivXRI707eZf1D7BrDPAjCEiNMO2fkArGBSHG4XIeUj4mWAqmY3sGrLWzvby85rkNWDkNQ6WFpk8uurSLXxBli6fWUgp8mYMG7+tKLs5B6ysaFuSVznRrDB74vKTTdzhxqac9U0N2iilwQ+xfqKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BoFwLDwl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BoFwLDwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC581F00A3A;
	Thu, 30 Jul 2026 02:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785379258;
	bh=CQU3DEqu42JsTMY1T0UHiJQEuBpIZgaC7K97MULwUsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BoFwLDwlRW+P7f26DdltEtD/jDePwdkaY4dHICQESDt2sHsCEgsesEV4Y+vsnOqpn
	 xIV+/2Q/dVoqXda3au5Ji33XH0ROTZ+2C0XdjK/cF9LZvfCAmV3kmah0DNeRqXdmkl
	 r9qn3DWlsfkE5s7pQ/TefRzonFq39vNEu2VvrrEf/8pOOcEzPSgh+nsv5a+d+YeHqb
	 5qBen+W1JyHNHIoVHSQY2l127bTRxqU/AKjqZCIwmPTC+S6VITe6s3ofVXSI3CFHYs
	 Ip1Yij3+TKEFVK07yo1n4nttslTrc4EtqusoEEv4yeB+HknxZCxrHhNSeViU6My1gL
	 FRSzoMAngBpCw==
From: Sasha Levin <sashal@kernel.org>
To: Wentao Guan <guanwentao@uniontech.com>
Cc: Sasha Levin <sashal@kernel.org>,
	andrii@kernel.org,
	ast@kernel.org,
	gregkh@linuxfoundation.org,
	kpsingh@kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	xukuohai@huawei.com
Subject: Re: [PATCH 6.1.y] bpf: drop bpf_lsm_getselfattr from hook list
Date: Wed, 29 Jul 2026 22:40:24 -0400
Message-ID: <20260729223316.stable-0031@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260729151151.2069645-1-guanwentao@uniontech.com>
References: <20260729151151.2069645-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [PATCH 6.1.y] bpf: drop bpf_lsm_getselfattr from hook list

Queued for 6.1, thanks.

-- 
Thanks,
Sasha
