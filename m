Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7019482CB;
	Thu, 30 Nov 2023 16:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiRAZJMU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756BFC433C8;
	Thu, 30 Nov 2023 16:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361510;
	bh=d4Kh8raAfDSyb2+3tIB1TOJ1jMVYuogQNvaAOJ5UbN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiRAZJMU1XcPEXgWSISjayd7JWTZ3wskZ8QepSefX0O+un/kBkq2Jow/Ps3Vye63P
	 pp7b6KtoV8SWzJ6lw590zTBkogyn3zr5S9vBRZfAla2aZJ1xnMyEetseookQtUsQcx
	 Z1zr+R9S3AfBC/vNrUGobHDJ06W76LkJF+1wEgvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Wolfram Sang <wsa@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/112] PM: tools: Fix sleepgraph syntax error
Date: Thu, 30 Nov 2023 16:21:14 +0000
Message-ID: <20231130162141.178471218@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: David Woodhouse <dwmw@amazon.co.uk>

[ Upstream commit b85e2dab33ce467e8dcf1cb6c0c587132ff17f56 ]

The sleepgraph tool currently fails:

  File "/usr/bin/sleepgraph", line 4155
    or re.match('psci: CPU(?P<cpu>[0-9]*) killed.*', msg)):
                                                         ^
SyntaxError: unmatched ')'

Fixes: 34ea427e01ea ("PM: tools: sleepgraph: Recognize "CPU killed" messages")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/pm-graph/sleepgraph.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/pm-graph/sleepgraph.py b/tools/power/pm-graph/sleepgraph.py
index 4a356a7067855..40ad221e88811 100755
--- a/tools/power/pm-graph/sleepgraph.py
+++ b/tools/power/pm-graph/sleepgraph.py
@@ -4151,7 +4151,7 @@ def parseKernelLog(data):
 			elif(re.match('Enabling non-boot CPUs .*', msg)):
 				# start of first cpu resume
 				cpu_start = ktime
-			elif(re.match('smpboot: CPU (?P<cpu>[0-9]*) is now offline', msg)) \
+			elif(re.match('smpboot: CPU (?P<cpu>[0-9]*) is now offline', msg) \
 				or re.match('psci: CPU(?P<cpu>[0-9]*) killed.*', msg)):
 				# end of a cpu suspend, start of the next
 				m = re.match('smpboot: CPU (?P<cpu>[0-9]*) is now offline', msg)
-- 
2.42.0



