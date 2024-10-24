Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75BC1FBF50
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793394; cv=none; b=pa13yWj5VZpkLqA4HQo6A9vNdLMJ6+NV4JCATQW5s/cEL/+AVepNhfUBeI5IzAaebxGxmfUnhz7m9na3pBn8BRa5mmYWg4DJxzvfs8xLsyyO62Hvs+ts8YZF7b/TI6PyMlVr7BymXoyzA8P2uiVjT5g1gVOI6QDIX1hOIw9vRaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793394; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+HNq7uyHldOr+h7rJPuDuW8WtbOu1kevvmmmdcUPlU2CPcXxtarhwwTWq7Gi5w9dOAzjJ6E4mvs0/mWx65tbHi9XzO4tohzwJBpVu/ZyEV0+PDf8MQOLtNvXAfXcvV/ncudYYbKlo5TRZITgJg6fnV8ATJmoPDc3pPGo8uSuXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QI+sGjP/; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QI+sGjP/"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-539f53973fdso1015599e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793391; x=1730398191; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=QI+sGjP/pB+AeqbGl4yL6q9iYtW4mpyDvngOyN0hMFXVY3lvL1w3IVnYGBHGAPIgvL
         +Q5RbmmEDN/ZnNECe93QPQhj9zFuJttPaCct1uSm2fBGf+v79Ch48VGfmttsxS8lL4S8
         xoRfpYGerbzDdHpzvgP+FnBqiYJSMW8ZpOHn7Mo+54g0sGZGnGkUEbpkKfPcKHyzKVeR
         1eYXJa3AnykzESZMcFAFTCODZFWsFBHKjKC7MB16hiC+zt6EgRvRWpjXwYSVPyaZgkuF
         tZbjMR7hR5jhYtoRgwDrM8H/X/nHqbnuUzY+VrvH5Kax20jZgNu340Cd+Ajd5oR/dvgn
         4ngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793391; x=1730398191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=ZRjj1ODxWOxJbKPvjbb2p7RC3ikmqPTi9DZLKk2I6+/kUJrtVnV2ij/ae7DXbHb9M1
         RRmY2gLKT8DRRdp0w7qMzoFEDlr1o3mLBojo09Ttu7C13OZZ+RJMjHxVOmcZRsPlavqV
         ZIKrBOcFZEmJVDCvHUtxcVM5A7oxlierpENEiZTFirlVae7mUYmOds7mMP64OLAEiqz6
         +gY0NB2ILynxk31OfZP7uss5VuARYWBqwkVU6jdP4fXflklnB9sWGuiUGJze9eoiu+QE
         mQtAi8Y+BLhbsomVj6hbYR8zXT6GhzN+R6vJ6/h/odL87T2VSJX1Ci0QwNAxesYKd7Rt
         TAuA==
X-Gm-Message-State: AOJu0Yw7ZwcAw9+sVEAiEMBKWOG8ZhZXndMxwqbMzhLm1am+YYa2/nt1
	frVNFZGUBzSmoCu18GVmNCvFHyBf/w+2EVy5quIJwfUu/bGrm3hd
X-Google-Smtp-Source: AGHT+IFFqBw4In6iyBKiLwzJc3SfUeoDC0p0URixHZfwUmuojTsJz2yyrpT8bbsamlLRzd9tuTwZ7Q==
X-Received: by 2002:a05:6512:3b0d:b0:53b:205c:e979 with SMTP id 2adb3069b0e04-53b236ddd54mr1092719e87.12.1729793390601;
        Thu, 24 Oct 2024 11:09:50 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a22420421sm1432217e87.173.2024.10.24.11.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:46 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:40 +0300
Message-ID: <20241024180940.3280-1-vladimirputin693389@gmail.com>
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
