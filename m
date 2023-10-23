Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D5614A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sB0pNnCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CA2C433C8;
	Mon, 23 Oct 2023 11:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059574;
	bh=eJd7klf4TBhAykFGgRMFhg42v1wp6RjHf6mKc9Jk0e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sB0pNnCNMgu8iw4wElURI4s72o6W9GhpWSgIGC2wN0ymBHuYvn4fnwMZh8HLQKucG
	 9LzGSR9X2iKnHd0Pid/4B+bGlG4qf8LfzRD4ok+5km+xRmTT1YflAsBH0ugq50t+AP
	 GQnkAz+TvP3QPNvIqt4i6CMBTi5yHykAOE95N14I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.5 205/241] platform/surface: platform_profile: Propagate error if profile registration fails
Date: Mon, 23 Oct 2023 12:56:31 +0200
Message-ID: <20231023104838.855556594@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

commit fe0e04cf66a12ffe6d1b43725ddaabd5599d024f upstream.

If platform_profile_register() fails, the driver does not propagate
the error, but instead probes successfully. This means when the driver
unbinds, the a warning might be issued by platform_profile_remove().

Fix this by propagating the error back to the caller of
surface_platform_profile_probe().

Compile-tested only.

Fixes: b78b4982d763 ("platform/surface: Add platform profile driver")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Maximilian Luz <luzmaximilian@gmail.com>
Tested-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20231014235449.288702-1-W_Armin@gmx.de
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/surface/surface_platform_profile.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/platform/surface/surface_platform_profile.c
+++ b/drivers/platform/surface/surface_platform_profile.c
@@ -159,8 +159,7 @@ static int surface_platform_profile_prob
 	set_bit(PLATFORM_PROFILE_BALANCED_PERFORMANCE, tpd->handler.choices);
 	set_bit(PLATFORM_PROFILE_PERFORMANCE, tpd->handler.choices);
 
-	platform_profile_register(&tpd->handler);
-	return 0;
+	return platform_profile_register(&tpd->handler);
 }
 
 static void surface_platform_profile_remove(struct ssam_device *sdev)


