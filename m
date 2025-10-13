Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCA530BBB6;
	Mon, 13 Oct 2025 15:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367767; cv=none; b=gLeKd6hm646/iDjO2cuPPf7NJBTtL1AA/gMeHzCz2KffOt/56rE1w7X7A9SfifbM0klAUOiRH38JjM7ewb5646qet5cn558qhsi6hC7dcotfCKVOpYlUMzSU7Ad3yCZ/WMPdpcX+4c/NWgVqZEciXXWEycI7+uzGSfe3G14bzhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367767; c=relaxed/simple;
	bh=KrVl1nmbjBwvQNYcGUr71cBZT7lkEPqWegUotMziRUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQCnVG13BGP/ugSk82SmrYgdfKecMB7wAm4ec9QVDWBBLyIPj5ttteN/krJTQPSRBbh6NXtZa4L9pWscxAsvLzMbu28lb+ZdJkZSP/heMnNzIQlsr+HFGdOWIfws1iNKTu0FROQUrQuQUvLf7y2czqBlUj9Lve9hulf4rOpkyrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKG6ZU9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKG6ZU9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F5CC4CEE7;
	Mon, 13 Oct 2025 15:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367767;
	bh=KrVl1nmbjBwvQNYcGUr71cBZT7lkEPqWegUotMziRUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKG6ZU9ZTFLNP7QJWLS3dGyf91YBjAQ7QMJ2hzmFIrwv27NGEO9Ad3INUmH/aVzmh
	 PlndjLcy6mCrR+cbTF3XySklAAv1m8oL8swiKTCkaxYAs/JYG3Pw4cSTQMFYv4X979
	 spzhGKQaZFAqO3PUSHzyvHPTIy/8Iv4X/TzQiACk=
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
Subject: [PATCH 6.6 126/196] Documentation: trace: historgram-design: Separate sched_waking histogram section heading and the following diagram
Date: Mon, 13 Oct 2025 16:45:17 +0200
Message-ID: <20251013144319.866754457@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



