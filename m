Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CC41A01A1;
	Thu,  6 Jun 2024 14:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683139; cv=none; b=dUr0f5TtdXVVOtJhIQYdRjgFjULjsSlv8otl+18C4Wwlcrt43AjHhEEkapmvwu1Bf8fK19jmmSshZPTVbQYV1U0ha6ni2IIBXJiftBS9TannHztgt2+B372LOPX6ClgZZLo07y0de2ieoNVmb5jjr7yAHsnjqJZw3lW4BSZSAAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683139; c=relaxed/simple;
	bh=pRbZTqZ4ClEeleQDZWdvSIatuPrrqgkGFOS7qmC73Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjkNHbuPGlpbNi2wentaqOC2GSI3Z6tzdkY/QS9rRQbJPoDraZI/9yiKfLmtxzEtE2IwjuyArNM6Q7qZ7xZrW7MVnM2nFBC4AwNO7jKettO/AdRwmUFpHxyh2oq8+x3awOzC08nRaxFMTQb22bEBasiER5SJKugz/OWCH987/+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmNO+IBE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmNO+IBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D895C2BD10;
	Thu,  6 Jun 2024 14:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683139;
	bh=pRbZTqZ4ClEeleQDZWdvSIatuPrrqgkGFOS7qmC73Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmNO+IBEEmVb5/0qheGwqmclTmmeMrh5DvK0MZdHU7mlKDqdfQpcqebURKUp80Dy/
	 42wKQ+uZGmDn/wFdEhzDkxJqolLt/rKHfV6CvlXbeRQSNrqvMXhsC8OOWUCaOZL8ew
	 Qmk3obMhOlUKVfqxmyWL3bWlUa4/GWVE5MB3Tqlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/744] nvmet-auth: return the error code to the nvmet_auth_host_hash() callers
Date: Thu,  6 Jun 2024 15:55:57 +0200
Message-ID: <20240606131735.128780658@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 46b8f9f74f6d500871985e22eb19560b21f3bc81 ]

If the nvmet_auth_host_hash() function fails, the error code should
be returned to its callers.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index 4dcddcf95279b..1f7d492c4dc26 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -368,7 +368,7 @@ int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 	kfree_sensitive(host_response);
 out_free_tfm:
 	crypto_free_shash(shash_tfm);
-	return 0;
+	return ret;
 }
 
 int nvmet_auth_ctrl_hash(struct nvmet_req *req, u8 *response,
-- 
2.43.0



