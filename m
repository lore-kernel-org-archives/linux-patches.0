Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906CF2003CC
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793394; cv=none; b=j2j1ysh/l4cSeggjRmdfhBR+DBHpH8BKyx2xW8UVA6vIPqY3Sz/6YkGssYkaptYwWpJVGAxc73laoWUSFo32FzFCKCVU1qbWsGc3QEimnNqrjy4mlaAKANhXxJ7qo9Lg61rKDraFGQ/gz0bbFTcM6w/WIkx8m0+pCLyfCcbPZic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793394; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqf3M8q6ad6E87gMgBFCuT6//zOfSLZ7YgHh6ZrcOSEXcNMapOz+yNufPqUY7Muqosk2uR2Aa4n7Y6Dl5lK5uwF9yMpl8lP6ue8OHjdDwDrvYPDBepGMEK0+2380QWL8QhM1fWHIKZWcZzJAIeBY7Lb4jDqrdX4dLCGLXdEMwBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S37jadhJ; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S37jadhJ"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2fb59652cb9so13064071fa.3
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793391; x=1730398191; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=S37jadhJpqsdaqqw7+1ggMwFoFFBFtLepEOKKg/svaTtLEcF38eN+ZjEdQSzFulczT
         8V1RqYTvVdUngdge9W9liF33NCmf7UZzU6XjKaXIFVd8N48CZT3e5ohhXLHclhtQCh+5
         wChq4HGr6MQwrbUBp6MXxVz/gjxPzdg2qnAyaqo2cbW/s3t9iA6zIkkPFFXrIL0bccQe
         YFBOHFPjXYVIMMw/53BD26sN49ox2aaJ3xH3osF12vrmxngA7eALDqE5n+wrER4CBkUN
         WjofABEFTbvZuz6MjCE10sKaROWJ1IM9QGL5jT8MZV95oF1XR2A44zgeBoGv+0dFvYJI
         Ewag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793391; x=1730398191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=vvJREz+hXm5BSHZQmIRQDOhKu+CsczXb6cXia7kdpVcE1vARJP0U0wTL2Ducu8//I2
         mbQepIrFAv7R2d08qTLfESUTl9YgW66L+ObcLXTD7ayCeRKQxMKtg+xfOJOuWWmnxu8q
         foQDXxxfw7jng5iJrjbssI7jaer39KMg24/Ur4G+WzXxPcoRxVySyiLCGPzvQbtdlZzg
         8rBnkfnncoTVYaTo0XReNbJpm7ZyGNW07zrjfUj1xjmqJYd+oyygGI6IjMa3aiyKJExj
         e17Jt1ecun+22d4vE/2hKrjuopVzRMY5WCEupNqpA1RU3bFMf3/A6Q4s4Yx4/IL161Mf
         Ry5g==
X-Gm-Message-State: AOJu0YwEAxyP82O233alRg5lu+eswn6J2xHTKbA8A6VVzJHuoS7DZgZk
	wD9l1be5RaoK+2vgO7dkHxKL9QI0TRo13RNKWGrm28tatPXb65qI
X-Google-Smtp-Source: AGHT+IGuymRT9vcFP0JPjP+GHleLlNGiL3OsmWBmBqBIsRpIxOreIzGpn1BwgCD0ABDPD8C7saKFxw==
X-Received: by 2002:a05:651c:1547:b0:2fb:628c:2580 with SMTP id 38308e7fff4ca-2fc9d32efb3mr42884561fa.2.1729793390416;
        Thu, 24 Oct 2024 11:09:50 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad75bbcsm14216401fa.47.2024.10.24.11.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:40 +0300
Message-ID: <20241024180940.3267-1-vladimirputin693389@gmail.com>
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
