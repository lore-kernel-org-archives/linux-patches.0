Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868C7358D13;
	Wed, 21 Jan 2026 18:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020145; cv=none; b=KXit6EKixBah6tnD3FU+zil9QqF2PCWD9vMJwIX6nq6WybSfUJ+1bAMkcomZ/COFMnVYXsKk/1FIPmNpuRVZG+SuftpoOOAnfzJ/sTPxUZ+LS5FrQnJicdj4bWeI/rwUITcUnBbZv1Frfrnd+FbefTxu1n/FGfRhNmsEDJZZV98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020145; c=relaxed/simple;
	bh=J6/NXBhDeawxihXyrO7u3CofjzoQUJXyvusS1m9Cu2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ii9nZAkXsLRn5QvDXwgAiZwj+rgGXqFss5Yz8ZGv1/Pt2M9S6j834gHnZtsLFNB69k0ODXN1AKkI+AdyVa6g3/y+BnE1VvzjAiRZYMvBXC3PuWjrHWAcJc8KiHm0HuBQ2ruZtrJt4DC/n05JZJf5IderlWYbK4AldT63l5kSlFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdsdYGaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdsdYGaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977BCC4CEF1;
	Wed, 21 Jan 2026 18:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020145;
	bh=J6/NXBhDeawxihXyrO7u3CofjzoQUJXyvusS1m9Cu2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdsdYGaX0o20dCClJvOK8VcRkyzQS7KJkClRxqzdfykMbR8L1KIS/bA9IY77JyvB+
	 0i1XvkmIl9uWa7usvTRsGd99jT80AMScsNuR+O9TvA7VZdL3E3k4MFQPpw83+oxHOj
	 ZwgjyC4rw8gLVMQyfn+/7H/Yx6Wnx9cR0efR4JCI=
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
Subject: [PATCH 6.18 065/198] mm, kfence: describe @slab parameter in __kfence_obj_info()
Date: Wed, 21 Jan 2026 19:14:53 +0100
Message-ID: <20260121181420.899514230@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



