Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4539E8F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62C7C433C7;
	Sun, 16 Jul 2023 20:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540980;
	bh=MhWnvgjUa0GJERQ4HN7kdbji4IAM4pWddadrN0fUFlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHap22rPmMFhwCrfTSqwdMzcvwh3GeSNgH9qMsnEbMGzjqiDqARUxr7vz2syGCjYE
	 /zFcdT0D+Ar/v1WTcEKjskuPlvyjceulDhVu49U9S1wwOBN+6xzTAhT9rOEvpC5fmZ
	 IOmnvD/KjCCwig1YFdCIrB2MzhsavSnARsxo+hp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 519/591] dm ioctl: have constant on the right side of the test
Date: Sun, 16 Jul 2023 21:50:58 +0200
Message-ID: <20230716194937.303692071@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heinz Mauelshagen <heinzm@redhat.com>

[ Upstream commit 5cae0aa77397015f530aeb34f3ced32db6ac2875 ]

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Stable-dep-of: 249bed821b4d ("dm ioctl: Avoid double-fetch of version")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 2ced382cdd70b..6aeae095086d7 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1819,8 +1819,8 @@ static int check_version(unsigned int cmd, struct dm_ioctl __user *user)
 	if (copy_from_user(version, user->version, sizeof(version)))
 		return -EFAULT;
 
-	if ((DM_VERSION_MAJOR != version[0]) ||
-	    (DM_VERSION_MINOR < version[1])) {
+	if ((version[0] != DM_VERSION_MAJOR) ||
+	    (version[1] > DM_VERSION_MINOR)) {
 		DMERR("ioctl interface mismatch: kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
 		      DM_VERSION_MAJOR, DM_VERSION_MINOR,
 		      DM_VERSION_PATCHLEVEL,
-- 
2.39.2



