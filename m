Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1DA2003C1
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793389; cv=none; b=IZu7EFzIuTYTfVOx5ajc/oU6GzzsskfHDrZ/gCeYnFMmrI/q781daEc85FJ/pQUhA+tghDny4TPouDN/IG03tUOJibzTMjhcfDiTi2DjzadwqEiKWsyza8bzWJ7dtAaItcT4dF8+ephYJnUeeOflOuyH8nHM6TfLY/vryQsyH8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793389; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2cmhQFnvrw4lGZ1igyuCBI1+74vfFQ1v0bjxIQJNQ6HvFDpH50IVnnLkLArP1V0OOyS48ES5gtd9d8Kvp8B9ngP4xpLOS32gOwliqihmulc6FiCqmVLhTRuxizWjr0l1zDUz6/1Rn2eeTbNdYDVJrOvWs88Td/lyqUffI0YUi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CUW5JhWe; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CUW5JhWe"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539fb49c64aso2149599e87.0
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793385; x=1730398185; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=CUW5JhWeLRrU1NWDoTTEUU7r1vR5DQJtCBBUr9DLW1dWxv8L2BToyxDTmQ24ThSMF3
         M5MMi9WfMxcjvNqxg7ODK6LdDdhU30zD+VSAOMqUk+J5ZnUHJ9quuzQNXVF8cDWeCRrE
         1LbRBSw5gq9rG6/KsZH8rb5YrHRMhSBpGvVc5jqe+MF2yAOFr3XH2qaWJAJbcr5TYd99
         qbP+1e+pUe5F4vd4OhZC02IONQdVOz9214m584J4H0I3hR4ZWBaP3vWWwiClnE1xm9Ps
         E8tbKefOnMxOXz4WDA5chtM5SjLOkV5i8FMC9ye9c8pKhCbLAT6OlcaoOsBc0IvKr68W
         hLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793385; x=1730398185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=oaWkaclXyQLUF2+P280oQL3PmVlRQymr23E4DRSsbLRi9+OEGCIsF/mlh6PMCINRXc
         iEoYK+6v8fZhXPHmk8at0vcgA/BBr4HzN8OHdYcBVmmKb6WdxDbpVqqQb1q2zPqeRr2A
         UUg/V1UcuqnV6/IDVU88JgnF0Y3FSD/qlFg8T9YxjneUtIQI/EJq1lSo8fliKegikDVn
         hsTOM2LQ7hskDPsM22HmgR7+bOWvaCCDBmrlaYdbmY3nBNwm3EUL2wSj8umTGtcUlBMy
         H3V4/j0vs/0uEOXDsfS3P/080UKlKsKbGi5wQv8QKAHciZnN22oIjPm1QhLoCTjJLPh/
         Tvxg==
X-Gm-Message-State: AOJu0Yy4ntdIYntLn1UpcXeECZiIrYoSrT4lg9Tb5gWpEVcBUOeYkaaf
	rCVv6uqVpSxZo6LjldwgNHpr9t66qaGQbQ+EXNeM7um76vQu/KHXsJtpkqKS
X-Google-Smtp-Source: AGHT+IEPLXeGyQLaDoPo1VR1g3sZdvCVAzDhAhUq15wnfC1NdWXfWe09i+jDtf6afTuAYOL5VHdMjw==
X-Received: by 2002:a05:6512:b22:b0:52c:e17c:cd7b with SMTP id 2adb3069b0e04-53b1a33d0b8mr7217484e87.22.1729793384890;
        Thu, 24 Oct 2024 11:09:44 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a224203e6sm1428535e87.131.2024.10.24.11.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:43 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:40 +0300
Message-ID: <20241024180940.3274-1-vladimirputin693389@gmail.com>
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
