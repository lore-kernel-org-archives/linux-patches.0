Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E71BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9012BC433EF;
	Tue,  7 Mar 2023 19:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216378;
	bh=bj36EocgUtIdbQ14b1Ttz0PbL87LXN5sZ/dCZxWxt14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+bQ9Y0XU1+KMEe4z4q+nb41staDhlsWFJYUFbbHVTtbBVVYIDBtFs2GwjkSgOGvT
	 iXikWDPR7MqKkNggBMY9JDB8yRn6+y0XFzSLp4v3XbHdI3/ZcXqQ8neFZZAHquktyK
	 7OX3xYG9KE3TffvYMy2wy0pMGkgnkzEG3FZz0T/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Alvarez Feijoo <antonio.feijoo@suse.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.15 537/567] tools/bootconfig: fix single & used for logical condition
Date: Tue,  7 Mar 2023 18:04:33 +0100
Message-Id: <20230307165929.222842402@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Antonio Alvarez Feijoo <antonio.feijoo@suse.com>

commit cf8c59a3756b2735c409a9b3ac1e4ec556546a7a upstream.

A single & will create a background process and return true, so the grep
command will run even if the file checked in the first condition does not
exist.

Link: https://lore.kernel.org/all/20230112114215.17103-1-antonio.feijoo@suse.com/

Fixes: 1eaad3ac3f39 ("tools/bootconfig: Use per-group/all enable option in ftrace2bconf script")
Signed-off-by: Antonio Alvarez Feijoo <antonio.feijoo@suse.com>
Cc: stable@vger.kernel.org
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bootconfig/scripts/ftrace2bconf.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bootconfig/scripts/ftrace2bconf.sh b/tools/bootconfig/scripts/ftrace2bconf.sh
index 6183b36c6846..1603801cf126 100755
--- a/tools/bootconfig/scripts/ftrace2bconf.sh
+++ b/tools/bootconfig/scripts/ftrace2bconf.sh
@@ -93,7 +93,7 @@ referred_vars() {
 }
 
 event_is_enabled() { # enable-file
-	test -f $1 & grep -q "1" $1
+	test -f $1 && grep -q "1" $1
 }
 
 per_event_options() { # event-dir
-- 
2.39.2



