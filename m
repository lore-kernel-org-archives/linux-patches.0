Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC39B81724
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 08:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738397772; cv=none; b=AtQ30vkCDWw5EnPMfNhPDLDuxDjFraohT/zIWXBzwaym3x1yvDgnaYv/lW12AG//X4ktigXY8PvQ5Kkk0/Jc+usCLa6jMD6qzpL0YSGL5yntB7SjEz0RmqUB9BnVkhozfl0jEETwFzfTVQ9t853TF6sAd6g1/evYuNlH4HuegQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738397772; c=relaxed/simple;
	bh=/VC/a+P6iCP2pEIsW9gY3qE7RSxAWZO7XlMdDqa8eYM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=Cjt1zMm5//0EBYjvv1zCyUretTvlPunfrGBRI6CFt9owAQVsr7uhIeC1iQj0OKZWy/RmOJp/Av4IhyTG6Exau4neNAPEJxvpGViF/NrQmuXQJPKuLXOfmyxYPoi2YZS0fjQDq1ITt0XBJb+aMVbOMG0GAitT/qvJk86aY2jaXnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=dkEgSx4L; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="dkEgSx4L"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 88A2A210C333; Sat,  1 Feb 2025 00:16:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 88A2A210C333
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1738397768;
	bh=/VC/a+P6iCP2pEIsW9gY3qE7RSxAWZO7XlMdDqa8eYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkEgSx4Lq6y5BW1v/A3BAXlAVQQ/tymp3MioQ47HZLjnW5+Y5G80M4qgf236iKDWw
	 +efsK6QQYp4a/39CI1EcGayDkkEwo/6oAn+ZpaYrePxYhbsbyXrpvy7PWBMY0Xu1zf
	 n2YEmUR/A38ntPTkZgYZ0C1VvF9p8a02Jpcyhoyc=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.6] 6.6.75-rc1 review
Date: Sat,  1 Feb 2025 00:16:08 -0800
Message-Id: <1738397768-7556-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.6.75-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
