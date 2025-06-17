Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474FD2ECEA5;
	Tue, 17 Jun 2025 15:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175182; cv=none; b=bMyIKUPzThDFu6PFQIUZZROmNg2sOz+bj3OaPZBlQeqU8U/c4IpgbV0ClrC3R8BjyOVjrZWaxjbjfD97GojhNwZPXjY92z3PxPRmXNm+P2EXB7kdGwJda9k5UAHeyrkIg95I7sHXdthox7DiwjpWAhdrS3/vp6oBW8pwRyZSqnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175182; c=relaxed/simple;
	bh=Zbe2HPkE951zSSN3DFb31EgVdlCFjkDNcawPeAgy+qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXv2AhapT4R89K6JcXfja7RvrRYg9aCMIsMWBwNRd3sf2eXPrKE/9laKLRfyerotaYV3I82POxWqCpDG4nR5B8FUtRhnIMoK/HZvmvh8eZnDt+7GIfd061RVCGA5T//b/MNti6g2m1E7WdZQ1w5UVBKzEG4lhx5V+aa5fNDAXi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0DyvTzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0DyvTzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB33CC4CEE3;
	Tue, 17 Jun 2025 15:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175182;
	bh=Zbe2HPkE951zSSN3DFb31EgVdlCFjkDNcawPeAgy+qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0DyvTzJPIGZGHKqQSBANvWFOlzhLWQ2z0OhMs8pUu41HVjKC7PBy2Tkh5EHoF3zP
	 QznRbSzGZahZVbsb2Lhr1VEvQ9sseqNATWpqSGWP+5vUQFOm32JGT1BHDJ6MAcDipT
	 fvGNUBS0qfomCVpK/ioqkSh28kL7PIFnB2sXSMNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/512] scsi: qedf: Use designated initializer for struct qed_fcoe_cb_ops
Date: Tue, 17 Jun 2025 17:21:01 +0200
Message-ID: <20250617152423.431505730@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index e979ec1478c18..e895bd25098fd 100644
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



