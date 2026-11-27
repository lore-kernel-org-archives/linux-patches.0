Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795766379;
	b=N6r4WsNKxmj6dmHaxNqAoauIVo6bgiR2zjTk9V5Caw4VTolVysKwq1rZDfqeQ2U4mFO1
	 4tNJymTSHDiHpcN9gTu7Ykft2zzzceMe3URJzmO0WCLM90MEmbRy1czzvea0cvFi+hoSB
	 O4ESPRbbciJ8SiLBsWvzY4mngpMf2NbavQ47+ZkCzNjMugItaLHN7fKdP/2xdqo+LvkH6
	 fMNnS7fHyZJFuHneQOG2eEYM97gZo7zcbpz3OeN3RLGkxm7R5gGhJhnNpyeyn07s9+/1G
	 EUp4Iuc/lJSS0jceYg6GcWi8dPoAtdH2pKYoYx04ZYcLo0/DLwgyrysYZFdBwgY3TTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795766379;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kY9TYKKb94AZM5BSiMSzPLcikP1Dk5G/hq7Zn5CtRxI=;
	b=Wd6WGIQdEl8SrTqIGXQbKvtEpfRhBLEZfEEfS3tmVBUnCwhh4htz6iaoyiBLbaLLUg1Z
	 iyi+WIqPJt6QHhUvz1cUK1AwU38wbMImDOKaoO2XrrL+ATnCxaUb9mAriLEC6s02iLgow
	 CXRn1Jr1PiFUvI3cBVygu+oyF1qDDayDmdvVBVvx4s14QWsVc3v896dv2yEtj61RF4wIm
	 YmapyrMtMRMHcVoaXQ74tK2hG2j6+B/ARBNGB+qlliDF/UqmU4sRqipCa5CzU+slXr6ZK
	 hASV/JLBMKqzmJ7b83ajvRTS0IANlFEurnhuM9bx4rDL0+Heh2wUinTJjTy/JnNAHxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b="f270/N7A";
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370C2606A31E;
	Fri, 27 Nov 2026 07:59:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 370C2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=f270/N7A
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=kY9TYKKb94AZM5BSiMSzPLcikP1Dk5G/hq7Zn5CtRxI=; t=1795766377; x=1796630377; 
	b=f270/N7A+I2wPvgW95BwEg7ipse/tELAsYKXWAH7qyFx/zpSJEp1ZEZoiqF0VQMK549PDNtNnzx
	bcpt4nWq1PtU+imm1vXIBZZrViWmhfUy/h09FhVuW1MqFNcjIVQqho537D9a+7C6xy/B2CqoR8bNW
	4AHkSqag2npFnvJw/Gv5PZXrI/mEWOuSa3ZxMCWyf4ErDsJmPiZsutxpzKFBeGsQ/uv3C9J0yigKG
	QXXkLaa2JqYTivzMy8wCz5UM1vh3gNmB6P76G+gFfi02L5rUJinjWOmW4CZa/rMzz45eRUUCLREVD
	fIhpYyyd1xj1IQuHQ0V9vcirEqLKFrmgGIZQ==;
From: Brett A C Sheffield <bacs@librecast.net>
To: gregkh@linuxfoundation.org
Cc: stable@vger.kernel.org,
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
	sr@sladewatkins.com,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 5.10 000/264] 5.10.276-rc2 review
Date: Fri, 27 Nov 2026 07:50:36 +0000
Message-ID: <20261127075041.39800-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261127052100.671985356@linuxfoundation.org>
References: <20261127052100.671985356@linuxfoundation.org>
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

# Librecast Test Results

044/044 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 5.10.276-rc2-02075-g846ef7d42a1e #1 SMP Fri Nov 27 07:47:53 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
