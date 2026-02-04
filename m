Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB0D264614;
	Wed,  4 Feb 2026 14:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216736; cv=none; b=pbCI+zS9PqmLdogU6dqK3B48xVxoUcvx3hYh3XZrveGxPN/qhXpA5QhQ+x1V8wQ/xKtMKYLOgCnXcZyMHVGGDVWE/ojAT9ZYnP5LlgmUYdLUWHULllzLDF2G7qa5VsxCp3eev2PcLAMgHqDmxeCT78tVI+Rd8YIQB62ZjGtVvKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216736; c=relaxed/simple;
	bh=RBmlaQanN+YODYZhoBIEpwI9vzRK8CkdOrx2B15QoAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLZyvPUk4LwzT6/LUNT9Q/7q/xsjVSc9xm9IVmao0yzsski1eeHu9vyYisOfmt90Fhxi/TTT7whbXqM0q2XT5r0xiglVYt5rTN0Ykgr8Sbr3wiVo2lgWb4JV9Tml7U6UhNZGqVb4sywmcGXGXJR/85SfIsy2Vm7gcS3JFw04Juo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13vooAEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13vooAEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CA7C4CEF7;
	Wed,  4 Feb 2026 14:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216735;
	bh=RBmlaQanN+YODYZhoBIEpwI9vzRK8CkdOrx2B15QoAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13vooAEa7zpt0rHLtshNxnmwC6lKiXCycA76KJ6pIzS+2erXXfWZYOTZonXASqatw
	 39g2h4q/fX+9BMnaGI19mFRjtW3FASKr7HYEkmjlI6tq0zYfxdG1s19bZNvqhym2UC
	 Fh888iIrAXRrDky2Fd38uos3jmgBZ0Zx+tyL2ei4=
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
Subject: [PATCH 5.15 016/206] mm, kfence: describe @slab parameter in __kfence_obj_info()
Date: Wed,  4 Feb 2026 15:37:27 +0100
Message-ID: <20260204143858.787353663@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3c75209a545e1..a8d9e6ff73629 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -208,6 +208,7 @@ struct kmem_obj_info;
  * __kfence_obj_info() - fill kmem_obj_info struct
  * @kpp: kmem_obj_info to be filled
  * @object: the object
+ * @slab: the slab
  *
  * Return:
  * * false - not a KFENCE object
-- 
2.51.0



