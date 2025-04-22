Received: from puleglot.ru (puleglot.ru [195.201.32.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C9A1E9B12;
	Tue, 22 Apr 2025 11:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.201.32.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745321017; cv=none; b=MSQPZe7QrOL2VzZWdxDKVhBd8zR7VnrfA4BRBFdymG/hwQoH+U2b+eyVD/S43JC/767zY9z+hP88NbwW9DWYq2sWZjY8bdj+hUPums7RHFAVms1b/7v/X9tWWuOq0MdFhFr45yHVliq9gisqLN/XqPjVwzzBoqYYpmIGWab7tnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745321017; c=relaxed/simple;
	bh=cF6Qey5ho+W99KDNaPS6EMctt9Y+b7lYH4maup3Gi2Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R6l3gf2SGgyZt6iiUokmIb7HzqjPvMPt6rSAr3VpgCz/REUKkdwbu570FFJZumCO5qDGYVv/AVlwPN/RAELEhL5zYbAj33Lyjoa86TQWShPT/f15GVhWz+9Uf8cRwyrab9qlgXTGuKX5fmWhOGiTHNp66kNrrpsjCq+F68Jp+N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tsoy.me; spf=pass smtp.mailfrom=puleglot.ru; dkim=pass (1024-bit key) header.d=tsoy.me header.i=@tsoy.me header.b=HmG2GkgP; arc=none smtp.client-ip=195.201.32.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tsoy.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=puleglot.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tsoy.me header.i=@tsoy.me header.b="HmG2GkgP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tsoy.me;
	s=mymail; h=Sender:MIME-Version:Content-Transfer-Encoding:Content-Type:
	References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
	:List-Post:List-Owner:List-Archive;
	bh=cF6Qey5ho+W99KDNaPS6EMctt9Y+b7lYH4maup3Gi2Y=; b=HmG2GkgP+aBL9rWG8yYoEFasBg
	sB4nyNhjhZ1HfHyeVQUjTFix7VE5vQmFlHtDUYKYAbj0iiohwf2lv94u0ZibLrRAdU6sAR9NtnAUK
	PODXNlmE364yaLbV+oD2OnkQRnbGNOF6FO5pfelES3jzYB69nWJd4DCIGw3b6b/zhpWI=;
Received: from [62.217.191.235] (helo=[192.168.1.111])
	by puleglot.ru with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <puleglot@puleglot.ru>)
	id 1u7Bit-00000000CfQ-3OPt;
	Tue, 22 Apr 2025 14:23:31 +0300
Message-ID: <6cb0c280c9f3344b6c87dbb0aff344f3b70abea6.camel@tsoy.me>
Subject: Re: [PATCH 6.12/6.13/6.14 1/2] Revert "wifi: ath12k: Fix invalid
 entry fetch in ath12k_dp_mon_srng_process"
From: Alexander Tsoy <alexander@tsoy.me>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, P Praneesh <quic_ppranees@quicinc.com>, Jeff
 Johnson <jeff.johnson@oss.qualcomm.com>, Sasha Levin <sashal@kernel.org>
Date: Tue, 22 Apr 2025 14:23:31 +0300
In-Reply-To: <20250422110819.223583-1-alexander@tsoy.me>
References: <20250422110819.223583-1-alexander@tsoy.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Sender: puleglot@puleglot.ru

=D0=92 =D0=92=D1=82, 22/04/2025 =D0=B2 14:08 +0300, Alexander Tsoy =D0=BF=
=D0=B8=D1=88=D0=B5=D1=82:
> This reverts commit 535b666118f6ddeae90a480a146c061796d37022 as it

Commit hash is actually different in different branches. Should I
resubmit these patches separately for every affected kernel?
