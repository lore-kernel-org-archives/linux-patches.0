Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EA6307AF6;
	Mon, 13 Oct 2025 15:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368446; cv=none; b=cT8Fc/nIE3xmr6o7+q7uCB6NtnzunlT+Ng2RDyQH/DiJE3SD1QnCuwU6HjMN/jgouWVjny4ZxysTlZJKinwKKKQNH1FMFAh+hDZWxPUPbAEtZ71hQMoNst3ddmbMrfy9vwsGzNBNsJsb9w50YOcEV0GFUQh1x0hDBrsYjee4VFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368446; c=relaxed/simple;
	bh=pggi2wGubKR+iHMkCTnofBszBFtTA+68/+TjKuVXvgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdZE8Rno58XIu/Fz3TiVonT9dPyBEjZ+vqlW7axK96O1aYnfXckc8t3GCkGd/JO+9PpvGqLWhsUwArA5wrcaQ8CuKN891srEU6+nOnz80Jg/F3RVEDpnUBlMxRkfKjYYygbjhJ78k2seUTq0o8lmdiPAjg4lJbTOzsXikCcHyI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Da8IdU1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Da8IdU1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8F8C4CEE7;
	Mon, 13 Oct 2025 15:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368445;
	bh=pggi2wGubKR+iHMkCTnofBszBFtTA+68/+TjKuVXvgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Da8IdU1J4ZyRypeYNPDPOllKr+X+k7faxVpxPsrf6nhqRa1ANY0LzGMfSjQlBX4df
	 kMx1KqjxBH5mxBYLKKGpClrElQryOyjr3N85HUhPdoSS0m0qsggN5midebvwx01DHZ
	 Zaj6JPrWKyoWm+kQAHUk5YeraHAY7UCS4s2YL3IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Zanussi <zanussi@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 164/262] Documentation: trace: historgram-design: Separate sched_waking histogram section heading and the following diagram
Date: Mon, 13 Oct 2025 16:45:06 +0200
Message-ID: <20251013144332.030374626@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

[ Upstream commit 8c716e87ea33519920811338100d6d8a7fb32456 ]

Section heading for sched_waking histogram is shown as normal paragraph
instead due to codeblock marker for the following diagram being in the
same line as the section underline. Separate them.

Fixes: daceabf1b494 ("tracing/doc: Fix ascii-art in histogram-design.rst")
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20250916054202.582074-5-bagasdotme@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/histogram-design.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace/histogram-design.rst b/Documentation/trace/histogram-design.rst
index 5765eb3e9efa7..a30f4bed11b4e 100644
--- a/Documentation/trace/histogram-design.rst
+++ b/Documentation/trace/histogram-design.rst
@@ -380,7 +380,9 @@ entry, ts0, corresponding to the ts0 variable in the sched_waking
 trigger above.
 
 sched_waking histogram
-----------------------::
+----------------------
+
+.. code-block::
 
   +------------------+
   | hist_data        |<-------------------------------------------------------+
-- 
2.51.0



