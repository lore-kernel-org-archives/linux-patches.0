Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF0321FF35
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 20:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748982408; cv=none; b=Pk3z4g2isKRKwm0LqkG4G0RrwodUaHd+sUSrXVnV/VWJJGhjixgOzJuqMs3BouKV/WJQ+HlKI5Qkw7Oqaw2vH0XbG/AGYqR1hP09kFcWGt73GHX+1+5Vmy5AMuhNbtCP5Eftf8kaAkdcxV7lSAUyzqxXM1BwYgtuetqP313SKHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748982408; c=relaxed/simple;
	bh=R9z1IlSni6rCY6oWmdrHGktLe/B8lhC9VM9i5V+1QTo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=lkQIYu1mI26enw9s5OCugwNOg/PRBKYcIBYfC3pQ2wMOhuz8siljyU5331YXyAKNstI2Uz/wxKsXhxyrlws1yxUgTWE+6YaKuXkitz2Xd0FUqxXyRmnYRg7jv/C9BzF8Eg/CItBtDyegzO5L55O8vo5pTFAarBfATfRovqBvqXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Ed8DN34o; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Ed8DN34o"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 91A0D207861B; Tue,  3 Jun 2025 13:26:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 91A0D207861B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1748982406;
	bh=IfitNqzs7m57IFAsJSygbJfWzzlKa7wwPBN0IJBjni4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ed8DN34oTUJVf1zlpSd/uIXrPwARmgWHTMyLzrlP6KN1n33uhudehO7mpKSVEleZu
	 /QJ0gBUuTkWFcqptiQWgRZhgb1pAlQ5QgRug2mpMhw3RrF86fnwWjU3O9Ck+TuBsjI
	 aYTxCk1vqSEKVph8MRLqcVvz6G77e45OhmjZMJwc=
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
Subject: Re: [PATCH 6.1 000/325] 6.1.141-rc1 review
Date: Tue,  3 Jun 2025 13:26:46 -0700
Message-Id: <1748982406-5679-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.1.141-rc1 on x86 and arm64 Azure VM.

Kernel binary size for x86 build:
text      data      bss      dec       hex      filename
25847143  11304250  16613376 53764769  33462a1  vmlinux

Kernel binary size for arm64 build:
text      data      bss      dec       hex      filename
31273699  12549552  831088   44654339  2a95f03  vmlinux


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
