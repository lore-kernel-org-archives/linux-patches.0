Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F392B1474A9;
	Fri,  6 Dec 2024 14:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496243; cv=none; b=h0Lkc8XhEji/tyCmv6VB7y7jVkkculnhER/ujnJ7rh26raa17Y5GbmF8ztbOTldGFKUWZQ3CmqNiAyD6lJc6wJOmYDxPNfzihTkFsAWigC3N+KNUTzG5x3uPuoNVWe5yE72TaDTv3SmniBATqKUy3OuFbygAswfR3v8G74cLK8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496243; c=relaxed/simple;
	bh=qKLOvWgZpZ9nDV8549RfapTrLmyCfqZmIzPwwmNdBp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naxILHaKORScVINL88sdET1jk+770ne6b+hrjbU+3wKkNdIoZsY+uPj/6OmLfg4Wqcrk8RR8j5JgDrTdQg1aGvyn6rtbFMaXIXrz3QQdm5Vg5vHjK+jnULESFLY5c1h6JW8AEj9f/a9wJaCgTXsxOf8A8Z7wVU4hVqZwTcJRwzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AfwLWx/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfwLWx/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D17BC4CED1;
	Fri,  6 Dec 2024 14:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496242;
	bh=qKLOvWgZpZ9nDV8549RfapTrLmyCfqZmIzPwwmNdBp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfwLWx/+yJVq9UFvb0ZI1OPfoeV7ZfOtMjitbKEmdgSrv8EBhwKPqUM8TYqi9N3Rc
	 g7VgSIBBzkXgO+DOlEPJR5mLHIAd4QQ3znDTVspylcXdv4HNsBaejsX+XhcAxVWLJv
	 7yyXAo1Mlg/ht4zdvboX4RRrAQ1euvMG7T4zuAWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 095/146] dm thin: Add missing destroy_work_on_stack()
Date: Fri,  6 Dec 2024 15:37:06 +0100
Message-ID: <20241206143531.315341814@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2484,6 +2484,7 @@ static void pool_work_wait(struct pool_w
 	init_completion(&pw->complete);
 	queue_work(pool->wq, &pw->worker);
 	wait_for_completion(&pw->complete);
+	destroy_work_on_stack(&pw->worker);
 }
 
 /*----------------------------------------------------------------*/


