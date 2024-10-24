Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02F02003A6
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793396; cv=none; b=SRu6zeYe95xXccRhSQJlV1DmJx7WMf9TgfkMGKnVL+CLBXLtcX03C+mStw1WnVCpGBpmaUM+Sd6Onuo2ynXQ2oXfET4YiCe7iRwU7rxCLxUjHryjtaG8/tsSt6CJeb4CP/xx4d3iO/JPECwoOkWIkE7eOe2g9H2Z8kieWfhoekA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793396; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCQDDjUCyksrYdEC7Zsip2059gfI00bw5fvYwlhFfdNvhDXapGNMyJ+gCqnIcNkvcK5bsXLt85TBmd1D9wwJmWNY4sBUaLp1ciIg8fQpeCLcQxBS/dfzI5wQXhaaZQoul2vqpHyyh1FY4UpsfLRLbfYondAt4BkolKWnoBPcTUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ha8pAG96; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ha8pAG96"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53a0c160b94so1543563e87.2
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793393; x=1730398193; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=Ha8pAG96hZpp9GOKd8iiwsy4NRky8+hEGMFNQGv5I7CYY6B1QRmEuks9UMjdydc6NI
         i3ulgeXMgxiVmgsWzFYjo+qD4hHSVPkNLAKGJ67aXv+puC6rND3cIoLcQ8MmJmASci8N
         8Rpp71f/g0BrfcyCHxfErZVSn+LW1OcmxvJRiLVBCIzZjE83bZbGLi8d9GMp24Y6mj+O
         fMz735+OYAp8tMYbqQGJ2WzaE/6Me7Iz5ktLV3wx8EmIbukGVwvLq2rR9Z4LMeFhV4Hv
         87xvIx4u3H696xQHo5hQpk1+VFtnSpP8+Xh6yRpjYd2QAhjhxWtxwuz4dQatj8Eyk6n4
         imiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793393; x=1730398193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=XZeDhnbW+M+CBDMLdqV5TlgSfN6XnBnVtmydISJTxnd2yBAxLt++KxrlGR71foSx3u
         nelWwc91cUQmgyIz/P1w0ILueRdx+wGUCSa0A8YFgd7Ey2J3dslpL8cojI6w1kWJYWbd
         LzxzMakWRN70kfu0WPjd8E8+tY+EUtcla22RisAnvKMXfQ5woiU4AJQZiAhvpBNNhqu6
         suWfbolfL5ly3ljX4AxR52Xx/OjSE2Bin2UODWJKL+FjnNyg10jDO8QzP/oyFByraSgW
         HAaK4sz43lipL3lBMkYyGwbrtXXhLJOAV85uQqqTOZ6r+pvKy5domSY1HjoBrt4JHv/s
         XWhw==
X-Gm-Message-State: AOJu0YyC0CD6HI9jygDgkuBmmCLYDuad068iP1LtTebawv8NybB/Qq58
	/DzUvamPTW41DJdzySohugWqNs+vPUHqFhOhOQN1a1Rdmwb8v0b/
X-Google-Smtp-Source: AGHT+IG5czLxk/6NQTA3aALReovOwgjSLR8V+zWZV03xn7uLjfJe545n2eSBUuX8W7wwlLc5PZMEoA==
X-Received: by 2002:a05:6512:318c:b0:539:93e8:7eca with SMTP id 2adb3069b0e04-53b1a321d31mr4125255e87.35.1729793392579;
        Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a224319e0sm1412383e87.237.2024.10.24.11.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:50 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:42 +0300
Message-ID: <20241024180942.3634-1-vladimirputin693389@gmail.com>
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
