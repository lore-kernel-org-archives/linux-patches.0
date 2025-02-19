Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7675A1D88DB;
	Wed, 19 Feb 2025 09:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957615; cv=none; b=ltq7kPRmQG+HG/gSNGo7CY3yX18uUK166AX6vmXPKMFGjxsL1VCr+m9EpX44NHfxR+Kn3yeAE+gNtBzlYa/4uaVUB61Z6ZxcJlPEQ9BEsZ2+6Tu07JyrGPzg3AwKueBBDcZ9YsYyk84ewMD/XedXBg/5qhRLzM9gIdDHAL1UZG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957615; c=relaxed/simple;
	bh=5qEYjM0nFKMfahOih16NTAf+QdxC/e8QUeGNrrnVti8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezDNnm668f1T0LxxH8nwrvv4mTMb5IaaeeSlBXmh5vN4tAH8Tev4RlcnxW74BL90Qxoj/oXCJ0/qxLjOpAZd7aLvAGl6ko2aw0qlh0Rr+bQjaiinejzSvOmVuyHn04gSVsdBVvTEIWLy5FRGMq6Xlrg/PLX+qDMg4q5rRyitKAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eETtsCFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eETtsCFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E95C4CED1;
	Wed, 19 Feb 2025 09:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957615;
	bh=5qEYjM0nFKMfahOih16NTAf+QdxC/e8QUeGNrrnVti8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eETtsCFN3Im5mVLPnmNu025fkkBKzprH3AVe9udT2SKJqe6cl1ND4X7F+vJF4JGXi
	 ya7+Q8DQHVin9V+TjDDoJns9+4CXCfn2G3tqIgEoQbseW2RAbIAzJ8P91BYLB8r4oH
	 jogWTaobTjQ0eeWcYRzACqFaffMUh+6g4telLhmA=
Date: Wed, 19 Feb 2025 10:08:05 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?utf-8?B?QsWCYcW8ZWogU3pjenlnaWXFgg==?= <mumei6102@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Sergey Kovalenko <seryoga.engineering@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 6.13 116/274] drm/amdgpu/gfx9: manually control gfxoff
 for CS on RV
Message-ID: <2025021944-imaginary-demote-31d1@gregkh>
References: <20250219082609.533585153@linuxfoundation.org>
 <20250219082614.161530240@linuxfoundation.org>
 <96738386-9155-4eea-b91d-8590ef3b4562@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <96738386-9155-4eea-b91d-8590ef3b4562@gmail.com>

On Wed, Feb 19, 2025 at 09:59:05AM +0100, Błażej Szczygieł wrote:
> This patch has to be changed for 6.13 - "gfx_v9_0_set_powergating_state" has
> 'amdgpu_device' argument instead of 'amdgpu_ip_block' argument there.

Why does it build then?

Anyway, can you send a working version?  I'll go drop this from the
queues for now.

thanks,

greg k-h
