Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4418A156968
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 21:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736284830; cv=none; b=oyjCol5nVWmrnvPw0NOoTvDYDVC3K6kd39qx/Crz24XAFiKgVsaHBESNeO2LE3wGcCTw6+DXyv4wy0ROcZmpyW6NxAnch0F8YzWnjeyiOi6EEj2LTJWhtexLaquxo6ZQVac3jZ87YdX/E+ybUlCxDC425h5ySBIHCIsYRWEbYsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736284830; c=relaxed/simple;
	bh=1dTVd6GY9tbaGou0YNoqBWWSdQLUbeLAanhp5tdtMko=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=hEedtom7xKcFVOkArwdD6pw3AvpF4MOZ1SFJ9131Tbc6l68149ebEguKVhOq95LJomkd2R5HVN079ZzQd5HXHAi620JNEKhk34z+s3AXnU8zTmLCZGtRqSOoaxAMYTHODQF00pIbPuGV9RA2TrzIkumKtl63R3VlAC78CKdj7g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=VyKYA62O; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="VyKYA62O"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id BAD1D206ADF6; Tue,  7 Jan 2025 13:20:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BAD1D206ADF6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1736284828;
	bh=1dTVd6GY9tbaGou0YNoqBWWSdQLUbeLAanhp5tdtMko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyKYA62OvYAKBpSTZjg3uobarfDFhZbBc3a0l6slrKTuHztCTo04ALzcw3O3yI0+q
	 BEb2Chs0K1WEcaUcOISi0B82QauytOYWTZvUEws+BkdO3mhqbN6A8nK0vbvaSfLQzL
	 H42sIKEvfceygxTFQB13YDGtI4b1PW3lZbOQ+E2s=
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
Subject: Re: [PATCH 6.6] 6.6.70-rc1 review
Date: Tue,  7 Jan 2025 13:20:28 -0800
Message-Id: <1736284828-7395-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, amd kselftest tool builds fine for v6.6.70-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
