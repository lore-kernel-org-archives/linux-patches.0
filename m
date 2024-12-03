Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14AA1F76A2;
	Tue,  3 Dec 2024 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239855; cv=none; b=SjmSJC6jr8SE4wcZwBKafVgDvyq3bmf0Wm6ORoqUlSpf4v1qLgd2iJXSGHOWs2vB7alCkcDxxlQedu0/hZ35Hhj7I/9hqafWsrfv7JhBNYhjscEU233xLbMl+94ZKB5wT9RngukSaCZyYXVxcBuKEur0bO9A13vPBtu5fMH3q4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239855; c=relaxed/simple;
	bh=wiCBTjt7C3Eus3ELw9mVqSdF7/n8meqw+NnZFydKMfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgWXj1mn83od1q6rNs0YBegV6twhAYmDoKcbR/FQGV78RXKj/4qjVqr7knh4PrEUEAa+mWlOUWLSBsPXJVwYwxtFEsxie7Lv4NQbXx/b63pTohRmpugpPBRGzLnU8qjbmLLScW/ScVxRUkuyuTZJ4MDFoo+0i/GPK+/dSKNjUSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R2qjPFOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R2qjPFOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CC2C4CED8;
	Tue,  3 Dec 2024 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239855;
	bh=wiCBTjt7C3Eus3ELw9mVqSdF7/n8meqw+NnZFydKMfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2qjPFOXLrAQ6Y7e9vqeN2aSAE/9aZ0RsHWT+J1xSM9M9nDJrdZ6mPMEIj959laNz
	 vTBHy0CebBpxFWpGElb+SIV+i+uVDqdlXaMC8RCXOegpR/qoOfW0puI/lMf5yOlp6c
	 vnJw7FZLY1a1hENE9Q2ZMtvunYj6rWBzgugIA3ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 758/817] ublk: fix error code for unsupported command
Date: Tue,  3 Dec 2024 15:45:30 +0100
Message-ID: <20241203144025.583732910@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit 34c1227035b3ab930a1ae6ab6f22fec1af8ab09e upstream.

ENOTSUPP is for kernel use only, and shouldn't be sent to userspace.

Fix it by replacing it with EOPNOTSUPP.

Cc: stable@vger.kernel.org
Fixes: bfbcef036396 ("ublk_drv: move ublk_get_device_from_id into ublk_ctrl_uring_cmd")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20241119030646.2319030-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2975,7 +2975,7 @@ static int ublk_ctrl_uring_cmd(struct io
 		ret = ublk_ctrl_end_recovery(ub, cmd);
 		break;
 	default:
-		ret = -ENOTSUPP;
+		ret = -EOPNOTSUPP;
 		break;
 	}
 


