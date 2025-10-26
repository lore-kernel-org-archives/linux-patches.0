Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AB827F724
	for <patches@lists.linux.dev>; Sun, 26 Oct 2025 23:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761520585; cv=none; b=IYjePVDQR1VkNqVfNmVs68vm1luwp8s1zxJ6x6R+6j4iCNSJNkHa31N39pn7dmteWI6yH+5C1ABI9CANrf61UwKKifPRTwHiV8QQNZFKQGzzBQqmp8pbaB/28aVzHjBqeIUNHMIQ2YgV3M/uBta/RII9I4xF86hTf7H60KVR3Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761520585; c=relaxed/simple;
	bh=KQ6oL4hiz75C/A8/vFj2v/R+XXo7kpXKDEDVyBnk9ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=TezBEXwjWRRlQ5zm3v3/tlIYKNMQuQcKGLt5wKU4Sy0cfQEVm8on2s6RMIVabF7eRMlrnWbnyg+BBGXyPve0HE/7nOBemE/QcTL7J5QeVhNDPSokyYwlYJNB6rI87hXZ1uMhg1lYlXOEaY2LhSjQRBGzpXTfHz4805sNCfVx6G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FZhgUXCg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FZhgUXCg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761520582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TM9g2J61qUgy8rn11tUgr2Kr+gynrxk9ajK18D17/SY=;
	b=FZhgUXCgfNhbFC0aLRD5m53O6tcsq4jZevBZGhuMO5eec7csVDXAm/Y0wD7V2iA1AbxPKT
	RgB0e2IXnGIhgFLcUTZoAv60pSRlP6Q+yiQHIQq60wz4HvyCd34tFKyCR/2KU2fYOyd0Qd
	MGmMG/J1iy/ULPu4wec1o6Rby3qq8v4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-fGte7niyNxCNSNlz_yIkFw-1; Sun, 26 Oct 2025 19:16:19 -0400
X-MC-Unique: fGte7niyNxCNSNlz_yIkFw-1
X-Mimecast-MFC-AGG-ID: fGte7niyNxCNSNlz_yIkFw_1761520579
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8a2594fa114so256971085a.0
        for <patches@lists.linux.dev>; Sun, 26 Oct 2025 16:16:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761520579; x=1762125379;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TM9g2J61qUgy8rn11tUgr2Kr+gynrxk9ajK18D17/SY=;
        b=inEKdcqNzmaATkYnDXKXDMrKm9/5H8UfNHqMeiLSh15ysdHd5XM8eOTNDddieaQ3AB
         /h4OTUVRXwknksCIYTxEhvRrFxEby1S+Evjziu9zwgKKvnf4JCyCvpNpW/z1gPc4IOO/
         /LcAi7CLrTvKKHw9/nRGjI/pLacXBilkpr9yRqBlr76I+2sTlkVzADvdDNzMbRzok8gn
         4L+rutLek+BrBP0WM72BfE5JwVwCEnuXI2eTzWh4kXmbJTLZAmguSy0zs1MOKelUpty7
         aISlAsRyrb5bt3lDDIYmoacknidmMqazwr9ENkkXwYeAagp5GIhIy2nD/RTbBglsaDkl
         r7ZA==
X-Gm-Message-State: AOJu0YxQc556D7uXdxK+810i5+K12emgTXk8g417cyqODp5z20sTTeyp
	BWNsskmVyDVdG7SZQjdEL7PzWuKYlTkz6q7cW1d8k76sAy1r7yeBVNIFmPndFpK9SzLe8qbr5ZG
	4O8HW4z9n7wg8IanMeBczhXl/kSo280Of1ilJEYNdz8ZEGgIFZiIG/XnOseE=
X-Gm-Gg: ASbGncsrr+tI0iqdqgLBG2N5/eJVPCG+rDMUA6Bx/xJOIio7qfj6rgM6GFdIj59Jsf/
	bJnmq02Z+F3VKI2Sb3nWWfXAi9enmXprwEIncv88mYBomBiPy9OvLaiMr2H8ydxR9Z0cTcGmK/5
	JLuGmk3WN/Gvv5PM5MXtFMoI1oSJYCTZnKCt4ZkzkRQRc7sJD1d/wHRsibQ2PILyf4flnwNuXMo
	1z/OUnGb4NCXBUmDXCwLE/bygc77uAS2hWOji6gecNin1rHM+l7S/NFoMT5B0g9F0DBPsfeX9d2
	9yXUdNDb93C1JrkTajyyLZKVp4ECYNUE4u5ve6XZKu6tLhLYZJi7vrRo3SlqF/A2Y3ep9j5xA6D
	x5ZKcXoKW9fxAL9OYIFZm2cHIIpfO
X-Received: by 2002:a05:620a:4454:b0:809:b21:5421 with SMTP id af79cd13be357-89da1bae914mr1370443785a.39.1761520578743;
        Sun, 26 Oct 2025 16:16:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0exW7QsnW96XJU3LfmVTRq5OXRYKfDNXF9pTY84ykGNprSECOl2LKm846J2PimjM64qIFow==
X-Received: by 2002:a05:620a:4454:b0:809:b21:5421 with SMTP id af79cd13be357-89da1bae914mr1370441885a.39.1761520578329;
        Sun, 26 Oct 2025 16:16:18 -0700 (PDT)
Received: from redhat.com ([2600:382:7702:71bf:259:17c7:d468:3f55])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f2421fc6fsm435746185a.9.2025.10.26.16.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Oct 2025 16:16:17 -0700 (PDT)
Date: Sun, 26 Oct 2025 19:16:13 -0400
From: Brian Masney <bmasney@redhat.com>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Sudeep Holla <sudeep.holla@arm.com>, Peng Fan <peng.fan@nxp.com>,
	mturquette@baylibre.com, sboyd@kernel.org, arm-scmi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.17-6.12] clk: scmi: migrate round_rate() to
 determine_rate()
Message-ID: <aP6rvQD-bwSkhfU5@redhat.com>
References: <20251026144958.26750-1-sashal@kernel.org>
 <20251026144958.26750-39-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251026144958.26750-39-sashal@kernel.org>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AxNZd0MptyDZ9g9XCUrkvrMJp7fFh8cTwGyyWw7_mLo_1761520579
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Sasha,

On Sun, Oct 26, 2025 at 10:49:17AM -0400, Sasha Levin wrote:
> From: Brian Masney <bmasney@redhat.com>
> 
> [ Upstream commit 80cb2b6edd8368f7e1e8bf2f66aabf57aa7de4b7 ]
> 
> This driver implements both the determine_rate() and round_rate() clk
> ops, and the round_rate() clk ops is deprecated. When both are defined,
> clk_core_determine_round_nolock() from the clk core will only use the
> determine_rate() clk ops.
> 
> The existing scmi_clk_determine_rate() is a noop implementation that
> lets the firmware round the rate as appropriate. Drop the existing
> determine_rate implementation and convert the existing round_rate()
> implementation over to determine_rate().
> 
> scmi_clk_determine_rate() was added recently when the clock parent
> support was added, so it's not expected that this change will regress
> anything.
> 
> Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
> Reviewed-by: Peng Fan <peng.fan@nxp.com>
> Tested-by: Peng Fan <peng.fan@nxp.com> #i.MX95-19x19-EVK
> Signed-off-by: Brian Masney <bmasney@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please drop this commit from all stable backports.

Thanks,

Brian

