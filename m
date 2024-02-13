Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B3510A1A
	for <patches@lists.linux.dev>; Tue, 13 Feb 2024 18:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707850055; cv=none; b=rRipyn8kE0AKxfdxglKfXGGYcEfzBY+ELm8ATVjTdA3lbHVbGjHBW1NXkSy9lgdGhf8YagJCrdjbQ8KHZBCtta6um9StrvXUa1JmqHvUbm8tacLp57hVWfEaW6lushnxYLMyZ/VOxRPNouIP8ytVC8HpsH2UIXl1SuGJldA0xy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707850055; c=relaxed/simple;
	bh=C2M9ewzmBBAwLW37reArtWIysIiranwPC/tKhbBZn/E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uy+jk+OvEjbPaVieWiFfI5mUX1ezmQgvp1C68N1oM3FWURea/9jDMbTmxcvgCN3oso/SWHy2+zL99j2p9olJMaefeo2pKnh8d3+ZeZVQEStCDtmCSWhde1DirKKOOY0cCf3fa4O/ZC114wg/VEpcPxlDPcy1cbuXuTglbNs9cIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K2aG8SGb; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2aG8SGb"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5116ec49365so5383575e87.3
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 10:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707850052; x=1708454852; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iqGRxMNg6YqNolmEH8Z1CBl/hkUAAWON8BZtDgDHhVI=;
        b=K2aG8SGbSKMaRGbjW+KEw4VlOsP+vzl2A/D0/40z9sYOGkZmkZJQKcHRDW4i2JO7xv
         68ewi+K8LKMwN/2iIGo2stwx4aFxeAe2oC0/zdbeSZnRoGhXV5sHV3WgyACcBr+dXXI4
         b69LVRe5MBphPdkjkb+5qoPbV2aFAYQjKag6dcv+hl1zqPSQo72QUjf+MLYAEc8aquLC
         rN4egEm0uU7HNeYfFiqpId1qJvMxEcaUVFzC6rTQk6SPQ8zA7cUd6qZ6pk3SsZ0Y+dYr
         PklshKOz/8xg0FgttHRTORZicEqP36hzyOOxg1kcVkOeJxm0JinLIgt0BOmCP5wbj3tr
         ZUAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707850052; x=1708454852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iqGRxMNg6YqNolmEH8Z1CBl/hkUAAWON8BZtDgDHhVI=;
        b=JLy029VlHisyabiD9WgbXBXCHAQtrZbJt+WwsPYXPA6q3g0iYmZnvbJy+HHPsADbII
         oDwNVUTKC713hN7O1UIYIfvvTEcbgYVv+DQQecRO2M1sfB1QdHRcoihNgk6jLZK01jPl
         SFF3siHLr4pYQ27qdtIBO1azhfNlgNcysDcrxWNFUVX326g7a6KAQit11cXiUmTPpd2x
         qw/h3gPGpkTizVOsJ30OHs3jdIsPmjGQS+ad1vo/zOfXQAAqOF+l2UM+8Utj7Eq+3XIr
         XS+BeeczG57kNxQLEiyRFraiWzS3Ddze57iSQxe29rdJ/hcYQ7dlAVb5ZB1v90t/rPWr
         Gi4w==
X-Forwarded-Encrypted: i=1; AJvYcCURgVIhRfDwoVEBFhR3bRUvupFAPA1t5tuq1ePVlI8xCGozHPHqFVs7YrpLWBymH6mEFYTWmQH51deAdlmkIt6j8Nq33wxvuA==
X-Gm-Message-State: AOJu0Ywt/WLbSIjVTd64QeLsixtdmEsv8R0Zso/KPZMpkclGLYc4yK2w
	cLZiVaK/R2BRt17ioepNSJdKV588EaIrBiXVQSy85oBK0awAwCji
X-Google-Smtp-Source: AGHT+IHrkxoyUQ91Fnm+yXUC2n+RHvl3TubDysJtvp7WFp9zQyKuZLUieqUgSux9eqSeNoQJnn9ieQ==
X-Received: by 2002:a19:6451:0:b0:511:31b4:ac16 with SMTP id b17-20020a196451000000b0051131b4ac16mr268419lfj.47.1707850051859;
        Tue, 13 Feb 2024 10:47:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVSF13gpNMdWWpkl8UigK3luvug0RdomM9JnCvQ0YJOu6CieO5u1V+l4zBe4Qo9PAe24wkIGxieJp4hQmC1bNm53dsxyH13RnXcRHSB5ryNiFQBGxbcUUDmF4e9XNs/HD7axnHciPU=
Received: from foxbook (bfh204.neoplus.adsl.tpnet.pl. [83.28.45.204])
        by smtp.gmail.com with ESMTPSA id q17-20020a056402249100b0056163b46393sm3860108eda.64.2024.02.13.10.47.30
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 13 Feb 2024 10:47:31 -0800 (PST)
Date: Tue, 13 Feb 2024 19:47:26 +0100
From: =?UTF-8?B?TWljaGHFgg==?= Pecio <michal.pecio@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mathias Nyman
 <mathias.nyman@linux.intel.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 6.1 53/64] xhci: process isoc TD properly when there was
 a transaction error mid TD.
Message-ID: <20240213194726.7262e240@foxbook>
In-Reply-To: <20240213171846.401480216@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
	<20240213171846.401480216@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

> 6.1-stable review patch.  If anyone has any objections, please let me
> know.

I'm afraid this patch needs a little backporting for 6.1.x and earlier,
because it frees entries in the transfer ring and this seems to involve
updating a free space counter (num_trbs_free) on those kernel versions.

There may be other incompatibilities, particularly in earlier versions,
I'm not clamining that this is a complete review.


Related patch "handle isoc Babble and Buffer Overrun events properly"
depends on this one and needs to wait until issues are resolved.


This is the problematic part which calls xhci_td_cleanup() and bypasses
finish_td() where the counting is normally done:
> +				if (ep_seg) {
> +					/* give back previous TD, start handling new */
> +					xhci_dbg(xhci, "Missing TD completion event after mid TD error\n");
> +					ep_ring->dequeue = td->last_trb;
> +					ep_ring->deq_seg = td->last_trb_seg;
> +					inc_deq(xhci, ep_ring);
> +					xhci_td_cleanup(xhci, td, ep_ring, td->status);
> +					td = td_next;
>  				}
