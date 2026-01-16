Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB3B7340DB0
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 17:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768585906; cv=none; b=PNiIG/VhRwsboe5uMLcPUn4DA6g6ExSDBomYNlnHI5HrsvvL0KHlDj/Dyj2nWD0Z4K2taYhwF231k3Eaf8u7pG1RzDezuSZAJ1IfajWzNqbCVLbtd99N/H+kaWq+is5RchU5fAr60x52ld8qxlo3/E21gSH5/M+LGhRHB4fEZkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768585906; c=relaxed/simple;
	bh=oUz+jh8+132BplwUywcHqPDLCJPoaYciDn6dcE6G/6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SU++vx761+Hydlg6hqhiFzRdwl3r8kr5UW/TeXnzSzyTLtmAQsBnODYYPCZH1Jm4ZRdfYcrOlmwcphLT+/heB3UTyAxAVS+cfCsSwgC3qVd1AMdjYM95YzW63XXYRg0Vs+T1IAukqom412Mpk9TqXt+VdesfSubZltxOWS1j6QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=fihGvk90; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="fihGvk90"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 508E420B7165; Fri, 16 Jan 2026 09:51:45 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 508E420B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1768585905;
	bh=oUz+jh8+132BplwUywcHqPDLCJPoaYciDn6dcE6G/6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fihGvk90IEpHzhofXRpDYETRsl1ldm5JEL4etx4D3/+LJ+sNLfFJKAgLdj4lA8Yw2
	 OKu/9xxl6gejQgl43u6n3iGd2oZbYwNmVjtH6N3hrR6jRKjFp47rveh+zmeHb2wKtU
	 VgXMqCdtDJR3U+Cn6sHhAAdlSyumSB0xbUcer5EA=
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
Subject: Re: [PATCH 6.18 000/181] 6.18.6-rc1 review
Date: Fri, 16 Jan 2026 09:51:43 -0800
Message-ID: <20260116175143.274400-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.18.6-rc1
on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
