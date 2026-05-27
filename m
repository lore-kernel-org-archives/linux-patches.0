Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F9C3B19B1;
	Wed, 27 May 2026 19:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779911378; cv=none; b=AwAP19f0mnZ51BrOD1Rbft48r+Q5qJ1MkSLEWMT10xJIZemEGDYVR73MOjcTOze2P7WorH9vUulcOwzv0q5AUmJ0nn569MeladZ1HAq3zFx0kpUKHmQ5gYgJFKugi3xe15vFVEt4dz5OCCoGTuqtm+JtuuYV0x5odCO/hdLjCNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779911378; c=relaxed/simple;
	bh=AAui/35BdXAduW1BLpfpXGcfFy5asK/kJ+Fe6tFyXWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKEYtESaSBiG26IELStptKAgbyFhW5iYr/Ic+tsZlLFFna5GEdXYq4UqYOJUuUsBrXX+Jdmjo2DCqGs77pvN4p9RYphFP5M4tF8gNdHLUsEYSKKe/tjOhDuH7pQvYaMvX1DEYx9SKzA8bp9vmN741jFORjEyNDneK9IiCYBCLfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eg7Yu50C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eg7Yu50C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B5D1F00A3D;
	Wed, 27 May 2026 19:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779911377;
	bh=AAui/35BdXAduW1BLpfpXGcfFy5asK/kJ+Fe6tFyXWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eg7Yu50CLmeomDkgpi6/9HXsOwbQwhVMdCa46yIB3jB8UsteWD7HCyCk937fZlV/v
	 QPo6BuRLt181aC6tvyRk8rxdhMQziK+rtTh7WKjC9+33AJY7meYCRz+tPhdWev2kIQ
	 m2hgpzQyRdBckkyBJQV7Yc0Ltx7MnVyEMitIW0cP690IGR0rFd3xuennFgSqioMvnM
	 snTl6GfAkn6yQtWWJOQEgsrs1E8xTexclHp/ciXsQnXwenEiKXTa3+Q9DVgNLWhBfp
	 BhjcdMzY2W4l4rcdls12opOq8R9rJzqkSBU7bheJAU0vjTKbb41Z1JISoRW1cFdgdH
	 WiSZVrRE/tr1A==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	adrian.hunter@intel.com
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	alexandre.belloni@bootlin.com,
	Frank.Li@nxp.com,
	billy_tsai@aspeedtech.com,
	npitre@baylibre.com,
	boris.brezillon@collabora.com,
	linux-i3c@lists.infradead.org,
	Jianqiang kang <jianqkang@sina.cn>
Subject: Re: [PATCH 6.12.y] i3c: mipi-i3c-hci: Correct RING_CTRL_ABORT handling in DMA dequeue
Date: Wed, 27 May 2026 15:49:10 -0400
Message-ID: <20260527-agent5-item018-i3c@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260527061933.3612126-1-jianqkang@sina.cn>
References: <20260527061933.3612126-1-jianqkang@sina.cn>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [ Upstream commit b795e68bf3073d67bebbb5a44d93f49efc5b8cc7 ]

Queued for 6.12.y, 6.6.y, 6.1.y and 5.15.y, thanks. The 6.12 backport
required dropping the upstream guard(mutex) usage (control_mutex doesn't
exist on these branches); the rest of the change applied cleanly.

--
Thanks,
Sasha
