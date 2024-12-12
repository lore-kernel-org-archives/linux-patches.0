Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D5221660B;
	Thu, 12 Dec 2024 17:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024602; cv=none; b=DZ2dgDbr3uhz4Se9mSCvIEbnt1cnkWNPmWCtwJyEwC4g8/aWang94uuaRkL2fc04IRLz+MLhXlqPNSP6lmYaeRRAjvpMGnVHqrsc3/fNORV3kWh5wvXYVpW1iH2UsIqtWCZ9jWQwjBGud/P6LtJFRz3O/G6lstIy5YXoW0zJom0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024602; c=relaxed/simple;
	bh=AeugrKrhT/1oSJHXa0eB1MgeMjzydTk3IawFr3MtlPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbIwsHLdwhuos+9G/GpPLf7+HzW+TkpaG0IKWJfNbh+bQCfoIyA0TgUeGME/mzaYYa0RAKM0bkG5gMbcD3ptzVXpj/1oK7lBMgNu1N5MFdKpNLFAxWWsBuiQii7TmkJi6GkUvyPIFN6B09pBzmSvvgnlcxtpb1ZYVLNly8ss00k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQa9Ql9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQa9Ql9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70569C4CECE;
	Thu, 12 Dec 2024 17:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024601;
	bh=AeugrKrhT/1oSJHXa0eB1MgeMjzydTk3IawFr3MtlPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQa9Ql9QIB5dn1dnxNU+E2eVBb5ON2ZKnFo6hE/I4prK5QUTd3fnCykqGHgNN4REL
	 N540XasKqscTWX8Gcroyouu4v7hdxu0fn9WLZ6pJ9sPWojsmYUGSKxIHkDLsjeufV+
	 +o/gcij1IM/JsuFrX6NZb7WzezRCXwPCwd7ChJno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 320/459] dm thin: Add missing destroy_work_on_stack()
Date: Thu, 12 Dec 2024 16:00:58 +0100
Message-ID: <20241212144306.295355253@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2468,6 +2468,7 @@ static void pool_work_wait(struct pool_w
 	init_completion(&pw->complete);
 	queue_work(pool->wq, &pw->worker);
 	wait_for_completion(&pw->complete);
+	destroy_work_on_stack(&pw->worker);
 }
 
 /*----------------------------------------------------------------*/


