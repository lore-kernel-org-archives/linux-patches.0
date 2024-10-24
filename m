Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406D2200139
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793410; cv=none; b=AlNSFgpDXZCj+2E6GuLYgsb6g5doywUnVCXhbwNVHHvHfo2et+wDzZq58zBWg9rzaITzxPjVGV2DlsSdlLUZQ5qtoy6YP6USaG1eMGRjBvjBL+ct+nO8YblzzRsg8PBv645/gfteZE5rq7AB4mry8DG9RPt+0ck7T5yVMpN5Jz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793410; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFzg/i25T547J4S3erIwxk/4ckRdsKXu8ljqcbXgTPOfW9MYWVVWDdPLJ7z+1qlhORojZSb3WuSoDrLxIQNODoqhkzyhkwAB/TiFHpeBxC2oVKuWtD9nxVR2cD4LbdPzx7itlOxLx9UL3KnLBJgJv5Fw+l3EpwnEgD5jYXdZb+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VNIj2Tt0; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VNIj2Tt0"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2fb3110b964so10765571fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793406; x=1730398206; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=VNIj2Tt0eKqNGnUEnRjAYPVEet3vDvQpqdHUt/iuMft1wBoyuSlIbH+HrgaMUXEJfn
         KjmhinwTd0IaS4TDxd3L36kTfhrQjJQ/dIJHJH5sM3EHdbdWhE2BTJvQ/pAxEtupfaVt
         /DNjT9BU2/Fk921zC1di31UH5GIWwY3gUauCN36XPCRjUtXj6U3wKNMtB6/d6qrxfzAH
         tOOpLnSzN2OJ3V9+jAfw1dUPAA0OIGGDyKflgmu0jBuxEaNc76xycnUfx3oZ5c7Ix+/G
         /EMKRBc2W1I3H0Dp3mNM92YPFZrU4KTQNe15mvExkDsYCmzmZZ1Ctc3eO7GaEjdcKBLz
         oSWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793406; x=1730398206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=QE9RDZf/vQjCeryKkk8PyUFqfpOnNXUIiQQM6LdtaiQAPQcymo8Km5qIfcEZPh8PFe
         Ira9Dbf+l3cyvemdJzq7BQvSiy7Ouh9i8lEax7vU8ll+68vaxyEpubqFYaKP2VOe1Dt2
         h8Pow6ZucF78QXncIemN/m2AJHJaFXb6z6xaSzosfQ8rs+yilELSZdgPpQM+KwnM2kjk
         k0Fun3P+Enc+zuQqXIFoSiq9toPtQUrakIb0qYKOw/8vPEjkKeLNIjYTIsorZyOvHE4i
         qH2LGYsjVs8WCyNrAa7Xqb3Vi4d6XWo83K5y1Ydd4dLjBmybOFyR8pMALFgRbQn2KvbR
         /HbQ==
X-Gm-Message-State: AOJu0YxKiqQWiytAkW+39zEW0/Pyht+GIW4VvtfX4bENUlyFTJJe4mpQ
	tWVVTGDfZyP3Pfpi65rGxY8r5+W8mkTLks26r9qlLAFA37y85bK4i38t4w4k
X-Google-Smtp-Source: AGHT+IEvz2VROQnEaF9RcK/Ot3tCtofaaQGgg3oxWYwRD89xR5XJFdsCHHCihXaFOPIdVGPF+kitLQ==
X-Received: by 2002:a2e:e1a:0:b0:2fa:fc98:8235 with SMTP id 38308e7fff4ca-2fc9d38ab28mr30797381fa.42.1729793406287;
        Thu, 24 Oct 2024 11:10:06 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad8f1aesm14748771fa.70.2024.10.24.11.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:56 +0300
Message-ID: <20241024180956.6336-1-vladimirputin693389@gmail.com>
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
