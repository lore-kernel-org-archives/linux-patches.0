Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794239627;
	b=uP6m8CCV6HI7xcZbjOxDV6oggeIg8f2CUKAwRQT+d3o821CcI9OY/rzPwB8/P5ju37CG
	 DYI7CSxwzXUlNFbJE11+fZfQ2mYXMnXzFmaYfJMrrZkvGmAuny0tLQx943UonGGCxjiIT
	 /IiNpHysY1r3UkW87Eldq3t9mIHzkhNj6iWeuTXg7AulEcn+IZRYYLBwxQof43PxSo4Q0
	 uTVrowxkMtRUr2zthVAsn66tllmKWu1yjuhwcCWyOBzJ9Xk1uNjr5a5dCNL+hsRwMSoQX
	 cl27i5wDBHK1ITZKaFGETKe34ayh7z56UQ6+M2DldzbAjIRdbtoiORunHXAKPkFPk5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794239627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=P3rbgdGEDBdMiB3LPLRZcCE/s5b2fDG43JrQf9DAC6s=;
	b=NgS/q7no6MFY88i3C8uH7cp7n0EPvUe+ekm2oN1wh2BqiEebTCqyUxBfRmWwDhXgdI3W
	 ddzDlES3t9St77Jy+2jcucmgn27Co2THXXDx8pa/erf4pkBUqHDXcjEdY9y87Zgy1QRwI
	 7Et8K6hfeoqiY1XynrRwwSxK3LzaNQwY0fPdE/weYtD9/wBRsKOIRleuvutMBrcKR5oqg
	 UJXp9FhLl8pRiMyBwuDn+Q1enevRipzSOGZKVvo8OLM3n7GOUQg7fdV37uL2Bokyg323K
	 fM4/NYd7W3Yi/WXwuEOj6zbTIzAGgG4/SAmRY7QcwwOi+3o10mAfIrPw+h/FyINNhsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WXb8pqAw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183D4606A33E;
	Mon,  9 Nov 2026 15:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WXb8pqAw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169791F008A4;
	Mon,  9 Nov 2026 15:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794239626;
	bh=P3rbgdGEDBdMiB3LPLRZcCE/s5b2fDG43JrQf9DAC6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WXb8pqAwTBfGh06ox2HfZJLcgKNMGYLWtMs40sYJvhBM0lk2/RcbiWg/Ar7k8Neqz
	 qD9bO/6gxQIThh9UCGuTHbB3p7pzrmvsWMomv7TO72nZ61PlCebNC7eglZDP+jAC5I
	 kQ2ST2cO90ib5bF045ANQ46BVzisCeZfivvohtcidRhs92mwwfcS9dRr6x0cKEC2fM
	 WfQapSLVga+37QPpLckVLXDMEMgAuzsfDbggTPy3VnytG+umiabyJ6YMH2kavKF2ke
	 p/hQnYSneJqZsRFekN5oqQiUED0KY2InP/26kGfauhsToAsHzuDrFn1teQK6MRoTNO
	 jK4l/Pq0mx1BA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH 7.3 0814/1257] spi: amd: fix len==0 underflow and FIFO overflow
Date: Mon,  9 Nov 2026 10:53:02 -0500
Message-ID: <2026-11-09-1-daily-reply-0020-spi-amd-fix@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <3bf31829-780e-4710-97d0-52a115725eaa@kernel.org>
References: <3bf31829-780e-4710-97d0-52a115725eaa@kernel.org>
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

> [PATCH 7.3 0814/1257] spi: amd: fix len==0 underflow and FIFO overflow

Queued the follow-up fix for 7.3, 6.18, 6.12, 6.6 and 6.1, so it rides with the patch it fixes. Thanks.

-- 
Thanks,
Sasha
