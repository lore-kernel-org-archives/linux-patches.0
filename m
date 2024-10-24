Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2031FE107
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793423; cv=none; b=XZsqFM29dBYIrvJdbYt96+oGZmirqzzyd64NdioX6bz+HosCmphZ31UsR1woqxEhUXnJaxLw4kRp5IyMr9zY0+5+yWhiqN5yQMef4K/cBP+2gSUaIZ9/TKG0+3C4e9ozRe3TlNNKMJcyM+LVPHLTdr0Ys0Xl2WyMYXWrdAoyhDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793423; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUHWy0FRyG3ttlFgzg/AMDSQjJuZgM1s/DVtzPjEeaBRSS4Ep61J0/2zuMabjeUAaHlzgINv0TzXheXXpIFjlCH8FekO5VCo10Lsv6WkAUtafvMAIemZwLyepUwYn86/M3vfjeZwZjfgRFkcp8/dHhq9f+ZhalYCijYYIoOuMSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fzjd/z1l; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fzjd/z1l"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-539eb97f26aso1277763e87.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793419; x=1730398219; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=fzjd/z1l7uu6eKLMZo9QMGeRA9nqMVy99mCLnfKqbasIqFwdde/ng+7T8t/RBM6ahI
         y9Qu61EEPxXPI+6Km3RRpr9oIX0wcz520EAreO3Lxfbhz19mi3TaywTbMBQRqKpvJNcn
         NpaxclHoCz5/dt1fIi+n3DKzNLGHYnvBRkrGWgyo28k7R5EiCsLshSbpQuIvlR5DuNkJ
         95Hg0k7WnGRPWUQr7ZsPaB6E1JzLWF94NvqUnptrQQi2CE8aMcudfcHU7pUahik30Rfd
         DclZpBkHulAhIV1Vgx3pY+ny6CgzxkMc7IO20fzeD5fFxsZB9dFe+upt1Anjpgdk3bZ9
         tI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793419; x=1730398219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=u1IriIsj7IMJGPeDBgBWUQyFIuGsPLIa9mGPtEUjK12ejWLYHeAoi+9Ix+fr0zD8Sb
         dLz4tKJHOp0n803a+P3KO4FZZlXJXslmzOCxokFEXxFOItVhXLUvCv9KSkEeuIRUA1ve
         b2ReR07nRWgzpKKYGPa+0P2eroCz6uJkzhPv2iFvwtAcBZeP+tqILrTUKudLndhtMf/q
         W2Y4VFds+NDjWFfHHbAVF4I90b8/HkxjfGD6b5UpZFp4lliLfghwvpT2mAMvdHUm0r5l
         MZeviksflLLwDz3zqnlnalnpjs4yF0j0iKbJmkGCLhdDkfo7VAGBztaONiy3ypn0auuQ
         4ufA==
X-Gm-Message-State: AOJu0YzGG1tLvqpl83QlpGO8fsgxMAJl/kCOL8EXUfPqoSj6nz+8rJ6G
	qbO3SqUsis/63GyOG1bobJDrLowFJdfp9WY5kLOvcF2PQk2yvq5gu0fHD0Km
X-Google-Smtp-Source: AGHT+IEOFGB9ghuMr44gjiFA0I43S/p9W8r7LJLo7KLAa86XoYzjfNMQhc1eZTT8IMgvdl5Dt8iVVQ==
X-Received: by 2002:a05:6512:12d6:b0:539:f37f:7d5b with SMTP id 2adb3069b0e04-53b1a39b023mr3741924e87.60.1729793418555;
        Thu, 24 Oct 2024 11:10:18 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2243158fsm1437929e87.220.2024.10.24.11.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:16 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:07 +0300
Message-ID: <20241024181007.7947-1-vladimirputin693389@gmail.com>
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
