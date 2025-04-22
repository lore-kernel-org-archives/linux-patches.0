Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48652741C5;
	Tue, 22 Apr 2025 11:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745322533; cv=none; b=nLGGANyPgUPm0shWU57KYUAZW4pmObKb28BTF3hJClCBlj8nw3SVg3HHnxmXMiD+5DaIsWRCg3o/TcRCoi6Uvp+BtBwiuTDJZ4oLvRrm61idnl7fwLgrk2OL7DPt283MgzbQ5aJ6jEc9d6F8WxJFdrhKsCtAkOCQmleap4IQRoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745322533; c=relaxed/simple;
	bh=gjfmO1uo0PXs35YOtpblppBPiZobWynhU1RHLlgVsik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EOR0OzyE1/rOz6s9J3xq7sWSOYRkSzVN9NWaMj5yo+L0EiA6jTVfnfOA9M2RuUneTmSMhxmRkYco1Xn/2Ixp7PCHFVG5QjhArnZp/6DZKsBD99sh6OI8ABCvws6gFN8WqCKEGNt6y/6+pSfKWIkrzx8cq59qVeAJfgrmTWgf1uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOYVD8zR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOYVD8zR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4DAC4CEE9;
	Tue, 22 Apr 2025 11:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745322532;
	bh=gjfmO1uo0PXs35YOtpblppBPiZobWynhU1RHLlgVsik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zOYVD8zRbRemLcpKjwfdyZrk/kAYpOrytkrRBwasUd4eWd2/FifmzIm9JnZrMgm8N
	 5VMc4NaQQEAnF2zT44C3zJCYcx9aSCJxd826OlLJtkenNPl18Ao6+ESSBuzC7Tp5sQ
	 44wckJGEnqv0U7yMaV1Gv0vF3iRcwtMJn6N4V6ak=
Date: Tue, 22 Apr 2025 13:48:49 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexander Tsoy <alexander@tsoy.me>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12/6.13/6.14 1/2] Revert "wifi: ath12k: Fix invalid
 entry fetch in ath12k_dp_mon_srng_process"
Message-ID: <2025042242-catching-donated-6e0d@gregkh>
References: <20250422110819.223583-1-alexander@tsoy.me>
 <6cb0c280c9f3344b6c87dbb0aff344f3b70abea6.camel@tsoy.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6cb0c280c9f3344b6c87dbb0aff344f3b70abea6.camel@tsoy.me>

On Tue, Apr 22, 2025 at 02:23:31PM +0300, Alexander Tsoy wrote:
> В Вт, 22/04/2025 в 14:08 +0300, Alexander Tsoy пишет:
> > This reverts commit 535b666118f6ddeae90a480a146c061796d37022 as it
> 
> Commit hash is actually different in different branches. Should I
> resubmit these patches separately for every affected kernel?

Yes please.

