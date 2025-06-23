Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCD41D86DC;
	Mon, 23 Jun 2025 22:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716196; cv=none; b=r0DL+j9xYrAdCGqBgITzeBgmZHuUas8lSrlxyjXR6AJFF3LtqERoZI1jhmlXSWIiOTKLN5hAKEWP76COYO1/ydWC4s1qqFlriXmqGK610dJjlfuBx/3TDNbJPKFtdjZ24gmOihYgYP3Ptu/VpEjgzGIT2RRAdB4jDPpKQqJ+yOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716196; c=relaxed/simple;
	bh=tAG6K8G0bQ7qKwL+eSJcO9IWrvk+CmiMBoVSE4PDqgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xo4U999j7OTrdDosQ4kp/rD7zF77rtDptjNGIYotOxTbR72lb+qTXflCUX7Vb1xTwbUsL3MTVUwjqlzDYRi1d33Zp1d1e333LzvknFevVzdmyPIuFsLNw7ruBKVnzZMpmvpXXvNLqLPBxBxbuWcxj2JfpJJLXfaWXqUhgtdLxCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSXwWKdz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSXwWKdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD48C4CEEA;
	Mon, 23 Jun 2025 22:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716196;
	bh=tAG6K8G0bQ7qKwL+eSJcO9IWrvk+CmiMBoVSE4PDqgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSXwWKdzpZMgal3YO9VJKz0vM0iwsvKeom6TzScCdhm1gA4oabdj3dPmBbt5QShxo
	 MXgNbUfDQ/+yvfY9fylo46iMuGp/7MRO/4YMVt8yS18uzn+Qom4UoEv1+cQOn73Dkh
	 KSMWhPtMBrUaCz4CGMsHFVgtV0kvaV44BRo0zSDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 5.15 334/411] i40e: fix MMIO write access to an invalid page in i40e_clear_hw
Date: Mon, 23 Jun 2025 15:07:58 +0200
Message-ID: <20250623130642.056912685@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyungwook Boo <bookyungwook@gmail.com>

[ Upstream commit 015bac5daca978448f2671478c553ce1f300c21e ]

When the device sends a specific input, an integer underflow can occur, leading
to MMIO write access to an invalid page.

Prevent the integer underflow by changing the type of related variables.

Signed-off-by: Kyungwook Boo <bookyungwook@gmail.com>
Link: https://lore.kernel.org/lkml/ffc91764-1142-4ba2-91b6-8c773f6f7095@gmail.com/T/
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 99dd8187476ba..fe8e6db53f23b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1061,10 +1061,11 @@ int i40e_pf_reset(struct i40e_hw *hw)
 void i40e_clear_hw(struct i40e_hw *hw)
 {
 	u32 num_queues, base_queue;
-	u32 num_pf_int;
-	u32 num_vf_int;
+	s32 num_pf_int;
+	s32 num_vf_int;
 	u32 num_vfs;
-	u32 i, j;
+	s32 i;
+	u32 j;
 	u32 val;
 	u32 eol = 0x7ff;
 
-- 
2.39.5



