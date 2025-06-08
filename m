Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567F78633F
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 16:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749401834; cv=none; b=ugldqBLo8cp18dsCOvgTLGBShbu0wEwfVtZLQioEzta3h1bNA5+Pb9nPLu5s7OW0Fbb3jOTlMmP/9fmNOHUEcXkWmUbKVQ9jcK5Zq+Zea+gFszL4t7ZHsVR7Xb9PAudaag3aOrJanGjlr7GUgQTVNs1DcejPdAZHeZk22WMnSAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749401834; c=relaxed/simple;
	bh=V97iY1Sq/zaYk+CjyZO3kcrQTN6xQUok5+0Jb8EJswI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vss2A1gNeR3OutIcAPHEJ+oIiITj5+IuoblZmjg5osnnSa1C6jQYgrBdEBFKEVXtWbk4xJKrE4D9PxWzTs4wUSClt8MjmUq9VAYn3Ip31ohs82N1dwD2D1QEzkgOqICqHxV7MJKR94uMlPrp2pMNKeR1zKZSUv4PGqyOwYhitTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AvOSw+g5; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AvOSw+g5"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-313067339e9so531684a91.2
        for <patches@lists.linux.dev>; Sun, 08 Jun 2025 09:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749401833; x=1750006633; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V97iY1Sq/zaYk+CjyZO3kcrQTN6xQUok5+0Jb8EJswI=;
        b=AvOSw+g5H2Sa2aFTw81HI+8qSw+4SEDW8R5rcA+PkC/n9oxG3ElUhwjS+bXuVhdQuL
         vaL2sMIFCiUkUkgw7vgusnwUMRZwFDyU9ed2ERVP3bPMUOBY+gY1hyvpvVw6hK+HV1NT
         WHlMrxRcegAxTbJBc4jd8VRLt7k7SMLKNzNDRfxVmTswontUuNywWYOS31OBqoLxe0wX
         EZmGXfLI7U0d+aqAWK/dznSDxifU/hC7Mlykl2zW/ybveNIBldLLj82qBBbgVMms+GFB
         7WfNgPdxitLCNkacI1bqQEW2SddaQICQ130q614oLxIaydpxfRRHBEjBPIBkUmZO6q50
         2qnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749401833; x=1750006633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V97iY1Sq/zaYk+CjyZO3kcrQTN6xQUok5+0Jb8EJswI=;
        b=imHPNGsyRketSEJoWYij+jmVZCQRgphKeKt1M5bfhFGWCOlE9CQjfzI/DkocBv+VEM
         pmw+V/WxCucrm/bDU6hoZMHw5NIobC+hc1+uPF8VUIBSGyIRLmWYMC+ADMXn0YaWf7dD
         03ysEyk2oWZLQ6Xk7MFkDXWtTMxe2Kn854nTBM1AlVnTlmuCUmpCBGiix+pKdHcku8Dn
         fm8uKDiyiB8y8MW4shOe7MImUBs+1FZYRodXCoURKFJhPe+e03epJDk0sDbdupVWT7KQ
         fa1ZoUPAK6o00fVVVxoU4F+6ScnaveRWZ6UyCQloJu1aOfqZRMWdNAjVKUk0lL3SIcqd
         D1hQ==
X-Gm-Message-State: AOJu0YyEAAGTDnpZ5CzAj5C7FT45NbxDH3kDwt4aGZVHsPFB+M0tVMf+
	I9MLrWrOPWiNowWZfuiwApisIDLSdMjUFamKa052lvzTBMyEoqKfw9SFez95QHs6W67X1g+XPHm
	BruKAWZMl9Bf76dFJ+L2Ug+ZQOJrR/m8=
X-Gm-Gg: ASbGnctREV9qCOZ9qzClEq9u7Z63W90Wfhr1PJTMYfJnH1LQGDwR7B6M7LWbzx3uV5/
	wTfRq7YTeOVGKVuDdiZh7pAx90Lb8pCLw8/GcgMqH8BStDDaBpwkcL2WX2dFUbXQAcWEBLv0QCc
	ivBA67nYx8cL14jtuOVdMzwFi4xsUVqhOVJBkqr5oTiqY=
X-Google-Smtp-Source: AGHT+IEn/11AnIHAJzGyPSjYoXDr3J0HfM90GHhu9iLYWLiUi5kqf/09bR9Hl9j8YAgaJ20xruk04JEWnpV075/+d1s=
X-Received: by 2002:a17:90b:1dcb:b0:311:c1da:3858 with SMTP id
 98e67ed59e1d1-3134debe401mr4991508a91.0.1749401832725; Sun, 08 Jun 2025
 09:57:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250608125527.934264-1-sashal@kernel.org> <20250608125527.934264-3-sashal@kernel.org>
In-Reply-To: <20250608125527.934264-3-sashal@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 8 Jun 2025 18:57:00 +0200
X-Gm-Features: AX0GCFvKosMGvMiB-oBY4D2DWnpstHFS6w1KStG5spKOTYbIiFQlSfQdEsHubVk
Message-ID: <CANiq72mnDqq1NftH6Y+u+Acvb1wL5M_7kv8-4bum7zUW6iiW9g@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 6.6 3/8] rust: module: place cleanup_module() in
 .exit.text section
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, alex.gaynor@gmail.com, lossin@kernel.org, 
	aliceryhl@google.com, gregkh@linuxfoundation.org, dakr@kernel.org, 
	trintaeoitogc@gmail.com, gary@garyguo.net, igor.korotin.linux@gmail.com, 
	walmeida@microsoft.com, anisse@astier.eu, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 8, 2025 at 2:55=E2=80=AFPM Sasha Levin <sashal@kernel.org> wrot=
e:
>
> **YES**

Same as: https://lore.kernel.org/rust-for-linux/CANiq72kEoavu3UOxBxjYx3XwnO=
StPkUmVaeKRrLSRgghar3L5w@mail.gmail.com/

Cheers,
Miguel
