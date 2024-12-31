Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48BAE1B0401
	for <patches@lists.linux.dev>; Tue, 31 Dec 2024 22:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684514; cv=none; b=iQsMwapR6PCkoQqvDOouih0LInABZdglr1MMigQ9bDNKwTHwe/OcCly0UhesMi3nZCbw/Qe9xFZ2yBiaPFaz1ttYrkLK+B1UtDwW6zwPpDr+Cx8Ex/U9zkYO1V0X4W3LwEEQI78oRHXQA6XrgrpjKBsuFhtfbNR3CyVjP8AkkSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684514; c=relaxed/simple;
	bh=Ohhj+4JzrDvuTw7oSSDYmpkPb4IAA8P49UYGQ3/WGug=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=EIQL65MJ9LQieuOW6F2QwR41w+kc0urZGb5NXPVLuU3Stm17gXs/BOqyhPDPi7IvYyf7jczRWw7RS/PiRqi8mNDuCko9d3w6HEaHwlgCsZZ658uivT4Z/O2A5U7chUYLGSe8BXyp844qCiSyc8hzYq47Wctc7ohQpxaCwiTR8hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=KVT154yA; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="KVT154yA"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id C9CC12046769; Tue, 31 Dec 2024 14:35:06 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C9CC12046769
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1735684506;
	bh=Ohhj+4JzrDvuTw7oSSDYmpkPb4IAA8P49UYGQ3/WGug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVT154yA/Bb/Q4twXK+CX+/jHDsKETjpO7SzQfB0BXNhzVP+TUPJNCOsoH3Ou8cL0
	 Ptdek8DfJB8J6kiZEmrNCdCafjS+Vf00Rx2YYLIauqIX0+GyVyI+ZUMtUlcGP4oYIL
	 BdBRex4w6UgHH5c7cz/dubls7geJk9MORgaqXSxA=
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
Subject: Re: [PATCH 6.6] 6.6.69-rc1 review
Date: Tue, 31 Dec 2024 14:35:06 -0800
Message-Id: <1735684506-20456-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, amd kselftest tool builds fine for v6.6.69-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
