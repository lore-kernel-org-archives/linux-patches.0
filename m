Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16081F427B;
	Tue, 21 Jan 2025 18:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482594; cv=none; b=ijb/RMoyvBpbFzWNsHRQYI2acnW8lwxfnDgL/8F3p0vEoinTS76/ocGVlb990lvi1dkAYNBZI0e9rUADR4Vw++jyIcKxbBZOPxpP23WSoXxHChZpJe14wzlKB67vwXTC7XTnkFVa8yvBJdnd/7m1MDH0JfpBgqSGdXIEg1cZtOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482594; c=relaxed/simple;
	bh=BGeaN7N9jnjR2aRts8pXbr9ITfE8xuPpm6oxWipvXoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHVVkOqZSrRRqystrq+c1F0sRFaPcSO8qVx1ENXD9qpVhemtUZXLfT6zqB+F1peVvGtwMV+AOuuF545ejJoKr7C7UtD0pofE4Vye4pKySKs/cV4hfg6KvRzDoDp8oT3PLZw/F+DGqD5IbhBBqNQpvlNj7fhqIsD3GeHRgHkHAIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3UedjzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3UedjzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432CFC4CEDF;
	Tue, 21 Jan 2025 18:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482594;
	bh=BGeaN7N9jnjR2aRts8pXbr9ITfE8xuPpm6oxWipvXoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3UedjzQDnroO1Ot4xv/y6oR6Z5PLZGt0LZ6PLdzzdfkwTjUsJ8iqu9FTAvQayfOo
	 j/sQP54RNLf+/+1am8EaAKzhLCPOOqj/YzatzLKMQEGjbtjBtkp4P6ttvtz3bZ1kTo
	 GMTC2qAzoiH873TIq0XLPBYhJ95rUbI+vhkY0CIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 095/122] tools: fix atomic_set() definition to set the value correctly
Date: Tue, 21 Jan 2025 18:52:23 +0100
Message-ID: <20250121174536.689048433@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Suren Baghdasaryan <surenb@google.com>

commit 4bbb6df62c54e6a2c1fcce4908df768f0cfa1e91 upstream.

Currently vma test is failing because of the new vma_assert_attached()
assertion.  The check is failing because previous refcount_set() inside
vma_mark_attached() is a NoOp.  Fix the definition of atomic_set() to
correctly set the value of the atomic.

Link: https://lkml.kernel.org/r/20241227222220.1726384-1-surenb@google.com
Fixes: 9325b8b5a1cb ("tools: add skeleton code for userland testing of VMA logic")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/shared/linux/maple_tree.h |    2 +-
 tools/testing/vma/linux/atomic.h        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/shared/linux/maple_tree.h
+++ b/tools/testing/shared/linux/maple_tree.h
@@ -2,6 +2,6 @@
 #define atomic_t int32_t
 #define atomic_inc(x) uatomic_inc(x)
 #define atomic_read(x) uatomic_read(x)
-#define atomic_set(x, y) do {} while (0)
+#define atomic_set(x, y) uatomic_set(x, y)
 #define U8_MAX UCHAR_MAX
 #include "../../../../include/linux/maple_tree.h"
--- a/tools/testing/vma/linux/atomic.h
+++ b/tools/testing/vma/linux/atomic.h
@@ -6,7 +6,7 @@
 #define atomic_t int32_t
 #define atomic_inc(x) uatomic_inc(x)
 #define atomic_read(x) uatomic_read(x)
-#define atomic_set(x, y) do {} while (0)
+#define atomic_set(x, y) uatomic_set(x, y)
 #define U8_MAX UCHAR_MAX
 
 #endif	/* _LINUX_ATOMIC_H */


