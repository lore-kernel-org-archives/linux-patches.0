Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B343B283FEA
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 17:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768585492; cv=none; b=s1DHW0PlZmBxbxeDmLsaDtKeSDrsTUd/EBhnyqZOYR1Qx+jf/LMpNlIQe6qFLphr6cH2GLPvrI8D9eRlapWQpfUrOZTKo4D9phes2Uct2OySo0RChiSKP8CTroil9ia7VlYDlSrMZlKPRgU9jHg+upH0AMK2vMm2qgsfSmxvY9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768585492; c=relaxed/simple;
	bh=cO/xDdOLnZ2ZURY9MQdnl/SbJd0TRbRPwGLW7RChiwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bW8/G3aO3ySO2K6iLLf3Q2J8sU33B5YPhA9gv+tHU/oWqwRXq0hfsQg1clAkdPaFv08+5R671ES5u3K5QiMLSafchPmL2EKSmol5VYWlO4Q1/sXfMDIyrI6pcKF6qFckOOgjH9/SY3f1nmDu7CKrsjnWVl2CCNNMLhr2TyqY8oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=F827u3f9; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="F827u3f9"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 6BFD820B7165; Fri, 16 Jan 2026 09:44:51 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6BFD820B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1768585491;
	bh=cO/xDdOLnZ2ZURY9MQdnl/SbJd0TRbRPwGLW7RChiwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F827u3f9RV/74Y7/h8t0hz293bMjc1pNKteeDoud/+T8vAKVLIADxXDC4stsz2oNR
	 1fAOS1xEvGJYGmcciNMXt4u5Qz0Ek6kqTSOCQgMj4dEJTaiu1mfBdPdO/i9LctyBfX
	 QvB89CGtIG1VAh1mcZAZtURMd0g9+7thOpyy7JNs=
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
Subject: Re: [PATCH 6.1 00/72] 6.1.161-rc1 review
Date: Fri, 16 Jan 2026 09:44:47 -0800
Message-ID: <20260116174447.274063-1-hargar@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.1.161-rc1
on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
