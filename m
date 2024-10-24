Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CD31FF7D9
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793408; cv=none; b=QjupVIB0LnVrMZpgy/fj8Dtw/zGRU1N5SbHeF1NOz1fOUbHcZrMe4oNjL+Fc5khp6WZ7Kx/HFC4s6/qoXZkSwqU07Gq4xyBJbP/4Gbp4hoJsTsnRMkaD/CHsQSQdWiILHUREK22QXnQtpLOlK5PXpsbhAL42mVteGpR3M2lK3YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793408; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEkIu72XE/1+35DAMyw021t1pBhnTbpIWFddkPoraFA+GrXIO2jfGUwC3XQ4imZH/O4vzUlj8k2O3tI94IqywCvcgV2bvQJqqWw4S2hNLWe7wYWAXfSFKFJKyV5ByzzMunf1x3EgViiOe74aH1ZbdlvlRv6+KiyAdRJW+OFiVJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q3dSpokv; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q3dSpokv"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2fc968b3545so13145041fa.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793405; x=1730398205; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Q3dSpokvlrI0bgaQ7sV5ew5Cxo4C3UPM8uhvtYo3Nvplg1edkj7zOqjwnPuyHYXHBg
         WHK3+u4QGB/2OhsdOSMwux0ffaEhK/9PxQhOtCDK9e3+ukvQc46ZQe/IOFQCCxCzIkNU
         hCuww9Y0c6sM4xrEGGm5Nt7gv4xkAO8sNeisbTgBrJ/vZF+Fog+k9qgERnXlltbz9bVG
         joz/YMFrKS/FF2IWj5SqlUyPpkKkVhLK4pCrTNzw3LodKEt7o/n+Uui2qz3a/hj/B3vX
         PBQgjUtlPdByiiLCkeut4p75mfY/7FC69dFQbJTELLOz6OFN6osmyeN5eryratO9FMCl
         N+TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793405; x=1730398205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=VmsLq+MKDs2iT/C3yl4df8POlppP3Zi6o+SJhZ37bMOco8EgdjydXhxSNZJX7vQFM8
         J7buZzUGSeq0QySSNubGCO5hDDM+r6BmAIQGMExBZIr5JbgEEmj5eBzvp2Bpf1Qy4Clw
         5LbVSAeqPkXFE62h7gC+VZWvGwgHJ/R+TGU1WOWxM4/8efELE0wZAa2Iom3n7l5b4lnC
         HiW98mm0QMKg8TVY7rDpPhaelvJYhsRPZo90fQ8IKbwHoTbLv0MpsF5K4I2EmR92PKSQ
         fzoh+ruOxKATcefrGJcT5CGeiM39hcCs276/mD8qIW5eeCCDm8S/xHgEx+UYsuZ+SFSl
         7uAg==
X-Gm-Message-State: AOJu0YzL0ZSEgeUfyIINq1B1axLTbcamhb5olNrRSYzZ8eZUNkf4UntX
	y0+BwYKpD2kt0G8rAwpidK8+O57pOeMlGoxOVPN2ohf93wvsmxQq
X-Google-Smtp-Source: AGHT+IHcLgkASoiNXJ0zmIB4Ty0MXRLXF2RBbST36SE9/QvrxYRR6z2oD5QYK6dwmHfFHSRiDKnc2g==
X-Received: by 2002:a2e:a54e:0:b0:2fb:54f7:bcd9 with SMTP id 38308e7fff4ca-2fc9d3849a9mr41730251fa.31.1729793404662;
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad79eeasm14645821fa.59.2024.10.24.11.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:56 +0300
Message-ID: <20241024180956.6203-1-vladimirputin693389@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <2024101835-tiptop-blip-09ed@gregkh>
References: <2024101835-tiptop-blip-09ed@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

You should kill yourself NOW!
