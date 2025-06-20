Received: from outbound.pv.icloud.com (p-west1-cluster3-host5-snip4-10.eps.apple.com [57.103.66.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8296F2E54C0
	for <patches@lists.linux.dev>; Fri, 20 Jun 2025 15:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.66.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750433498; cv=none; b=VMhQzXCvVcthmTX5TV/C6TVSD46DvkT/V45/34K0YxXP4dHYdPvnCuNpBgKSIiubuHNrdQaidgIt1/FTDiiUPQ4lN1cPJWIcND1pImbKJUrdZgdHWE2EsqAq9Tby90qT3hMR95xIiQW3+AKhnWtOsToHWEPMM15X7hQDR0pNGsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750433498; c=relaxed/simple;
	bh=+s+BrX06amdtEHvaG2tDNQez8uevGHMEwIFbYuc66eU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YBIahFQBShVAFGp24VHvHLfOc8nitr+jZ99CZcCY9a5If4gHQnlD+ZxqyTEXEn4zpupJYs9LHc+GHnDVsp/Wc6Vkwl2mPa/x6wNPFqVigCBPx3VBbWgf5inTdMQ2w2fvzJI1wkjcDIaiDLbQqYxpUBKxPHvq989hNWbW6XidheY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=WtSw4Kn3; arc=none smtp.client-ip=57.103.66.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="WtSw4Kn3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
	s=1a1hai; bh=+s+BrX06amdtEHvaG2tDNQez8uevGHMEwIFbYuc66eU=;
	h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type:x-icloud-hme;
	b=WtSw4Kn3MCcJZnT/iYgKfk4xReQ/7feus5ALCaVOfc2MmoaQgSzbsLPtkfPFnAhgM
	 Easel1GyMnBaSulpzC+Zpg7LSChoeK1mg0OxCzU7CaeEmILW3VU655Gy7O1+lp+dbL
	 5PB03/OmVbvrteEMxBuHiiE5Up9C4z3ysdB+XwkoxMm2M4vo3mNqnkVW7ZuCuyfX7F
	 EGdRU+2EdUuyeO0wZLiYy+LVZaQImaf8mXVH0unbSPHZmhr2i2WB9ZHkkJzBf4ByVr
	 7ibRXvESlmN/+5TrPlBFnlBDqvUN4UF+4yPdgwZVNxs2PNprWcNm7r/q0H1Zz2uAXg
	 eaWv0dDP+xpuw==
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by outbound.pv.icloud.com (Postfix) with ESMTPS id 1C5C818030BD;
	Fri, 20 Jun 2025 15:31:32 +0000 (UTC)
Received: from [192.168.1.26] (pv-asmtp-me-k8s.p00.prod.me.com [17.56.9.36])
	by outbound.pv.icloud.com (Postfix) with ESMTPSA id 4674D1801BC2;
	Fri, 20 Jun 2025 15:28:33 +0000 (UTC)
Message-ID: <59d1ae11-c132-43cd-ba88-c16e86d862f5@icloud.com>
Date: Fri, 20 Jun 2025 23:28:29 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 471/512] fs/filesystems: Fix potential unsigned
 integer underflow in fs_name()
To: Pavel Machek <pavel@denx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Zijun Hu <quic_zijuhu@quicinc.com>, Christian Brauner <brauner@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20250617152419.512865572@linuxfoundation.org>
 <20250617152438.664510685@linuxfoundation.org> <aFVCH8CeAEDY2oEj@duo.ucw.cz>
Content-Language: en-US
From: Zijun Hu <zijun_hu@icloud.com>
In-Reply-To: <aFVCH8CeAEDY2oEj@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDExMCBTYWx0ZWRfXzexrwsWQ4jLj
 YKYXTILNV+ipNqC0CeWtsTmfychRfhG0EHMHY0x5A8e8+9mGNd/8FDh/2Dy9vTnL10jO1urVmOg
 14j1k2mxQcfoM67R51yGf5MifSsh/HDqQ5VGtV7MsQr06ioZKl+zoz0ZXqMwfzD7Sy82KNVsC7S
 bFqY8aAHzgW7XPPHUa/WFbmIgoYTIr2938BNqtSy2thEVAsl5ju1AZYegb9ZuHo5bncqo18SaZ+
 o3W5bRCKqPQ4uYD4mXi+nxnBpHQHr2lX9G91TttI874RnoNTI2SVBnm7k/NGMp1q8W0NEO5+w=
X-Proofpoint-ORIG-GUID: zMcZiIdCRpLL6m9XmGnF43hvvYSI-BQx
X-Proofpoint-GUID: zMcZiIdCRpLL6m9XmGnF43hvvYSI-BQx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-20_06,2025-06-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0
 clxscore=1011 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.22.0-2506060001 definitions=main-2506200110

On 2025/6/20 19:12, Pavel Machek wrote:
> How could it underflow? for (..., index) already means we break the
> loop. I don't see underflow possibility.

let us assume list @file_systems has 1000 entries, and think about what
will happen for below scenario.

for invocation fs_name(0, ...) but the first try_module_get() fails.


@index underflow will cause extra and unnecessary 999 cycles.



