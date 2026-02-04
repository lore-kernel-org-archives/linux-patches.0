Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95A72D879A;
	Wed,  4 Feb 2026 15:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217487; cv=none; b=M6i1h+KrwkCXQ2222kNRw8RDSwwcQoBG89Bj+PHif56xWGeMly/hwl5YE1nlZZFp7/bUTIfICXou/dQFJZR9UWz9H3e4xqXTEuV/Q76V1qGxJaQErb5pvk31WwGMnkiwRYtKUeeHnJTswv1n6V7mdBf7BbHLp+b0RaVLwcAedf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217487; c=relaxed/simple;
	bh=BFYy6iL7zlPN2KFxI5kHCPZibRVSmEZ/YwDSr55qiV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snHCvW2IJrJE7fFwKQAMN/7hnO4n6Pp239HswmwX9vzGmgKB+HPMRIYeZkuGM6CeNcLWHWnpsi6BxoievUMuN1fVf8l30DixRaDJSpQT9k80neN6SLvt2VbcdousXVGC5U+6jPbYPrNjdMNawFDyKR2V7XBI28mkbNzrD762qck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fydgRSnD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fydgRSnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB62C4CEF7;
	Wed,  4 Feb 2026 15:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217486;
	bh=BFYy6iL7zlPN2KFxI5kHCPZibRVSmEZ/YwDSr55qiV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fydgRSnD+GSTGwNmAo1WybArYDCgyOjStElAG76AhwJDdOT0+sjsckzMPBIZ+6eo6
	 915LhPzKJNZ1gQzcoI02kIZqu6updt/wPFKxe4WcA1WF7MUVGxnQ98+ZPUeiD0xqFD
	 q0qzH2EBuNnd08XCDl7s+LxB7iVRMz+CvZgNE1Wg=
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
Subject: [PATCH 6.1 030/280] mm, kfence: describe @slab parameter in __kfence_obj_info()
Date: Wed,  4 Feb 2026 15:36:44 +0100
Message-ID: <20260204143910.723393503@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 726857a4b6805..d5258c63ffd7c 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -210,6 +210,7 @@ struct kmem_obj_info;
  * __kfence_obj_info() - fill kmem_obj_info struct
  * @kpp: kmem_obj_info to be filled
  * @object: the object
+ * @slab: the slab
  *
  * Return:
  * * false - not a KFENCE object
-- 
2.51.0



