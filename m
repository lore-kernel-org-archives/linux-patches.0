Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792508082;
	b=pqc8l9EF6Tq4iZeXF3FWX1wohVxXnVuiY1xu0XPnHCaPetjkKOLxXOf+/MfH7bLksF4m
	 JhJham7N9QxypcREYwZ9Co15YRmm8QghpYS1gJ+7bUnoRFp94VXF6xGqJYLiY3/KCCXuX
	 oGYiMsSYgAl2Gvmx21wxYGlVBFOhISq93V40VrQCC2UWGoV8gclhXiEwXH+Yr7OMTs54n
	 ELyXpy9Dqr3OEDZDLdbuWzPmxRzq7CXbn49YU2GspT+8MdOMS6llIR6DCw1c7qeh1aXBr
	 4LWaBTH5h9QL+6+T+88TOgQfSpA5QIWxiuAG36nrbkTD+g2b1zjbPyQvVQhscXzeloQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792508082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/N2vEDspMeBxvAsx0/efXFk4ZBc7+qkvIXFQZ4lDJmA=;
	b=NxLy8FmtNoc0y5OpW1YZF7GWYZWE2gCtT1hP8ZtiH3/K08+JiJ1z05xMQtRp3iugdEuG
	 /nTEOyzydili9EIJw9BfZzuBPTmVS2n1tJhJ2Okw0CDU6509phNu6sILX2ikm7hrUp4Bf
	 6fjSUlGMyRrY16oOOERHKvNMhwiZyKRs3DeYXTtE0VjDMsq9AA5xFTp/HrHi7Rgou4Jzn
	 JsmVCeJSSIC7k60Lod3xDqj1CutYiCK2j6dW9bZ3Y/LxZ17nlbcp1e9SwLmtsncKKytVb
	 kRObYKqqO/YzYU0TBpj0KsOEwbLbPhXNTXKmfXc6U3RR40o4drC705+1/L+56F5kEcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F7LFA3sQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773F5606A31A;
	Tue, 20 Oct 2026 14:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F7LFA3sQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADF11F000C4;
	Tue, 20 Oct 2026 14:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792508082;
	bh=/N2vEDspMeBxvAsx0/efXFk4ZBc7+qkvIXFQZ4lDJmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7LFA3sQ21HhpWwvsLp8L1LmS/o9R7EhGZVXOHcSPQ6u5BVlqzBEZih60qjEwSbr8
	 ycLznB1SxmwKYbzKEPceU4R9JzTG2XtCGDQuY6zvyFYIFgsNTQSpLODw+mB9wu9wSM
	 Pf2pZyfGnjt5by5WaHg0W8t3XO2faZvmMb8rl4tJPLMLFMOLswA1DlozieRFUiCSZh
	 ZE+Hc/hM6jFprgGAy040GbW0CWZ/rVJGecw7F3qd7o61tWNoDXvpddGBcWAdY9BUcL
	 tcOweJ3J+gNGfzsmkFOHeZIyuDwD7LjiXqaIvMXr0J8Y6wSyTonE7seyOVbQQKGetU
	 EWxtUxrd+NbPA==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
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
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/858] 6.12.114-rc2 review
Date: Tue, 20 Oct 2026 07:54:33 -0700
Message-ID: <20261020145434.89456-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261020075246.861837975@linuxfoundation.org>
References: 
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

On Tue, 20 Oct 2026 09:57:31 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.114 release.
> There are 858 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
