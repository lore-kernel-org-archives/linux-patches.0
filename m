Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A40E72F6562
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 19:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769716042; cv=none; b=lbPSJsYBa0f7LBmNXyYGq/Hm+ejV8cmKKx+k0AFPZ+10o5ldNfVFeDovfb/wvZ/06oF1ajo3Lqs0Mp9b1A250e+iZ887pbv/+uX4fZkfKpRNXbybZgRUdhLNeqXq1nM+9InizyRLMdGLrsyJ8IUvucMw/vEegWXL4hZa9mO3eqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769716042; c=relaxed/simple;
	bh=RovrNQTRDU6eSb9P10JH8/7pv6QP8zpAwNfmtjqKXGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zxaoz6y7QZ46eSqdL09p7UfWp2eE7Nib+Cgniv8k8bhJd2cJtgd7D4HExJ37dCk7+wrFZJf+2TbU7LuaEahP3kk5VWlcVu/8obAk/QIsLuH0o+EdgiMSigYK0IMuvyPEvD20MFWLBHKR0eKiN6B2VuMsr68yjNqWJ8Q2Rz7X6dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=RppKrCTd; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="RppKrCTd"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 8748F20B7167; Thu, 29 Jan 2026 11:47:21 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8748F20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1769716041;
	bh=RovrNQTRDU6eSb9P10JH8/7pv6QP8zpAwNfmtjqKXGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RppKrCTd5ZNEX4+H/wpuwfR9Xdwew0uxTpxm5nwVhFlJWxha/NAhuUA7Lp1fOB1Y1
	 X25aGvBJ7MDiSTpzb6ZioFBB0p4/sTCmwV7gclDXmCA/6+7WsOpnyOGDGGryxbKHGD
	 hEki0IqPyral6sQpAOcAgEfBMHFUXnPFX+40nwlg=
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
Subject: Re: [PATCH 6.12 000/169] 6.12.68-rc1 review
Date: Thu, 29 Jan 2026 11:47:04 -0800
Message-ID: <20260129194704.582606-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for
v6.12.68-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
