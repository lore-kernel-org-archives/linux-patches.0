Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E621C16
	for <patches@lists.linux.dev>; Fri, 17 Nov 2023 01:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="b0vbF4T+";
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="hHJp1NCA"
Received: by nautica.notk.org (Postfix, from userid 108)
	id 97AC7C01F; Fri, 17 Nov 2023 02:58:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1700186298; bh=ZYscM4K0i/DYI5C23FGVV4gaI0ztfSb6cyBVRQzYaS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b0vbF4T+9DwQaW07UIf4vZ1UPVdXes9nrizOowKk5pPOPGmndhe3Em+wsHTp+S2ZB
	 8Tr375keRF2qhsMSYln6cJGtMPzkExbxKNMGFBCxyP5touwoP9kCzy7FRM7f8RSvit
	 Sl20GTCxVU+GyI9P+TAVscyw9z8TVtBrdnv0dPmF418/GoCZMuXP37Qc8Ec8raEW/3
	 BMgcxqB+rlwbnFF/PHqNvGSEOAJCW5pk6zTNH37OqN5hYOL7jsWz04bPdq1SAZSR7V
	 raSpZsOZAFfrRILAY9/tTudwEUi5pGdIRWCFVSs4kFwiazANy79wNRbm+xuz7SQnLV
	 9aUmRnnrMifxQ==
X-Spam-Level: 
Received: from gaia (localhost [127.0.0.1])
	by nautica.notk.org (Postfix) with ESMTPS id E6D2DC009;
	Fri, 17 Nov 2023 02:58:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1700186297; bh=ZYscM4K0i/DYI5C23FGVV4gaI0ztfSb6cyBVRQzYaS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hHJp1NCACRehTXtGwyeWEpT0j/m0XCqcQyMqRYbYe/VtxyoAvgunHqaozr3NVc1VS
	 n5wYhOuLl9OnMABEXBXhz5/ij45cWlENqSvaOGt2y0zY/SMH6K/KeX9IqyzhjHTz5X
	 cbUmNiiG1sGyU3baCKs3+oxXOU6RVqdFV/zdIfOS6M35++/ISPPerXCJ5xmFApGUZ3
	 UR8Opi1b3lXMLa4M8GWZO+oPoDiTChiwvw4CBzx4K5VGf3D88iZ3GU/r5lO6lR/l0Y
	 hooSgKfsvq6MaNmEVdF3g2QbZ6xFakI/WImmBStjR8nsIw5yJuSehwJyf0VEZQfXJW
	 EcW0dFsdAtuzw==
Received: from localhost (gaia [local])
	by gaia (OpenSMTPD) with ESMTPA id 3930b9f6;
	Fri, 17 Nov 2023 01:58:09 +0000 (UTC)
Date: Fri, 17 Nov 2023 10:57:54 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 000/191] 5.10.201-rc1 review
Message-ID: <ZVbIoqXjfn7V1NtT@codewreck.org>
References: <20231115204644.490636297@linuxfoundation.org>
 <b5367845-8d70-4fcf-861a-ff9b8849c9c9@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b5367845-8d70-4fcf-861a-ff9b8849c9c9@roeck-us.net>

Guenter Roeck wrote on Thu, Nov 16, 2023 at 05:13:39PM -0800:
> Failed builds:
> 	arm:allmodconfig
> 	arm64:allmodconfig
> 	i386:tools/perf
> 	x86_64:tools/perf

> This is with v5.10.200-192-g550b7e1fee20. I am a bit puzzled why others
> don't seem to see those problems.

The perf problem was reported by Florian Fainelli, but my current test
build does not include userspace tools as we're not shipping them (and
would rely on $distro packages when I need perf as a user rather than
building it).

Likewise, it looks like neither Linaro nor me build the qcom driver...
I'm building kernels that have been trimmed down for our boards (with
that exact config we're shipping and providing for our customers), and
arm* drivers are especially fractured so it's a bit misleading to see
"arm64 pass", that's just the tip of the actual setup tested.


(Anyway, the main reason for me is mostly that $job is a small company
that cannot afford extensive upstream testing, so I just don't have the
time to do extended tests -- for the same reason we're only supporting
the 5.10 tree so I'm focusing my limited time on just this branch, even
if I'd love to do more.
I'm just taking the stance that some test is better than no test and
report back things we'd need to test before shipping customers a few
weeks later anyway -- thank you for covering more!)

-- 
Dominique Martinet | Asmadeus
