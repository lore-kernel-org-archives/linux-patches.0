Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B69381DC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gy4M3+fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5569AC433C7;
	Wed, 15 Nov 2023 19:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076927;
	bh=wxbEi4+MECzaMug/mpu2qFyYt/kzA8WsAn2yQctrcBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gy4M3+fwekqTCdYpyD0iIa91QcudYKtrYMO5f8r8Z7WnzSeZfFtZ9gaZ5oemeBKXk
	 qJSW+1UIXw4xdnrMIjA9IRgi8KwQEsrOnimt4Kd4icTR/XRxgIfjxqZs39+kBiO1qW
	 N14GN6Zi1j0TCPVh4OIKFLqU7DArWo+4Ca3jX5lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 448/550] rtla: Fix uninitialized variable found
Date: Wed, 15 Nov 2023 14:17:12 -0500
Message-ID: <20231115191631.860717503@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 696444a544ecd6d62c1edc89516b376cefb28929 ]

Variable found is not being initialized, in the case where the desired
mount is not found the variable contains garbage. Fix this by initializing
it to zero.

Link: https://lore.kernel.org/all/20230727150117.627730-1-colin.i.king@gmail.com/

Fixes: a957cbc02531 ("rtla: Add -C cgroup support")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/src/utils.c b/tools/tracing/rtla/src/utils.c
index 623a38908ed5b..c769d7b3842c0 100644
--- a/tools/tracing/rtla/src/utils.c
+++ b/tools/tracing/rtla/src/utils.c
@@ -538,7 +538,7 @@ static const int find_mount(const char *fs, char *mp, int sizeof_mp)
 {
 	char mount_point[MAX_PATH];
 	char type[100];
-	int found;
+	int found = 0;
 	FILE *fp;
 
 	fp = fopen("/proc/mounts", "r");
-- 
2.42.0



