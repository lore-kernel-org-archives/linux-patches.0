Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C61A19F42D;
	Mon, 24 Feb 2025 14:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407882; cv=none; b=LJlsEDR2dwjY1ggWBqPSZN2M8v4gTffE567mJtaQPFXGbdr4cFsGa8bH+pcdDtnc+owW6v6tFnxVPQ4kEkBahGkRqXohbsIzR5BVbMYQHsebWoebNrWSa3RIl18I4Fi/RNOTKUNioxDBGVKZEAw1No3t638xi9psvdRhEG9lGCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407882; c=relaxed/simple;
	bh=aZBDQtkfUaaN9/uA7nkGdiFQ79SjPpciHKLw7/Zq6Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eC8eGGLEfnXtiSf7kMekyfkn91fwJ3tr88BeEWE3Sde8o57wDYjFaXau50Uv+IetGXEZj+3ZzbYiE5TIZiyfSMhmQB8NBpZ98YS10HBE+aWZN6DE/uJyhb5dOcbHZ5jDM7pDIHQDUQl/RgjoI2+RQrCzUGtetGMk+0RqNscQUv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2wZa0K6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2wZa0K6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96ACC4CED6;
	Mon, 24 Feb 2025 14:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407882;
	bh=aZBDQtkfUaaN9/uA7nkGdiFQ79SjPpciHKLw7/Zq6Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2wZa0K6c/qu0VyU4sqdctSUKzmU2vk6I61cVGxajfJArI/mqGhqMFpXt5n03mVv26
	 Ml13a8lI84a7EGpHqB165j2Yu2qqnFsm7AUOUmwLYpwjGWvZWN7jFupIkEbTjCQ4LU
	 1hv7kF3/yEu4IaPfXn9sJxZ9qr/jqEC9lDeNZI/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/140] cpufreq: dt-platdev: add missing MODULE_DESCRIPTION() macro
Date: Mon, 24 Feb 2025 15:33:56 +0100
Message-ID: <20250224142604.467409418@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Johnson <quic_jjohnson@quicinc.com>

[ Upstream commit 64e018d7a8990c11734704a0767c47fd8efd5388 ]

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/cpufreq/cpufreq-dt-platdev.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: f1f010c9d9c6 ("cpufreq: fix using cpufreq-dt as module")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq-dt-platdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index fb2875ce1fdd5..99c31837084c0 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -225,4 +225,5 @@ static int __init cpufreq_dt_platdev_init(void)
 			       sizeof(struct cpufreq_dt_platform_data)));
 }
 core_initcall(cpufreq_dt_platdev_init);
+MODULE_DESCRIPTION("Generic DT based cpufreq platdev driver");
 MODULE_LICENSE("GPL");
-- 
2.39.5



