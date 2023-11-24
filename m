Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB5B33CCA;
	Fri, 24 Nov 2023 19:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4u+TLKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C72AC433CA;
	Fri, 24 Nov 2023 19:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853510;
	bh=Ec47Oyq2wElovwshFO8jpng6tFfN0HCLHSH3D0C8/Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4u+TLKgjE6chf2ciSSlEepgNcGOf6vL86JQTJSbNL4UEaKoVnyzVwAGfaPERbFho
	 kyC0XyiyY+5bmw0Hz9fvLZMY86i+jSnn5k2MnkI3qZWWl6dNnQvxuXetYdPoLqs92P
	 2q/417/jnUTIwLGs53paz/0jIokw9PSZhHC+MnFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.15 210/297] selftests/resctrl: Reduce failures due to outliers in MBA/MBM tests
Date: Fri, 24 Nov 2023 17:54:12 +0000
Message-ID: <20231124172007.566110144@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit ef43c30858754d99373a63dff33280a9969b49bc upstream.

The initial value of 5% chosen for the maximum allowed percentage
difference between resctrl mbm value and IMC mbm value in

commit 06bd03a57f8c ("selftests/resctrl: Fix MBA/MBM results reporting
       format") was "randomly chosen value" (as admitted by the changelog).

When running tests in our lab across a large number platforms, 5%
difference upper bound for success seems a bit on the low side for the
MBA and MBM tests. Some platforms produce outliers that are slightly
above that, typically 6-7%, which leads MBA/MBM test frequently
failing.

Replace the "randomly chosen value" with a success bound that is based
on those measurements across large number of platforms by relaxing the
MBA/MBM success bound to 8%. The relaxed bound removes the failures due
the frequent outliers.

Fixed commit description style error during merge:
Shuah Khan <skhan@linuxfoundation.org>

Fixes: 06bd03a57f8c ("selftests/resctrl: Fix MBA/MBM results reporting format")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/resctrl/mba_test.c |    2 +-
 tools/testing/selftests/resctrl/mbm_test.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/resctrl/mba_test.c
+++ b/tools/testing/selftests/resctrl/mba_test.c
@@ -12,7 +12,7 @@
 
 #define RESULT_FILE_NAME	"result_mba"
 #define NUM_OF_RUNS		5
-#define MAX_DIFF_PERCENT	5
+#define MAX_DIFF_PERCENT	8
 #define ALLOCATION_MAX		100
 #define ALLOCATION_MIN		10
 #define ALLOCATION_STEP		10
--- a/tools/testing/selftests/resctrl/mbm_test.c
+++ b/tools/testing/selftests/resctrl/mbm_test.c
@@ -11,7 +11,7 @@
 #include "resctrl.h"
 
 #define RESULT_FILE_NAME	"result_mbm"
-#define MAX_DIFF_PERCENT	5
+#define MAX_DIFF_PERCENT	8
 #define NUM_OF_RUNS		5
 
 static int


