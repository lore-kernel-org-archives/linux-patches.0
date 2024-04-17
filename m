Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4A6FBF3
	for <patches@lists.linux.dev>; Wed, 17 Apr 2024 18:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713380396; cv=none; b=uBw3Z6x5np/NrLCuW3cq66TDGISnhpVGtgeIMu5tzbxaVzlkN6tR2PlJGc+vYpzru4np70xkJMg5N826ex+LPY4ZdCLrn4T2toz3lxoQzfrNWf9u+ESuhm47hDUKHZXTFK1tLooqwa9jc983BBM2H3SmVCaLjNr6vuiNhf8wH54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713380396; c=relaxed/simple;
	bh=BA12yhIn/tlwN3KcWEpZllfM7GcJgrUEZA6BLeoXfDc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fdb6jQcOxaTROEMgeO7MUDjn6KMGONZNwBDZr2BO/sGv0uWclA7ZIE0unnIoM/1jAXvGL27JqUYvkVdidthLFDxG7qM9zoruN3UpxUgD0BRorIfznzsGToZFk1OYqAWqjRyMa8WRgrLMf71tfAUhNmtunmSXmFjHCW7DaSsPfMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WSbUMM9k; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WSbUMM9k"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc0bcf9256so117548276.3
        for <patches@lists.linux.dev>; Wed, 17 Apr 2024 11:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713380394; x=1713985194; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xQae4cfX4NaL9u9eCz9LjDnsnMH5rontKvZj0HGESGE=;
        b=WSbUMM9kFJ7ySqMsToLLPZCz7vWC5QqKJMMj3evGV34/FH4GjOTZ05ds7NBmvWGJmY
         75PKuWCC5WKtVrIlz1Rc52giCZS9qlHGCVAtt74eNI690BhOQsf2VArHjE4nnJp2+UVo
         /1dlPMH8/G3NE0CD/ArHwrXZlBtr0z1Rcy2cbeY5/8Jas+fxGMmGabP6gbQv4eOprXIU
         Wc3Bh2Gsfkk1859hujwnv0Kb8RdFVLY11UMluBH4pTWt+0Ogso+Jlcg8xyAdA9qiQt6a
         PS3t4Dj+AdznMcP3uDBLQCb+5vQe4VUsLtPBS0zaTKhRobhcAgCnHwsrtL9E8uogJ9Qz
         HYxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713380394; x=1713985194;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xQae4cfX4NaL9u9eCz9LjDnsnMH5rontKvZj0HGESGE=;
        b=lXxZXrnxNgucqTLb11z4WNzfaKnbmKmdzS0IrhtvAVNKLcnw8LEJ2c0B6S0aQwwBac
         IKIuy6Mnif9al01QdbCp2Qvn+rZdpGgp0qfOg3kjkxBEgePfuTLudscF+B+Afivipehl
         WfR4Z8hPgYfjlIFt3xPBOYqSVvx52UQxHsPlhpbDujRjTCU2rtMG7DAhxKPOu09oWa8y
         q726QSj1D0wPRATxi8nNlVKG8DOQqZl+0GldzRq/jexlbzpoxSAD+QuUgOxUgn6a2gHs
         OUHgeFwu1RmCX6sHmW85XT0jj8/Wj9QMCGsjLjNhYmFbuFLTd1boRsugfeE6vCN+wK9l
         ptyg==
X-Forwarded-Encrypted: i=1; AJvYcCVeQfX2N4SY/2tGot7puFhAUP9fdsayeaUOaa4qrrgp6YXckXPAlpTIp1yeBbTn0IR9ygDbSAK4YYz9QC2MrHIg90Yz9jA+YQ==
X-Gm-Message-State: AOJu0Yzcy23Pa53DVVyanNEahKedMcQ9Y+L+B6fOy2t/n//fSj1zjIad
	Av4oxxVkz7ac/YPMFIjm3TZMQbVcVnsrV8lcLpVBM7TCR1vOMRvSTad0jdI5xMlUzfJdkM4Gnvy
	6Rg==
X-Google-Smtp-Source: AGHT+IGLW2W1pTs3wPgozteR9glPETjOgHDdfcxzf86ViF2A3bPyNslXaVI1lvNh87ZSztdrKiw/9LObPqo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c711:0:b0:dda:d7cf:5c2c with SMTP id
 w17-20020a25c711000000b00ddad7cf5c2cmr22957ybe.13.1713380394327; Wed, 17 Apr
 2024 11:59:54 -0700 (PDT)
Date: Wed, 17 Apr 2024 11:59:52 -0700
In-Reply-To: <20240416211941.9369-31-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416211941.9369-1-tony.luck@intel.com> <20240416211941.9369-31-tony.luck@intel.com>
Message-ID: <ZiAcKKX_L2MNOF_n@google.com>
Subject: Re: [PATCH v3 30/74] x86/cpu/vfm: Update arch/x86/kvm/pmu.c
From: Sean Christopherson <seanjc@google.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

For the scope, please use:

   KVM: x86/pmu:

On Tue, Apr 16, 2024, Tony Luck wrote:
> New CPU #defines encode vendor and family as well as model.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>
