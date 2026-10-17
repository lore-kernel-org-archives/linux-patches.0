Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898343B19A6;
	Sat, 17 Oct 2026 16:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255696; cv=none; b=J4dO5e35U6Qx6fu1S3Cbva+AMXBYJwdDxF1SXFWQ93uWf4dUXrXfoAJxdPut7DyzsBlDCUdR12r+fiuadsUprm1rHL2K0S46NFJGNKJIs1mzgrSC0iFFWEbMmmPuDFKCvKbIQm8gf7z41LtGaFjbKy4fkvXtuhW3PdOx9UzDIZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255696; c=relaxed/simple;
	bh=D34gTHEd1G5E8HUTdoZex6o3rYpN4mO9nZP3u6mbHFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3LohOI83ukEPjWypBg3XxoLHH70I1vZ8NzUF9xY9SXvyP3xT6oqLb6Hud8cz/RmBBt3A1QnLFEk6tLSMXXmnLnWUqgNpQ3tVhXhbc42O603fjr9PRYFQdAgFu99OdnXK9FsgoiLeBxbEJBya3TIWkiG1zz/2JqsLq4+dr5m7gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkULCl0Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkULCl0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A991F000C4;
	Sat, 17 Oct 2026 16:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255695;
	bh=Yo9V3tsQ+6zX4qz4P6qOucj6bCFPi2Xkvmobgu7VXhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LkULCl0YWeHBbXbCf2l+PqX/i8sSIVdny2MnWb5KauKMjb2rzvYQj8hPlrTwMJ+IE
	 gFyCwtxmPIZ0BlHlDm81R+xPLumQkHlk3iqDbRSmBFeI6ExdgxSybr94RwFM09Ur50
	 WrdFILug61ba2Xucp8fZWOPfWyATPI2T8Knf/gP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 861/869] tracing: Fix ring_buffer_read_page_size() kernel-doc
Date: Sat, 17 Oct 2026 18:01:42 +0200
Message-ID: <20261017160058.932988688@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index c89f4f8a33b0e..6e84f2f1eb201 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6746,7 +6746,7 @@ EXPORT_SYMBOL_GPL(ring_buffer_read_page_data);
 
 /**
  * ring_buffer_read_page_size - get size of the read page.
- * @page:  the page to get the size from
+ * @rpage:  the page to get the size from
  *
  * Returns size of the page in bytes.
  */
-- 
2.53.0



