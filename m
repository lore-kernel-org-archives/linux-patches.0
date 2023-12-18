Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C3D3788E;
	Mon, 18 Dec 2023 14:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B12sIgPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89F5C433CA;
	Mon, 18 Dec 2023 14:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908221;
	bh=5PonOZEbqFusvDsDmWYyrtWokYqyi+SGV8R1OcC+2MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B12sIgPbMWLv2a4E0Zp5vSoKB2aEmD2b1qwqTmAJ4DveTGAZHFnsgKvyC0L1svO5C
	 Hxb3D94djq/UPhEi6Lwvol5h9te6lkP5CBbe5oWCzdu6QUaqdgB8l9prmbIFAzoqLl
	 1kRym6Y5/VzLe0bl5EA6pn7nPt15BMhMpY5AePdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark ODonovan <shiftee@posteo.net>,
	Hannes Reinecke <hare@suse.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/166] nvme-auth: set explanation code for failure2 msgs
Date: Mon, 18 Dec 2023 14:51:04 +0100
Message-ID: <20231218135109.373243575@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Mark O'Donovan <shiftee@posteo.net>

[ Upstream commit 38ce1570e2c46e7e9af983aa337edd7e43723aa2 ]

Some error cases were not setting an auth-failure-reason-code-explanation.
This means an AUTH_Failure2 message will be sent with an explanation value
of 0 which is a reserved value.

Signed-off-by: Mark O'Donovan <shiftee@posteo.net>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/auth.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -840,6 +840,8 @@ static void nvme_queue_auth_work(struct
 	}
 
 fail2:
+	if (chap->status == 0)
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_FAILED;
 	dev_dbg(ctrl->device, "%s: qid %d send failure2, status %x\n",
 		__func__, chap->qid, chap->status);
 	tl = nvme_auth_set_dhchap_failure2_data(ctrl, chap);


