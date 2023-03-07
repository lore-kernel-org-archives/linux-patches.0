Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D146BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E41C433D2;
	Tue,  7 Mar 2023 18:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215539;
	bh=0PUw4MVpfQLlCW/kccu/ExNflEiMw4ygIXMfL/3Hx9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jdvcIse092ICeXGXDsblrUZOag1iD3UgS1EKXMSJYrqkrjVjs3xPUaG0r9RK67axj
	 Gp6kq2EO170FgZaZ85KGtXAWfZB+DDpaS6umWSvt9aBCjxgoHIwPLLE/rsqkqKzMJE
	 8H/JGCaumPhCWXtUdGv/uhtbj3fANn1pBLXtry+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 263/567] perf intel-pt: Add link to the perf wikis Intel PT page
Date: Tue,  7 Mar 2023 17:59:59 +0100
Message-Id: <20230307165917.314249338@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 9e5e641045ff09ded4eb52828c4c7e110635422a ]

Add an EXAMPLE section and link to the perf wiki's Intel PT page.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: http://lore.kernel.org/lkml/20220426133213.248475-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: aeb802f872a7 ("perf intel-pt: Do not try to queue auxtrace data on pipe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Documentation/perf-intel-pt.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/Documentation/perf-intel-pt.txt b/tools/perf/Documentation/perf-intel-pt.txt
index 48460923a0e4e..d44e6a332dfb1 100644
--- a/tools/perf/Documentation/perf-intel-pt.txt
+++ b/tools/perf/Documentation/perf-intel-pt.txt
@@ -1438,6 +1438,13 @@ In that case the --itrace q option is forced because walking executable code
 to reconstruct the control flow is not possible.
 
 
+EXAMPLE
+-------
+
+Examples can be found on perf wiki page "Perf tools support for Intel® Processor Trace":
+
+https://perf.wiki.kernel.org/index.php/Perf_tools_support_for_Intel%C2%AE_Processor_Trace
+
 
 SEE ALSO
 --------
-- 
2.39.2



