Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF11A47F53
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 02:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730167376; cv=none; b=Ej0DJ75ij3tMg1FztV3oFH3oHp/BUvix6/2hG0/TN7AB1HATlRTk6A/bYk+17MDVWIN7jmyxYJfIngZVnJbpL/1ByjH8PeTQjtf30M7pBX1c+fE/BMbDT1EmKhV0QYkd5EjNC5ndLhPI9YVYHSbGE+JQkLKDUomcMcK6d9DHO2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730167376; c=relaxed/simple;
	bh=H5yKHa85K/kN38MCbIEu0HaXLqb/id9+omWJt6O4sx0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=nMo8v4XlHlfYcRlurvjBXxZPu0QCWnVpr2MmrNOlb/T9Zn03/jTbCCqr5x0J/TFMIBR6mxTO1cx37v4alXrzlScacnzkG+kJmbVM/FODWX2BVbVShFTy+T4eOgJOdjwOfHJvHS+9dv8y4ppYaLoO+hEeiE/keoR8M6OukkmFFRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=SO7hRXFU; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="SO7hRXFU"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 871B0211F60A; Mon, 28 Oct 2024 19:02:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 871B0211F60A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1730167374;
	bh=H5yKHa85K/kN38MCbIEu0HaXLqb/id9+omWJt6O4sx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SO7hRXFUATO4MXJ7fYXg2q7IHCONT3u5+UPbNgy6hMXd3yAvAnW6av7/lJ2qrIJ49
	 47A/7H4KmeVXRw7i3GUfBKChs/x3iOXGRJlAkhIYuyANWQEypwIbqKUKYoy9uppaf7
	 bTlNMKHFrfmqNYQ/+puBHQlFVoH+9v+oGAtPlKew=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	allen.lkml@gmail.com,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
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
Subject: Re: [PATCH 6.6] 6.6.59-rc1 review
Date: Mon, 28 Oct 2024 19:02:54 -0700
Message-Id: <1730167374-10012-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
