Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E8D31E821
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 23:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780615526; cv=none; b=LdIBUwk/In50YCXGCKy2dft8myMaqEVJ8Epo4HWdy8MhwCUXhM/fCv/VCp3ashgL1E0GBnmbi1auY6eDCnMNGfR5wvPulyzSKEZjDDPEibUWOZ1luzJB1rrCgYABRFlXMXAorfGNJycYSWRNneULH90Z41YjF0naHygfgM0EvoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780615526; c=relaxed/simple;
	bh=YcOxrIBH2BpZdGTvyCaML4gFpZ+luYLhgZonf1vLcN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0IteuXMMFjkToWwa7QM+DEulLOnvy6lopDCXcF4me/vMIZ58hfiPM+f9Rr8+BSgskjfiX8TA+W42z3f1H3E2KH0fVmNc5i23LyNoHlYck9IP6dlvLf00Qk8IOJaOgWkEJ3suvVoPonRf21vFN2psTM1B4OAH4vV64K+mfk0u9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WPd7/09T; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPd7/09T"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-46013161068so640772f8f.2
        for <patches@lists.linux.dev>; Thu, 04 Jun 2026 16:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780615524; x=1781220324; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=afznK2o04gyhM0m9icIwY9Iwej89NrlffaDAhI1G0qM=;
        b=WPd7/09T3U69rxyk3isCTd9gDmq35Sbs40eiQpBc/lRxQZMbCv3toOBJJozHVUOqqG
         +by94WifjwjXtyBHzo9JbS7nldt0UCtLGyrSLYSCKVhRzqzH6X4HTST/xlGbba8BdTxk
         eYvs/Cwp0SOMFZIKMVXTvDUI9Ij/6jX2V7cUn9efga3qi3EieWBF/WXd2gEFJArWIDph
         TwcD9suH4OWmkNnWG+cGwKascPrTttNXPqy+jOumWJ14gyyNojHNWpJl1LEKafvPmBNl
         wP7dnwMsLh5I3pzVmCBDMJLHeoB+Mp2DRyn6JnJUvqZjAfw+JyJzyaKQAkAlGMDhOWh4
         2nag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780615524; x=1781220324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=afznK2o04gyhM0m9icIwY9Iwej89NrlffaDAhI1G0qM=;
        b=pQ1N4FpKAUfYu4wwIUew9tslsPBpWi/MfqKVv+ggLHMgydpzalv+F6Duaadm2VWPcP
         6V1EtM6XuwdoPDdJzwmuAGCfKw0GBJh6N1XIbCKh0uNvZHSvn2QNpl6cqE5SWlp3W5OS
         nZHSUWmgw6eEU8mf6rW4HgvWuWni0sVprtsERNUBNHWAvUloVxfmaDAFIzF+AYTRuBcL
         CTuY1t9hC5LO3tfPO16X6WLvU/0epFeX04SjZkioJDwPDnSIaw+2ucvQu6SO+/7tFsZ/
         2vY/FqmsrS+LUcqHtpf5SlDPbDd5VOH0769QqFdB0rrFhVOCyVM5ZtXV3MsEdO4kCY3Z
         MBjw==
X-Forwarded-Encrypted: i=1; AFNElJ/s39FwG+liSz5WgLPwy8x82CHkQ+9yqT2Dz07LLyvdUOZDnRFXVPWzMijRFEUep5CYpAO/QUuO@lists.linux.dev
X-Gm-Message-State: AOJu0YxuGiZGb8w3cCtAURxBnrATnpktHYr4ky0JgmvZk9QUHZeNJvZP
	6bRI5COn69LgK+q6JDFl+gwIuU7N5rE2eZbCAKdDFf48Qc6tHZaHaYkG
X-Gm-Gg: Acq92OGAVjYR8qlaM6XnO14i8u3klejB0b4W9ztkzEniWti+XCRvIxDdxDVL5cnfk/T
	WFqjFhRXx1Zz7iF5sABxzlfaf8cSq7yc47qCQdlaIhETTUaVoSX5ga94Cwbv3dA9eYhiqI+X49L
	qZcKShTKidewGJXuPBCKdtGcCRTaVzViPgN03JQfgtUpiqGYvA1FyJvYW7JQoeAL+3fnqWYx0Ta
	wVfAQ2b86JpvRvtKy5hzPGt8PiRW/75kGQZ8XucfNriKkfeS5CZP+ajjeZrweyE98epIwZ/iwPT
	r8IIoo/xs+p867q+ANRzH0PyJS2LNzf5lW9n/KUP4bMxtu7roEf9yShB1AkNu/rFwSLdne8pk+e
	xNSwV5vMsNTJKk0N5UgJgyXmU4aQ5nhdikqzp1uIk/XY0D5dD1INsaTizhN1UyqiG7h0ivxB8De
	lagdJCUxHhpN6wVH/OSp606EFoTKtetQ==
X-Received: by 2002:a5d:4e49:0:b0:460:1ab4:6623 with SMTP id ffacd0b85a97d-460306429a0mr1128044f8f.27.1780615523601;
        Thu, 04 Jun 2026 16:25:23 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4601f3529e0sm20375107f8f.28.2026.06.04.16.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 16:25:23 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: david.laight.linux@gmail.com
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	metze@samba.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Fri,  5 Jun 2026 02:25:18 +0300
Message-ID: <20260604232518.1896014-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260604183829.63c35fd9@pumpkin>
References: <20260604183829.63c35fd9@pumpkin>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

David Laight <david.laight.linux@gmail.com>:
> I know it has mattered elsewhere, and is easy to get wrong because
> 'mostly it works'.

I will send a patch, which will change that argument back to "int".
Hopefully today.
Also I will add that "wait_for_space".

-- 
Askar Safin
