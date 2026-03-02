Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2B533557D
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 10:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772448134; cv=none; b=BkK/CxpcPRSdpESjkAVRYr+K8oSdyvShd1GugUbjgL9aD4Hn5Ch/E/p7AihJUtnyxVvA+jTvy85PhZvfAhnQvXc8/D1sFQROTq3vuU85gLN9EAHf7cIJSPV0DHlmz2GTjBJ+fCbwkEhSD/D9yXM5fKQV62qK8OsNZtcDpe3CHq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772448134; c=relaxed/simple;
	bh=bOrJ4Ju+8XEOJCR7kEWs3PuhJEx2x1iS5H7K9GVOLWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kGhS4XhwL5+N1g1IraFEAzYlWWtLrt5On5TfXykqt6WGmYHGoY/bnkwlGsH5uslbCyANxcu8cjqEAy7O9AxaaAtveE/28ovisqS+pAY1L60NSs8rKP6MoeFOTYfvYmCE3cn2xEU9BMlxlpI98iqI7w3C2EDeCBNGqDlAdmiP4uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=HRoncpi3; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="HRoncpi3"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id 222361FB1F;
	Mon,  2 Mar 2026 11:42:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1772448129;
	bh=EHXWvkzks+R1ouW0lRjm9BUXydRiyos5Dz9+DZjQL2Q=; h=From:To:Subject;
	b=HRoncpi3/oDlFUOXwAgKz6HX1wPlLvNB0ccKciHZ759beF+iHDAL6GaN6HCb4dzx5
	 RNjj/P25ed+QUJO4rx4cqYWu2sWoDPlId0mhh+m3VWHQOrW76jpg2Tez6P121EeI/P
	 t/YRVrY3rwHCvoxdryw20wQue0YhwTo2+lOHx1GkluTBgQezjy/3DpW+J4WuB7gqnL
	 xU4Umgm2mpWckKayoWTLhfepmTF5IAWkamTKJyRs4ld4o8VcudLbktpBmeajU9wxMj
	 x1h+dk2jCpjyruvkwUgco62mmV21jmf57RKxryw7lVg/Jhf5tkKuC71PRiX2DTCt0a
	 iuU/aSsIwdgAg==
Date: Mon, 2 Mar 2026 11:42:05 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/385] 6.12.75-rc1 review
Message-ID: <20260302104205.GA43213@francesco-nb>
References: <20260228180001.1567994-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260228180001.1567994-1-sashal@kernel.org>

On Sat, Feb 28, 2026 at 01:00:01PM -0500, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 385 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin AM62
 - Verdin iMX8MP
 - Toradex SMARC iMX8MP

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

