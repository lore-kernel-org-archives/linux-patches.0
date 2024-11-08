Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB85A1D043C
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 07:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731049782; cv=none; b=jduTtdvlgYXIxDzjEU3roPOLu4XqXW13Jp/7CIwwLzQidhZ+k3Fp5Q9kPilrYJDXd9hOEHFtlaoX+q2J6MnHLVlXYkervaMvBLlio1SMYB+rVbRv4VUT5hRX8OBBbTKQiEe4FLe9Zj7W/9FRgWZ84QJ10CiGcys/uqnmr5rGVj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731049782; c=relaxed/simple;
	bh=H5yKHa85K/kN38MCbIEu0HaXLqb/id9+omWJt6O4sx0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=r4e3iQ4FQjMbOD4vLW4tu/ZAKsncA0y6/DjvUoWWBuvqmQorBVzsrl0oji4BPIv7GmfjEuVOOJ6V8Owy/S9DZZmBNHYq7kdA5YRbHDZJ0K3/JQYa/s4bnhJgE6QR6f4jd+P+CT/wh+nEvYj155LIkGCdOBnmWyQweGf3wiNiVQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ReunkYjQ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ReunkYjQ"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 68B80212D51F; Thu,  7 Nov 2024 23:09:41 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 68B80212D51F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1731049781;
	bh=H5yKHa85K/kN38MCbIEu0HaXLqb/id9+omWJt6O4sx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ReunkYjQcYNrNRriUBMcVxEvKUPouEflPelIyG6WkDlK5uDzlZPzZCod1nBt1Oz+C
	 JwE/8y9a8/yUPqMUNZZChVcIVy9ezF+MrwPV3tbzsKrkaSCFEQL9l+PU54JDNLpeRS
	 lmPq2NYcp4Me8FQPghv43lJgbYc01eioEPOqKqgk=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hagar@microsoft.com,
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
Subject: Re: [PATCH 6.6] 6.6.60-rc1 review
Date: Thu,  7 Nov 2024 23:09:41 -0800
Message-Id: <1731049781-19185-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
