Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38ACC168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4341C433D2;
	Mon,  8 May 2023 11:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545325;
	bh=twQBlo0z1/wngMaLnICujCMwfJjvC6WMoe/YUvdsOSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbbfTGgxOaOrRyqeC3IDWwkSQSScKkBs3/EewghuX7SmJCiVF041YChyoUjTskLlq
	 8nXegrOoUiUOmTTSGK6UFnxPZK/UXN80Prswt68iLPl2dy6H3bzMYOVhBf6X0MkiGu
	 edgQix/tygkpP7x2BEA3ifVoDpfrVdwV8p58zVyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.3 680/694] dm clone: call kmem_cache_destroy() in dm_clone_init() error path
Date: Mon,  8 May 2023 11:48:35 +0200
Message-Id: <20230508094458.352488996@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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
 


