Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889F229A30A
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 21:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760737491; cv=none; b=h9Oubyn01fFeWRmw7/RBu8FJsMycxi/ftmIDw/1sIHqwPcvvRc19OKDmU+oNhaFITjaX+GuthkLSZ2+CS26t6f9gelYQCBW/cJnh8pVa71yEHlHjc8WLM+SaVvmg38hW4wWMIw5hxkFKJrLHkllSzwx224VDZJx0z6cBLfLrf1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760737491; c=relaxed/simple;
	bh=VXPlbpPcLu681gXIL+8sVsGbwrlDtaQn5lbTGo96eSY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=e52Av/QqdRcZYjMTjwSvCyqVELSZ9osOdlfLrmUxGSWDfpSjPg/FvbOlndIU6GZzBYEA4gvIfuGG4yuBJSAupSpMe+zY0QOpb/G3rzKRF2bJHs2xtR8y9/RXSU+m0Cr71DZCV//QqlZvpxCqpI9+z/MbU/cRgUnDi32lJR1i130=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=fmy0fc0y; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="fmy0fc0y"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 4A69A201726E; Fri, 17 Oct 2025 14:44:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4A69A201726E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1760737490;
	bh=VXPlbpPcLu681gXIL+8sVsGbwrlDtaQn5lbTGo96eSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmy0fc0y+IuhUt6yKSCye4v8J+9EwOOy0H0JxhXjr8RNNGcuEXr9jxipfe7qviZU6
	 eWzNVxUX6DJ34P+BhgGySx8wfXdYsPKObeflaxVj8vMqq05v1GrLMwLlE/FJaEU1fy
	 3kueCHPvbfUNAQUE46oEQ64mRGX7qM1t4m+w38ls=
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
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.6 000/201] 6.6.113-rc1 review
Date: Fri, 17 Oct 2025 14:44:50 -0700
Message-Id: <1760737490-28442-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.6.113-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
