Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3F21D3195
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793387; cv=none; b=kaQjtFwhIeXZL0l2AldR6l+9Ye1aE1Ah0MS1YwDFzKznDUFKZ4FPLnVAJuvi6nKtqiTuhZrtaMMMWR4hPrzzd96TuEVVKHqpe3bcymmm8keuYVZ85E5Y35VnQWQq7gvseLZZwh/biemOJaTVEuanHGisyNRkfn3vLwu0uL6l6+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793387; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiQgVWKV1fWpPTWnsImMo6ufJcGavKmF+yR1znFwhmMAQaUTkyiFYJOlCZKcv1XCSMcLbZGm1mx6ZfCwvQo6Yxtkfr7fQzh+YA8UEjYnQFhRyyCdilLmWgnuD3uhXFPeVLBtQRy3q3Yrkzh6GZTDFrNSYDCOYAHBIha6p5G13Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FFmjIq3j; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FFmjIq3j"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-539f8490856so1169259e87.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793384; x=1730398184; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=FFmjIq3jIiDr5ExkKloeGAdPsiWFP2JFF+6NjBSc6wsfdMnWzezCjMN5RVAPxwK/6x
         EecsH40x8pK2GxCs5kQNfy4VR1E2yGSwsMd17mssYd6yyfn7CSSNhFw70mzCBiRWKaqp
         ZxU9ys8Uo5RfgFjs+UnkBsLlpaRZaIJUm1J+gL924EswK3jRPOfRa80+E3MlVwedZ5DU
         mpYemgLDA2l8Urvqmp7W6EHz7TYjnWrKu57d8uD95ZuJhWHXDfdBbkCJs7EWQnvAbtlK
         SQgZ7GweSlB5UBEwJC0X9J5En9R/olk/w7u6YOuUy5k77speHYwoVJUYZK17DzvGF3Wh
         yibg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793384; x=1730398184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=gKyAZLZv9bO9ZFnj6tSyx6rlLdO7rjbwDI8JT/0mCgiJe1dXEWVSmCrMBJ4EwiB2/g
         3G8bW03VREJTK1fOc+cw0vTYm1RVnEMWv3cjUe8YXtahfmgOzK/GsXNxfVSfHpkHUEo6
         BBn2epGPGXJLUwp5Jg2+kq3rtCF3KePiZ4lf2znw5A4kbRg+vNx/nb1WpsFHyXiDg1NM
         Ctlch2jPDD2LBR39oORBBV3OBRPZMG7z5decHPckUPyeM3PSlIZIQX0SUNGfy2P0/PLW
         AllsVv0mpILyOPU4Yem8EB20eRcTFqL3yKOwhxYhsRhx11n8xzUhSXsUCsquWwld1EoG
         M1wg==
X-Gm-Message-State: AOJu0YzcCALmS8WSUxyrXvwKJmJX7o4bTEO3ux9ssk2vOfkM3eqYcGAy
	oGi/9HzIQF4jxanUkN38bGCRNAH7ka55RpGOVKBVoga2QdwFOiShumdWjYJw
X-Google-Smtp-Source: AGHT+IE6cqy7lW+I83Ni3zgyikhfcnT6SUm6mGehruB9Rjiclj3wrcOJ/RIguvoCjWb7NyVimQhYCw==
X-Received: by 2002:a05:6512:224f:b0:539:f496:aa88 with SMTP id 2adb3069b0e04-53b1a3a18cfmr3700225e87.53.1729793383683;
        Thu, 24 Oct 2024 11:09:43 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a2243eeffsm1429949e87.268.2024.10.24.11.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:43 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:40 +0300
Message-ID: <20241024180940.3257-1-vladimirputin693389@gmail.com>
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
