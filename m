Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2E8298CB0
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 12:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750769464; cv=none; b=AcM/c1xY0KTBFvxiV9IpvKAKngXEBlJ+z4VliliIUoIFLeK0pmAgn+tVbX87roYgvoxX1fBYtrwSx83oPoJ2Fwg/qzUUGwdex6wzrk4ge/kp2wCjB6zQNRg6bYJd3DBjUPbueOhif+ufIsRIx1MN0fmwRrJ/jn1G7qwJuH8ei28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750769464; c=relaxed/simple;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MX3NXTmZZfSlYr6XcoHtLZIA0ugICJxHBVectyfxbd2UiYR8xeSrQkYdZz18G2QSQOrvlTZZUWKFGGeznWR9E/TfyWvizIeCj3EQnygezzkKyswlyegxJXH1Yid533voLvJX3k+hQfmlUkTsKV7za2FmQOR10/o22g1HDF8quYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=TTNLzfxA; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="TTNLzfxA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1750769453; x=1751374253; i=rwarsow@gmx.de;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=TTNLzfxAWPqVorOkmt7tbY+S4KrfvHqhZJo/wnb0c9e1XyORR7eEfls/D8IZD8SD
	 JB4a7QAcrPzHtRQvbVGlnEpNWiWHkCCr1IrtSe+7C0lEvsQQKp2TeGKo/ZHc6K3Gr
	 fFgjGu629Mov+rte6Qm352z5f9F9E6LiKkXBh6eSbAgpXO0ucahwXmcnLLF1dY01V
	 Pto+yGtvDTdLmf0QhQajNBF1ir4RwuJsZ/MyXgBuOWj27fgUJrDlnnTK+UZ/P6PlC
	 3W6IMCnkCt0y8KiCFfgF7dmUhqJoFw2pkKTbUt5xhVkqNFkC7RFkYG65OzfhcjUQm
	 HZgTdly39h2dvPUXkw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.35.16]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M72sJ-1uOF1O0oUJ-00GPtV; Tue, 24
 Jun 2025 14:50:53 +0200
Message-ID: <1dc07d84-b19e-440b-9a49-6a34cd73f3b5@gmx.de>
Date: Tue, 24 Jun 2025 14:50:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250624121449.136416081@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250624121449.136416081@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:YfHN219fMgd8XtyQpXiI4uiUFd0ajSFLmBBT5maCiSdGcNMm4K9
 jkeTGTIwZF9tL8cBIQheWL5UIqejgDlfs/UNxYTJz/nEKN6pcfolwk2gEY1fX3djZ+QzOmW
 DyO0yD9WqVTU39MLqxEk31awXAoXIdB0melyCHQ+Twyf5oXZ8TzExTQIi/S23QHd02Gdo0K
 KQ7xyNJF0ZkDgEziXiDEw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:gBy6ai+Js54=;RynbtzxjGkVdmOmIqJglyTXcoCz
 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

Hi Greg

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

