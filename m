Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC6827FB0C;
	Tue, 27 May 2025 17:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366302; cv=none; b=gc4Jin2mcE7Ux1wbL7Fi4mcmuKmW3bWXm+KCyDTPZQQulIVjuUdAMMUxw+3wXAzRVI8Enb2SV6fFaJQZsCqf9dCxLjkCQ9J1bhVxSioAN+AZFhJw6+dPOkqYde6OcmLI03GDWgesOmQq0Oei1UycoHRneY2kK6uFQeXYkKYkgtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366302; c=relaxed/simple;
	bh=q+n8sVKmFvaG8rD14UBjrkSDj9Zxn0gwYrqycENMSLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ES94vPnvYVKkCAqgo3reW5Yku9kTz9aBTik5RYAd5TBnmgx7DLQCsJnmbyyXlKVm5lzDhhnSfmjls6st323qWXnhukYh53u7S1tiRVQSRdQuwuB4sJwMo9ZyKcjifXIlfN2GrdQY1l8ulHJpiAWuiN4bLqpL2SFIiFM9A0uZ0Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dyk4qGVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dyk4qGVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B078BC4CEE9;
	Tue, 27 May 2025 17:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366302;
	bh=q+n8sVKmFvaG8rD14UBjrkSDj9Zxn0gwYrqycENMSLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dyk4qGVIXAsDcKHQURO2ckJRVa+DRhla9IXpcvE8H3kQ6hdfNoIN1RxXqbXlQ0oGr
	 bRLvgzkW8rH0bZUcXp65uLOp02mAjDa9qx4x2V2FrLQseW5LEZ3oHRuv039pnjOjwS
	 BP3ryYzpKcIFHQ5OsCZDPVY+ftOT3WiFBUvqyUMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 025/783] vhost_task: fix vhost_task_create() documentation
Date: Tue, 27 May 2025 18:17:02 +0200
Message-ID: <20250527162514.125760244@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit fec0abf52609c20279243699d08b660c142ce0aa ]

Commit cb380909ae3b ("vhost: return task creation error instead of NULL")
changed the return value of vhost_task_create(), but did not update the
documentation.

Reflect the change in the documentation: on an error, vhost_task_create()
returns an ERR_PTR() and no longer NULL.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Message-Id: <20250327124435.142831-1-sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/vhost_task.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index 2ef2e1b800916..2f844c279a3e0 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -111,7 +111,7 @@ EXPORT_SYMBOL_GPL(vhost_task_stop);
  * @arg: data to be passed to fn and handled_kill
  * @name: the thread's name
  *
- * This returns a specialized task for use by the vhost layer or NULL on
+ * This returns a specialized task for use by the vhost layer or ERR_PTR() on
  * failure. The returned task is inactive, and the caller must fire it up
  * through vhost_task_start().
  */
-- 
2.39.5



