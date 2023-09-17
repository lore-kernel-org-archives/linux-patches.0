Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8401C6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF5DC433A9;
	Sun, 17 Sep 2023 20:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981534;
	bh=90/VDRzgAsMMbP9GktBU599SBM0WKn8bYsfshphDvvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATHELWMrKbsDMw8jzATy6LKea6R+0gDdSx3Hiuf0Wu4r080lVdWxDjQPhxPbH3zSD
	 nFzCJ/ATLcp9aPMqc8j14Qiya3q16Q4n2gJHM0tQlKNg6C6WcWWCVWFI5TDIchAYlP
	 /usRrO7uZaCsiC1L6cWQfJFy7wQGZIvnBTwAWPeY=
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
Subject: [PATCH 5.15 068/511] selftests/resctrl: Unmount resctrl FS if child fails to run benchmark
Date: Sun, 17 Sep 2023 21:08:15 +0200
Message-ID: <20230917191115.523591702@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

[ Upstream commit f99e413eb54652e2436cc56d081176bc9a34cd8d ]

A child calls PARENT_EXIT() when it fails to run a benchmark to kill
the parent process. PARENT_EXIT() lacks unmount for the resctrl FS and
the parent won't be there to unmount it either after it gets killed.

Add the resctrl FS unmount also to PARENT_EXIT().

Fixes: 591a6e8588fc ("selftests/resctrl: Add basic resctrl file system operations and data")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Tested-by: Shaopeng Tan (Fujitsu) <tan.shaopeng@fujitsu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/resctrl.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
index f44fa2de4d986..dbe5cfb545585 100644
--- a/tools/testing/selftests/resctrl/resctrl.h
+++ b/tools/testing/selftests/resctrl/resctrl.h
@@ -43,6 +43,7 @@
 	do {					\
 		perror(err_msg);		\
 		kill(ppid, SIGKILL);		\
+		umount_resctrlfs();		\
 		exit(EXIT_FAILURE);		\
 	} while (0)
 
-- 
2.40.1



