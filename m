Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5BE2A1BB;
	Tue,  4 Nov 2025 00:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762215758; cv=none; b=Hl+jFrK/e1lmqe+ex7ErBmioUHhaOcT+YCynznl4FEArYizE//x5cE6z97ooHjsFX6O86Ih16x5jvt+LaXCTd9cbSUgw82mTTR7m1E/fSEUxCHltIzjONGqaOq8RI9GgQyNEjvui+uiNkbCy5s9twFMyxliQv4ulKnh7imOqOuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762215758; c=relaxed/simple;
	bh=b9CZ+VB3UXS0C3cTQaC/sdKRLZE5rzAOC3vy3hu5KMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o3x6U8BxvNXy2imV8TRGoYmTKdw+ZigPFC1/NbNuabOLAIS7vINt+ARITiPDiH6P3i4xsDzgxFmJnYsXp2wA8lD99X7VymqqYBUTda1+Yp9Rq8HplSvOJqKhMDZrkc84nt15nPlLqjiiDBwCWiuuQf4vaQNGL1OjU6PknloIKEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ttY1tiFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ttY1tiFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E086C4CEE7;
	Tue,  4 Nov 2025 00:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762215757;
	bh=b9CZ+VB3UXS0C3cTQaC/sdKRLZE5rzAOC3vy3hu5KMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ttY1tiFm8W5I8B4z2PfG5pKGVRZCrl8YOIScu4Oo4kjqWGBQzmACXgACg0wXn/2Gs
	 XyVn+O9bMNwCga05VqO0nSGhlBxyl3Oaz6612cCJxERCWYo4Puzav9k2ViiI+Vxh3T
	 TxeLVu8qy8ZdMzEXxVpU6W8Hw+4rTr/9iGeykOYNiIB1FY4m9su6DG2cyh940falxh
	 1XybPt1Kfx0SrzyaJn8481kjiFrzr099MqooQxcBRuWvfbxXHg/QqmYllwEp9vZq09
	 8Pp6OT/p84QAna3LFcRepcRCtFtH2vI4CmboqYfvLZQkuWXYQeyVoKaey9bmY5kPEE
	 Mt+Y+HHrZpG2Q==
Date: Mon, 3 Nov 2025 19:22:36 -0500
From: Sasha Levin <sashal@kernel.org>
To: Andre Przywara <andre.przywara@arm.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>, samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 6.17-6.12] soc: sunxi: sram: add entry for a523
Message-ID: <aQlHTCB-UyA7JrFo@laps>
References: <20251009155752.773732-1-sashal@kernel.org>
 <20251009155752.773732-11-sashal@kernel.org>
 <20251009173801.13c133a4@donnerap.manchester.arm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251009173801.13c133a4@donnerap.manchester.arm.com>

On Thu, Oct 09, 2025 at 05:38:01PM +0100, Andre Przywara wrote:
>On Thu,  9 Oct 2025 11:54:37 -0400
>Sasha Levin <sashal@kernel.org> wrote:
>
>Hi,
>
>> From: Chen-Yu Tsai <wens@csie.org>
>>
>> [ Upstream commit 30849ab484f7397c9902082c7567ca4cd4eb03d3 ]
>>
>> The A523 has two Ethernet controllers. So in the system controller
>> address space, there are two registers for Ethernet clock delays,
>> one for each controller.
>>
>> Add a new entry for the A523 system controller that allows access to
>> the second register.
>>
>> Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
>> Link: https://patch.msgid.link/20250908181059.1785605-4-wens@kernel.org
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>
>> LLM Generated explanations, may be completely bogus:
>>
>> YES – this should go to stable; without it the second GMAC on A523
>> cannot program its clock-delay register.
>
>It's pointless, any kernel before v6.15 will not boot on any A523 device,
>so support for any kind of A523 MAC is irrelevant.
>For newer kernels, this would be tied to the GMAC1 enablement, which is
>also a new feature, so not a candidate for stable.

Dropped, thanks!

-- 
Thanks,
Sasha
