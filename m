Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A388204F66
	for <patches@lists.linux.dev>; Thu,  9 Jan 2025 22:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736460420; cv=none; b=nHkW78xbhUZWW9afHwhXmw+7P84GMqjEZXgerXctOsRo9oeXSS9iyOOnZyzkTHxnVlBWz6S4kd3uD/GAiuXYsp3NFAI3F0betm70MMJwyoJ0C6X2mVjInEcroj4//SDskCubmtPQ8z6Q4dvkBBB4MCUXZOzvFkq2PaL8i7hJQlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736460420; c=relaxed/simple;
	bh=6z84NXznKiE1NpRqFZDZSeRqLTK2pAiyrFfu5gZG7/k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=X5dQKCaLvMAj5gsp5+NQurxg+D/q6bGc817JNcr2GMmz4Ot4UwCWKt9BweEdA7o0BnB+ScuOqm4Pzf/J+yWOJnr2e20K/UHT+poAWbqyVl/1IkzWSLCkbWQphm3zqo9foNX/fwabwSg0++Vg6/qGeL67lPYnblu4uKklgpgDjT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=fo1Ho9FC; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fo1Ho9FC"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2164b662090so21949905ad.1
        for <patches@lists.linux.dev>; Thu, 09 Jan 2025 14:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736460418; x=1737065218; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8tXgQ4cb0sIkfCID//2h8RdPOUcbcJV/Yvr7tKk7nQ8=;
        b=fo1Ho9FCW+1dNTnis3XfYNl31vcu4cO+zBONAcAImWqqIV879RhEDGPlaWrfkXUjd/
         iQPR/JUhBbW/qhGkJWVPvQooZTcGJlSpS51eY7k+mKJJD1yNJ8+eL96N6SFqZ23z3KNh
         lVmnt8YigB6vEy+IL3YMBwqRnSOnqw7q6Fuk0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736460418; x=1737065218;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8tXgQ4cb0sIkfCID//2h8RdPOUcbcJV/Yvr7tKk7nQ8=;
        b=O1IpSZTJaf/xgGCA9FoLJdkMNY08o+Gt3aITmif/8Z07UxrDpB4QGCmuVL8daRWuf6
         PixgazuTCa84aH6wbE91yFJlcSr+XrDa6aP5tbfqQSOX5ML0/N4vUgSsCHRItEPov0Nb
         Lh0xVlk658d4UihfaAmbl3Ryrop4P/IbFIyX2uqtwqD1AfZ/Rd3PMvS7B5/abpB5CXIv
         Lavn1+96TJYfnRgSFMmnHS4vPyD60nMQbw+odwN8xw82jPHRiobQI+1VVJZ+rP/vRvnA
         2QWz6eFECe1MHZzNY70Z+dY00Uuc06VdGGboRNXZlj/KieG9qqqzkAdnkGlywS0OHrHW
         Bveg==
X-Forwarded-Encrypted: i=1; AJvYcCWEA5HWfuoAWmYVoKACZDPAs+ew7/NsPFzl+vef+IXPBI76OM5pBhylW6qWCgDp/4VY0GJ6DD0+@lists.linux.dev
X-Gm-Message-State: AOJu0YwOOh9j2hqPBacr5oRkpvolVeRfoWzrppI3bTSIE3X0gl//BjXz
	Fi1Y4n3a5T1m8gCWPZ35E4RhMizjYdXqgvku9UesiH8Kxg9hwucf0Czbp45t7w==
X-Gm-Gg: ASbGncvDKdtYPpLgGxVdIy9yVp46NMv2lOEEWNI6l86v6c2OU1WIv8xcqu6St5RcJZj
	D8nL8ka5b6EyxbCzxJzXKIuzOvB73CRmkYeHfSi3gZZewPWNyOcIJmssyMqmF9ZplnIVQLXRXDr
	OIxReJH1hD4bjUseParCPg9bDlKgHOS93NrdUpvNrUUXPGk9DSX2n6Hx/9MfzLtEfcBxGbbjeZ5
	GqA3nGQ/I0jDPd0pkwFzqUGVGaEm2nH9Bq1miPpq+5+Vfp9U9Y3Eb6LIEAlFiORPw6ZQ6AIp3Ht
	xq78XxujSgohT4rXwaoJ
X-Google-Smtp-Source: AGHT+IFbGsLInk2MTDokl6bXci0oi0ScYGAl8eACwvZ0JgMc+OuCQNESJJhMTrboOSbjH+j4yrWz/w==
X-Received: by 2002:a05:6a21:329d:b0:1e3:cf57:5f5f with SMTP id adf61e73a8af0-1e88d043d3amr12319701637.27.1736460417708;
        Thu, 09 Jan 2025 14:06:57 -0800 (PST)
Received: from localhost (129.135.125.34.bc.googleusercontent.com. [34.125.135.129])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-72d4067e5d8sm277650b3a.122.2025.01.09.14.06.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 14:06:57 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	chrome-platform@lists.linux.dev,
	linux-usb@vger.kernel.org,
	Pavan Holla <pholla@chromium.org>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>
Subject: [PATCH 0/2] usb: typec: cros-ec-ucsi: A couple small cleanups
Date: Thu,  9 Jan 2025 14:06:51 -0800
Message-ID: <20250109220655.1677506-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A couple small cleanups to the cros-ec-ucsi driver that was recently
introduced. Patches on top of next-20250109.

Stephen Boyd (2):
  usb: typec: cros-ec-ucsi: Add newlines to printk messages
  usb: typec: cros-ec-ucsi: Mark cros_ucsi_ops static/const

 drivers/usb/typec/ucsi/cros_ec_ucsi.c | 30 ++++++++++++---------------
 1 file changed, 13 insertions(+), 17 deletions(-)


base-commit: 6ecd20965bdc21b265a0671ccf36d9ad8043f5ab
-- 
https://chromeos.dev

