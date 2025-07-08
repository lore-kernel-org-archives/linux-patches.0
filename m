Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FB923DE;
	Tue,  8 Jul 2025 16:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993333; cv=none; b=jagnCCAZuIhEHGjJgCUs8RzwR9QHIKxmi2qELxhAMIdY5OYiUpKjSmmVX+tEbk45ku+PBfGJRbk5QZjhH4q8+blNOs7F5PD1rrrujBAhP3SI7Vj7ow9CeMs0CiueCbT90qddMSMzWFV2bux2ALm7EZm9uKtzTacZAKORzNb0tWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993333; c=relaxed/simple;
	bh=vOyAIPbpzJ2MwyuAaq5BBKwE1yQIWqhYzHFuhFDXopM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POerm4hvaJDjAAyxagCiMyfRQcJDW2IcoBeP4k6KAtrmRH9LMldcIC8ymAQP57zppMLnXjDiLTXrJosokv7NSyk9HVw8xj2WBVezkCNqPq+zIgEeTpiHZsCzffYGBWL3xi6+otHnRCs1X0Zw1NUcs0n815BEYNG0lPF1f7p0Zw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1v8sOQw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1v8sOQw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FBDC4CEED;
	Tue,  8 Jul 2025 16:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993332;
	bh=vOyAIPbpzJ2MwyuAaq5BBKwE1yQIWqhYzHFuhFDXopM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1v8sOQw9Isywwr/ggVOJ6szSb9i1x8lWG+SgKAUDUP1RM3cM5gAkxVu5JfR7nxONd
	 nM0gPGst1aR62kkUAXmvSWe76IF745v25pE8/xUTynRgKhxPr0Vx9ToaLjhLcWyp07
	 rPxlHsCXAShEzIeCUNf1jZX/yPVRZlHTMtOdXB5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Bertrand Marquis <bertrand.marquis@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 036/178] firmware: arm_ffa: Fix the missing entry in struct ffa_indirect_msg_hdr
Date: Tue,  8 Jul 2025 18:21:13 +0200
Message-ID: <20250708162237.625528595@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 4c46a471be12216347ba707f8eadadbf5d68e698 ]

As per the spec, one 32 bit reserved entry is missing here, add it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Fixes: 910cc1acc9b4 ("firmware: arm_ffa: Add support for passing UUID in FFA_MSG_SEND2")
Reviewed-by: Bertrand Marquis <bertrand.marquis@arm.com>
Message-Id: <28a624fbf416975de4fbe08cfbf7c2db89cb630e.1748948911.git.viresh.kumar@linaro.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/arm_ffa.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index 5bded24dc24fe..e1634897e159c 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -283,6 +283,7 @@ struct ffa_indirect_msg_hdr {
 	u32 offset;
 	u32 send_recv_id;
 	u32 size;
+	u32 res1;
 	uuid_t uuid;
 };
 
-- 
2.39.5



