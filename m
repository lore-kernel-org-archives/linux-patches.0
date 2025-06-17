Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EBF1E8332;
	Tue, 17 Jun 2025 15:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174476; cv=none; b=kNz/hVJNQhBa/QZ3y4O+uidHhmq68wo1YmR+A0Q5mjZftnQJzPJ1WJRvspyo5HdPEmPDJad8GWqV42oFLrL0QTGFiJyFPJySGyyHeNhxr72DzcBVTpvIYJZrBwVjKXWWfmntREO/2x6jhosZrY3zaqXKhmfcIBt7pn+JneMwvtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174476; c=relaxed/simple;
	bh=/8dM3wcc5lQ6bi11civ6vZGP6uD77uXZdBr8Dv0HhNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tApb830OmCxqeuvq0X/XtUXTrvqilbRP0Muu07SkCkC+qUbA+JDJYo1zZnubjYap+VZ1QNufznIzBnHCUcHlC7y1tv6W9SUydPk43g4s0PM5l+rpf+9Ph7a9jrPUW5nZKAEUj/4b2plNAZiYvbT6a601aoHC44WJFDmzgzS1Hho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGtOlMEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGtOlMEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6119DC4CEE3;
	Tue, 17 Jun 2025 15:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174475;
	bh=/8dM3wcc5lQ6bi11civ6vZGP6uD77uXZdBr8Dv0HhNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGtOlMEQIQbAT6IOhgwcC9hOa+1s8+CftprX9J2GzGICi0QEdLXz9GIvPBVnbQQaB
	 6hGvGPY2WLEsJmZZ8ENidmq/XyF36f4trRLeSxiHCEOuH960TgdxYdEpus7lslacCv
	 wMk0BXiq7urlG9+dXUmR2tKQarCCC4wfcpa7krVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/356] scsi: qedf: Use designated initializer for struct qed_fcoe_cb_ops
Date: Tue, 17 Jun 2025 17:23:09 +0200
Message-ID: <20250617152341.201287198@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9a81d14aef6b9..17b19b39699a3 100644
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



