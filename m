Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD4F225A3D
	for <patches@lists.linux.dev>; Sat, 25 Oct 2025 16:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761410869; cv=none; b=FH0qxiIKMyd9r1JPS+A5FSx18pbc1hs+f5eem2S8DpP3MvipXcdfdcg4Nydghy2zUduJOGbC8CLx2GZC76znhguI9SuI82h8LOFW4nQxH+11xJI2AE93mCRjKFucVaI0HXXmHIAFRykOecU4J/kcSTp4aUyOEgXtMmd7SY1hSgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761410869; c=relaxed/simple;
	bh=MjmsUVHr6NMRcRBnZl5oyGiiFbM8seOg1onkjxTlhSs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fPb/ZI2Pck7MieV/hK5IJ+KtWpwPWFBOHVJrxZsrv1E10vFTouha1UJU5X6ogZ35bleCXJiRZtLQ1Ax6GNLQzwRzbpi3+raKejD3mUPoSpkV63eK6yzNuNxFZQs9jTdHpBPfP7ogo335ivKVfQt7ua1La53TctT+Sy47nzg1rtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AVXNBR9s; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AVXNBR9s"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-592f29e273bso2969594e87.0
        for <patches@lists.linux.dev>; Sat, 25 Oct 2025 09:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761410865; x=1762015665; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zdq0pmLhJNTjhaDx3mb1Ru2H4viWHvHrb5MIRLM0trs=;
        b=AVXNBR9sk/Z3YD7D4k61c2YGPdUxlqtWW17eB0GUrzL4CTSTLf/ZB4M6Ffrgfx2sa/
         r9Amgg8245aYDl3WFJCWjwsOx+XNuggI1j0dVOHTVTTL+wcnCvEqenxc1cXXyVsyqdGy
         LvKr+GF89n/RKYVKAPMwll2mLN8kfaWQPZTbcGp/Eb6Ys28/s4+1QMqmo5ajLtoGUF3i
         MSrs6bLL0zmeeEFx2l7srZWp6h84RDOUGd3DifNr5Q6ZtR+raU6Gx2vZd2TVXo7dCWhl
         LupzP2abyyUMVEksflWXv8g8FDup8xSAqSjST9nokKjEcKKXv4uxGWx1zNlRTWWpYNPd
         cYOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761410865; x=1762015665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zdq0pmLhJNTjhaDx3mb1Ru2H4viWHvHrb5MIRLM0trs=;
        b=vFW5LcX318IyQKlaMuvRe8hcFtclzs1Ju/e5IAWJWU0x/SBj/Hvs8biI3P4SYvE0X7
         3FjuJLEnqReUYt2N2DUPzp2vBU1RkPOt4WQg+c2fxjzNxx6wNuGFJ9HT+6i2kEX9H1Ox
         WJHJUCgZLCwudTWT6Y4PhtCXxlcoaiaOvzZyPZKxYB7Fvqs0u+/yhKU/7nQD9eH1JXvl
         OwHk0sXoZ+67FM09vPqmnXqU0RzRd/l43hULf4268+Xb/tlkHssUjD7wkX5iMJfWLKTS
         KYtj5TynbhvagTugXz0ZKFfW5mYFrd3fUMMYmubJfGNSea6GGy+yZDJgyanEUjeDj+1J
         rUlQ==
X-Gm-Message-State: AOJu0YyQt82sT90fCUcqo7fv4fXNjf3b1EwQdHsQvZtiCBj+yOQqIibm
	RZfvgSWXioF5M70ENM9jhBulKk9tvuFt7ruiXtgGf8jMwdVngD+Snwz+
X-Gm-Gg: ASbGncuA0XLLhaTz+UflpBPJYb48NuUCM3xynEHZU0nEVcOoXtNxc1R0l5cWpfFf7dI
	Gn8uZ0BK/U5+aeSX4wTRXVORJfdnaf6tmI1W/uKfhh/V12e/d2pzqvAR6Mae/dDUoAVcuJVLfDL
	WvLLEObsJ6GYrrhVGVxtaAAHdTnJCh3Fkbaq35VZHpYaw5ihFiJRShJ8kgLi4izgxeFc/sUhulk
	tEu2jXavWESGLJcgeWyomcJjBLMTfik3RydPDEvRWPxzk1IXRjntcwSYvjL7ef2vTU8Ye/SGX6m
	aTZBEjqh+7n0gimsXlIVVfqd8g/v7oRbSTXmoIUR12nrF75OA3QfBh9SbtRYHkbvfIPEPj6MXKi
	1cZUw1ZFJQuy/yQ+Vqog2mzCWPekYcyVDm0oB03fJi5Rzdh5okNvI8dB+BNWoEESkoaDnSslNMG
	ofI2+mLmQacjqVusNX
X-Google-Smtp-Source: AGHT+IHmiyWgOLaCOggvhZPPIwoORQ6P44GeIcmP22SsJkQdAGjOfRUpAYo47TvsrY1gKVuQYt2uuw==
X-Received: by 2002:a05:6512:b95:b0:58b:25f:cbbd with SMTP id 2adb3069b0e04-592f590541amr2974425e87.2.1761410865269;
        Sat, 25 Oct 2025 09:47:45 -0700 (PDT)
Received: from foxbook (bey128.neoplus.adsl.tpnet.pl. [83.28.36.128])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59301f74ba6sm792838e87.90.2025.10.25.09.47.42
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 25 Oct 2025 09:47:44 -0700 (PDT)
Date: Sat, 25 Oct 2025 18:47:40 +0200
From: Michal Pecio <michal.pecio@gmail.com>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, Niklas Neronin
 <niklas.neronin@linux.intel.com>, Nick Nielsen <nick.kainielsen@free.fr>,
 grm1 <grm1@mailbox.org>, Mathias Nyman <mathias.nyman@linux.intel.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, mathias.nyman@intel.com,
 linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.17-6.12] usb: xhci-pci: add support for hosts
 with zero USB3 ports
Message-ID: <20251025184740.15989ebe.michal.pecio@gmail.com>
In-Reply-To: <20251025160905.3857885-36-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
	<20251025160905.3857885-36-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 25 Oct 2025 11:54:27 -0400, Sasha Levin wrote:
> From: Niklas Neronin <niklas.neronin@linux.intel.com>
> 
> [ Upstream commit 719de070f764e079cdcb4ddeeb5b19b3ddddf9c1 ]
> 
> Add xhci support for PCI hosts that have zero USB3 ports.
> Avoid creating a shared Host Controller Driver (HCD) when there is only
> one root hub. Additionally, all references to 'xhci->shared_hcd' are now
> checked before use.
> 
> Only xhci-pci.c requires modification to accommodate this change, as the
> xhci core already supports configurations with zero USB3 ports. This
> capability was introduced when xHCI Platform and MediaTek added support
> for zero USB3 ports.
> 
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220181
> Tested-by: Nick Nielsen <nick.kainielsen@free.fr>
> Tested-by: grm1 <grm1@mailbox.org>
> Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Link: https://lore.kernel.org/r/20250917210726.97100-4-mathias.nyman@linux.intel.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Hi Sasha,

This is completely broken, fix is pending in Greg's usb-linus branch.
(Which is something autosel could perhaps check itself...)

8607edcd1748 usb: xhci-pci: Fix USB2-only root hub registration

Michal
