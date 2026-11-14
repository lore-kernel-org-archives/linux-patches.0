Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794643232;
	b=QxoSWHtj+O5eHZygHagB7TmnjZbhxJgAS5THw9o9UEF9mDBlAhdEEu+nVXY0/BlMNS0G
	 4Q9WPZhoIlVrRd732yHIPchOwHZ5gNr9wqyrR74DkFgw75G5yZMA3JTUI7tD0aXHihyEk
	 BOGk4VpAeIh8EOUGlW7FAYI8JFcol3LzRaY1M5Yj7xL4hfdqhx8xFH0mXkmWpej6oHn8T
	 OuTQObUFo3+b6geMN5l9VyQ/lUa9rRU9UW+XQojIH9mnetYABGNnDHHgNhkKCZQDP/4FU
	 8HILAdL+eLY6j3wgV4+m4eKAEvl5Po6MIXOCIRU2SIazZwQsjrJaqZplAUW+ytcwBuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794643232;
	h=DMARC-Filter:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HlAJQDRNS3wb647fcEyzYriwXRRuzHo0Z4HCUvN0pNE=;
	b=gFYiSEy6P8ghpxH2Kr3dI9jzhPF8E6UQJTrR5MekpuViv7BzE/F1PEoOCqSdbzOiZplr
	 khTKzLLac5CERpyjrtXlEZ9cA5+oqRxeLs4SLea5uwF6pb6utvgc/dqcklubMInLI98Wl
	 tHfZIbSg4Wm6vwZWzx49caRkHQLbX2Bqa9hGMMbGm9y0qcUDAOK17eW+sZOU94vNkA+6K
	 kI5EF6oZxo6R/Jamz6pg4JKOI6+e3jDSO9t3FbLgIZU8LfUSh6wGNYvhKc/mSaV8E1rWE
	 KBAnnviyeEpDYuCGkJhMwUiDxBmD//KcmjoHTFOJFX5NkhbvPdaZdMI91WthEE3EXlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=Gr12Pwib;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BB1606A880;
	Sat, 14 Nov 2026 08:00:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92BB1606A880
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=Gr12Pwib
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=HlAJQDRNS3wb647fcEyzYriwXRRuzHo0Z4HCUvN0pNE=; t=1794643231; x=1795507231; 
	b=Gr12PwibIakuDLwy6jyztVqdQWgUyouwH7blkx6VvA4dDK//7mr5GeJbAft9qzSYCoxMacKEJSE
	B08FArPbZWa55gORQYoxrZNXnImPtIPWb+DmCwa39pdPAjjXOQLJR69+p8g7oc0duGGdPVwlr5gYM
	t3PlOa773iCqTLurqh1abEmnkIOjLF/c2sKm+plP6TsQRN2N+W6PHr9t/qGu6Y/pb3IJN247s15gi
	x7r/8FpVfMpC8pGJvLm8jkcOg/0tCn6u4Z8ST41JqqAHaS6tZtq0VrTDa52lN7jSIEOziHReMdVEk
	fQKLxnhSiDdLUk1ETbauSzK3Z7WjQ/7YRLIw==;
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
Subject: Re: [PATCH 6.12 000/670] 6.12.118-rc1 review
Date: Sat, 14 Nov 2026 07:51:30 +0000
Message-ID: <20261114075133.50635-1-bacs@librecast.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.12.118-rc1-g8ea1fd6d2bee #1 SMP PREEMPT_DYNAMIC Sat Nov 14 07:22:16 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
