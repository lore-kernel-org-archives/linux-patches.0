Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116132D787;
	Fri, 24 Nov 2023 18:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndqRYMyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B45BC433C9;
	Fri, 24 Nov 2023 18:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851209;
	bh=AKOsXrrK3koaz4fZgXklVgY+/88ZGhAxfi98dtXzGeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndqRYMyZROa4H7CYDLPNrqoasR9AR4syc3CAgm2mEENMBJ/8QG5wHV62l+KOJpPuZ
	 LN2cObJX3NmKLSE98nc07dmb84+zwgHmGq8XOyNuVewFtBYPnQYO6M3qT2HyF5WKyz
	 el2+NW8UwHqeIpdwZHItgjJmfLpFlG5YwMoePGco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.5 332/491] selftests/resctrl: Remove duplicate feature check from CMT test
Date: Fri, 24 Nov 2023 17:49:28 +0000
Message-ID: <20231124172034.543823795@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

commit 030b48fb2cf045dead8ee2c5ead560930044c029 upstream.

The test runner run_cmt_test() in resctrl_tests.c checks for CMT
feature and does not run cmt_resctrl_val() if CMT is not supported.
Then cmt_resctrl_val() also check is CMT is supported.

Remove the duplicated feature check for CMT from cmt_resctrl_val().

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/resctrl/cmt_test.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/tools/testing/selftests/resctrl/cmt_test.c
+++ b/tools/testing/selftests/resctrl/cmt_test.c
@@ -90,9 +90,6 @@ int cmt_resctrl_val(int cpu_no, int n, c
 	if (ret)
 		return ret;
 
-	if (!validate_resctrl_feature_request(CMT_STR))
-		return -1;
-
 	ret = get_cbm_mask("L3", cbm_mask);
 	if (ret)
 		return ret;


