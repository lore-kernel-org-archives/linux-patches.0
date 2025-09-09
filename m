Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FECE22CBC6
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 17:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757439821; cv=none; b=FF34GfsnYKhrU9YU7QPrMcDNIt8q2fG0792j1rZ0O6zR6TCA0i82HO8n2FnZ4vepxK/orhIqpl+RuiIYAzs2OqrVhnJCKEBjx4QYkQjLeDoGN9XExZs3EVg5HiImHs6ahZ9j6KeHEHKFznq6zh1n0jfG8xK8/ls1cG41wea/F10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757439821; c=relaxed/simple;
	bh=APqVb+9/qOszoLpvaATKLITA8676lX032ZJdclRb1DQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=jHO4QxJl5JBkEqk513/d3MSH4rKtuu2hlvtaK5e/DiMuaoZfCIqHZcoe/FEAqJCA6QUBX/4e7qDuiaCo47mjORiNSvLyD4aGcW5hj8PtnOJVTRx2srQVDiNLPUS9vQec2BXeHMySHMcskc1ZeoySrwLvtsAOJPkvhJbmg63xzjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=RKJOSwdL; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="RKJOSwdL"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 47824211AA11; Tue,  9 Sep 2025 10:43:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 47824211AA11
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1757439820;
	bh=APqVb+9/qOszoLpvaATKLITA8676lX032ZJdclRb1DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKJOSwdLdceiVYDXEoSjSy7bwxzko5T0Bnfj8S4RGjAwqiBJZRg/E35Yr8GqIQHTm
	 FvxMFZJgnUSg5stqSHiFx61i6BwtK5EjrEQZfLu/NjD40gIJ+OBvRVY1H7uuvwxfzh
	 2wj9hwKRXbVE6wALgxl+b0i5VBtKSJVaElhXCK18=
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
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.12 000/175] 6.12.46-rc1 review
Date: Tue,  9 Sep 2025 10:43:40 -0700
Message-Id: <1757439820-16783-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.12.46-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
