Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E70190664;
	Wed, 21 Jan 2026 18:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019567; cv=none; b=UAcFHkbHNkLliMD68ayDnRlklUiowL4mtjq5kaCYF+u0eyZR32spMloNPGXwLEkdqfB4NHNiufplIP6/Bz4HeYUcwZ26pvi1N0RJ+acgXEaZUUQmEpPntpXa8wtKWM+lJhPL98giBGGwRLgkd+dLe02j5/gFQAbtZNrnduOhOOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019567; c=relaxed/simple;
	bh=S5RG+mY0fCwMlXPGCeUx/HH0AzLVY9OUV9ogLx0i3mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nn8hOqN4eSfRr+f6deuxYLr8Bb2c43wBrCEDw4+ecdsSTNNEL9XaynHiS530smKBMsrw5Jjk7y/qmgtyXCMuJuGYK1WFrQVOSyyj6rcqWuLdfJJ086JMtyHiBqSMpZe6BRvdHNP9IT73DmXOvSR2itXqLYpAR1lLd4+eRfIgb7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXDwNATv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXDwNATv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FD3C4CEF1;
	Wed, 21 Jan 2026 18:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019567;
	bh=S5RG+mY0fCwMlXPGCeUx/HH0AzLVY9OUV9ogLx0i3mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXDwNATvZ1bL+12m7G9q5wD/aHh3vIWuXyUCZhwJK0thyWpNDb0rOBdK0YqAMuJDt
	 nE3L2gSyCW0XAiEdTCJvcZCSPUN/GjjmatC54GT8uMUMnC10/VE7MKMAj6lTw6L3dJ
	 hBJWa7FcnySZQmWvELw+HZ9Rrv73uYqjLvjKDeSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Marco Elver <elver@google.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/139] mm, kfence: describe @slab parameter in __kfence_obj_info()
Date: Wed, 21 Jan 2026 19:14:51 +0100
Message-ID: <20260121181413.004602408@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Bagas Sanjaya <bagasdotme@gmail.com>

[ Upstream commit 6cfab50e1440fde19af7c614aacd85e11aa4dcea ]

Sphinx reports kernel-doc warning:

WARNING: ./include/linux/kfence.h:220 function parameter 'slab' not described in '__kfence_obj_info'

Fix it by describing @slab parameter.

Link: https://lkml.kernel.org/r/20251219014006.16328-6-bagasdotme@gmail.com
Fixes: 2dfe63e61cc3 ("mm, kfence: support kmem_dump_obj() for KFENCE objects")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: Marco Elver <elver@google.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kfence.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index 0ad1ddbb8b996..e5822f6e7f279 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -211,6 +211,7 @@ struct kmem_obj_info;
  * __kfence_obj_info() - fill kmem_obj_info struct
  * @kpp: kmem_obj_info to be filled
  * @object: the object
+ * @slab: the slab
  *
  * Return:
  * * false - not a KFENCE object
-- 
2.51.0



