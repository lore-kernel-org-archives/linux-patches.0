Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E813A17B4EC;
	Tue,  8 Oct 2024 12:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389817; cv=none; b=Vxznv9huISr+Nvclgmgr1T14+ZVnvs5+uIA9RDU5iwwNDMvRWa4NiXYq1Yvngy3w/ZwAMSv0lz1nScAbahmUQ/u5leGYXeG+LJxkwWxP0KNMxLCDp90+eJRhOxrxcc/OEUxOIrvy3W/WP6dnkMNfYyz3khEMBVzQqAaXKtPaefw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389817; c=relaxed/simple;
	bh=6Y4TgvqSxnsPnsXmAtJI6AbZruYt6fY0u8DpgJfmojQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+LhLYCtU+NT8pDz4ZnhsbkNtEwPSln3Opln1+xu845HNV9r82CGlZg6OFAFh4yDHA6by2FwFp43HvoLfZOE8YKlz9Gc5N3/KCIwsoaJr9ZJF9RudmyUPZrz6eG8MJGoA3xhYnMT/MbugMoSEMeManbnFfKg9haQHcixVxtLB2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrC3ke0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrC3ke0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC439C4CEC7;
	Tue,  8 Oct 2024 12:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389816;
	bh=6Y4TgvqSxnsPnsXmAtJI6AbZruYt6fY0u8DpgJfmojQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrC3ke0B9GCzKoNugLzwMHBM8zEa5GTa8Q7kvQUthb5NIZNiNy4Gr2fQS2P8Qub76
	 RJpc00sMo8xf/0Gf7NyvnuuQXtxj5LpBTpq4u9E5QsJDeO1N6+ynfL6OO+SBHb7PJl
	 pViIY3hOScB7iDxcxmdGJKlzmnDtfTT1tP9gU9Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 105/482] bnxt_en: Extend maximum length of version string by 1 byte
Date: Tue,  8 Oct 2024 14:02:48 +0200
Message-ID: <20241008115652.441088036@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit ffff7ee843c351ce71d6e0d52f0f20bea35e18c9 ]

This corrects an out-by-one error in the maximum length of the package
version string. The size argument of snprintf includes space for the
trailing '\0' byte, so there is no need to allow extra space for it by
reducing the value of the size argument by 1.

Found by inspection.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20240813-bnxt-str-v2-1-872050a157e7@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 79c09c1cdf936..0032c4ebd7e12 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -4146,7 +4146,7 @@ static void bnxt_get_pkgver(struct net_device *dev)
 
 	if (!bnxt_get_pkginfo(dev, buf, sizeof(buf))) {
 		len = strlen(bp->fw_ver_str);
-		snprintf(bp->fw_ver_str + len, FW_VER_STR_LEN - len - 1,
+		snprintf(bp->fw_ver_str + len, FW_VER_STR_LEN - len,
 			 "/pkg %s", buf);
 	}
 }
-- 
2.43.0



