Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9251D3195
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793400; cv=none; b=pgvVeRmNbh/+VVsjNNwFF2S4O10+S37SSjC2mORhxNwGQiI6mt/XyN7SmkgJfiiXVQ9KK4nnJav6EObUL12yEVczddVXoxkLZTNPeCl+fhTG0s5sXOar2a1oKQ3MLC5F3HZo8LFdnFyf6xMT0U1uR57JD0DAym9U68IbjkJd+B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793400; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhEaSqI6FvVPylg1zzgBDxHNwZQOiADKV5Gmptc5IBYQvXbkGYBwoUKYK9zur0QEQsiJjEjqakk04SGs9ipU+8jgDcyGYbv6Dq/8TRkkDQRNco0fMvsx8xD/EB0HiRCT6nP5L5LuO8mdUlAWN63c8skqQ3CKO4Rb+bUk9aeBWpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M0t1HzJH; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M0t1HzJH"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-539f76a6f0dso1212490e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793397; x=1730398197; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=M0t1HzJHH8YSCJ0obC9oP7jXIlKFDb4Wyv5rU2qRAm8C0mFsiMA6iCnx2IzGrrWWtQ
         ISy0T4/9O/e04UsQMOUTjvTJh4RC+wzixwPWBENIVhpAWvppiMGmO+nivEbbVErVy3/r
         ru95oVs3CF4jr0j9iYyzSeG6baLRhPaGXRmzZcl7AsW6WdBjzNljSBP5PCiLcPGEOI90
         d2udLV8TeTQDqmjCHbGHW3Ow9JIED9pYrjMTpguUzQz8F/sQ5B6XPt/Ed65G28pN268C
         Yw17RisXmUkw/ErRtotGQZZeXGWNqJA/e8nHHFW1SEFXVTIeMpNDYpjayzD2gPugngsc
         I/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793397; x=1730398197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=DInIfr+UztD3IGotDS4pVMzPDo4tTtwgy37vTkNOjrR4VryD0YS6KLTINlwz1XrLn1
         CLnlMgCgpLsPnk/BZdCVR4GUTxLM8PbCD/8GLLRddVN+KHTygQ7iqQV/eWuMQBNSBpAi
         gdUMoOilY7JzH9kpC4AhCYBYgRUWuzM4h5rhGyIKvLaQN6ojutlCULxSkcuaPMYuKi4J
         dYhZPNpUPazbZKg2Xbiqd5G4dOlGMG2ShO75eV5+UbsJWxffnMKL7fjxQtDOQZ8MmLAO
         A0f6OwYs6rWgN2MLDKPNSzlJGYVjSabpfcuDgCss18BcWirIOMKYYfYDM+z3IDjeIuxf
         YFAw==
X-Gm-Message-State: AOJu0Yzf/zqC6nQXOdAONPdIpqwpTtTX5kkWmMMi0c3zDECMsgGcQpFx
	+X8cb5aelfVRTZH8tXXzpX84CYw2Tq4JRwd8+EeJULboSBrEw6Sq
X-Google-Smtp-Source: AGHT+IG8w6wDYMznpcYi8ij8P6luPgkLHSziv8enUfc1g9Lu/LIWLgiUMjwnqagcBiNTpTkgJ/unmg==
X-Received: by 2002:a05:6512:308b:b0:536:53a9:96d5 with SMTP id 2adb3069b0e04-53b1a3084c0mr3959893e87.17.1729793397193;
        Thu, 24 Oct 2024 11:09:57 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a22420041sm1430786e87.158.2024.10.24.11.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:55 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:48 +0300
Message-ID: <20241024180948.4772-1-vladimirputin693389@gmail.com>
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
