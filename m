Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D377E208D6
	for <patches@lists.linux.dev>; Wed, 17 Apr 2024 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713380449; cv=none; b=oLk3CqobTaL7bYPfohnEcY3NpG22TnDeI7/+C/j+Uj19V1ksRzLCMJXrPclIVweIRW8iDgKJlrtyReH8QDx868DiHGMLu9mN/SrOorQhtrUysjmEMnoJZ8EX9ZzoIZ14QbAibou5RU+pJeSARgIRBhcXFt4wn5BbFtKZLW8OGoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713380449; c=relaxed/simple;
	bh=01o4dHuglQVsTu+PcICGhK6gJNVEOr86+0KoEPkkiwE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z43JZ2tsKl+3Ow5ba6O2suzMyTEEMXC/L0qeMuhG7eEIpTHjVRIGimWjY2urEUuKhinvxlH5ZnZnXgiH+3LTaG4v9ZQzHfRgWs04XqS6uI2DOOsy9FRDRGRYeUvYWWjSeJKUPN7svJqlFEER3l9IV6YquMeCnygclOQ6O6ABvUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CHifo0e2; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CHifo0e2"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-610b96c8ca2so96724947b3.2
        for <patches@lists.linux.dev>; Wed, 17 Apr 2024 12:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713380446; x=1713985246; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vfxuAXuPWvmyvdr5+9PlGKbmbBIGocadn3UYl5buNro=;
        b=CHifo0e2jaNuCsh+d6TbEVnnkMRbJeRbacxjSg+nkXMtRW+wgJWOha4PuTnAdFJ2hE
         eqYf2D7O6YUHC8yjQ7q5E3fYO8Gs8EZRNirnh8rzKvQLs/0XHbhSABpR7nrlOEdngMRV
         3egwYadPFbfy4PJG8On+21ck323labSdL+cJjQh9MA9IsZvhK11BU1Wigl8NoBQrJKOU
         YMK237zNKdUBmWCZ5b2iZ4TT+SSTWalpcJXGOsTIcD+fHTRBtDBxSmB751Pkgh2PL1Rj
         oB4n7KY+Ytt0JA2ukByFoJfMar0hXL6XLl5Lfx9SD5xeRSXEHmYxpDdQ09JxX8qn9NDh
         T6Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713380446; x=1713985246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vfxuAXuPWvmyvdr5+9PlGKbmbBIGocadn3UYl5buNro=;
        b=WLwaZRlCKb8RVdZiLLCNoC/OVblW+Rtg2n9ENrGj4R55dLfHCgPRoRQ3I+dtdNZSQW
         IjE1mp5vPFiVezettpfb2vGk3aJ1h/iKCEQWNULQaSTvrERhcxg3bRWq3FhzeEiWTPJW
         yf9maJ3GaVrVoNPhr+0YVd2ZR93mwIAWSraNMCzjdvawKFr4F5+2ce26DUWweVwwdISi
         UDCsqn8l2DC9aiIXD1L8yCa8WOMoed1zJTeaJt4UfJR/fhiaZAUyoK7uPEBIovtCMvjF
         +52SOf35E6sCZZ7oJH43ftJSpsmA6vtW/x6SSx40gEgee+KyoaA+6u5136m7Q9p4pnEk
         5sSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpPiDug7b7U9Hdz7yV468Q//E6Zu0i9Ems5Uqd3VrOFkIs+/bgS5sefaPb2jMxfd3f1l6qHD81OTZOYzgJmwlOVBzpoCPVEA==
X-Gm-Message-State: AOJu0YxkYh2THqmEU8r5woX6UbyRUPXPnAkGmIy/ebq/zk0SyV760d9S
	0es7PzpGQfVIspkGtkE579xUuzXUuixArVm8l/nK+pJEAxX58f7SZtjft3QZpLwbOKSEEs7Ttjw
	cag==
X-Google-Smtp-Source: AGHT+IF1El6IZGCeA7PMlSPFtdTtFo9BlftsZ/Xw0iunvnYRq58iSoQFWMf5DXWl+OqcrZTERay510JNjxo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ccc7:0:b0:618:859e:3f01 with SMTP id
 o190-20020a0dccc7000000b00618859e3f01mr21635ywd.6.1713380445908; Wed, 17 Apr
 2024 12:00:45 -0700 (PDT)
Date: Wed, 17 Apr 2024 12:00:44 -0700
In-Reply-To: <20240416211941.9369-32-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416211941.9369-1-tony.luck@intel.com> <20240416211941.9369-32-tony.luck@intel.com>
Message-ID: <ZiAcXCQBy3rBFKOF@google.com>
Subject: Re: [PATCH v3 31/74] x86/cpu/vfm: Update arch/x86/kvm/vmx/vmx.c
From: Sean Christopherson <seanjc@google.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

For the scope:

  KVM: VMX:

On Tue, Apr 16, 2024, Tony Luck wrote:
> New CPU #defines encode vendor and family as well as model.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>
