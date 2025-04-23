Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D3F2820CF;
	Wed, 23 Apr 2025 14:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420192; cv=none; b=rbJ7rKTXPwqDR4W/hW/DYv1rGdqotd8m9NFCn6pjCUQhyoqfXOPz5ksZ8m9hVjggPaJJF6olC30WZFFohSsFIcHAIRVaccoc5VvhP4I2D5YioBqPzPLTa/FzQwrlL+oFOm8pFqGJV0OpEMfERYBMqrWNKYnsVfmuxF61yoZeeiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420192; c=relaxed/simple;
	bh=u4ZJEi5IiPiWfvZO1/8sPTqDP3oVUZ4o7KhWtxYqF7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KubdmKkn82pxElGRNmHJcarHtH13aC8ssOgNKbew3vB7dRxlJnXTanmMYfNWx1x/OcDmqbwBNiycqPC2Yu/ubYxkjHD0P4rW064ji1Qpe4pECEsuJN2Tv9xo3p8u07nWQjf9pGokJuZbQOzAp783euKNzR9hH+pGyagZGbiHTdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HcMyYKV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HcMyYKV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCC6C4CEE3;
	Wed, 23 Apr 2025 14:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420192;
	bh=u4ZJEi5IiPiWfvZO1/8sPTqDP3oVUZ4o7KhWtxYqF7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HcMyYKV5wh/ZRRx9r85aaHoPNkEQZBfUbeguEkAFzg0u9Y/GIqwRpEpsYFBmI0upJ
	 iVemyJ32bgqmx6LW9PBgLJaHI5S4B5R4r0vsxWnf79CIxuYeKnhoGQwu7XGexnxqQt
	 CTh9O6iZ96OhGCPtCQTN5Gk1l6BFRUJvuVQOQ6uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	xen-devel@lists.xenproject.org,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/291] xen/mcelog: Add __nonstring annotations for unterminated strings
Date: Wed, 23 Apr 2025 16:40:14 +0200
Message-ID: <20250423142625.430159156@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 1c3dfc7c6b0f551fdca3f7c1f1e4c73be8adb17d ]

When a character array without a terminating NUL character has a static
initializer, GCC 15's -Wunterminated-string-initialization will only
warn if the array lacks the "nonstring" attribute[1]. Mark the arrays
with __nonstring to and correctly identify the char array as "not a C
string" and thereby eliminate the warning.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=117178 [1]
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: xen-devel@lists.xenproject.org
Signed-off-by: Kees Cook <kees@kernel.org>
Acked-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250310222234.work.473-kees@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/xen/interface/xen-mca.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/xen/interface/xen-mca.h b/include/xen/interface/xen-mca.h
index 464aa6b3a5f92..1c9afbe8cc260 100644
--- a/include/xen/interface/xen-mca.h
+++ b/include/xen/interface/xen-mca.h
@@ -372,7 +372,7 @@ struct xen_mce {
 #define XEN_MCE_LOG_LEN 32
 
 struct xen_mce_log {
-	char signature[12]; /* "MACHINECHECK" */
+	char signature[12] __nonstring; /* "MACHINECHECK" */
 	unsigned len;	    /* = XEN_MCE_LOG_LEN */
 	unsigned next;
 	unsigned flags;
-- 
2.39.5



um: ntf-flags
       -
-        name: type
+        name: ndm-type
         type: u8
         enum: rtm-type
   -
-- 
2.39.5



