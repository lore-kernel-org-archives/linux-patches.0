Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036512DFF0B;
	Tue, 17 Jun 2025 15:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175980; cv=none; b=rr7/uO18MMu7EnCObZFSVKThdhHOdN+vznICpbnrM63LR0SWO/T+SZKIpFokN0OstO7dGxpLFm4P5CjFqQrqzHgP2OUJ3ynKXcKCO8oaNQVnhEkFpW+mdsgwmJSpnUCDh10itjlzIv8Ic+ojK+sxw2dSDrAw1+79DTutjw2cBJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175980; c=relaxed/simple;
	bh=L/K1dvP4S7DvGsURvhvPgEB4sPLxwI7QkKIHKyJaUtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/65riHCjlBWkj717DXjcLjyUuDGNukIqDfSJPOENzXAb3je8KG1AHcC6SWI00SndiDu27E1cx5ePNVlZuTQ+Y9I5NA24LaR08R2WwcHtm+VV8jR29GkEom0zu8AcR8M6GwT/19TuVrcQ6dO4auBkn0aFhotpcdlECC5FrIwDDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3fT5uo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3fT5uo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D40C4CEF6;
	Tue, 17 Jun 2025 15:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175979;
	bh=L/K1dvP4S7DvGsURvhvPgEB4sPLxwI7QkKIHKyJaUtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3fT5uo4eQWQb7DKhNmJ+Jd31Aaj5aGwHGwRqYuyag0EQIV/xOqj15UGhXuONuxQT
	 A7rzoyj+YhbTFOtJ9kF5mPjp+NY5Uz8I5FG9MB1PsJf+BYko9YG4inlEhTod1sse4k
	 ATfmpRdPkdQiVF+QT2R1uEixijLwb/9u/CvKw4Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 140/780] scsi: qedf: Use designated initializer for struct qed_fcoe_cb_ops
Date: Tue, 17 Jun 2025 17:17:28 +0200
Message-ID: <20250617152457.201159418@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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
index 436bd29d5ebae..6b1ebab36fa35 100644
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



