Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A65149C51;
	Fri,  6 Dec 2024 15:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498776; cv=none; b=uAHLacagVYYDuh3ElCyuysPGusepj8o+4GdlKZRlMN1pniYbb4eI5BAjqyhRyQQ10vHKpvc6dRU3KiXgYoY8ALFqsOWO/VcnfKnNozRdK1eswuzV3Gmy0QCOGG9e6l8vOJbUzHnKS0HFKHI7qO1vDR/p5yT2rXy+fbu/xJq01xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498776; c=relaxed/simple;
	bh=IQisGBLeS/SV+iqwGrF28t95m7yH90UbuyDiVItm4xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9tqeKiTZr41tTdYafV1Miu3OvAaYwj2V9M1vQ/vgM4NbOqOmbQGj9NkfChFVEUgEgFWMknHYAVjFXOPBvtUI3/yjmL+Kp2BtbtdKBT3VbP8+bl6CRv4LGwwUzJ/FE/O4I7ncvwCDPRQWsdyaqddTCbbuUKpKak+3uREIExrV90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaIlus7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaIlus7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD90C4CED1;
	Fri,  6 Dec 2024 15:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498775;
	bh=IQisGBLeS/SV+iqwGrF28t95m7yH90UbuyDiVItm4xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaIlus7kOOHihrIE3iw7c903COInPRsId3eoVjmjYb8mgp+ZAr+8rsXmjpLQ23weq
	 6n7LnkQs8gFiKpCdnEHQNuaekOK5hyrMlPjxRqXsnP+rdBM/SyT8URZJS5aBpaibS2
	 Owd1yvLOmsZ937XXYD0I65ZFfAqXM+n+YUZgZksw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 653/676] dm thin: Add missing destroy_work_on_stack()
Date: Fri,  6 Dec 2024 15:37:52 +0100
Message-ID: <20241206143718.876969671@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

commit e74fa2447bf9ed03d085b6d91f0256cc1b53f1a8 upstream.

This commit add missed destroy_work_on_stack() operations for pw->worker in
pool_work_wait().

Fixes: e7a3e871d895 ("dm thin: cleanup noflush_work to use a proper completion")
Cc: stable@vger.kernel.org
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2486,6 +2486,7 @@ static void pool_work_wait(struct pool_w
 	init_completion(&pw->complete);
 	queue_work(pool->wq, &pw->worker);
 	wait_for_completion(&pw->complete);
+	destroy_work_on_stack(&pw->worker);
 }
 
 /*----------------------------------------------------------------*/


