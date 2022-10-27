Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712BF8486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED204C433D7;
	Thu, 27 Oct 2022 17:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890017;
	bh=IelhFjdo+Nbb+ZaaSKU7P1Dwd1+KS+fy+R7cjWKzj+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQrKfpxZPcGXq2KYAD09JRTblT1h7RYXwMzvrBeP2q+q2bn77V+LDoQ4lfhF9UhbN
	 RD78mhqE/SUaBteuwHSoy6Y2HwUBMaFcmQbQBNOG1s5Ck7yZ5wJfiQ1QDdGCZs3FBx
	 Q93N6acrcg68Ab7+TsQ6QVqlkqDdXa9AH0LN+mug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	kernel test robot <lkp@intel.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 85/94] rv/dot2c: Make automaton definition static
Date: Thu, 27 Oct 2022 18:55:27 +0200
Message-Id: <20221027165100.615336065@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Bristot de Oliveira <bristot@kernel.org>

[ Upstream commit 21a1994b6492b12e55dbf39d15271430ef6839f0 ]

Monitor's automata definition is only used locally, so make dot2c generate
a static definition.

Link: https://lore.kernel.org/all/202208210332.gtHXje45-lkp@intel.com
Link: https://lore.kernel.org/all/202208210358.6HH3OrVs-lkp@intel.com
Link: https://lkml.kernel.org/r/ffbb92010f643307766c9307fd42f416e5b85fa0.1661266564.git.bristot@kernel.org

Cc: Steven Rostedt <rostedt@goodmis.org>
Fixes: e3c9fc78f096 ("tools/rv: Add dot2c")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/verification/dot2/dot2c.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/verification/dot2/dot2c.py b/tools/verification/dot2/dot2c.py
index fa73353f7e56..be8a364a469b 100644
--- a/tools/verification/dot2/dot2c.py
+++ b/tools/verification/dot2/dot2c.py
@@ -111,7 +111,7 @@ class Dot2c(Automata):
 
     def format_aut_init_header(self):
         buff = []
-        buff.append("struct %s %s = {" % (self.struct_automaton_def, self.var_automaton_def))
+        buff.append("static struct %s %s = {" % (self.struct_automaton_def, self.var_automaton_def))
         return buff
 
     def __get_string_vector_per_line_content(self, buff):
-- 
2.35.1



