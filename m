Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB13FBF3
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2F8C433D2;
	Mon, 15 May 2023 16:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169577;
	bh=okmCW/nC5I62wkF5kWuZFeOKF9Qrq+Dk2uDjwK7SZZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UA0iRLXmgArEXzBKu4qq2XTvVxZxpzBfOGngQ8BWhbVrYA8/6TqmOem7NC0CG/KGS
	 8B7HUGIjnxaG94GVzsOhTJbaIDKc9+Dy0CHJKl6G05+JMccrC4eneRZFBSyqKe9PPn
	 ezCK8fEkuVsNqJ9rMYPHsZoGIRtIcyKBSd2rxR5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Lozko <lozko.roma@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 103/246] perf scripts intel-pt-events.py: Fix IPC output for Python 2
Date: Mon, 15 May 2023 18:25:15 +0200
Message-Id: <20230515161725.672416780@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roman Lozko <lozko.roma@gmail.com>

[ Upstream commit 1f64cfdebfe0494264271e8d7a3a47faf5f58ec7 ]

Integers are not converted to floats during division in Python 2 which
results in incorrect IPC values. Fix by switching to new division
behavior.

Fixes: a483e64c0b62e93a ("perf scripting python: intel-pt-events.py: Add --insn-trace and --src-trace")
Signed-off-by: Roman Lozko <lozko.roma@gmail.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20230310150445.2925841-1-lozko.roma@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/scripts/python/intel-pt-events.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/scripts/python/intel-pt-events.py b/tools/perf/scripts/python/intel-pt-events.py
index 08862a2582f44..1c76368f13c1a 100644
--- a/tools/perf/scripts/python/intel-pt-events.py
+++ b/tools/perf/scripts/python/intel-pt-events.py
@@ -11,7 +11,7 @@
 # FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 # more details.
 
-from __future__ import print_function
+from __future__ import division, print_function
 
 import io
 import os
-- 
2.39.2



