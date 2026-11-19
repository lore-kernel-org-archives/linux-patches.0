Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104531;
	b=Av8JB5qxFplto+x+7Qs+bzSTcjF3xzVyBR0HmBjP0ZSAFNiow7C3js5AuSBwDqdr041g
	 U4wJ5ZYA/RLQ7/fioA83K0FePT/3oHhyZtYbHnobOeRuapjfXpef4cAkqgZZSSskIOKIz
	 BLEHzPshw72NnkAv2aSGi9A5NnNcq2ayKSNQrxuv9d8jRthoOUNm7fyl2ZjSo403BF4/Y
	 tulnWe7cKp7ureEscmGxW9KFimADEeY5PWaNwmw2Nqvlf41/7pmynOfj1Xr+AbX9WAuDr
	 oBhdoQWZVMa+lA+O3GZ5cNblPZTlNbGcIUXnmckHchk/9viqZ/JbfHjBbspDIO/4EQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=K/w2D4IDaFKl8TJL+4WcEgenP0LHctap2rGQ7ZMeeFs=;
	b=vQ0KkjHbcX+kDC6EoNabNKOVpFiLPl5hXlwqrARodMo0cCLEHc+a/Vfrk4lr5aMnOPjx
	 KDzxFhniIHse+M4ITpWe8Ww32FP1eQTRWwodHarjlbdASEacDV9KLT1FY93yfJ6uVAzTL
	 +AB8ivbjNVneBZrZc0vUpzpMtBwdJXmpQ/L53V+iVX++xxDDyldCPVHFYIg+/hsoNqvEF
	 J1Hghrcd7j6wXFyjsZXA+i4wo+OEfgnFCsYaixTYkW25yEzt3b+8zLbU5E8x/tJcbmtsC
	 G/P29NtdvXsZBt6HJnrgFXZeCFXoGWhwI3t/YlSue/emp65pGDudtK4u+iplLqKbftA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aUPPbE3x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3393660A261A;
	Thu, 19 Nov 2026 16:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aUPPbE3x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B511F000C5;
	Thu, 19 Nov 2026 16:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104531;
	bh=K/w2D4IDaFKl8TJL+4WcEgenP0LHctap2rGQ7ZMeeFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUPPbE3xz5kuCMcXQka9CMpNdGMoIk8yVUNwQRXg2gihvFC9uxqF8UOHv/GmZx/oG
	 0NWzeJlGi/9AziM6BXW+2WfURRSAeNg73+pr6dTHMshPT7kSVmkZmvrTYDBA+Oigos
	 hhSolUS5R5Mh4BxgiE+rcNZbWlLCdXlG+C0c9QqVUMBpNApz7PLTNk548w65AmniXt
	 p8w3Od/Jiofm2JqVlw/RlAupwSbLaOt3lqsuI4/lA0IYboQkXC2T4ICYA3oPkXbgl8
	 ES/1DXpKHqTKFjWAhU6VCe8ufvqxSO9Z8aJs4JlfXTSEJFiBpJsF/ikzeld63dxsCH
	 SythfVfEjtWyg==
From: Sasha Levin <sashal@kernel.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Semih Baskan <strst.gs@gmail.com>
Subject: Re: [PATCH 7.3 1913/2651] PCI: iproc: Use the EROM outbound window on BCMA
Date: Thu, 19 Nov 2026 11:08:18 -0500
Message-ID: <2026-11-19-1-daily-reply-0016@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAAsRjRmbj+f_v8d99EgGi_z_rfmw+0rnKN8Y2ZwuHarPKP4NEQ@mail.gmail.com>
References: <CAAsRjRmbj+f_v8d99EgGi_z_rfmw+0rnKN8Y2ZwuHarPKP4NEQ@mail.gmail.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> > This does not build on armv7hl:
> > drivers/pci/controller/pcie-iproc-bcma.c:72:45: error:
> > 'devm_pci_alloc_host_bridge_release' undeclared (first use in this

Queued the missing prerequisite for 7.3, thanks.

-- 
Thanks,
Sasha
