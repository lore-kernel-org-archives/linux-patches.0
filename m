Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E074738D68F
	for <patches@lists.linux.dev>; Wed,  1 Apr 2026 07:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775029604; cv=none; b=tewGn2p/f8y667bYdTCWokj09Ib8dWo7smK9hziLjjvYn9oP3aoDbQDZPAzxA81nhiYHy4EdSO+duEjO3QW+qyXFAG1JwwXJlocDXMK29oAzj7QR3nuLLaHETUwm7J9LRISBJzPiLo3tp2ZkbVwMykto7pRvc0pdZV1JSFT6yv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775029604; c=relaxed/simple;
	bh=ZvycyQZUJfXCLJgPVKg8hrNxNwulOZXfXf50yiF6FBU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FC4qr7XDDzRugT4qijpUyGg71EJV+9wApY1YEjzI9B6c0gzdWuB3WxFGt3NFW3VVYihxTs6Saps4TYTEblnctPu3kYZUjVOGQ+1eASgSO8J4qN8WyYekp+kYH670YCtrcajOdXlP3H//VAzIjhh9sxEovYgdvzb/Bnel7UKxL+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=luCuayUk; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="luCuayUk"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4852c9b4158so53331245e9.0
        for <patches@lists.linux.dev>; Wed, 01 Apr 2026 00:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775029600; x=1775634400; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sJvZwOWMHoXwE5ggOVVKWUiXU3/orvRsQj0ayyHjWKg=;
        b=luCuayUkt9j50TUNPSI+eX3YgKeOKrXSqcu4jVLzjxg4+xV1/QxWPg1KDtihunWRm3
         3n0KNlYb6Q4Qr4wdehiTmLZKnxkIItHA6ztM04uk50vFTmTEOKwOwM8RCUKju/1otwNL
         1kIKDxXYi0dXfo8Xl0fpCfJk881KyFHUmJ+3b8HEUOjaIpKv9xGTf1M0fVsqOR7YdR+a
         WVc5GZUsYs2T5F+mdpcs1SH5ot6Y12Ksc+aODhGV6ufO+Vp4O6vxxWNIE8IatsdcIeig
         3VFjagkFRSTezwwQXNiGtUUf/1d6z853rqho3cJYUrMIFJA3IwXWvgaeg3Z6eM4lyjYG
         5xjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775029600; x=1775634400;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJvZwOWMHoXwE5ggOVVKWUiXU3/orvRsQj0ayyHjWKg=;
        b=fNlBNo4D+bTorriyWw5T1ROZTwHxLExU3FTrQ74FaBjy9Cyt0GXbNAChDC6P7jjyqd
         YMahDxjfe63Wo2EEuWqgD9WI7HQf8wGKLeqYgHdW/XlLe2TcuX2+YkOOzhezZ/7+/DWO
         RaXs5WxRzTv/G3KksodjimPpyMVx94SI7DaLLUpLNhawgwU85doK99IBkX8R7bEF9TVX
         gCZ+p7w/gtzf6ES10u0Bt/jiMy3J2O0PKDVraeIapLntcJgVmIOQ9BwMfjcx3TIvYDyB
         +J8vvMLwDUYpd9XcE+EatFtgfLYMoEMXDmtAUh9OWzP2IFU8Mc7rrgkd0YrmD/H8cb/C
         mAJA==
X-Gm-Message-State: AOJu0YzOpL/PzxbCumcLHoxqEBPB6RR+v8Q+kdghnDHI+yjUuHq6IAWW
	HLHhwODQJSN7wShJlX/yHpzBVZTl4+Qtl8K0/oLPWpRI1akwQisy18pm
X-Gm-Gg: ATEYQzyFSW+gURieDoGThNjt64wqpmpnUZgrrfTWAA29++GNdxIhe7NFFb2QEtlZmkI
	rbT2IN4+OsYsXRuWtLAPaAEALE30GaJH1M6qI2Bz5q6T5lBepeytUPwfA9MFFS49QyKAOkTYw8R
	i6yjAGHsqBeypMkLf1Jx8IXjQ3EAlvoiNJbVsTn25fJa5wvhlO1hdrGsHUSSwFsJqAmqCwQzPW2
	VUrZhbXLPnixx05LnIdBghxBW1hxevYpmYkBRYwc/CfzBjRxGdCd/Ijv7zNiydAjejA2JswrI1f
	2fHe3LDttlHVRRpOotSd/32ldXCIaiLfRNGBPRLt2CgzaLSjCnzXWgr4I8/7RVy2uXjF+gG2myG
	GbeN+0esPTMep7TjxUauGbDxnsTwSMSFcnAXKvWYomyDnmLrTUhRsAOgiKQYHNi1Kq/8bIN5Lnq
	aeVWLiD/34cfvgDJJsnWowjqAV/BYg5w==
X-Received: by 2002:a05:600c:c04a:b0:486:fe23:1707 with SMTP id 5b1f17b1804b1-4888359048cmr30934405e9.20.1775029599965;
        Wed, 01 Apr 2026 00:46:39 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4887a630922sm130219545e9.0.2026.04.01.00.46.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 00:46:39 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: patches@lists.linux.dev
Subject: [PATCH] .get_maintainer.ignore: add myself
Date: Wed,  1 Apr 2026 07:46:19 +0000
Message-ID: <20260401074619.988459-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I don't want get_maintainer.pl to automatically print my email.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
Andrew Morton, please, apply this (.get_maintainer.ignore is not listed
in MAINTAINERS). I already sent this to Greg KH, but got no answer.
And this get_maintainer.pl problem already caused unwanted emails, such
as this:
https://lore.kernel.org/all/CALzav=f4--Kp5vXz5zrxZR3WVsa9T1GF4NFFtuf_Q5ESMHmWwQ@mail.gmail.com/
---
 .get_maintainer.ignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.get_maintainer.ignore b/.get_maintainer.ignore
index e8d2269ba..60b6b2a37 100644
--- a/.get_maintainer.ignore
+++ b/.get_maintainer.ignore
@@ -1,6 +1,7 @@
 Alan Cox <alan@lxorguk.ukuu.org.uk>
 Alan Cox <root@hraefn.swansea.linux.org.uk>
 Alyssa Rosenzweig <alyssa@rosenzweig.io>
+Askar Safin <safinaskar@gmail.com>
 Christoph Hellwig <hch@lst.de>
 Jeff Kirsher <jeffrey.t.kirsher@intel.com>
 Marc Gonzalez <marc.w.gonzalez@free.fr>

base-commit: 9147566d801602c9e7fc7f85e989735735bf38ba
-- 
2.47.3

