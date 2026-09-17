Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7974973A6;
	Thu, 17 Sep 2026 15:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660001; cv=none; b=TufKQOrqbMqjkR7SKFiQa61ubPpyHA0hJAmllVa2Mi8omAUSkWACdYwbALc11lDjR//MDY/adKzVuyAEIyRsX0ihmrEDWk6kBdc1JrmN450dpdv69GrNGvBz5bq840iV6qaREPZWEsCZRhigJgvXFS8laF1NRenA5JxE7L+lBtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660001; c=relaxed/simple;
	bh=j0AFHNQGi92BD4Y66dwoxifekZV+He/+rgcpwkpOf/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prsCJ4PkqjYkw1wWQXhcyMt+5SLybP6hgp5Vtqnw1o8RmwFZgvbIVg3xY/VEnFeG/Km2i6KYAlcC4PFZIjAtFpRnUkyfvffGf2drCSZRrEV5Zn5afHY2wbFghEp8jwjD1Tt7wpE/ry+JBSDzZLVVBjRU+OfM6ZAr6aOL6Hyydlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Zxe/SDz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Zxe/SDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5C41F000FF;
	Thu, 17 Sep 2026 15:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659994;
	bh=vBcgiQl8UxyTVunwawaFvbWJtZmXar8f3gFynNDbV5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Zxe/SDzsQLH316WDdf+L9egxqxovBGusAypUphVffiT3JrYnH/IFsJmYPPmPTbjm
	 ce9Um/AziZP4mEV8QIFOFo+3B8oGiSkedylt9H7HaCf0zdl6EgWxyt2DVKO2UXUw9x
	 FcZwc6j7NqLhB/OD4+Tw0DMDbtnce32kj+BrSurI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 442/733] tracing: Fix ring_buffer_read_page_size() kernel-doc
Date: Thu, 17 Sep 2026 16:12:30 +0100
Message-ID: <20260917151402.889320596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 7e645147dfba67edb3ed3090a1ed1d89df77fc27 ]

ring_buffer_read_page_size() takes a parameter named rpage, but its
kernel-doc describes page. As a result, kernel-doc reports rpage as
undescribed and page as an excess parameter description.

Rename the documentation entry to match the function.

Link: https://patch.msgid.link/20260909062917.89482-1-kmehltretter@gmail.com
Fixes: dae8dda341d2 ("tracing: Fix subbuf resize races with trace_pipe_raw readers")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 66760542fce10..f958538c649ae 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7368,7 +7368,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_read_page_data);
 
 /**
  * ring_buffer_read_page_size - get size of the read page.
- * @page:  the page to get the size from
+ * @rpage:  the page to get the size from
  *
  * Returns size of the page in bytes.
  */
-- 
2.53.0



