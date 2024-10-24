Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DD21FF7B7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793399; cv=none; b=XaRzrsmKQ1PBsavmuaEEDJGn9s5f/CD9JqP+cUeCzFGEfAMzak+tIimmhiKYjSBU2WAGmePJm5aNHgkZf2O4SAcMcbKgBVFAoHf2XTczv9SBw2F5MI9doR4etDcmQRWx8KAv6cLkovmjZNV3VbF3LD7Aq3fLxebLAO1Z9UfTXZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793399; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhtQ8ed/l8pJgrNhPS91nL6HWqQEh+eJupljkoVOkrmihpVYDAqj8ahNvibl658FL06tImR+87AUZT9ie2EJ/B/zotIcry8EBnsPe4zM/L7OfwrVL2cgoORTIvL+BR91tQTL+yn2+XPBIQVJliqTmbUHIOcqiteNx0SXUsKQqdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OIrFKAo4; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OIrFKAo4"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-539fb49c64aso2149882e87.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793395; x=1730398195; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=OIrFKAo4nfV8mYOwmwDp5V/1IiGdKvBND6FyMyEqySXqTkcZMCU4YXuZH5oncz+TE6
         51oLX3S39Kbh0A8lSi/i6nTI1FcJHe3MZHugerOY4XaqqIRDT3djFB93mfLeR/cbyBTz
         BxrujxOE/pu2FcsWKPMzHrYCE2zcw0cjtXh4wrye07jFkoCEWpeWkk4PGIszZWolnLQp
         vP+6heUm04KJ2kj3OW4iCtAKqtwprHcs2V9Vq5iTuf5/cyjueo++50K0mNFkfvC+3yPY
         RdX5zqsXv1eIDRfAgHJCHixKNcXuyXvw+W9rlH4hJsHmlYaP949qjl2m1VronunimJeo
         /nAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793395; x=1730398195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=hRhERoyLlFKA0hJiW0Psmy7Fje2uWDqXrwnHCuAuq8uMlH/rq8EHUhUMzFP9uRVpGm
         62WuH2M4Cm+QDB61amQD9tSkEIlu1dLyXFGmvup0BBinu1ITzPlv50is5z1mFs455NED
         cnUl1HcCJWTJOXJjNDxzXBoEzZpc5uKKfBTqh4nZE/hw2zex6Qv+OyeeZhu7uXyMEQC8
         ZY0vlGZwkrq9T6ymWqFbVQK/eILD9GnvEp6VDPj1qwABXA682hYK2aEpJZonyWJy8YJ3
         4KX9q+TfJ4RnrXOeDZEvGoqyGpHjHqSwpL3rjkP0ttNYApPHiaMn90/wpGpZodYwvSRE
         r+nA==
X-Gm-Message-State: AOJu0Yzv5S/2bEj1eH+5HNMmHpW3wTN5/1g9+foVkgkUh8L5FxSYm/RG
	srScKjXUF7wzrM/Nm6ELTeSiBg4z160hiNPbknp+qhtJNt2ZKACx
X-Google-Smtp-Source: AGHT+IG3FNazXNVbPG6WGxlB0yZb83xmV2s0rUB6K8/u3fQvx6J9tIa+JUhVcT/V/7UV8SGa4mXTkw==
X-Received: by 2002:ac2:4c47:0:b0:53b:154c:f75d with SMTP id 2adb3069b0e04-53b1a34d059mr6783823e87.31.1729793395201;
        Thu, 24 Oct 2024 11:09:55 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53b214a6cf7sm345834e87.202.2024.10.24.11.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:46 +0300
Message-ID: <20241024180946.4370-1-vladimirputin693389@gmail.com>
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
