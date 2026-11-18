Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056468;
	b=XdXhCHwBhJht0ScwSgJIa3c9CT8nNYdd2Cs3YDNahz1wkTSnscr0Jxk4luRJwwSZvawG
	 yV60GcrpBsi8v2LRrQx/0D5uigTUeb7l2o3d2CxJdaki//NQZeBgWX73fZbC+jXbWyY1g
	 qZ7cqGyKDXL7AcR5DDcoZbllG4a4jWz68oWuAf6kDchda/lFEMckXUrKxRrFjborbQ1Pb
	 004DeAnyoQ1FjfYWWmVqDaiUUyoG5tWy4uWZwVUf7aoi+3IpIHXE5qodEPhF0ed1eHcky
	 gtX5zW13xXx4Qs/zumByJ+mOUCFLeH+/Gs2NE3q3yzRcVwLItSlQGM3wHckBnnN+sbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3186s5uARaEydvgE8JsuFY8O5Fla8ER9xlMg7vip1yU=;
	b=j3CCAEe2qLnXlISADeiwYqPkFhql0mt0lZRcvOxBN51U38CkXlfFqhyMsrJ6OBc3Jomg
	 6C8fnJ56qLWfSUcEdEEmRpmXD8+vqv2gmQvHtyasT5xj7rwQECkOV1QPNiUrh18seUmkB
	 rW48hrIZDfQxlxkA5TmCyxUs8qjLstyjbIQxUStE4wcaiFir2XzaxlZ/x+IZmX0W5+W//
	 TNwlXddoKxozKkybkEbtQxx99K1e8Rk4OcfV/u7eLK0dS6oon7cq9nxcCKz5KWrq9FSRt
	 M30kOf+zgXAGriFPYyo1Xh/Vw+tLJi9S9FS2IjjJYpd+yR5ahrfv4PkZieef/b5IjCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B0oyeIiA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE0060A2605;
	Thu, 19 Nov 2026 02:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B0oyeIiA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407C71F000C7;
	Thu, 19 Nov 2026 02:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056468;
	bh=3186s5uARaEydvgE8JsuFY8O5Fla8ER9xlMg7vip1yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0oyeIiAS4RZh68D2lzBVu6Gc/q4FIavNUA/fMjbQvoLf0XHXt+STnlXOBxdZo2bF
	 FURQw0czO10oysjdDmnANV5nEFXsTL+qn6Ia7P8c4Tz9c3cAb95JUcSTCQiaPeAAYq
	 b20jPjDidIU6ktJIAat1WjvLxojZObwLP60aTeR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Tom Zanussi <zanussi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2000/2214] tracing: docs: Update histogram doc for .percent/.graph and nohitcount
Date: Wed, 18 Nov 2026 16:01:16 +0100
Message-ID: <20261118150130.791719973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 8c2b99790196d34a58a2b00a4c9862d2de3af3e2 ]

Update histogram document for .percent/.graph suffixes and 'nohitcount'
option.

Link: https://lore.kernel.org/linux-trace-kernel/166610815604.56030.4124933216911828519.stgit@devnote2

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Tested-by: Tom Zanussi <zanussi@kernel.org>
Stable-dep-of: 289e2a775de4 ("tracing: Clamp the printed end of a histogram bucket at U64_MAX")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/histogram.rst | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace/histogram.rst b/Documentation/trace/histogram.rst
index 7a68a5ac33a86..abb023ef9f5eb 100644
--- a/Documentation/trace/histogram.rst
+++ b/Documentation/trace/histogram.rst
@@ -25,7 +25,7 @@ Documentation written by Tom Zanussi
 
         hist:keys=<field1[,field2,...]>[:values=<field1[,field2,...]>]
           [:sort=<field1[,field2,...]>][:size=#entries][:pause][:continue]
-          [:clear][:name=histname1][:<handler>.<action>] [if <filter>]
+          [:clear][:name=histname1][:nohitcount][:<handler>.<action>] [if <filter>]
 
   When a matching event is hit, an entry is added to a hash table
   using the key(s) and value(s) named.  Keys and values correspond to
@@ -79,6 +79,8 @@ Documentation written by Tom Zanussi
 	.log2          display log2 value rather than raw number
 	.buckets=size  display grouping of values rather than raw number
 	.usecs         display a common_timestamp in microseconds
+        .percent       display a number of percentage value
+        .graph         display a bar-graph of a value
 	=============  =================================================
 
   Note that in general the semantics of a given field aren't
@@ -137,6 +139,12 @@ Documentation written by Tom Zanussi
   existing trigger, rather than via the '>' operator, which will cause
   the trigger to be removed through truncation.
 
+  The 'nohitcount' (or NOHC) parameter will suppress display of
+  raw hitcount in the histogram. This option requires at least one
+  value field which is not a 'raw hitcount'. For example,
+  'hist:...:vals=hitcount:nohitcount' is rejected, but
+  'hist:...:vals=hitcount.percent:nohitcount' is OK.
+
 - enable_hist/disable_hist
 
   The enable_hist and disable_hist triggers can be used to have one
-- 
2.53.0



