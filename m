Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753B13218C2;
	Mon, 18 Aug 2025 13:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522482; cv=none; b=KbaeQ9iMZOqwqvmtdMKCI9br+nYm0OnsW9UrwEd1o3yuM5YXdUJspYa2EZbJhecyrBvodQXjxgJ5rGvTEw715s5KhY1D7Wc53dHxu1TBgIW5Y+hoFeCYIvk0RtSsb3AFtcCaw78OJcfNZ5UHym37aNPPF7KhI5NS18krsAgXLHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522482; c=relaxed/simple;
	bh=KLrrrniHZwESHB7qrfQo0/2BzMh9LHsn9cZKfyfMToQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nO/WdqvyQaEztppFkW4orhNFUEtbw5WEHvk+e5AtG/9awfI9mcIHAxICvwMYyIavaiB/G8l4hjrDTuL2pAUf9gnG+eN5w7DV+JXnoqIn7nnECQcmH+AZz9yvV65Sl9U2HvBgqY4oQw/G78b4VA+tR6IfF3rGfBjDCKblhT3RU0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+Pfq3Vq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+Pfq3Vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF95EC4CEEB;
	Mon, 18 Aug 2025 13:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522482;
	bh=KLrrrniHZwESHB7qrfQo0/2BzMh9LHsn9cZKfyfMToQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+Pfq3Vqf/CQzP8KMRehzLGTiU87Hg4SDzj4zGgQhhREydJHq4/Y50+UzcSuyjtDn
	 AwKl5uxaUhFDW5ki9Awx0t6TwwqjkTij8Vt0qLvTNavw/uAJOFwGqv+mWtnqSdSWa+
	 tOFUzMnA8hTTIdUKVbDpwZsuhfabg90/BpTvTWqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Shravya KN <shravya.k-n@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 296/444] RDMA/bnxt_re: Fix size of uverbs_copy_to() in BNXT_RE_METHOD_GET_TOGGLE_MEM
Date: Mon, 18 Aug 2025 14:45:22 +0200
Message-ID: <20250818124500.055997834@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 09d231ab569ca97478445ccc1ad44ab026de39b1 ]

Since both "length" and "offset" are of type u32, there is
no functional issue here.

Reviewed-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Shravya KN <shravya.k-n@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/20250704043857.19158-2-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 0b21d8b5d962..4a3ce61a3bba 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4642,7 +4642,7 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE_MEM)(struct uverbs_attr_bund
 		return err;
 
 	err = uverbs_copy_to(attrs, BNXT_RE_TOGGLE_MEM_MMAP_OFFSET,
-			     &offset, sizeof(length));
+			     &offset, sizeof(offset));
 	if (err)
 		return err;
 
-- 
2.39.5



