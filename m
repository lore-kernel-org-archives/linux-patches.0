Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC7234C988;
	Wed,  3 Dec 2025 16:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777724; cv=none; b=Pz+Kw/rHALLJzRoH+pBaJ1z22O6pgBPjxw5GeoUJNMsFeSBuyqYRIFzv/syzIIvzUj8/4eX5dG5Cc8Hgc54Cfc4F4NOf1YFuOMutkA0xVsbALRhL0xNAKNiCdNkRMpLo7FZ+XIt0RKwDbUUToJ6R9OnlkJjkcQ5MMhfmX2uHw8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777724; c=relaxed/simple;
	bh=BvEwuIThMGP+cyk6N6akDdUerbcgD2P/hyKxqHSUKE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucdReNm3SJ2fFd3sV2OjkPRCHTM9moRbNapzRSLyqVyzbUL3VY2U8k2VKCjige526J+XXIbTTdqvhiR8viP8q1tG9/h4Hw6D/vh3eXkDrifgUy3xi8mBA+eYgASG981lZNZriTjsCpvggfNAThAmBUIJAtOptYrlZzM0KnYug8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFEy1kNt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFEy1kNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A38C4CEF5;
	Wed,  3 Dec 2025 16:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777723;
	bh=BvEwuIThMGP+cyk6N6akDdUerbcgD2P/hyKxqHSUKE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFEy1kNt8GeRrIY5YUTRfbH7QLjS2DMNR8TnZeOWrEo57G+SBJ+gzvZOlR4ljkLjX
	 +GT5YBKin1Du3w049/2koJurJoiqJw4HeFgX5hLQCH0vIX6kRfiM7mDJsqANwuQadk
	 qNPt3HhQN+1u0q0cMUneI3L4pn24ZiACiKPbNmsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/392] scsi: pm8001: Use int instead of u32 to store error codes
Date: Wed,  3 Dec 2025 16:24:35 +0100
Message-ID: <20251203152418.693478884@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit bee3554d1a4efbce91d6eca732f41b97272213a5 ]

Use int instead of u32 for 'ret' variable to store negative error codes
returned by PM8001_CHIP_DISP->set_nvmd_req().

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Link: https://lore.kernel.org/r/20250826093242.230344-1-rongqianfeng@vivo.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index e2ff42e16f94b..082437c84f81e 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -684,7 +684,7 @@ static int pm8001_set_nvmd(struct pm8001_hba_info *pm8001_ha)
 	struct pm8001_ioctl_payload	*payload;
 	DECLARE_COMPLETION_ONSTACK(completion);
 	u8		*ioctlbuffer;
-	u32		ret;
+	int		ret;
 	u32		length = 1024 * 5 + sizeof(*payload) - 1;
 
 	if (pm8001_ha->fw_image->size > 4096) {
-- 
2.51.0



