Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050023;
	b=cUlaO8VfIYHhkIXstXtIIXudrXGwP5Pdx3CiAa2nHJVB6HbCk8zYX9FFaZGVSuFJQ4/M
	 KnxiY3s7BW67yprMp610wNFwAtpTrmyANAHGMR94YIKCvRqDpTN0Qa4Vzup0+IVGxQRvY
	 +SssOCYJt5WUe7ruEi53S1VItjVf5edKXFcpu/Ob6eaqgR+pl9MZzWwOXg7ulLLyHNlj1
	 sRim94J4etPIMGGMkDXoPZX7zkusPld7vRjLi6pIEhnriCCQU+uXuU7JbeIgMnB9G7efA
	 jUKjSlHtcjdFbBUIhLXr5xvzPy0E8GNPYagGtwFjeaGvocHbg4Vr91IC3d0og8RMYrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T046Pi9eVsJhqk5Q4rEjlLgDFP+BmD7/xZva/O3vn5Q=;
	b=hBz23aEed4+75v4KILHjxqBTfX+ONHncYH4PVL66EMRd1wSj9LQEEzlO+aIx691L4UDu
	 G7ujfBA6VYaOxoBmIvz3xpHhmXuB1pLTozAhvqq22QWzuK87o6yj0+Msq1XlFYvJVWoqC
	 qhzqxE/NA1rXTDaMoTFo4c3XwDFrr8tf9jIdx3OIHAQ1b56BF7hJqBBfn+MGTsXoX1suz
	 oCzNdbqxTLSf+FjomX3JO5LJfzeJ5P0E1AGfuXHMUyAv1BlcETdujqNkazLPN+97yKc4Q
	 XRunjbvE+EAdULIpg+X5njHwWeo3ESRYpmFQZhwT02JIoIMNc7gStIhaPXX+NXqkW1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jujg65n2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA77606A33E;
	Thu, 19 Nov 2026 01:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jujg65n2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326941F000C4;
	Thu, 19 Nov 2026 01:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050022;
	bh=T046Pi9eVsJhqk5Q4rEjlLgDFP+BmD7/xZva/O3vn5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jujg65n2lY8pMGsjFuTOG8tusro/4vDNm8YA89N+nE1mfjb3dal8+heK4sllrfQok
	 A88LSd+SHBRDBvx/jPfM0NEDygcxVrJCSb8l0YEEFlc+0KUCIAHKS6Fb3L3bcDTmz4
	 //vn5lnr+EaqmGX12Ub8MzFWo31r7Q+LitepszIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Tom Zanussi <zanussi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2560/2857] tracing: docs: Update histogram doc for .percent/.graph and nohitcount
Date: Wed, 18 Nov 2026 15:59:54 +0100
Message-ID: <20261118150333.676053989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 87bd772836c0c..f95459aa984f3 100644
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



