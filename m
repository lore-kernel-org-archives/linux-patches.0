Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEBC441D;
	Thu, 13 Jun 2024 12:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282229; cv=none; b=bBCs3h/8NMXAv5vFaOk2gVCUabMhiPilhj2D6v3It7d5lt8WrI5NSRiWakVK4RLslPnc7mouEKhpJVJi9Zdb6MeRIzYCqGrqMQJdtjKvPiFJRYHPXlHZTuT6V0zU65axAwZEoWLfnb1kC5rnH7AUEhRj/TJKyIXn2wpYafnUpao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282229; c=relaxed/simple;
	bh=8tV/khUqVFlHFzYXVe/84zXGZgh7cGJRdzO6gq6B6QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThQSL9Us0oO8ZSryjePZNtKrfru8cRjwC5riQBoNuEh4/j6U05O9DFyM6Cd6/Ibmom/2j3jjVmNhG3s8wDH2VwxD9TXEHFsgZP9oWT4Lcjt5p0Id5dUYfJvvSepbtIzRm12Rl4MrHWZqYw0zgcGKjXNQclgcSYUhRmPCcY2GeKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRbgAhJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRbgAhJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5A3C4AF1C;
	Thu, 13 Jun 2024 12:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282229;
	bh=8tV/khUqVFlHFzYXVe/84zXGZgh7cGJRdzO6gq6B6QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRbgAhJ4j+B6uCdHTon6kxHzTG+SB1zUwsKHnXhxn0HTDHy+AgSBEk/M/g/pS/b69
	 F2/a/Cuju8Dkt+SzaLZgjeqMQFIHRawlQJTFdQe1ODJGAQHBDWMrrBaFSDR0n9xiex
	 SmvaQ6bQDHD2aUlJziDQ3rOVcrs+xtT3gVjBeCho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki Poulose <suzuki.poulose@arm.com>,
	James Clark <james.clark@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 206/402] coresight: no-op refactor to make INSTP0 check more idiomatic
Date: Thu, 13 Jun 2024 13:32:43 +0200
Message-ID: <20240613113310.181641782@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@arm.com>

[ Upstream commit d05bbad0130ff86b802e5cd6acbb6cac23b841b8 ]

The spec says this:

  P0 tracing support field. The permitted values are:
      0b00  Tracing of load and store instructions as P0 elements is not
            supported.
      0b11  Tracing of load and store instructions as P0 elements is
            supported, so TRCCONFIGR.INSTP0 is supported.

            All other values are reserved.

The value we are looking for is 0b11 so simplify this. The double read
and && was a bit obfuscated.

Suggested-by: Suzuki Poulose <suzuki.poulose@arm.com>
Signed-off-by: James Clark <james.clark@arm.com>
Link: https://lore.kernel.org/r/20220203115336.119735-2-james.clark@arm.com
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Stable-dep-of: 46bf8d7cd853 ("coresight: etm4x: Safe access for TRCQCLTR")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index d3c11e305e5b9..fd753669b33eb 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1048,7 +1048,7 @@ static void etm4_init_arch_data(void *info)
 	etmidr0 = etm4x_relaxed_read32(csa, TRCIDR0);
 
 	/* INSTP0, bits[2:1] P0 tracing support field */
-	if (BMVAL(etmidr0, 1, 1) && BMVAL(etmidr0, 2, 2))
+	if (BMVAL(etmidr0, 1, 2) == 0b11)
 		drvdata->instrp0 = true;
 	else
 		drvdata->instrp0 = false;
-- 
2.43.0



