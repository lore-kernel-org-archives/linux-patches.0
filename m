Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C55FD283FDC
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 17:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768585750; cv=none; b=N9QzOOe4lgtZnn0ndVqB6lYBNdH8gWft4+GAecvbHtzi+d8suadbgZ4TEhKP0wRLo2TZJGaMgQbUIj+ZOCmf/EHhdfffBlJqIQZ6eHJlcGbBm2Fy9AjCxgT0FJfhPjci73mgcazbRrNWMqxN9O0d9773AShtgPEf4FD6oPoWfT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768585750; c=relaxed/simple;
	bh=E7T4z4b9y9SCIxQWSxl5atYYJrAu/uDb/fibor0jowc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqSnqYBkoBPIvq+Jpz0Oe6iNbpXxlKSOSqaTwdPWeqMPrfJ+xCT2otHSlvpUUvmzYCg8+tIciuWWzH+ZQlGTP11vGqa6J3BP5MEkhvQFSyCN0sW1UNiZgsy5kAQ0L2tKuz2kNARq3AktvvZZO2CjXVaXsK8QZHwlQ3Tm6eYg1A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Es4OUeiQ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Es4OUeiQ"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 7D7FC20B7165; Fri, 16 Jan 2026 09:49:09 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7D7FC20B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1768585749;
	bh=E7T4z4b9y9SCIxQWSxl5atYYJrAu/uDb/fibor0jowc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Es4OUeiQ3A+EQpK6yvdYuw5Cd/JLbplQSRz5MRIHO00rnG0eyd2HSTAnOkZ5erKNm
	 lggCoKA8O3JEXIPgr+9lAizmfWDHk7BzuuGzafAzh9BMW44I9Wx5XfqnhItQG33w8o
	 Dm8Ia6EileEv1ovBtjyancfxJ7n+HBTvlHIzmans=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
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
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: Re: [PATCH 6.12 000/119] 6.12.66-rc1 review
Date: Fri, 16 Jan 2026 09:48:59 -0800
Message-ID: <20260116174859.274262-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.12.66-rc1
on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
