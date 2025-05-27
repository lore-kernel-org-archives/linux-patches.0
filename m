Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFF71D6DC5;
	Tue, 27 May 2025 16:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364338; cv=none; b=hBw4Xc+UkJckOd1w9uMUSPKrZECLFDGaE4CQz62tV8OCar7l6iegyGA3uswRIlgt20Zm7dJzjDhxwH0+n5xWLSZHvgR5Hl2tkxjDYXeqWiDjpX/dGMKbdspCRFYNNm07u40jOERl0OohPVOqvAsHtCphOUh3YXoG60KAGBaATUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364338; c=relaxed/simple;
	bh=LKlROuwKMgLDmjWs22ht9BBXUowg4j9zB/tidqmtvnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsbyICE3Hthn5Oeo3dheYe8kPUIR6Jn8v0bVb3JNnAj1X2dOTKIIUwT77wNAd9afXrtjh6W5D1XO+53QvAfOrrn7Sl9YQTpU0a9W5u5/VNEDwdJkfYB/WOeji6wp3pVDCqPZ/6Zq6okcelb41L5gK6+XeFvdelOQCntpJkSzvn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ibOic3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ibOic3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A650C4CEE9;
	Tue, 27 May 2025 16:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364338;
	bh=LKlROuwKMgLDmjWs22ht9BBXUowg4j9zB/tidqmtvnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ibOic3cUijRIdaQ2VPK/Q073ogSIkv5jaYuwu1VLmXA4xV1nodS1Z5IhlwTVqIiW
	 Otw/ApinRPGwC7GeFgeXyZiYX5LvvYxDnxVuvo/nVOsDaqChIvd4Vtb/sWUVLu8nBU
	 UaRLnp44OyYDkRc217PPDXKT9BKPxOIHC76p9dgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/626] vhost_task: fix vhost_task_create() documentation
Date: Tue, 27 May 2025 18:18:38 +0200
Message-ID: <20250527162446.093893591@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



