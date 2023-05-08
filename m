Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97457168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB19C433EF;
	Mon,  8 May 2023 10:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543088;
	bh=twQBlo0z1/wngMaLnICujCMwfJjvC6WMoe/YUvdsOSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4LBqeeT7VC+i/V4X8xk5x3m+qzU7UY5P5nmuOjM2csuQBuzFG0K1jWmTtgQuVasM
	 8XX8Mlv2kteke8+QFLN72B1jS2d10qjbr19UES/zS32+W+5UCh2/0dI70k1gSuPYPO
	 js7HB8MsERdcXjml350iOxn5RUS5n2E1VTCGjTGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.2 646/663] dm clone: call kmem_cache_destroy() in dm_clone_init() error path
Date: Mon,  8 May 2023 11:47:52 +0200
Message-Id: <20230508094451.021028773@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Snitzer <snitzer@kernel.org>

commit 6827af4a9a9f5bb664c42abf7c11af4978d72201 upstream.

Otherwise the _hydration_cache will leak if dm_register_target() fails.

Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-clone-target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -2205,6 +2205,7 @@ static int __init dm_clone_init(void)
 	r = dm_register_target(&clone_target);
 	if (r < 0) {
 		DMERR("Failed to register clone target");
+		kmem_cache_destroy(_hydration_cache);
 		return r;
 	}
 


