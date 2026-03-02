Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D43800
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 00:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772412262; cv=none; b=FoUDkPUf6VBwOMD92y5bwivhnWUqo2o9ZMRDMNQQXEOyiBzUQfPBHZpme8jgWGnOQJphdUGSjkK84hmbWftLxXZ3+66tyUv/joKL9KpFzTUrpIiwma5ghbzKmY3Nv25So9yZpK5EcgiBpzLtIvwjAFsp+J77ZLZhSPEybY7gzio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772412262; c=relaxed/simple;
	bh=LHLO1FbzuNZ8I/Rrla6osGMbbTyKFYB/w8iv3DkzNrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HUFyVAZIL/WHmXhiMbrLUArJMXwzY25sq6VWOjpBgdIhKEZJwitNNtctHkkZI6GMjPW24pe9lAQ8iB17XL46ynDGqSe1CF2JOKc6QJMS6bGzKuSd/XZlYePwfS4RaxBECypaWSjS8UwNrH/4x4sMnBea+37OJ/GGPOKeA8MGpj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FmDtjlXi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FmDtjlXi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA314C116C6;
	Mon,  2 Mar 2026 00:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772412262;
	bh=LHLO1FbzuNZ8I/Rrla6osGMbbTyKFYB/w8iv3DkzNrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FmDtjlXi80JOuxwYzjAHZSlAP/XAdL7RyIo+7dVJjJsLWOIwLD6lvvqh+p8DmO1Jj
	 sCFKs3R8bQfTYa0E4xGr4ZjozzoGbCQYrNEChVW2Wj1h04C3rhL2AlNvBlQ9zpzuPE
	 bD6DenHOuPJ2L3eatp8CtwzXGzQK6y42OkvxPl8XelXSa3RCE4Ov7fnN1KaH10v0JC
	 jM6Bk+I3ir5V/mxozU085MiUIPmA2HbuWOYv6rK2+Q8JRCGfxO7IGaLquOpwwjFfaW
	 oEeyOAUqH7XoUpucetkZwyvavqaQwuj/maMHoX8l4xls/P04oxcIw6BK5PZHVWSx9X
	 PQS3CL9hUNhlA==
Date: Sun, 1 Mar 2026 19:44:20 -0500
From: Sasha Levin <sashal@kernel.org>
To: David Heidelberg <david@ixit.cz>
Cc: patches@lists.linux.dev, Casey Connolly <casey.connolly@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: Re: [PATCH 6.12 100/385] arm64: dts: qcom: sdm845-oneplus: Don't
 keep panel regulator always on
Message-ID: <aaTdZMlCbLxNJPJf@laps>
References: <20260228180011.1568201-1-sashal@kernel.org>
 <20260228180011.1568201-100-sashal@kernel.org>
 <b05f2343-8dac-4fb6-b45a-006f38d37e13@ixit.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b05f2343-8dac-4fb6-b45a-006f38d37e13@ixit.cz>

On Sat, Feb 28, 2026 at 07:10:29PM +0100, David Heidelberg wrote:
>I believe this patch SHOULDN'T be backported. The 6.12 trees for 
>sdm845 following stable releases may have drivers and setup, which may 
>not be able to work with regulators properly. This got fixed later 
>with fixes to sofef00 and introduction of s6e3fc2x01 driver with 
>proper regulator handling.
>
>The clean (without additional patches) 6.12 stable won't work anyway 
>here, so it would be meaningless add this patch.

Dropped, thanks!

-- 
Thanks,
Sasha
