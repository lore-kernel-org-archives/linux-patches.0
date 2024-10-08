Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050921D618C;
	Tue,  8 Oct 2024 12:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390359; cv=none; b=nAup7QkOqoKFgwqLr2JDfz8ggakRSdL2GZNau3rI/nlF4PDmZwd8gDO8+WifP4TlJuth8CsRvPutVrTxUFZB29OlUBFlrDgxIqVWr/g83ef7mpr3JQg40Z4remjxWpgpkNbvl+lPDHn4miaw3mcNVhUPU4rQrbZoD1BYtC7xq7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390359; c=relaxed/simple;
	bh=CQbDf1olt7Ii1zOPYgeGJ6zlFfcL7PGj0qBO3AjHZSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cebFzeCT1ZXkyXzRu5q+lTdRIs2F1bytvJST5+R/6h06cKTjez751HWd8xeDjHhxwKYTNNM5HDN83XaFV6sszk39uIID2qSj+3LNRD19M1QY3JR4viwHrhIBDQ0FEssHFZ6/l6DLQNR7LVb7baBG+nhv7pd6028RqOba8tYPkpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbGC1Wd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbGC1Wd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD54C4CEC7;
	Tue,  8 Oct 2024 12:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390358;
	bh=CQbDf1olt7Ii1zOPYgeGJ6zlFfcL7PGj0qBO3AjHZSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbGC1Wd/LyJrjnsV9rTjdj8pgKgUpE0LKoRo36N95FpCs/BOLp0dAIBOM62PK3f/i
	 xPxhseJv54OaBj92wIedXGQrjx/98AsXkLUUsJVMk4xJfM8/7lDYtbXaeVCL1cKbY6
	 LfrLOxa4z7QFIQQFFRqC54KBClslbNsgH3hModx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander F. Lent" <lx@xanderlent.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 266/482] accel/ivpu: Add missing MODULE_FIRMWARE metadata
Date: Tue,  8 Oct 2024 14:05:29 +0200
Message-ID: <20241008115658.751172540@linuxfoundation.org>
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

From: Alexander F. Lent <lx@xanderlent.com>

[ Upstream commit 58b5618ba80a5e5a8d531a70eae12070e5bd713f ]

Modules that load firmware from various paths at runtime must declare
those paths at compile time, via the MODULE_FIRMWARE macro, so that the
firmware paths are included in the module's metadata.

The accel/ivpu driver loads firmware but lacks this metadata,
preventing dracut from correctly locating firmware files. Fix it.

Fixes: 9ab43e95f922 ("accel/ivpu: Switch to generation based FW names")
Fixes: 02d5b0aacd05 ("accel/ivpu: Implement firmware parsing and booting")
Signed-off-by: Alexander F. Lent <lx@xanderlent.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240709-fix-ivpu-firmware-metadata-v3-1-55f70bba055b@xanderlent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_fw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/accel/ivpu/ivpu_fw.c b/drivers/accel/ivpu/ivpu_fw.c
index 1457300828bf1..ef717802a3c8c 100644
--- a/drivers/accel/ivpu/ivpu_fw.c
+++ b/drivers/accel/ivpu/ivpu_fw.c
@@ -58,6 +58,10 @@ static struct {
 	{ IVPU_HW_40XX, "intel/vpu/vpu_40xx_v0.0.bin" },
 };
 
+/* Production fw_names from the table above */
+MODULE_FIRMWARE("intel/vpu/vpu_37xx_v0.0.bin");
+MODULE_FIRMWARE("intel/vpu/vpu_40xx_v0.0.bin");
+
 static int ivpu_fw_request(struct ivpu_device *vdev)
 {
 	int ret = -ENOENT;
-- 
2.43.0



