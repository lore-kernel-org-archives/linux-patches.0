Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F0741A84
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZ3TiwqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9538C433CB;
	Wed, 15 Nov 2023 19:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077005;
	bh=W/cC/sUwkSm6tCDZJrJdFJeIX3brPtNntsGqJhkPfhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZ3TiwqDnqctlyLQN5137CXQ2gfr6TZBdEkCGDt04w7Eef071S5arazPLMX0ZY276
	 HyFPlo0octh8FD+lWauminx9CrYFVZc8pASDUf3roGggXJM7HDN51hBKOFixqcrO7B
	 jbaVpsh33IT3ba6VjJPbIgHmOWCS3Kqww5xQCO74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mark Brown <broonie@kernel.org>,
	"Srivatsa S. Bhat (VMware)" <srivatsa@csail.mit.edu>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Len Brown <len.brown@intel.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 490/550] cpupower: fix reference to nonexistent document
Date: Wed, 15 Nov 2023 14:17:54 -0500
Message-ID: <20231115191634.838625557@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vegard Nossum <vegard.nossum@oracle.com>

[ Upstream commit 6feb1a9641197ee630bf43b5c34ea1d9f8b4a0aa ]

This file was renamed from .txt to .rst and left a dangling reference.
Fix it.

Fixes: 151f4e2bdc7a ("docs: power: convert docs to ReST and rename to *.rst")
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/man/cpupower-powercap-info.1 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/cpupower/man/cpupower-powercap-info.1 b/tools/power/cpupower/man/cpupower-powercap-info.1
index df3087000efb8..145d6f06fa72d 100644
--- a/tools/power/cpupower/man/cpupower-powercap-info.1
+++ b/tools/power/cpupower/man/cpupower-powercap-info.1
@@ -17,7 +17,7 @@ settings of all cores, see cpupower(1) how to choose specific cores.
 .SH "DOCUMENTATION"
 
 kernel sources:
-Documentation/power/powercap/powercap.txt
+Documentation/power/powercap/powercap.rst
 
 
 .SH "SEE ALSO"
-- 
2.42.0



