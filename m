Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BA620EB;
	Wed, 13 Aug 2025 09:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755075950; cv=none; b=OomJAKV/BKDJdBAJqqhC/xXzL4/0GoGz9HMK4G8aQOIuaTtIH7Tv0PepChEbQwTMxFZChbrEu3OxDuaU/frDM/5kPjt17ZOngLdXzaD0+Z856aqu3+5CFG089G1a37uKD/OB52/ZDnUALe6oMdD5fuNHQWegnqKOsa6iliGQhps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755075950; c=relaxed/simple;
	bh=V8EtCNrK/jrR8UES+CHfocT6eRWLjKGqgegKtQ11to4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qjUcuXMV3ZdQn6pOOJimFZoZBwURaish6mHsbhcC0ERKNex1WzICaty9stkb9JPU5gG2G0K4MyyoLWXAGuSa8AVqiIlW26mavM94wFeQkLRHwQHTUbAHFs0zr8oT3OwF1lbAH7+d/Rz0JhQvAC9fmTlYtjSS8oBixiyPoMthkMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AeTA4jYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AeTA4jYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C14FC4CEEB;
	Wed, 13 Aug 2025 09:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755075949;
	bh=V8EtCNrK/jrR8UES+CHfocT6eRWLjKGqgegKtQ11to4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AeTA4jYi9TzC6Urbg34Xze20hjVtdGD4IOl+VpIqbPQpQfB/NkQiZPBBiFLVyUE6X
	 2NfghcsMITF+/hA4AutL5beNYDAONX+u03S089OFbEULtabJAZch7AqzlpamSZ6Ksb
	 RZbNMwwSGbITRqLFSk2ae+lqEXNEwwmR+CxCfpwQ=
Date: Wed, 13 Aug 2025 11:05:46 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.16 121/627] interconnect: qcom: qcs615: Drop IP0
 interconnects
Message-ID: <2025081339-bootleg-matter-8311@gregkh>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173423.926141939@linuxfoundation.org>
 <7faaa006-1162-4fe3-b27c-f507c0df792c@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7faaa006-1162-4fe3-b27c-f507c0df792c@oss.qualcomm.com>

On Wed, Aug 13, 2025 at 10:58:27AM +0200, Konrad Dybcio wrote:
> On 8/12/25 7:26 PM, Greg Kroah-Hartman wrote:
> > 6.16-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> > 
> > [ Upstream commit cbabc73e85be9e706a5051c9416de4a8d391cf57 ]
> > 
> > In the same spirit as e.g. Commit b136d257ee0b ("interconnect: qcom:
> > sc8280xp: Drop IP0 interconnects"), drop the resources that should be
> > taken care of through the clk-rpmh driver.
> > 
> > Fixes: 77d79677b04b ("interconnect: qcom: add QCS615 interconnect provider driver")
> > Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> > Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> > Link: https://lore.kernel.org/r/20250627-topic-qcs615_icc_ipa-v1-2-dc47596cde69@oss.qualcomm.com
> > Signed-off-by: Georgi Djakov <djakov@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> 
> <copypasta for another stable queue>
> 
> Please drop, this has cross-dependencies and even if we applied
> all of them, the series had no visible impact

Ok, all now dropped, thanks.

greg k-h
