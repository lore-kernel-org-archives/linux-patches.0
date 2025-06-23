Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F20347DD;
	Mon, 23 Jun 2025 13:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685794; cv=none; b=thQxYnvmEZeOanA+vHza9NzbL8NNhqd2BazvcA38fdL1ZKVAfl9Ok2TWOlW7diCowAz8sMPy3Rqqc9g8MOED8cxQNpXcB4d4R2nIBh9bGwxVL5pGSXbRf6qErVHzPWIdr9Xr9Lwto4AUzSS0wIE+OMPy5fD7uzExkohnbG3qN00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685794; c=relaxed/simple;
	bh=+OLis/VnHPEWS0E7i4NlVYZBlps3iPgmXs64kTZDbbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJ+ShJ4XNtVhcXOiXC/mdmnFyhs0ypnrieCcJY/xo4pPWc5EIx9QMspndpVX0vdgaaHMVdj6XbDbymruMCNb+9c5r9DyTLhx+ZMWXWP5ySnf1d8vFv6rNy1OwGUpT/u9DMoBS/4XmAoYo+bru1oiDaA+jnHwSfMzxzZdJtXbup8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oalEEIPs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oalEEIPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E24C4CEEA;
	Mon, 23 Jun 2025 13:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685794;
	bh=+OLis/VnHPEWS0E7i4NlVYZBlps3iPgmXs64kTZDbbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oalEEIPsO8Vj2arFoqqDMqbSGGIEfP5xqzUoR0UsupmSC645SpmGou/FGME/YYMjr
	 an2V0CqhZDaDRjwodWKru4NjZibtGzUtMFHUW1xRFANDI4chnPMqFaOVJr5Hvyg+ep
	 LvAIz3DssXFo2Twxg7s9OJfnAxgbXB/kK0qAj+JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/508] scsi: qedf: Use designated initializer for struct qed_fcoe_cb_ops
Date: Mon, 23 Jun 2025 15:01:37 +0200
Message-ID: <20250623130646.526592712@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit d8720235d5b5cad86c1f07f65117ef2a96f8bec7 ]

Recent fixes to the randstruct GCC plugin allowed it to notice
that this structure is entirely function pointers and is therefore
subject to randomization, but doing so requires that it always use
designated initializers. Explicitly specify the "common" member as being
initialized. Silences:

drivers/scsi/qedf/qedf_main.c:702:9: error: positional initialization of field in 'struct' declared with 'designated_init' attribute [-Werror=designated-init]
  702 |         {
      |         ^

Fixes: 035f7f87b729 ("randstruct: Enable Clang support")
Link: https://lore.kernel.org/r/20250502224156.work.617-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 288c96e7bc39f..a6f53cfff9383 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -699,7 +699,7 @@ static u32 qedf_get_login_failures(void *cookie)
 }
 
 static struct qed_fcoe_cb_ops qedf_cb_ops = {
-	{
+	.common = {
 		.link_update = qedf_link_update,
 		.bw_update = qedf_bw_update,
 		.schedule_recovery_handler = qedf_schedule_recovery_handler,
-- 
2.39.5



