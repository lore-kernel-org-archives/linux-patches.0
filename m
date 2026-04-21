Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309E3362156
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 16:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776790049; cv=none; b=PezS3CNvZpymk3s69xjql8rUde4BwOpzeYIpb8m8zb6bwf/GBOBrs4hrQoZ8tUS8Bb7L689GTCL/0YqCodDMOv2oPJIFy8C85/KGvDeO3Afxiu42wGa85aCTU2xkeOwaytu63GZ/7QkDdiY0/cMfDAN1Nn+3NQu7Jn+WdiZGgYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776790049; c=relaxed/simple;
	bh=jbTcbnwcv6C/KtX2jxldMnJqhsn56C8Z+WJw2C1s9ZA=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=DrZxQ0QWbQ54f+ba46xqg4NYxV7D3b1hLkgJD9bv28Oc1f5v8yvyAftOQSVtqdM9zAacWZys2OrptkqDPkgO+An8dGIUFsuRwSdzgR7ETpHiNlWfpgpc/Ag7ztpJva2Ka14A9ZxC7xyzbATNvKAcLKqUeuBTQLuBNSTzNlwszE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=am7skxfw; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="am7skxfw"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488b0046078so41255465e9.1
        for <patches@lists.linux.dev>; Tue, 21 Apr 2026 09:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776790046; x=1777394846; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jbTcbnwcv6C/KtX2jxldMnJqhsn56C8Z+WJw2C1s9ZA=;
        b=am7skxfwfC6/chvL9YABJkFlNcMRL7Sv9KDz7m4bLzmEmxZZei4ti8zuQ9rNLUPsHq
         VEULwn2fPf5/shUgzpqcBFDYcASY5BJVhrHl2gVgc0MVMV1gFp/6rt293U9qUrC8oTfB
         ERt7mNck0NQ6gwxXxGCmxDP6petwKLo2FMRYmdLCOlAIIyeTaR9ZoRkbxDR1QnNaZMXt
         doM6Xh7+rrYkF6aEdsK2w1xb9grZhBq3gw8OXsvYrbF21DRBkLzcoiNeYCm/u70P5zLq
         2I7s4iB/3Cns/CCtIxJB3+AoVBOMmhKYqKrHGuhHR3vhYxvoUB/dFpJwe7Z6g9lSszWn
         ufoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776790046; x=1777394846;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jbTcbnwcv6C/KtX2jxldMnJqhsn56C8Z+WJw2C1s9ZA=;
        b=qJRwwi1kOU7MYgWuhOJ1QRywHre/iJj5TYMIE/6qVMtn64HtVx1icMB6ZY+uzNazAC
         uEH1/OljzUvALv6ra5fEP6kg1mTDSFxC+DLwBxKdtZy4LigRvydpBgxssm8hNkxlbV1z
         GUnP+pRmO1vg1Wyua3Hlv/6Tn8EmcqZwSbfPR0tyn0IHwdJuOzwuM9Y+J+U0v1dl7FwS
         KVHKFrpcaROyE9/fncwVO7DqnHYsIXTf+VSCwamAq4EB95bkOhINi3o345PvKz5AkwTF
         TCsA5tTgPhzRNGf3mrVMRT/PbHGYLSKEP139yrGzXx1APtKRvm5gGZwFDD/C0R79QC7X
         tGfA==
X-Forwarded-Encrypted: i=1; AFNElJ9LWxzTmBLdrql+BZU1S8T2C7NPK6jGXEO+1woUeoEc6y4u29mQ+kYJ96Ne4P1RDHcM6GHNZek+@lists.linux.dev
X-Gm-Message-State: AOJu0YwQB8SgXue4cmUVIRQg6kYdbAjiXPJGfczSKvL3bfr1OQ9MU2Um
	SfC27Egjfq8V9U3rjRifUjgmVvJpnIxwPRRRsL1IPydi2h2F2JTG4lri
X-Gm-Gg: AeBDieuvareUr9fXYthwi0vexGPD159SWDouCqGgqeFRv56+dwkzeMmmmDUa75Sxuik
	6TNPbWLKXMMnZg7m2t2JPosw61zG3/SNDC4qrhGgVpPc9WN5N/JS46iccwXWeonP8mfDXGVdXlU
	RaHDagWSynUqUmHD4pm39asuS4Nx8BlM/1v4i5FTtS86sP9wXNnV9yF1r8rk2VqriCIuK9L/QUX
	tiLmd5BEKscGqZCPdV/WxQRLOStd1OWjaWA/vvaajm1VAT8IDGpoKEJ+fzSUcONMbqKDIocreRF
	mCnEAgmRqT9q7VgOa1MXv/iWPvrGjc726y0n7yoJBinKZ7On0txO2CtJNyP7+QYp+wdgqBUXJQz
	d7IKkEXdcyMoVVNxwHNRp9ouVFOvuiWbKmvnrch1W4vCxakmns0nC7ET1CtxGx00W5lXBhfexmc
	3oVc6H7Nv0EoVxocfXMIhHYBogFF42KZzj32qymrk+fcvdjEg=
X-Received: by 2002:a05:600c:1f94:b0:489:1c2d:211e with SMTP id 5b1f17b1804b1-4891c2d2213mr130924665e9.5.1776790046173;
        Tue, 21 Apr 2026 09:47:26 -0700 (PDT)
Received: from ehlo.thunderbird.net ([2a00:23ee:1cd8:1171:2646:73c1:cff8:b7c1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb7a06f3sm138096905e9.22.2026.04.21.09.47.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 09:47:25 -0700 (PDT)
Date: Tue, 21 Apr 2026 17:47:25 +0100
From: Josh Law <joshlaw48@gmail.com>
To: gregkh@linuxfoundation.org
CC: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
 jonathanh@nvidia.com, linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
 stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org
Subject: Re: [PATCH 7.0 00/76] 7.0.1-rc1 review
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
Message-ID: <68FC4979-9D28-4F62-9839-1B9C9A7CFA9F@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

Tested on Geobook 1E, no issues, lib/ tests pass

Tested-by: Josh Law <joshlaw48@gmail.com>
