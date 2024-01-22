Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396F55BAFD;
	Tue, 23 Jan 2024 01:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974360; cv=none; b=D4t05X1m28tSpXxXuHW38oW/Up7VCvPxp7a5Guz5ZjMuWcv7/tok5G3StRv3vv41ehbiOPwXJZZoXGjp4WzeNukPWI7iTtA5inakSqItomVwSCsud49fGoA7J9NtC32nEhWWCmcmtqhhGk3vpK30XEFDBme+HIefRQl6P/FQa5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974360; c=relaxed/simple;
	bh=2A0aLUdlR/AuExWmldWGIUtP+6GgxcC/H8DhqZYjPVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BomAxLKGe4nZJiAIdMNGSDSEcC0kWKKDRx10+Lmo/7Q19RL/YIQnC9659433Rnsdzpg1EGDfSeAQPgxf86zfGl8MgjvmQAcg0yGYCx7ajzzKn1suGloN98eQLRXECqf19trryeqxknoornp0h9FPBZ8ZdmIKH7CspQ7Emnz7NVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyfkqKp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyfkqKp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8454C433C7;
	Tue, 23 Jan 2024 01:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974360;
	bh=2A0aLUdlR/AuExWmldWGIUtP+6GgxcC/H8DhqZYjPVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyfkqKp8z3X1tJjkf0dF2CuF6F+QsuHeh0/E44K8FYVjTRb2g+3rhqLXSV1dKO3W6
	 IihJY4QccTjj/NHNi8LlCRtjIIyah5UAjeEx0nKIDg3HWz6i3aZlzJ/grYuxGRSvFe
	 dOxvi96S9aNIgcCtOyf0R78u+4MbZ8T0kD4gco8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/583] dlm: fix format seq ops type 4
Date: Mon, 22 Jan 2024 15:51:56 -0800
Message-ID: <20240122235814.129242476@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 367e753d5c54a414d82610eb709fe71fda6cf1c3 ]

This patch fixes to set the type 4 format ops in case of table_open4().
It got accidentially changed by commit 541adb0d4d10 ("fs: dlm: debugfs
for queued callbacks") and since them toss debug dumps the same format
as format 5 that are the queued ast callbacks for lkbs.

Fixes: 541adb0d4d10 ("fs: dlm: debugfs for queued callbacks")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/debug_fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index c93359ceaae6..d2c035387595 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -748,7 +748,7 @@ static int table_open4(struct inode *inode, struct file *file)
 	struct seq_file *seq;
 	int ret;
 
-	ret = seq_open(file, &format5_seq_ops);
+	ret = seq_open(file, &format4_seq_ops);
 	if (ret)
 		return ret;
 
-- 
2.43.0



