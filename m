Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D012EFDA0;
	Wed, 16 Jul 2025 11:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752664182; cv=none; b=X6pCPqWLc7mkiYT3kkGfj5M4qSD4UVimxf8EoM+byuDvUv2txCFoRIg/AivAKSUVvEzQysFXo48gBjYpTr+GyeTzR6ulyU0kBLI8ztDWEPlvRrgx33XsEIaTOgkdYnHDuOjgpYjefsooa8ETZIk+EqqkihKDS9/W7owEEa8WtXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752664182; c=relaxed/simple;
	bh=RZjR+zBNXTDV8Esh9IbuzSTwt+E2KPtd34O2E1kw9CE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezdxgUygCP1HDacemwTDrhH5ae+bAypX6IXEp17GcSctDLnVb+65Ond8NP3vvM1PnRU8OSm0okeBDr/iFcS5sUFUqs3qs93DZ4Y0RqqXKq5ShhBG7jXnKoC1MEOhlFbKjrd3zCL2M6yCJ4fTrlVVVbqfgekkEgV/7sQWddWNeMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KJqdX+uE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KJqdX+uE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D985C4CEF0;
	Wed, 16 Jul 2025 11:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752664182;
	bh=RZjR+zBNXTDV8Esh9IbuzSTwt+E2KPtd34O2E1kw9CE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KJqdX+uEV25XZ8V+PYzhBOfdC8nG9XiSSNaTauNQAnXakMuWAOiBA0WryVQc0ljES
	 THSz5iSKYWKBOyEOxt0XXR5aoMl1sDDlkbD6CixsHIEDKyP+muT9tPuOKnXGIPZFRN
	 gpGhilsXOq0hXU7pH6ZfVdPz+ehvb0rOY1CbSGBU=
Date: Wed, 16 Jul 2025 13:09:40 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Macpaul Lin <macpaul.lin@mediatek.com>,
	openembedded-core@lists.openembedded.org, patches@lists.linux.dev,
	stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>,
	=?iso-8859-1?Q?N=EDcolas_F_=2E_R_=2E_A_=2E?= Prado <nfraprado@collabora.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Bear Wang <bear.wang@mediatek.com>,
	Pablo Sun <pablo.sun@mediatek.com>, Macpaul Lin <macpaul@gmail.com>,
	MediaTek Chromebook Upstream <Project_Global_Chrome_Upstream_Group@mediatek.com>,
	=?iso-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6.12 2/2] arm64: defconfig: enable Maxim TCPCI driver
Message-ID: <2025071601-unwatched-chowtime-82ff@gregkh>
References: <20250716102854.4012956-1-macpaul.lin@mediatek.com>
 <20250716102854.4012956-2-macpaul.lin@mediatek.com>
 <8698f842-a464-47b8-8c47-97cda016e227@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8698f842-a464-47b8-8c47-97cda016e227@linaro.org>

On Wed, Jul 16, 2025 at 12:30:20PM +0200, Krzysztof Kozlowski wrote:
> On 16/07/2025 12:28, Macpaul Lin wrote:
> > From: André Draszik <andre.draszik@linaro.org>
> > 
> > [ Upstream commit d2ca319822e071423ab883bc8493053320b8e52c ]
> > 
> > Enable the Maxim max33359 as this is used by the gs101-oriole (Google
> > Pixel 6) board.
> > 
> > Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
> > Signed-off-by: André Draszik <andre.draszik@linaro.org>
> > Link: https://lore.kernel.org/r/20241203-gs101-phy-lanes-orientation-dts-v2-1-1412783a6b01@linaro.org
> > Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > Acked-by: Conor Dooley <conor.dooley@microchip.com>
> > Link: https://lore.kernel.org/r/20241231131742.134329-1-krzysztof.kozlowski@linaro.org
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
> 
> No, that's not a fix.

Yeah, defconfig changes don't really make sense for stable updates as
everyone already has a .config file for their systems by now for those
kernel versions, and changing the defconfig will not change anything for
anyone.

Sorry,

greg k-h
