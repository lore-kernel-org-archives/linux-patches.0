Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7DC1FC7D7
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793420; cv=none; b=O9deX3fDpxLoJ//o/n54TOJQ0oS9Q5Lh+0mkp6z9sLc0q09+PPaUj3519YfMOXINSF6KgGjuWv5KNHTB8eVFPmS2Jp8Rfnq01qIdjJGen5N91BisRz1V2WPtIVahLS5hAt04p5ylFAmg70o74PNpNVrilxS2tKeQIaL20i75Xss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793420; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjoyrpLncVfqttbifN7QK+7h3LG5ETArFxSeM06rNYeN5T4GuUSs/+xSN4obB4mq/KjiVnguRQbVZr6uuW9HP96+EytTdnCeK7elaCksNKH19zs5+VOG2Z5Vjc6HTemC8T9X6htcOi6hNDwKk03+J2q7UGXcaavZhqXBsEvcvvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g3tMa0d0; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g3tMa0d0"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2fb3da341c9so14071901fa.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793416; x=1730398216; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=g3tMa0d0a16UfBoxN9WX36dj1bKqJe6uwMVGsC+cJBxFR1o5TLkIldwiIqEK6Y7FV8
         Oz1BTR77o/75Hf4F23w1s356vVv3mz4FZZKD00wpUSXToKIlrTeJqNs88ZVUIAEMx21J
         YqD7Jxy3EjkljZQJ9CajYLshRf6YmSPp2p4leS+s4ZGlTDI8b/nu97AHiUH/kkvNcYK0
         bLetGE4u31h2yYQSXCih2caCC6uIdN/EbfsgBS3+64q/RBWqSHPGbMY9ld1O7HtT69+A
         tGXE9nMBWV1AHG+DgPxzMrHn6dExo/RR6VtP3CGdZCEcVMjIR0dBwa9/0K3gN1SgdiVD
         DJBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793416; x=1730398216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=I+Wf6yXvxWEmNwAGcIpU1RCtbmj5UwMSsZQVh4LXBRRSjvbv8Pq48dzdNc0L11xF4x
         X2y+MrCR0Pv+GWBMxaDKm/XTJWN8IoYUPBnTVnOrQ7oFx5CEfMHUq1ab11HyIZUzZLys
         iKJOsB5+4ZyH/bB3HzCtUSuh7niEQF9IKbCo5PGsmYzoDm5Glapyin3t0mHIuN1F+F1s
         JDcpfMHxzzn4mgK0Rx3vw4iGQWkoMI4hZa3QCuHSoSmkWwjessS6n8dbIp9RsA0WLdjs
         sfWvQ71pA69VxJo73tSik4Dn0mfCfXLqIkKNgxn1FaFhDMnW084TSaQ5xl2LFUV4Jces
         KDpw==
X-Gm-Message-State: AOJu0YxPKfWM+Elw9Nlr22O1tt+b1j4Ga7UM6JNRkhU1btrujpe4/u1N
	hmBMn3BPfTfWGwgqzt/h1nkvDlCIXSQ9cNaqhm0n8z6cflO/5uydqske5lgb
X-Google-Smtp-Source: AGHT+IF2ob5xeLbvZH+JdJoYc9VBaZTXxpZWoXy7rv/lVcU4htDZGZGCTdIGzzo8+qh7iCgVspic7w==
X-Received: by 2002:a2e:a547:0:b0:2fb:5035:7e4 with SMTP id 38308e7fff4ca-2fc9d2e54camr43829911fa.5.1729793416298;
        Thu, 24 Oct 2024 11:10:16 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9adf84besm14352481fa.86.2024.10.24.11.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:15 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:04 +0300
Message-ID: <20241024181004.7459-1-vladimirputin693389@gmail.com>
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
