Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2823E1FBF50
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793416; cv=none; b=i9fTM5/QjlDzVdFEWQR7efZRWE0AaKKsmbJXexy5u3HdgH1yxnujVLpTNQLP2ZGsezZXZFqu6XB8dSvN1XQluefaktajnZ++mlV8Or9yQ29HVZuBZbUhDNdE5syHTvsb4p1ijZDK5PPOSEiYQp46WLMkloBdB2OOixdNIK/aXvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793416; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUMa8F4JPhNTXzedetNeGEQFt3R6QtoxG/Nh9Ego5hucMH9mwNlFobWYNG9IgDK8moAkP7GdfSEghctT+tcPH2hwsCf46jUxnllxwnDQpj7dQXqfu0laO5YSezThtlcxktSTDEqnxESSC+t8M6N7Xq9Tnrxx5LdLnigdI+nGWoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I2ECOACH; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I2ECOACH"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2fb51e00c05so18905271fa.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793412; x=1730398212; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=I2ECOACHH5Dd4h4vm7gLAK0bnQOQklVL338TsWXw23EncFQpLb+3XW31tV7PiPja7u
         o3HSf/30t+Q3cUKz6lJ85ZcRHHAvqFt1RuGdByu5Y5aeyZJlhfnuTAdHqikBh6ZMCW3B
         GRW/5wGolJvo3XTkVuHFw4rWIG87QQZKTswfQcYN4q2vrybUu0r4J/nITjPvzDvtEsjS
         vwzETOPOU9IwQ0YF3PF/YuO9Q+tUWCyVLm0I5oQ0jLMMbYX7GRMOhx+SXCqFRaNBXIAI
         eJG2AYbLfc5XHIKW951zBrmG7qBzgt8L+LtfPdNYiPWuPadi94ExgSOAwdqH6p+BljrO
         Sw6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793412; x=1730398212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=vaEgh3lPl8vWk7osb0VV748NArWN864tMFD6Ty2U9r9gzftm63qjePEObPxV4Msftv
         MDcVRZAU3PYNbZNNaCXeDWle0EDbB4hceCDXFRGn8/3uqmfVe4EG45PCeB/K2ya3EAUa
         woc9QQcwMcqgsbtOpV00f9HKnf8uhEHiGpqqeSkKt22flc++pnD+DsOle3Wsg5u3W7Zo
         TCGHVQ6Rrw5U22XTZO4CYiu7EfdAiSrywb14aok11hwYFmWvsXPxhA98dPqLQjqc30gm
         1814zEhKoY/rRx4KcLTu7n/ls9+o1HRSttWIa6z3gp8xCYfc78vljWODv8pKUXBMdBN0
         OIKQ==
X-Gm-Message-State: AOJu0Yx+1mpWi+CnYtAQb1G8b3fbebCI3mt/BKxnKEeDumuEqmOPaL8R
	g5M7VPr2rh1Vm1hIpG97cT4qocp61fleTJdASJnFbi+cTJYBVKePwReWaq3l
X-Google-Smtp-Source: AGHT+IG9yz50BpnfPkgRYAfApJoTQ2I4kVSEgjfFIBNw2mrAeLSdUH7PPJ9kw6+w65ZTrwzkdLAtfw==
X-Received: by 2002:a05:6512:3ca7:b0:538:9e36:7b6a with SMTP id 2adb3069b0e04-53b1a34d04emr6992837e87.32.1729793411970;
        Thu, 24 Oct 2024 11:10:11 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e55e7sm1427559e87.33.2024.10.24.11.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:09 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:00 +0300
Message-ID: <20241024181001.7044-1-vladimirputin693389@gmail.com>
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
