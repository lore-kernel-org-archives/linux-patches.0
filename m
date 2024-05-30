Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820CC16F0C4;
	Thu, 30 May 2024 10:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717063360; cv=none; b=lShtGbLs8BiOLTYc9JWgxug5W/zKxbiEq4hefz8wGFRbJeyLDPwSFBg8noaS9zMCfYlFPuXVaaRQdCGqJXu4seX7mza2wdiHdkmH8PYUOKgiYGisio2PyWbqC+sRiFB27N8l1tl3IVHJAwZ+diXn7vBddEyGypw+fyWpMYEPhDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717063360; c=relaxed/simple;
	bh=DKCn8idYu1vHktXieRhr32FGpakQmNwEfEL37/FE5Dk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OA7Uyxt/S4k7MURqIv5t7MigALRMY4WYZ5i4QMuOMM5WoSHJW3D87jYhpw9IaqNPeoVCWw2u2bCRn0iTBfKKO2fgXmvX2qc1Q7p/BAFjxOrSDl8P74SR1CWtC1Zp/rBpTy3P9OgwneC43Hb3tTziLYtQSvjLZV20KJbjjco1spk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=ZjIUBXRA; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="ZjIUBXRA"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id CcaAsTmsExs4FCccHsAIlX; Thu, 30 May 2024 10:02:37 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id CccFs1R8RsT9BCccFs20sY; Thu, 30 May 2024 10:02:36 +0000
X-Authority-Analysis: v=2.4 cv=LIutQ4W9 c=1 sm=1 tr=0 ts=66584ebc
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=7eglLlv4HFOW3sTsDH6Jqg==:17
 a=IkcTkHD0fZMA:10 a=TpHVaj0NuXgA:10 a=wYkD_t78qR0A:10
 a=wEqYQv3dOdCw8QfXo94A:9 a=QEXdDO2ut3YA:10
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DKCn8idYu1vHktXieRhr32FGpakQmNwEfEL37/FE5Dk=; b=ZjIUBXRAbxd7YuFLrFymQGWgFR
	sCftGX6RPmhqmQ802FhA/OqnkVQ3j5onKBoXDVrjjGoiokYc+NInfGOOrfnG347/h/5+2qvh+ZnKO
	2uYPFMtx1Hcr084hltyAFuCh0A9EociAjt/XPJKozBnCmUajGHTq7LgHG+E4OMxOR1ohv4xUA4xK4
	sITPubykCzD9qfb3dEC5NjZdimmJ5hT7VOkoIAbb8jJKsnMoSx8Cnw4GCntCERzrIWcevOvKTcRqx
	C9pgrXqs/XO1tKj2y6m1YWkoqDFpkI6+EjDXd64BD2uoPZDxG6400uH5ObK+iFHgy4il8V/0iL8Kc
	Aei7+frA==;
Received: from d58c58c2.rev.dansknet.dk ([213.140.88.194]:38378 helo=[10.0.0.182])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1sCbMg-000tFs-1A;
	Thu, 30 May 2024 03:42:27 -0500
Message-ID: <0899cab2-2772-4001-98de-9bd2306442f2@embeddedor.com>
Date: Thu, 30 May 2024 10:42:15 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tty: mxser: Remove __counted_by from mxser_board.ports[]
To: Jiri Slaby <jirislaby@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 linux-serial@vger.kernel.org, imx@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
References: <20240529-drop-counted-by-ports-mxser-board-v1-1-0ab217f4da6d@kernel.org>
 <d7c19866-6883-4f98-b178-a5ccf8726895@kernel.org>
 <2024053008-sadly-skydiver-92be@gregkh>
 <09445a96-4f86-4d34-9984-4769bd6f4bc1@embeddedor.com>
 <68293959-9141-4184-a436-ea67efa9aa7c@kernel.org>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <68293959-9141-4184-a436-ea67efa9aa7c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 213.140.88.194
X-Source-L: No
X-Exim-ID: 1sCbMg-000tFs-1A
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: d58c58c2.rev.dansknet.dk ([10.0.0.182]) [213.140.88.194]:38378
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 0
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKmCc+WbVafpLzhO14UxOGGWZ/EgLlFC87aZzFJE5RilR88R+pyZYz1O0IUNFdXRp+DoIE3sLp6ARN+U9qVC64twzm+DThmst0u2BxUwnZwqX1b5NSVo
 lmQ79RywrjzLwGuosJYWe6Zcfku+U8O7X1oBMaMscp9G2PRLPcCwmBRHSb+OHmftegZDiasva/iSDnxtJhFQtElRCQs+PQHld0PCJE9g9JGNFdKpQKwiJWXz
 krzteEhZqP7nEhIGKDDkkxrzJPuJYaBp1Cepn0VgXE4=


> Ah, ok. The assumption is sentinel.data[] shall be unused.

This snippet is useful information.

Thanks
--
Gustavo
