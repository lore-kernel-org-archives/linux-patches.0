Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1FE3D0D5
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 19:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721159745; cv=none; b=W5+0RvtOCnmo2gatBjN2hteAk2v9+VZm7rgwruY0inJKks9euvA3ReHNF5TqPsA1Z6bONu/t+nb0G+ZNEutzPtdzekzuC0pLXXeCLFLGz7BIGZkf21/HetDidwUia+XGMJaxi1Xn8jLak+fJ5adUPWdFPd3zcH5gEyw0N/wd4M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721159745; c=relaxed/simple;
	bh=y/eDmyrhbNINw2A3HOSpVgr82ZNiUMJiNBLPDBLAJKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sv9VRUJrJLGnZlNanyqcQURGncABJF32ki6c2Cd+Zv4kvLIyVnF67NvJZ7kL2c7blOSRDcchzzA29N5wsBy+9fdueB7/j2Ss86PLVjyO8TxcH5zi0VzPt19hul8wbJ1WouFT7VPcIB7z5rZVL2NqykzVgOqDBEzBsJCHHJNFHDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=J6eFzM1J; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="J6eFzM1J"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WNqYk13nNz6CmM6Q;
	Tue, 16 Jul 2024 19:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1721159736; x=1723751737; bh=Ufp9ItpaEVwHwjubiXcf2wxm
	vGVRYOAT/dEARkYgx8M=; b=J6eFzM1JfympXrhn+hxsm/g/OH0FWAI6VCapkURS
	CUOwrItylH6SBtEUC0MgfKglZF9HKotPegTLVGejzNSfrRmvmJFSKpgo8DRcP1vb
	oZyUibV46RIW4A+39bsODzLSPVNZqBwirRFeg1cYlz70RxFVuCQFHLpWUBxVoM9l
	2fGl8FpQC+0k2QEzZQR01KZjAupcctDahtOKiUHrHODTGOPuLIYqVn0LQScKfXy+
	5h91+LcAH6jWZUqfjGkFibW1rDlXukmHqqcAeJ8Hv3yoJAa50CQacxnDA7mHXXTW
	ncSq543UHApjyoSZ0dTktWMTcTmNSriYOhVyXswDRr67lA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xetiVkziKFpJ; Tue, 16 Jul 2024 19:55:36 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WNqYf66Hdz6CmR43;
	Tue, 16 Jul 2024 19:55:34 +0000 (UTC)
Message-ID: <3908f81b-0500-44fa-907a-111efeefcdc0@acm.org>
Date: Tue, 16 Jul 2024 12:55:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 093/143] scsi: sd: Do not repeat the starting disk
 message
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Damien Le Moal <dlemoal@kernel.org>,
 John Garry <john.g.garry@oracle.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20240716152755.980289992@linuxfoundation.org>
 <20240716152759.554308808@linuxfoundation.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240716152759.554308808@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 8:31 AM, Greg Kroah-Hartman wrote:
> 6.9-stable review patch.  If anyone has any objections, please let me know.

Please wait with applying this patch until this conversation has
concluded: [PATCH] Revert "scsi: sd: Do not repeat the starting disk
message" 
(https://lore.kernel.org/linux-scsi/20240716161101.30692-1-johan+linaro@kernel.org/T/#u).

Thanks,

Bart.
