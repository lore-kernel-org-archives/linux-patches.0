Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78FE107B2
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DD5C433D2;
	Mon, 15 May 2023 18:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173875;
	bh=8dORmYOobbUUTHC4B6LmXGP/4FOF9jV17MZvGPlLXLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1vwv01agqOd+moCk2DH6O7RG4iUwW3MUMvkAD2ccF+RZYxnPInRzbZ/eqcnmzZR3
	 9xhabN7bfEnGqwa0cp1PouzDYnhD2DJsaVreT+ClQ/gKdZJGq0t0Z3cHn9+C0D/YV5
	 NtyjzBa7sEJBtqHiJqv7IKSrStY4khoZDdYLVjrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.4 203/282] dm clone: call kmem_cache_destroy() in dm_clone_init() error path
Date: Mon, 15 May 2023 18:29:41 +0200
Message-Id: <20230515161728.336636477@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
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
@@ -2232,6 +2232,7 @@ static int __init dm_clone_init(void)
 	r = dm_register_target(&clone_target);
 	if (r < 0) {
 		DMERR("Failed to register clone target");
+		kmem_cache_destroy(_hydration_cache);
 		return r;
 	}
 


