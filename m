Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986682288FB;
	Thu, 12 Dec 2024 17:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025663; cv=none; b=mmhpStNIXPHejApZrhJrjF6ohHhLS+xdZJjXuq3lkUh7aAJZjAM/I5fHNSchoWWbGvJyazH89J8IQ+Hee2VxhiFjx7INH4xtQ8kCmfBB7r/jruFwtoA3a2jZ1LYSzI7mujztqF3LhYhrzbgFDA7UlI7AHy0yN86Wd/DIvYCy1Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025663; c=relaxed/simple;
	bh=NenJrlwSUY0L2Zq/bP0yovmssxaMbhrcKruhOwcA/yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVI2diaIpwQcaXsTBLHqd9LB7e6ig3FOxtV2JvV5j1knCEBkm2MLLNnQhxnLQmJ03kAL+wRhcwRF6TINPHs+I228ZOE451hk6sE0O4ROVIdgcQLpb/91Cq7IHK6OSsm2Xv63yVnrh2dPedaFh7cjcQv+43X2ti7NMvCvIqQ9wIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suBhCTmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suBhCTmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EB1C4CECE;
	Thu, 12 Dec 2024 17:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025663;
	bh=NenJrlwSUY0L2Zq/bP0yovmssxaMbhrcKruhOwcA/yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suBhCTmYPM2kZMS+zj4zjZt8bntFj95+zg3Jajko9XHpaG8g1HbUf/mO1I0n7rZ+D
	 SNYPUT4iF+DodOCqb0LPNtZl3xwB4ZuR+98UjyTGihTuol02hV67qkU3c2/2fi24ip
	 8AAS4eIbJ6Ncwq844Zc5t+stADEb8RBRlyNQmYFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.4 215/321] dm thin: Add missing destroy_work_on_stack()
Date: Thu, 12 Dec 2024 16:02:13 +0100
Message-ID: <20241212144238.471724049@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2477,6 +2477,7 @@ static void pool_work_wait(struct pool_w
 	init_completion(&pw->complete);
 	queue_work(pool->wq, &pw->worker);
 	wait_for_completion(&pw->complete);
+	destroy_work_on_stack(&pw->worker);
 }
 
 /*----------------------------------------------------------------*/


