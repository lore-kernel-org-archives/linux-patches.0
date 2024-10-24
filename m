Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7621A2003DA
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793391; cv=none; b=XHJu1V2gz0lT1kp2cHAnNE2QNTHdNEUQR0U7YTvV2VJq0bJI4b35Bdi8/tYm+LoaqIZyfWJVPQVLJR8hXGGXsJOvONKt61jKpF/H9/YlbDOhxK5ZuuXPOIwx0SWZPblk19PKbFpSQrMG0mxB1bmq6PEY82B/w4VmAgpXUxIVMEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793391; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U55MtR3LrFmoXbc7sr9ilMXCdQInjvk3ZSaXShnMp9d0EP2F+x1ge7G/laUv5eU3zvTRgUhQpqR6hEygnCChPPTVWIzrffWfI0elLJ2uV9XX2VHMoCPy8dLLORck8LDohm/eQsrytogKrhik74wYkIlqgKbyjnwnINUQgkUeCKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bwrHbJPd; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bwrHbJPd"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-539f76a6f0dso1212244e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793387; x=1730398187; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=bwrHbJPdX94JGkCCOStTbA1XO2EA2AiRGXRA1qtbB49Yyj/m05AWWN4Jyz2keOLfyt
         KIuTKPfRsuWFCTE+fp/4i6doOxqwW7qiO9K+WIokSw4UIfF3pO5sxXlLaO7VIHhVIQeY
         bmuLAQsjvsc0mrUZQy7HFkeD2EH0MZjatCmEP7BgTHkXb6iKB5+rYg7AdKeYbmw6JLB5
         rTGE8oRgTXJ39HcSBxwFnOnqIYEWBAE30wkUYn+LrbhM+cTUxZmFRhaHk/6z/RDufY5B
         nnEljMbqJeWF3/vzYoFTZJuWz37cnpZTIS4LQBMMJB8S0am4fEut/CZQVMf/IE5+s8Eq
         p4JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793387; x=1730398187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=bXpZmjbvYfpkZaTZpw81LMp9HuH2gThW5Q/jDTAJRAVd0BRzaWrLpfm23DCFiEeK4c
         Rtnd4BDin6rl+n3KqdtURzqeGEfNPNzUdcNPkMIPzq9FJoc3G2KIB4hglTSMQP51gi/D
         EDzG84hsqN4+T450qWMQ6DoVx959UN4nlCC//oCM1qxLqODGwd0qZ4HrZ1kR0jvXINF0
         1TX+Do5DdTlvNYDZFG+y2cOPztI8GjbHwvne6nZZdvGOsgEUEappyXX7glATsUGg1HeD
         9xccFwPO9JB+7vejj0I/M6Rfx5lhmFNnDI2OxFmx1S+W8QvTxW8HBJn3VCPPQzRjxkiV
         xvBQ==
X-Gm-Message-State: AOJu0YxCUicz/tsZ5JSf8B4lDqXdMb8KrMNU3qATstTSmZMXIcepFzpF
	Wrw/iaRzoDe4gCcTkBhkR+F0KvEC3C2YEBayEVGIlrKmpQgmoYOo90foJq8F
X-Google-Smtp-Source: AGHT+IHjViKO2hJM8o6GKq0hMjv8A4xxj1FNI5q9PzhCXG9Z85JPmrro0IxWtidowyJItg0v9zaubQ==
X-Received: by 2002:a05:6512:2810:b0:539:f763:789d with SMTP id 2adb3069b0e04-53b1a36c638mr4379422e87.43.1729793387161;
        Thu, 24 Oct 2024 11:09:47 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a224322f5sm1423020e87.236.2024.10.24.11.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:40 +0300
Message-ID: <20241024180940.3300-1-vladimirputin693389@gmail.com>
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
