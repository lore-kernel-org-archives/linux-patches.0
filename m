Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB4A53A7;
	Fri,  6 Dec 2024 15:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498508; cv=none; b=niz6yznWXhnbHYCvxTMe6EM66Lz89LLae4G8kWLAon/nWyRChfzZMr+7ZMg5dGQznGnonNMotoxfuZZvLgPJl05BhpvFmTbC02Ntro6XEyS4sVFmV14VAQZIxCCqKvBUgjPY8xdZmzFjXKA266Ze7TLPSd3tOcs/q7NJsNbo5sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498508; c=relaxed/simple;
	bh=B98Pb3m3QQypRDwD8yiuDYOCWzE3GWlDxXkb5TJrN8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRMy9h58bFWhARC17ihEg9suf2fTFNOtpUcMv5iHD22/cClPqzQS/LGkSvl7OYHhoeaVSkUOqFfIaFkXMQNuc5zZR4/vSz/8q0AwU1dqWqMYz0zuAx9tr+rWb3vNWZB7xsvizpFmGgSiFliTS513Dhjn/p1+/HIjFSaKiE2OrRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHXZwJ6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHXZwJ6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB5AC4CED1;
	Fri,  6 Dec 2024 15:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498508;
	bh=B98Pb3m3QQypRDwD8yiuDYOCWzE3GWlDxXkb5TJrN8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHXZwJ6GQsD+FEouxJ1V+M9hM5uml6L42NrkMC/hBtL0RP0dkfeFLWXkqBrwhKsb/
	 renrV4uyaXpdWtJyS+OlZN6G9IU2rwc+rHl4SbJ7LgPVhMxa9Oyg0x/AmN6MNBN579
	 3dEYWK3T7FAAAZVzTblEr8zlqT7/NydhMZN5DStY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.6 605/676] md/md-bitmap: Add missing destroy_work_on_stack()
Date: Fri,  6 Dec 2024 15:37:04 +0100
Message-ID: <20241206143717.006528390@linuxfoundation.org>
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

commit 6012169e8aae9c0eda38bbedcd7a1540a81220ae upstream.

This commit add missed destroy_work_on_stack() operations for
unplug_work.work in bitmap_unplug_async().

Fixes: a022325ab970 ("md/md-bitmap: add a new helper to unplug bitmap asynchrously")
Cc: stable@vger.kernel.org
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20241105130105.127336-1-yuancan@huawei.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md-bitmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1089,6 +1089,7 @@ void md_bitmap_unplug_async(struct bitma
 
 	queue_work(md_bitmap_wq, &unplug_work.work);
 	wait_for_completion(&done);
+	destroy_work_on_stack(&unplug_work.work);
 }
 EXPORT_SYMBOL(md_bitmap_unplug_async);
 


