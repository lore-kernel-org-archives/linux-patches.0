Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD87B1F3BBC
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 18:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739989830; cv=none; b=uC+7p96h1kStMHlrRxi2fOfRbLs/2H9zm+1Tx90Msa+yrkvDB6vbdG519ZB5h5H+NX2r4YTaenmG2WNjqrCwgQpHqMsTqaj8T7+W0R/FECvzvYh20q1eqwFozZQvBgwp28EO+hI+eBJckJtzxZ7BMoPE2mW8kXdUzsvU2isrPDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739989830; c=relaxed/simple;
	bh=j1ntND9PrFNOvloFr8cDlUOsjbJyryBotMMe+6Y6iz8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=BcYaxBRxAqqkH2m+Y2iMRCeBHAdS2/ZFhA5eg4ZXa5CaFgcFWi+5tIQO3GZwTnTaMxrlW1aoyru/8LrNHjeimran+Idj+FxIKIBa9N317fjozwNfWHrvPPoAW2WqeiRZYZKYllT3ZM3AbxW12OqaT3uW4mAMW1Qy9CwL8PXLJm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=bwS7FOCO; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="bwS7FOCO"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 583572043E1A; Wed, 19 Feb 2025 10:30:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 583572043E1A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739989828;
	bh=ZW/ZlAeKhSCAFq87BjuBtxIkkXoyBSxc5bnS4caWS74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bwS7FOCOV3SbKAH6tGFB/Zr0sPd94AV2wqwFjiT118MJGy/9JkfwmYRgcut2LQ1UL
	 /mEsIedNvb+eubiiZYi+0lSa6MNS5iCDGUmxNulIlONKJl4VSirsZ9l8g2u6V427Ga
	 kbyUOY6pPEr8/CCgAw/Y/VGjof3v9LY2EZGwqXXc=
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
Subject: Re: [PATCH 6.1] 6.1.129-rc1 review
Date: Wed, 19 Feb 2025 10:30:28 -0800
Message-Id: <1739989828-11367-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and kselftest builds fine for v6.1.129-rc1 on x86 Azure VM.

perf build fails with the following error:
CC      util/trace-event-parse.o
util/namespaces.c: In function 'nsinfo__set_in_pidns':
util/namespaces.c:247:9: error: implicit declaration of function 'RC_CHK_ACCESS' [-Werror=implicit-function-declaration]
  247 |         RC_CHK_ACCESS(nsi)->in_pidns = true;
      |         ^~~~~~~~~~~~~
util/namespaces.c:247:27: error: invalid type argument of '->' (have 'int')
  247 |         RC_CHK_ACCESS(nsi)->in_pidns = true;
      |                           ^~
cc1: all warnings being treated as errors
make[5]: *** [/home/hgarg2/upstream-kernel/linux-stable-rc/tools/build/Makefile.build:97: util/namespaces.o] Error 1
make[5]: *** Waiting for unfinished jobs....
  CC      tests/unit_number__scnprintf.o


Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
