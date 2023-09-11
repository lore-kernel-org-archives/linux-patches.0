Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB691170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF6AC433C8;
	Mon, 11 Sep 2023 13:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440351;
	bh=RLnomFS5Et5ZuDjwT1EtJpfDvkJG/LRtN42AgmXFIsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQ8D2/uWxS3gxFAwueeVCLobY3xuPFjijBHS3tbPOkrhu1kaoJ2A9C1X13LtE6jIL
	 oemiqxh6XKB6kb2j7E2r37mK6LJlzpTaK2eaqpprLha+3TTB9X6PyELwCE5Y/MB0J/
	 rTgvQ/kCFENhZVWpbF5LYOD/brIdKMM0qbTqqICY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Babu Moger <babu.moger@amd.com>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 031/739] selftests/resctrl: Add resctrl.h into build deps
Date: Mon, 11 Sep 2023 15:37:10 +0200
Message-ID: <20230911134651.954485459@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 8e289f4542890168705219e54f0231dccfabddbe ]

Makefile only lists *.c as build dependencies for the resctrl_tests
executable which excludes resctrl.h.

Add *.h to wildcard() to include resctrl.h.

Fixes: 591a6e8588fc ("selftests/resctrl: Add basic resctrl file system operations and data")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Shaopeng Tan (Fujitsu) <tan.shaopeng@fujitsu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/resctrl/Makefile b/tools/testing/selftests/resctrl/Makefile
index 73d53257df42f..5073dbc961258 100644
--- a/tools/testing/selftests/resctrl/Makefile
+++ b/tools/testing/selftests/resctrl/Makefile
@@ -7,4 +7,4 @@ TEST_GEN_PROGS := resctrl_tests
 
 include ../lib.mk
 
-$(OUTPUT)/resctrl_tests: $(wildcard *.c)
+$(OUTPUT)/resctrl_tests: $(wildcard *.[ch])
-- 
2.40.1



